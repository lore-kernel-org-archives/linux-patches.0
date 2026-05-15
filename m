Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A806D3C0607;
	Fri, 15 May 2026 16:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862658; cv=none; b=GPlXwVWS4REGEwIEVcTIY8GsKy10Lo907fy88puICt2wXn22yQbx92uG51AvN8RpeLNSOyoJo8YoFQicwhjpCwGML45JK/CKI+8tGczekVG4bGpoyLGWVRobnAqqy6vOMR+w+9J/zuQo30LTHXrNe0DjVvszm7jLhCQBD240YDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862658; c=relaxed/simple;
	bh=/zO1vPSl8RkT8chPnalt84XeMh9SsQ5o4J/nScSDmQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D4z2bwX+rxrYvDK3ECXiGEV5fChqVLJi7TZPC4qoOSfddBnCr4YZksQnMA/43PdjjmvdR6+L8lA1l+GjfuowMy3Wa3z8Fsr37ozuSEF3sTZcg42SXGsa0gPcTJpUUaWs6YV0+c1tdDDnrK4Rk9lHE3Cno+j/0ieOz7ZqzB9Mj/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c+Naxx17; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c+Naxx17"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D001C2BCC7;
	Fri, 15 May 2026 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862658;
	bh=/zO1vPSl8RkT8chPnalt84XeMh9SsQ5o4J/nScSDmQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c+Naxx17CYJNulfTFbIUMm+bsW4W+hUSAcDADX+gGnvwBmgjMegcjlLsgJt55duC+
	 lc/CltYxVYQqlNgJR8ifSBYXL7/+rNtJqY9vWY0QsXnp2kw0l+neDDCVN47Lk3BV5S
	 KN7Fo1khyhfRCJk1VGATA3lWFvqL2+C7KQtRGi6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 092/201] spi: pl022: fix controller deregistration
Date: Fri, 15 May 2026 17:48:30 +0200
Message-ID: <20260515154700.526416390@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

From: Johan Hovold <johan@kernel.org>

commit 994b33366be9148240690e3e94bffe17c4d89458 upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: b43d65f7e818 ("[ARM] 5546/1: ARM PL022 SSP/SPI driver v3")
Cc: stable@vger.kernel.org	# 2.6.31
Cc: Linus Walleij <linusw@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-9-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pl022.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-pl022.c
+++ b/drivers/spi/spi-pl022.c
@@ -1956,7 +1956,7 @@ static int pl022_probe(struct amba_devic
 
 	/* Register with the SPI framework */
 	amba_set_drvdata(adev, pl022);
-	status = devm_spi_register_controller(&adev->dev, host);
+	status = spi_register_controller(host);
 	if (status != 0) {
 		dev_err_probe(&adev->dev, status,
 			      "problem registering spi host\n");
@@ -1997,6 +1997,10 @@ pl022_remove(struct amba_device *adev)
 	if (!pl022)
 		return;
 
+	spi_controller_get(pl022->host);
+
+	spi_unregister_controller(pl022->host);
+
 	/*
 	 * undo pm_runtime_put() in probe.  I assume that we're not
 	 * accessing the primecell here.
@@ -2008,6 +2012,8 @@ pl022_remove(struct amba_device *adev)
 		pl022_dma_remove(pl022);
 
 	amba_release_regions(adev);
+
+	spi_controller_put(pl022->host);
 }
 
 #ifdef CONFIG_PM_SLEEP


