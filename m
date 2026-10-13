Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300374E4C5E;
	Tue, 13 Oct 2026 12:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893564; cv=none; b=kaPM9TgR5UxuVvyiwcV0uAndjKwz6EGp7MGBUlTiR1Kg0PYZu+pHBDabweG5kyZTDl8OSCTkYXtVnPZcK3yg1sikdoTEF8Q9j6F1xpy9eZ8BxGN+IP5noDFVF6Y77TTxxz9vPtT7nU3KdEaZgDo6WRMvvvWix+8IWOipBZ+rU8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893564; c=relaxed/simple;
	bh=CSJ7vGFU+n8hcof2AxyPtY6rpf0hdaDKTuoLj9LByrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BusgvKGlJTUrZYj8XERmGmZzXlZKpymX9X8L9W89xMEbozyak/y7wBK7W25ZA4H9TRrANY+HzzQEbmyyCnJfsS4apdxD9uKCayshIxQtszBeaesw+lCUbPGVJ8otPjkTZ58rE+d6zOiEwp3ztQUj7NX5buAvYTzwiNwdyEbjYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P8qey5w0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P8qey5w0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE851F000FF;
	Tue, 13 Oct 2026 12:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893562;
	bh=RKSstbHwAZb/SfVC9eqRgfZB67G3eaRB5jHB7DwY+1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P8qey5w0R7TpZjTPOME8rg1mcSTmvjBGe3JvpX7FmtZcT7PRyQcfxizvXmNZ/S0vM
	 nV4NykXNvHuCx/Mor8S8qwl/OQhjIQRNsqhzeg8D/3K9v52FQVc+xPQvIz4K1hDm8U
	 wtgw8C90bUeYNaMVi5FUK1XmiEc9sSuUWiE4zrq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 250/621] drm/msm/adreno: Fix a reference leak in a6xx_gpu_init()
Date: Tue, 13 Oct 2026 13:34:05 +0200
Message-ID: <20261013112926.795220696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index d1eaa849b1978..f56ac2e0adbe1 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2633,7 +2633,6 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	struct msm_drm_private *priv = dev->dev_private;
 	struct platform_device *pdev = priv->gpu_pdev;
 	struct adreno_platform_config *config = pdev->dev.platform_data;
-	struct device_node *node;
 	struct a6xx_gpu *a6xx_gpu;
 	struct adreno_gpu *adreno_gpu;
 	struct msm_gpu *gpu;
@@ -2653,7 +2652,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	adreno_gpu->registers = NULL;
 
 	/* Check if there is a GMU phandle and set it up */
-	node = of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
+	struct device_node *node __free(device_node) =
+		of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
 	/* FIXME: How do we gracefully handle this? */
 	BUG_ON(!node);
 
@@ -2701,7 +2701,6 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 		ret = a6xx_gmu_wrapper_init(a6xx_gpu, node);
 	else
 		ret = a6xx_gmu_init(a6xx_gpu, node);
-	of_node_put(node);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.53.0



