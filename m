Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83842690D5;
	Sat, 30 May 2026 17:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160667; cv=none; b=tFzRnM5bOtIziIj62KLrCRKCMkQ+EAUtyYvfNpkvkxKaQx/CIXRais15y3Db0kC1dYygmj2sBubCSPzEU4Erv5tr7/ELsKIUL4r1OyWX/C7vaL6/yBmeAaNhal+gyscYCa3XPK59vynp69YpNUHcMkA4De5T7+DnL7vnyXNd+2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160667; c=relaxed/simple;
	bh=YrLVaznKkx3JTiO5XvgcCesj1bG6IIs414K7pwN1ZZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5/MJaYToG6nT1uPt45ckrL0d2TwQ+jWjFvGeQUePfZvNtL3fLa0kfWJHVUxAdsixVdGxPo+dSFZzldCxLnukmUW0R0fHwOXfbmYe8RzHGcduAARjVXsaYqL8rw6B7sHI0R7Q742wLlKihMLHg60imvsc90rcakZv5yqbGVCFwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X/rOKun0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X/rOKun0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A42C1F00893;
	Sat, 30 May 2026 17:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160666;
	bh=7VInI5O2h6KyzDrsg+MTmrZpNG3WnUEeHVqdf5a5m6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X/rOKun0Fo2WkkQbLhBJhRQIwr40ZuZuwj7dYKCHR6BKf9HAyld2Kr8E15hRjdCnY
	 klgNgf7DHtEdVTAeFcapceWritVEV5n0E0PyXVpB6szppshT/21rf8H4vkz9GqDKr+
	 0OINuGYHjotO0y80xBF9Ve1FyGKDkco+uiQDb3i4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 399/969] spi: mtk-nor: fix controller deregistration
Date: Sat, 30 May 2026 17:58:43 +0200
Message-ID: <20260530160311.309263751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 76336f24934621db286cabb20b483773ee01dcaa upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 881d1ee9fe81 ("spi: add support for mediatek spi-nor controller")
Cc: stable@vger.kernel.org	# 5.7
Cc: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mtk-nor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -900,7 +900,7 @@ static int mtk_nor_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0)
 		goto err_probe;
 
@@ -926,6 +926,8 @@ static int mtk_nor_remove(struct platfor
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


