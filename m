Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 587C2352FD3;
	Tue, 26 Aug 2025 13:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216292; cv=none; b=MoxVAXiRmFx23A5crOCyQs/0AvroZaCvnbAS1i2oaxpFwV8Oht+ZTIhLr1xyYuq7ejF+hFeoEqCZ5s0J0fR+iMZypGjUcd9BPOysGUABGQPLEaoU26MM8V0I2TL9voJlCEouSAg7a7RjR4um8+4JYpBTG4VPPvllvDpI1PSUeXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216292; c=relaxed/simple;
	bh=IWhVfqyKmsiJ4AUAfagZ2OMv6pIkpb19NbgfZlp8JcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OwFZy7KeJjXq2DQwL5ooVecZxEvG2xscUcsh6GRgjY2+areD2RmhcN51Zcn5sdD49YT77pQaEkAIMREntS4b8ZlibRz6vQR/W2N6ijdx+8Dh0T5BGnHS1SG8eAWRpbV86nN++rlmv6PNTGGjDI/P46MbaizOsDXmF1O+IiQtp5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xspsMZZP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xspsMZZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E0CC113CF;
	Tue, 26 Aug 2025 13:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216292;
	bh=IWhVfqyKmsiJ4AUAfagZ2OMv6pIkpb19NbgfZlp8JcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xspsMZZP750C3A/KPc+i2D/X7J9m8+fcLQqQTAlLu+2PS+TtKMhhVJMBhJqeihhdi
	 Pzk+LQgWEwMHOdRLIcgbCoOb1AgT3dnPQhhPZl5EwOLrYJ+bW4u+1vVCHlaxTdAq9j
	 PWt5pI1kg8eVwAK+GqIuOpqr1VK4qV1WeXpCHrFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Antonino Maniscalco <antomani103@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/644] drm/msm: use trylock for debugfs
Date: Tue, 26 Aug 2025 13:07:28 +0200
Message-ID: <20250826110955.249870863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 0a1ff88ec5b60b41ba830c5bf08b6cd8f45ab411 ]

This resolves a potential deadlock vs msm_gem_vm_close().  Otherwise for
_NO_SHARE buffers msm_gem_describe() could be trying to acquire the
shared vm resv, while already holding priv->obj_lock.  But _vm_close()
might drop the last reference to a GEM obj while already holding the vm
resv, and msm_gem_free_object() needs to grab priv->obj_lock, a locking
inversion.

OTOH this is only for debugfs and it isn't critical if we undercount by
skipping a locked obj.  So just use trylock() and move along if we can't
get the lock.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Tested-by: Antonino Maniscalco <antomani103@gmail.com>
Reviewed-by: Antonino Maniscalco <antomani103@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/661525/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index d280dd64744d..36ced8f83434 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -886,7 +886,8 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m,
 	uint64_t off = drm_vma_node_start(&obj->vma_node);
 	const char *madv;
 
-	msm_gem_lock(obj);
+	if (!msm_gem_trylock(obj))
+		return;
 
 	stats->all.count++;
 	stats->all.size += obj->size;
-- 
2.39.5



