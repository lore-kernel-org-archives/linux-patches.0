Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BB22248B3;
	Sat, 17 Oct 2026 16:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254191; cv=none; b=U0LoZhFhlIq1wYa5/3momDrAm/CwIJxuP4wf3LDCpl3YnJCB3sxSo0g9TSGAyzf/shBUKD9mP3bSsybB9hQaAIOl0q/FFF/S1BTjPZooGBW590NB1W9btSYLTI6su4LLYZnu7Zyo/nf1VEFFhh+XEBm92/voM2PgGhVImpREw1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254191; c=relaxed/simple;
	bh=QWOOUGcXVYRQOTcq+WSVj5lfzmFD62ktOK92+GnUp1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4IxWa7ZfjeBWyLyK2r1HEE06UqJF6TO/pOGAiLPjEwiYyNji3fL+6YmZDZ4qgdxVxNTrZoGMY4TNSX/hxdIDywGoWRJP8f53iMQ4dFGGqxcnVDu2bFzpasm0E7WH9rfkgQ4Jg5v0cnHBK2uOFHwxhflPftzvaW2BX4EezO1jK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OTd715Bg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OTd715Bg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A9F1F000C4;
	Sat, 17 Oct 2026 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254189;
	bh=kuuKMsSpj3chdk9GRZOdnNTqyKI6VH0wffZRGqDkIuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OTd715BgkI7+Cv1zcYukJD9v4CLkidBikNVKM5Wl+NQgKX/sSciM7fIciGWP3R4q5
	 1z3Bt4niCezUSe6irqgM8Yz21JUCh0nJbT9dqCE/ceHN/KgmwNIgnXf+fKYxgrFZeJ
	 Be+xKZ++X2HsW5v82wifQpvjjC++suW4lZ+WvVTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 364/869] drm/msm/adreno: Fix a reference leak in a6xx_gpu_init()
Date: Sat, 17 Oct 2026 17:53:25 +0200
Message-ID: <20261017160046.442551069@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit e64bca63647db1d5518198d6c5ca2dbcc66b182b ]

In a6xx_gpu_init(), node is obtained via of_parse_phandle().
While there was a manual of_node_put() at the end of the
common path, several early error returns would bypass this call,
resulting in a reference leak.
Fix this by using the __free(device_node) cleanup handler to
release the reference when the variable goes out of scope.

Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/700661/
Message-ID: <20260124-a6xx_gpu-v1-1-fa0c8b2dcfb1@gmail.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 2407140508d8a..4bae3813d90b5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2277,7 +2277,6 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	struct msm_drm_private *priv = dev->dev_private;
 	struct platform_device *pdev = priv->gpu_pdev;
 	struct adreno_platform_config *config = pdev->dev.platform_data;
-	struct device_node *node;
 	struct a6xx_gpu *a6xx_gpu;
 	struct adreno_gpu *adreno_gpu;
 	struct msm_gpu *gpu;
@@ -2296,7 +2295,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	adreno_gpu->registers = NULL;
 
 	/* Check if there is a GMU phandle and set it up */
-	node = of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
+	struct device_node *node __free(device_node) =
+		of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
 	/* FIXME: How do we gracefully handle this? */
 	BUG_ON(!node);
 
@@ -2341,7 +2341,6 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 		ret = a6xx_gmu_wrapper_init(a6xx_gpu, node);
 	else
 		ret = a6xx_gmu_init(a6xx_gpu, node);
-	of_node_put(node);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.53.0



