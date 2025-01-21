Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319051F542A;
	Tue, 21 Jan 2025 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482152; cv=none; b=RE3FIP+MHIcHY5qPq9/5bwdS/DeoQ3oIvtvGY30i4wflXuoARbo6C15D5OtGut685s6z+a46chy4Qn3JFPKYaTeXBfEL41Pqyq3ML91HNtVef/5cuRyrBSAo0W+kiJ/BwAAGSH6Qb+uo3LkAYwTXJHhSf5JP5rCgKgg2O7LX8is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482152; c=relaxed/simple;
	bh=Okvqtvbx9QvCekuXeYMKD2aSpxnvEVaP7Uk9LhK2gcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oy7/xE5FLiLbHy9nJIUHFcrYdgGu3kZXfX2iGeN5+PQGp++hDtBiaUNSXsV9uxF9Klw1U/09oRZj9Z9a9zLNUJmd4MeHkH8Hs2E6M1BK/FlwtqYsGNIjjWCB0cx4xAydif6H5C2AJj8d4G3FEn+G94Gu98YiUgq1sQJcYZPqMsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=woEHNQ2o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="woEHNQ2o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1D84C4CEDF;
	Tue, 21 Jan 2025 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482152;
	bh=Okvqtvbx9QvCekuXeYMKD2aSpxnvEVaP7Uk9LhK2gcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=woEHNQ2o3Vn+RUXfTtx2LoLkRMBEVLcEmS37cVyaOGLaNGWlj0J61Fush+UciKrx/
	 tuT3+Up34tQqbLvr7q1aYwrYPqtOtGUIskuXf56FIkoXBOjh9YVKKOBY34fFW661P8
	 MZJz+9WIaorxGot2JeWVPhRYfejHwan5HnbVUDkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.6 50/72] nouveau/fence: handle cross device fences properly
Date: Tue, 21 Jan 2025 18:52:16 +0100
Message-ID: <20250121174525.351971946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 1f9910b41c857a892b83801feebdc7bdf38c5985 upstream.

The fence sync logic doesn't handle a fence sync across devices
as it tries to write to a channel offset from one device into
the fence bo from a different device, which won't work so well.

This patch fixes that to avoid using the sync path in the case
where the fences come from different nouveau drm devices.

This works fine on a single device as the fence bo is shared
across the devices, and mapped into each channels vma space,
the channel offsets are therefore okay to pass between sides,
so one channel can sync on the seqnos from the other by using
the offset into it's vma.

Signed-off-by: Dave Airlie <airlied@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Ben Skeggs <bskeggs@nvidia.com>
[ Fix compilation issue; remove version log from commit messsage.
  - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20250109005553.623947-1-airlied@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nouveau_fence.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/nouveau_fence.c
+++ b/drivers/gpu/drm/nouveau/nouveau_fence.c
@@ -386,11 +386,13 @@ nouveau_fence_sync(struct nouveau_bo *nv
 			if (f) {
 				struct nouveau_channel *prev;
 				bool must_wait = true;
+				bool local;
 
 				rcu_read_lock();
 				prev = rcu_dereference(f->channel);
-				if (prev && (prev == chan ||
-					     fctx->sync(f, prev, chan) == 0))
+				local = prev && prev->cli->drm == chan->cli->drm;
+				if (local && (prev == chan ||
+					      fctx->sync(f, prev, chan) == 0))
 					must_wait = false;
 				rcu_read_unlock();
 				if (!must_wait)


