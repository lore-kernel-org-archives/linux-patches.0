Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C37F67E69;
	Tue, 23 Jan 2024 02:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975310; cv=none; b=QND/qPG6Z2Us9dh8RT9PiVqqCHXIhZ885lV0SsgxCGb/d5KLCoWj5iqkDUXbXPTA4I7P9O0N2+nis70DVSY9DshuHHpfpcbsevIgdlO10oNpuhk3R2VnlkmvNiNde4+qh/phLndW3WdemyQykW6t4ZniY/BeMr4eMCOW57ztqZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975310; c=relaxed/simple;
	bh=BmEPPigl4hcuSCOwe8F7DdvIUMgdMVhoFPM3X9VZNsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tx+bUHXolztBw3z4PJiw7WUsrqxTXc41otgNrg94ZdFgf+bV9arVPPvGWv8UXEKgC+2Cc+RjFiK5XzphtWtAXW1DWekklV8ma1U8OhCmh1+11p9Uf3sfK4GPTxFWIBADObKICAgsiAv5ccQAIvOb/H+FqRoYKqqBK3lvtKrHQkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lD7ieYzZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lD7ieYzZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F161CC43390;
	Tue, 23 Jan 2024 02:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975310;
	bh=BmEPPigl4hcuSCOwe8F7DdvIUMgdMVhoFPM3X9VZNsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lD7ieYzZCQYXlySy+swqb1uMZWbY6pZEoC0AftHy31/WL8Kn3RoKEgCQW71/JJnPo
	 Kv2CmQd767ZUILAfpeAENHXrfqP+zDIqFkwNys2GpGI+nN6jhKwQXny+0BlTgaqjUz
	 IGz82HZWiJYGaJ+4sxXemZfnpgbkhzb6PB4MPhE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tommaso Merciai <tomm.merciai@gmail.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/583] media: rkisp1: Fix media device memory leak
Date: Mon, 22 Jan 2024 15:55:24 -0800
Message-ID: <20240122235820.349567406@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>

[ Upstream commit 452f604a4683654f4d9472b3126d8da61d748443 ]

Add missing calls to media_device_cleanup() to fix memory leak.

Link: https://lore.kernel.org/r/20231122-rkisp-fixes-v2-1-78bfb63cdcf8@ideasonboard.com

Fixes: d65dd85281fb ("media: staging: rkisp1: add Rockchip ISP1 base driver")
Reviewed-by: Tommaso Merciai <tomm.merciai@gmail.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index c41abd2833f1..894d5afaff4e 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -582,7 +582,7 @@ static int rkisp1_probe(struct platform_device *pdev)
 
 	ret = v4l2_device_register(rkisp1->dev, &rkisp1->v4l2_dev);
 	if (ret)
-		goto err_pm_runtime_disable;
+		goto err_media_dev_cleanup;
 
 	ret = media_device_register(&rkisp1->media_dev);
 	if (ret) {
@@ -617,6 +617,8 @@ static int rkisp1_probe(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 err_unreg_v4l2_dev:
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
+err_media_dev_cleanup:
+	media_device_cleanup(&rkisp1->media_dev);
 err_pm_runtime_disable:
 	pm_runtime_disable(&pdev->dev);
 	return ret;
@@ -637,6 +639,8 @@ static void rkisp1_remove(struct platform_device *pdev)
 	media_device_unregister(&rkisp1->media_dev);
 	v4l2_device_unregister(&rkisp1->v4l2_dev);
 
+	media_device_cleanup(&rkisp1->media_dev);
+
 	pm_runtime_disable(&pdev->dev);
 }
 
-- 
2.43.0



