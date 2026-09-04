Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F3C35AC03;
	Fri,  4 Sep 2026 05:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501176; cv=none; b=NGR3ND+cimr4Pjn/d4eXvFs/LYN4BoCSYELcVATyb4i3f6AJWWT4R+LKyR6Xc7e7g2GDloi8alVCots06cMw9tFxWI3koI5DNDIb/lKVhalVPWHUGv3Ac0eXXIJ3Xp6BnWoiwwFKQuaABREveRXr7OfhUETSglSfphDNMFPaWyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501176; c=relaxed/simple;
	bh=aePHUI1Bnrxq0w89uYvTyUxZIrXsfuUrqLdfluTKcSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwDuMp/Tvd87N0x5amhFk5H121Dy0aTFFS+DvfzejFT5TAS/AWLtwoZAxOReLnTo4AoU6OKCSw3c9peVbbmh6BcufR7aglr8xt3BVyKS6D938Tlt4BIIMAf7DdKdE9jkLUf/mNPTssBue0By1OzzPfN09oUhdyYxL47BrtoKvaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju+IM5OT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju+IM5OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1334D1F00A3D;
	Fri,  4 Sep 2026 05:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501175;
	bh=b7CjVNcCcPiI7TlZIVivDkO9NO+oXTmgw2X40NnBaog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju+IM5OT0fQ9tSr7FjlcV233Bg04d1HrV2yPbSo7RySpJD9qBsxlo5PLdr8DLrTPn
	 G/H1i9z07YtrFO7cUvJMp6rgEdgE5kRiKHXmZmQXiNe51S3CJWcGWIMWpZlzEfppIj
	 LM6h1Rygy6KspymeQb8s9eR8wsR1jZ3P1J6OZnPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erin Lo <erin.lo@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH 6.18 318/552] remoteproc: scp: Fix device reference leak on failed lookup
Date: Fri,  4 Sep 2026 06:57:55 +0200
Message-ID: <20260904045757.484302364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 22f9efb3ae07f966a1901d929d16df1388cce65c upstream.

Make sure to drop the reference taken to the SCP device when attempting
to look up its driver data before the driver has been bound.

Note that holding a reference to a device does not prevent its driver
data from going away.

Fixes: 63c13d61eafe ("remoteproc/mediatek: add SCP support for mt8183")
Cc: stable@vger.kernel.org	# 5.6
Cc: Erin Lo <erin.lo@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20260706065614.389412-1-johan@kernel.org
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/mtk_scp.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/remoteproc/mtk_scp.c
+++ b/drivers/remoteproc/mtk_scp.c
@@ -35,6 +35,7 @@ struct mtk_scp *scp_get(struct platform_
 	struct device *dev = &pdev->dev;
 	struct device_node *scp_node;
 	struct platform_device *scp_pdev;
+	struct mtk_scp *scp;
 
 	scp_node = of_parse_phandle(dev->of_node, "mediatek,scp", 0);
 	if (!scp_node) {
@@ -50,7 +51,13 @@ struct mtk_scp *scp_get(struct platform_
 		return NULL;
 	}
 
-	return platform_get_drvdata(scp_pdev);
+	scp = platform_get_drvdata(scp_pdev);
+	if (!scp) {
+		put_device(&scp_pdev->dev);
+		return NULL;
+	}
+
+	return scp;
 }
 EXPORT_SYMBOL_GPL(scp_get);
 


