Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816511F470A;
	Tue, 21 Jan 2025 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482475; cv=none; b=tLMuYiSHS6a6DavXlmMcvfg9L4EVgi6ziOlolaLHxQLGVsieYOY3Wyy10cqZ/JD5WNWut6JOCt0YRh6GE0p/eh9fFbwFpAOqf5R2UGHatHtLOSU5H6SQexKxqV4IL7pgFPWoPff51czrUhY55bnNf1U44ZGbzcbMf/I5G0OSD68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482475; c=relaxed/simple;
	bh=rVJSzcP5GfbgK6iuHl2zRNcBlUpHv/jAG+NmlUT0Mrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BiIX82CCEbRClUgxm6m9mwLcdQms/4N1Bq9p0aB0PVhI4T9lokFVZvKEtf0CLXfmX01Iin9ySgXfy3mluAiu/6GCPE8rIkrPy27ELWDhkxs47t9FCmcQU9O6Zwrc7cxppSaSzYz1vO/jIKHX46EUJpoFwUyMNw3tGSRkOaKVlr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RrzAzLzk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RrzAzLzk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04031C4CEDF;
	Tue, 21 Jan 2025 18:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482475;
	bh=rVJSzcP5GfbgK6iuHl2zRNcBlUpHv/jAG+NmlUT0Mrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RrzAzLzkcwrAa6hdzE4xEpNTMDikDv4DFY1dAgSsAJtrmrtrQjc6RR7hwAxpn+/OY
	 HezYwBVBtlQ5910LMyshrMsHxupCrTaUee2jB1bTovOKm1Sv8R7sjxmCKRMpzgVvTH
	 2zICbM/wOZNVLvKe2mi0gXITbNIUpy1eaHzZ+hus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Airlie <airlied@redhat.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.12 089/122] nouveau/fence: handle cross device fences properly
Date: Tue, 21 Jan 2025 18:52:17 +0100
Message-ID: <20250121174536.449809284@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -387,11 +387,13 @@ nouveau_fence_sync(struct nouveau_bo *nv
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


