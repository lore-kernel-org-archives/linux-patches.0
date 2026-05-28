Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 154CC304BB3;
	Thu, 28 May 2026 20:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998815; cv=none; b=M6iZ6e8xfEIvyPvA3M0c0mAUJr7GxwZ8EzyqeQE8Np5RvY1SGg4sJ2ebE7czIGW7PJ4g174D0uZlgou/a3tqKOJyd1mYYFQBiS42FofOh3zpP5VDVJF2fOCpxEog41AmjUXk99Aa5/kgOXHq4JOCGDJS+yPTefMDkSsfZ49vPOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998815; c=relaxed/simple;
	bh=3eVBVN5TCxLu4O5MmMB1QXny8+mKj5jMhzsZ/gOze0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKLjBfD3uKgXLltKlb1JFafJXuhkQW3gqk41tSCzmvQrXkYpn2Bqf2feMh9BYyVfTSxUk+BqTxaxHqKhygGMAThH5Zsz6xRvngDAW246/uARXN+wDQFu0jx3t7sUfh3YHk6YASmRuOpfq/PWsCka8Jmzjt+PqAATmkbS/FTSA4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB1BCHvx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB1BCHvx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746B91F000E9;
	Thu, 28 May 2026 20:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998814;
	bh=ZffXEbx7USnP9a2pCG5yvbb3/xvqXEXePhEPl8kJBS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB1BCHvxXaXCpnjdkd3sZWWcrGb1SL2EdzzQslrSztCXMfjABoCCcm1gOn2QJUd9m
	 v9cFDe06nCQICncqsmxIcgX4cKY/QU8vlRMRdXV3hD+39D7SyhDV6z310omFO2aDuD
	 M3TYV8neEUPVbW5dGWgCcfi2B927+oMIl8WPxncI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 306/461] drm/msm/adreno: Fix a reference leak in a6xx_gpu_init()
Date: Thu, 28 May 2026 21:47:15 +0200
Message-ID: <20260528194656.133330902@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index ae61c204898cd..02a776ac9ab43 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2607,7 +2607,6 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	struct platform_device *pdev = priv->gpu_pdev;
 	struct adreno_platform_config *config = pdev->dev.platform_data;
 	const struct adreno_info *info = config->info;
-	struct device_node *node;
 	struct a6xx_gpu *a6xx_gpu;
 	struct adreno_gpu *adreno_gpu;
 	struct msm_gpu *gpu;
@@ -2629,7 +2628,8 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	adreno_gpu->registers = NULL;
 
 	/* Check if there is a GMU phandle and set it up */
-	node = of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
+	struct device_node *node __free(device_node) =
+		of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
 	/* FIXME: How do we gracefully handle this? */
 	BUG_ON(!node);
 
@@ -2676,7 +2676,6 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 		ret = a6xx_gmu_wrapper_init(a6xx_gpu, node);
 	else
 		ret = a6xx_gmu_init(a6xx_gpu, node);
-	of_node_put(node);
 	if (ret) {
 		a6xx_destroy(&(a6xx_gpu->base.base));
 		return ERR_PTR(ret);
-- 
2.53.0



