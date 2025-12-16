Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F33335CBCE;
	Tue, 16 Dec 2025 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886795; cv=none; b=hsthsqssNzWHPQlHXyVJIetJ2ta81vaLkoIgxfuq1ztIHO3KaqH9EKR84dK9Ysa0q1rV1ll4jXqQVm4rl0TuW8BJVccwn5KV9M555GnS3CuFbo5oHGz+waeDfklHkfm1RwuLkjsep388wjNXdOIM1LFIPfTv3W/IDqJxMBJaT54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886795; c=relaxed/simple;
	bh=+QemsGgvnu5s0St+Bop1S1RvDwCEFi2j6xFzmlRM1RE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSvGnFRJwRitoX6GLZ59PY2TtoGtIXiNdwTO0Mv7yLQ5SD594wlrLwIIZ0vU74GEsOZUg+ekeyWs7HaJ5Lx0BRslbvbpcKbsRoX+xXz44gN/Ly5z2AV9ZvOPeVaDLd9VLG0/oHdnvmtyF2qF69iLdCE1LhURa+1YM4bMQDev6Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d9MtVIy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d9MtVIy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E797C4CEF1;
	Tue, 16 Dec 2025 12:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886794;
	bh=+QemsGgvnu5s0St+Bop1S1RvDwCEFi2j6xFzmlRM1RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d9MtVIy3KV6hxbDaonV33PguiCQMhCmvkuSmAt6XCvdlFRmawwQPniPP9mUnNSRD8
	 ZvdUCvAhhnZnO8j8FB1xpb1B+g/8fYmEYRlzOW5XMPrqVAPLz+Js/OGJgejqXsUb0/
	 Q6Q48WJjvq47PXcjD1lAEeH7CWPxFYxJrwg+6Pi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Wludzik, Jozef" <jozef.wludzik@intel.com>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 035/614] accel/ivpu: Fix race condition when mapping dmabuf
Date: Tue, 16 Dec 2025 12:06:42 +0100
Message-ID: <20251216111402.580898206@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 171e809575ad6..1fca969df19dc 100644
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
2.51.0



