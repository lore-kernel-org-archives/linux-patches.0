Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAD018B0F;
	Mon, 18 Aug 2025 13:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522085; cv=none; b=cOUd2SeoJJ7iYbJC61pCzmJdZgjJ76NkKa4MDLfCHfFCJatKXcFEm1tiW0iJ7lw1Dut3AqEDJsNfLGrlkbU2gDZDRQJa6QFFyj7FA/VFuR9ut//vk4gdmZb33crYdehGuiPG6F2054GqbiFntgjGe9oVskQeK3ydIiN8KPKsWrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522085; c=relaxed/simple;
	bh=Rzv/qKkHEVSE+wAjaAfDfhM93xMkv0ZkU+8D3YLWsUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pK4nSOLWr2Kd2Xb9L/9Ha8EkUEkW1GfvU/XzKaEdM5Erib+tlCMheVx+RJ8rTEoHrsF9Ig48/yZsLSNXXjn0BI/4R5Pcdpjx2hzuhb8JnKmXguumuWzb3y4Cqh8wD3ZNgJFWf7aXAUaH0+CZGboWFM6wJMW0WnI1Qe4Vb5c+RHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEgaab9j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEgaab9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59F2C4CEF1;
	Mon, 18 Aug 2025 13:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522085;
	bh=Rzv/qKkHEVSE+wAjaAfDfhM93xMkv0ZkU+8D3YLWsUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZEgaab9jdxmbdFVyfVai0M7MbPahtxWCET8z62ErL3XeOUr+2QQHs9uAv0JOpy5fk
	 JCqkqsVz79htEMtQ8gA4L9f2ApzfKGnhaJc2SdUTyVuCbSuCs2RE6YOK8h/S5qmlYu
	 ezHHenTvJTltOff8apeN0Af66PaP2BaDbfeDmQAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Antonino Maniscalco <antomani103@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 210/444] drm/msm: use trylock for debugfs
Date: Mon, 18 Aug 2025 14:43:56 +0200
Message-ID: <20250818124456.726380498@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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
 drivers/gpu/drm/msm/msm_gem.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_gem.c b/drivers/gpu/drm/msm/msm_gem.c
index ebc9ba66efb8..eeb3b65dd4d1 100644
--- a/drivers/gpu/drm/msm/msm_gem.c
+++ b/drivers/gpu/drm/msm/msm_gem.c
@@ -963,7 +963,8 @@ void msm_gem_describe(struct drm_gem_object *obj, struct seq_file *m,
 	uint64_t off = drm_vma_node_start(&obj->vma_node);
 	const char *madv;
 
-	msm_gem_lock(obj);
+	if (!msm_gem_trylock(obj))
+		return;
 
 	stats->all.count++;
 	stats->all.size += obj->size;
diff --git a/drivers/gpu/drm/msm/msm_gem.h b/drivers/gpu/drm/msm/msm_gem.h
index 85f0257e83da..748053f70ca7 100644
--- a/drivers/gpu/drm/msm/msm_gem.h
+++ b/drivers/gpu/drm/msm/msm_gem.h
@@ -188,6 +188,12 @@ msm_gem_lock(struct drm_gem_object *obj)
 	dma_resv_lock(obj->resv, NULL);
 }
 
+static inline bool __must_check
+msm_gem_trylock(struct drm_gem_object *obj)
+{
+	return dma_resv_trylock(obj->resv);
+}
+
 static inline int
 msm_gem_lock_interruptible(struct drm_gem_object *obj)
 {
-- 
2.39.5



