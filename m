Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D892637E2E9;
	Fri,  9 Oct 2026 14:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555952; cv=none; b=Qmq8/iG3KHHBXCgEnsx+5dDJYwPgkB5oNn88FfULiu3tsrpUl0UTMCIlAqHpY+vl9AAkKui2w705AxJAeBm8vkGZjOgR2rmGIKP5SH/KbFRBLcugLmd/6yPT9Z1/y8+le6VOOGlvvdSXQHiwU1rJ62CwFC2MPpYS4xrW25Ee26o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555952; c=relaxed/simple;
	bh=2sewB8eND31jfoQepq7giDr9f/pXeqfQ7L4jWUMUTXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQ6j7UC5O+r2hyZsq+9x/KHKbbi7k1JlfpH6tPOow0aCSl7eIQMiG0aRg8YQRkC09CqL9llRD+5egrLzanC/6e8hBGjRAbeyHLMKAID24JjUYoxODcM7EOPiI4t+CuOj30CpWGSscubQP0qlbiijEmI2PckICuq9W4jeGWaeln4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VLJBhJ/+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VLJBhJ/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AB7A1F000FF;
	Fri,  9 Oct 2026 14:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555951;
	bh=xM3o8hfYQsJqJ8+Ij9+jNg39Bq60Z73E+SO6p2OouaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLJBhJ/+h1ruqm4TBvoFUWKRZIgwLpn/1/5vbVUwx/Zh/Pp4VmHU8rzP2NJQYrUTj
	 MemrtSFgGshy7e6gaeQWxIqAUf5+YhTbv9F10C6oMeSn78uzD8IetyQXA1HwO/fW25
	 gmDB6MCsYVKz+CMlpPQDgcFuYIfxHZt3gYQE7U9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>
Subject: [PATCH 6.18 144/403] drm/mediatek: Fix pdev reference leak in mtk_drm_bind()
Date: Fri,  9 Oct 2026 16:08:25 +0200
Message-ID: <20261009140955.439942507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
@@ -652,8 +652,10 @@ static int mtk_drm_bind(struct device *d
 	private->mtk_drm_bound = true;
 	private->dev = dev;
 
-	if (!mtk_drm_get_all_drm_priv(dev))
+	if (!mtk_drm_get_all_drm_priv(dev)) {
+		put_device(private->mutex_dev);
 		return 0;
+	}
 
 	drm = drm_dev_alloc(&mtk_drm_driver, dev);
 	if (IS_ERR(drm)) {


