Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C3D394470;
	Sat, 17 Oct 2026 16:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255606; cv=none; b=O9IqIH+HhQ1GaTTopI31QNLLJTLhgB54BDCt6FjzLr6kP+hPhtOd8Z5m4UBZLqr2wUEn/SAZgbHDv/7LYKXSpxbKgNlPg+valgNbcerWx0CrWjkf3zuG+/0wyuRDeS9N3hEO/dmdnm1u08Mfjb+tTYZjhPUzrZWUEiNjNfJt27Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255606; c=relaxed/simple;
	bh=Wary7KXPEZSWz0HgSvBRvnTTrPuArmMKV+WfT0H2jMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh6QIsEFQrKBh1whq7ceeR9/lNA5kkT21HGPkPGpMWxKArbsxVG1zFNbmsQYgoiQMjpxAJ8elb0ddngifUin5e9bKQ6EjzNceoAZfwdpnm8JTZqDBOcki/4DMcNnqqGHczt8/Su2uwZFG0iw+U3mxI7oflZEcOXeSx7iuvo1ZXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fmesq5H7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmesq5H7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 491F31F000C4;
	Sat, 17 Oct 2026 16:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255604;
	bh=vQmeXsM+ZAqla9HDUYMIC6tJhZKXLZBDvdFyy1LR4Zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmesq5H75VS6LlDvWZyvSeqUaj9EiZzPUVgIFdt73VCMtPK58GHth/dsKwiOKiBr1
	 eOYQ8ATqDll+rFcp8hRTnjZ6Eb54VWAJCjSEji9qB4tJ08bIOezSTECYUllqguFmWM
	 518m5TrI6bdyeYntn8OXV9XEpVjk+9cEFwVPNioE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wludzik, Jozef" <jozef.wludzik@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 830/869] accel/ivpu: Fix race condition when mapping dmabuf
Date: Sat, 17 Oct 2026 18:01:11 +0200
Message-ID: <20261017160058.158795917@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wludzik, Jozef <jozef.wludzik@intel.com>

[ Upstream commit 63c7870fab67b2ab2bfe75e8b46f3c37b88c47a8 ]

Fix a race that can occur when multiple jobs submit the same dmabuf.
This could cause the sg_table to be mapped twice, leading to undefined
behavior.

Fixes: e0c0891cd63b ("accel/ivpu: Rework bind/unbind of imported buffers")
Signed-off-by: Wludzik, Jozef <jozef.wludzik@intel.com>
Reviewed-by: Jeff Hugo <jeff.hugo@oss.qualcomm.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://lore.kernel.org/r/20251014071725.3047287-1-karol.wachowski@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_gem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_gem.c b/drivers/accel/ivpu/ivpu_gem.c
index 1f66355ffe9fb..3929357a61a37 100644
--- a/drivers/accel/ivpu/ivpu_gem.c
+++ b/drivers/accel/ivpu/ivpu_gem.c
@@ -45,12 +45,13 @@ static inline void ivpu_bo_unlock(struct ivpu_bo *bo)
 
 static struct sg_table *ivpu_bo_map_attachment(struct ivpu_device *vdev, struct ivpu_bo *bo)
 {
-	struct sg_table *sgt = bo->base.sgt;
+	struct sg_table *sgt;
 
 	drm_WARN_ON(&vdev->drm, !bo->base.base.import_attach);
 
 	ivpu_bo_lock(bo);
 
+	sgt = bo->base.sgt;
 	if (!sgt) {
 		sgt = dma_buf_map_attachment(bo->base.base.import_attach, DMA_BIDIRECTIONAL);
 		if (IS_ERR(sgt))
-- 
2.53.0



