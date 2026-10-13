Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DE2C4F472E;
	Tue, 13 Oct 2026 12:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894981; cv=none; b=F9MD/niuLJ+dNo0aIg8Zc3vHOb5PXrpl662FusZ5bBNGRmxDYmlPg3GoDin0a5nNiIro9A7aJ09XO244XKhpk95NRsc0U+ehOnaL4+hBLuLMsJHMCQxQv4DApk1Dbb+aNuHXQnt/joU3CjyeB0B1DxRmh2b6p1H9CNPCTHNDfaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894981; c=relaxed/simple;
	bh=6eecWKdoNsmj4msDa83uu8OyilpvmVz8TcEQfuYsX1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qEA6BgVkAPdXRVOHtrS/TUziflSJ5/Ct/7SNb314HDgu8s59GHpNh+Z/PqVSFhT4aRuqdpha8oX9kF9emP/b6Ig6ePadFm7UxFzNbiO/VO4jGnV6la/tJ9MjTi2IwzE4czL+134RgCm/m68K0SBSY3+h4wNs6/WHllxVawRf1j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LwOZkBpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwOZkBpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F9B1F000FF;
	Tue, 13 Oct 2026 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894980;
	bh=dyqD/BUpNpfubAHn/JTxiJqe/Nf4ryTBAo7Md9z++pY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LwOZkBpYFfsYYhHP0u7+HWcwej0Ts9UmKfLTTVHbGFU1Ji79jVjuYGK93IuLIRu8O
	 F/HbBTO+HnjXDCrCtgi8cyZnjYDBXCzsO/GWGfyAjtoUHyqpHOM4xTWJp82nUmRWFS
	 1NwmVeHa4dy/9+KTsDAOzy9Im6Bi+w9U/GIqgATc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.12 120/497] drm/mediatek: Fix pdev reference leak in mtk_drm_bind()
Date: Tue, 13 Oct 2026 13:34:47 +0200
Message-ID: <20261013112910.739994873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -650,8 +650,10 @@ static int mtk_drm_bind(struct device *d
 	private->mtk_drm_bound = true;
 	private->dev = dev;
 
-	if (!mtk_drm_get_all_drm_priv(dev))
+	if (!mtk_drm_get_all_drm_priv(dev)) {
+		put_device(private->mutex_dev);
 		return 0;
+	}
 
 	drm = drm_dev_alloc(&mtk_drm_driver, dev);
 	if (IS_ERR(drm)) {


