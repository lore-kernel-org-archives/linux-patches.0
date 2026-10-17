Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0DB3587DE;
	Sat, 17 Oct 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256459; cv=none; b=kGIDPr2081JjCiGA+NYK6CDfvVG1x4dUoDwjWqS2UF/JFCZrU6QeC4J4SMFAUbKunVRqfnDt6vP80UQU3/h97CiVRu/ZcQFKCNSQvYw2O/BaZ2noYj2qvIiHBQANpYmqRgDNFdbS3L9J33IhSMp53ZXLCxVU/9pKGNZNWxAPhs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256459; c=relaxed/simple;
	bh=hRFUwS/le+4RuYJ9+rs8NdekuKuCYCATLNvDWdmBS0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuoU2qZ4PuEljxygxvai7K06g990GY7ZKpD32wVlqdFRYDZlwS3SK5x6N9AyTUDEbjm6YmY2Vx1yW7MX8uW0JnLEJr2cuSWi1YB57wpglnJouW/+V3W8m0ZCUO1pRpiGGtNNiPwuYf20DDatMiOsI30oalUTKWildPpDlQziF7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ebe+aR3t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ebe+aR3t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C15771F000C4;
	Sat, 17 Oct 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256458;
	bh=pPuvw7myu/lHQ2Cw9AdJ8vA9OPoljjZTgC2Ris4RjHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ebe+aR3tUbMRH395VlvyMSI0Ua3+tc6m3cVI8LAQ9j089VYcu72q7H6FIIRo5ilV9
	 WbnOUni17JzGqxJ8m6Uz0+ucjumehpKuUYxVYLvngNojNKlgLwBVmk/cQ+X+O1DgM9
	 4Tv354bbTAPvVuypGogJ0xGgXZiY1gutY5zN5aRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.6 0242/1674] drm/mediatek: Fix pdev reference leak in mtk_drm_bind()
Date: Sat, 17 Oct 2026 17:41:54 +0200
Message-ID: <20261017160437.342903247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -621,8 +621,10 @@ static int mtk_drm_bind(struct device *d
 	private->mtk_drm_bound = true;
 	private->dev = dev;
 
-	if (!mtk_drm_get_all_drm_priv(dev))
+	if (!mtk_drm_get_all_drm_priv(dev)) {
+		put_device(private->mutex_dev);
 		return 0;
+	}
 
 	drm = drm_dev_alloc(&mtk_drm_driver, dev);
 	if (IS_ERR(drm)) {


