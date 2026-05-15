Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76362609EE;
	Fri, 15 May 2026 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862110; cv=none; b=JeZnaaKlYK5JbvYcMOKFqd0WHsds8xoVQlvXtgH8Ne0ohm4vaLW5pYJ+aEGUXrrrjJzsG1NalVItfVJgVF1sW2ErwW9YrdX8YPruWHRen+Q4X9NiDF7NYaR6zvmMZrOyfpsO8Xt1IjEFHkM+2JpMn4Y8lJ918cg45yr0+oP3AkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862110; c=relaxed/simple;
	bh=VbGr3JYSeyFlJZ94aVdu8wwTmYWSMA1puST+hbxUmXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JNCAx16Jb2QAeUqAQbbyncKdVEQNVFEQnVP/S4o7d8x8wyd5/EQZo4NmNJSpIiQf5EaBl9lGf4iHCbuDcK6ot5jqqnRk0Stk65yRwQv55D8eX7GANJPU0z+DU4iQhbKEQF9pooMK4rIx6NaTYIzh8j+Hu1URqwTRTzpB+28hPfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lhAysJQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lhAysJQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBE6C2BCB0;
	Fri, 15 May 2026 16:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862110;
	bh=VbGr3JYSeyFlJZ94aVdu8wwTmYWSMA1puST+hbxUmXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lhAysJQlHtx2/daWM9xrkg8mAOv3Xph0sDcjmIeLT4jLkOeBA6qKl0MJefVJfQVGs
	 /5QpvTT6CKgqYghKHBYH6C2DrnBMYUDwT4vLtVJVtLro6D4QGUhooiDyp06ux+Si4I
	 Vq/IYdn2DxeOBlqhd2X3PJiYVq2xJ+qeYuxsn6gk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 071/188] spi: pl022: fix controller deregistration
Date: Fri, 15 May 2026 17:48:08 +0200
Message-ID: <20260515154658.859491520@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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
@@ -1957,7 +1957,7 @@ static int pl022_probe(struct amba_devic
 
 	/* Register with the SPI framework */
 	amba_set_drvdata(adev, pl022);
-	status = devm_spi_register_controller(&adev->dev, host);
+	status = spi_register_controller(host);
 	if (status != 0) {
 		dev_err_probe(&adev->dev, status,
 			      "problem registering spi host\n");
@@ -1998,6 +1998,10 @@ pl022_remove(struct amba_device *adev)
 	if (!pl022)
 		return;
 
+	spi_controller_get(pl022->host);
+
+	spi_unregister_controller(pl022->host);
+
 	/*
 	 * undo pm_runtime_put() in probe.  I assume that we're not
 	 * accessing the primecell here.
@@ -2009,6 +2013,8 @@ pl022_remove(struct amba_device *adev)
 		pl022_dma_remove(pl022);
 
 	amba_release_regions(adev);
+
+	spi_controller_put(pl022->host);
 }
 
 #ifdef CONFIG_PM_SLEEP


