Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532DD45516B;
	Fri,  9 Oct 2026 14:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556540; cv=none; b=SY1us/5iaXvKjXR1OSvqZ4bfvht8t7Dcarq6YbPED9fYAgbz71GMmX7dTU8lqIyrfovgE4uH+EftZFzUlttsGNmizyxY4QrMVSRodHHn3ehn1ovId4O/2eueZYSbH3KYAnB9Sl96LEgUyZKJrIlH7ZyN+s+YWSSvIt6jp/uXq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556540; c=relaxed/simple;
	bh=ENJKkv5YlhpLls1BQH18o5iQaBkQwyBth6kVd1yr5no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EM95QyaPp9KHHOxqTEO0Y3AHbUplUTTI4hk4Q7yiq3EJF3KW2R2ztQtD7/dMpvy2jw2EFlx6GkZ5RP1f5zXG1jTsc89gwAKkCxdhIKKYQn0m7FPtYFWSL7eoxGN8B5KkFtiEPdOZCkX3XR171GyO/jBC3aO2NqQdxoaY2RfgY/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1DyGFkw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1DyGFkw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A771F000FF;
	Fri,  9 Oct 2026 14:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556539;
	bh=DzCAoCpMmr8CYL+io3aZDMam6KT/FBwV3q1AmEMc5Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1DyGFkwCWsUslg8YDbBDB5YyIt0dagMrRDroAqTxhdw3oBPeOQpCUHIH/5+WMWOB
	 iOotQC3+Y5VGPcZAv+lge6fpgL78n80sHjENhDMwUW1KpXPpkhhvs4Rz/TZEXJP5Oy
	 fot1EZK/wtzKYpyYUj2u8PD49srPTbv3aXv/1hJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 7.2 184/428] drm/mediatek: Fix pdev reference leak in mtk_drm_bind()
Date: Fri,  9 Oct 2026 16:08:41 +0200
Message-ID: <20261009140950.187987630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 3753e34b73fcbe2a2edbe984614a008a261697ef upstream.

When the device is not the mmsys master, mtk_drm_bind() returns early
after taking a reference on the disp-mutex device via
of_find_device_by_node(), without ever dropping it: mtk_drm_unbind()
only puts mutex_dev for the master. Drop the reference before returning
from the non-master path.

Fixes: 1ef7ed48356c ("drm/mediatek: Modify mediatek-drm for mt8195 multi mmsys support")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patchwork.kernel.org/project/linux-mediatek/patch/20260916174058.2088709-1-vulab@iscas.ac.cn/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/mediatek/mtk_drm_drv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -638,8 +638,10 @@ static int mtk_drm_bind(struct device *d
 	private->mtk_drm_bound = true;
 	private->dev = dev;
 
-	if (!mtk_drm_get_all_drm_priv(dev))
+	if (!mtk_drm_get_all_drm_priv(dev)) {
+		put_device(private->mutex_dev);
 		return 0;
+	}
 
 	drm = drm_dev_alloc(&mtk_drm_driver, dev);
 	if (IS_ERR(drm)) {


