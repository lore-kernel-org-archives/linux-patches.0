Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6703C819C;
	Fri, 15 May 2026 16:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861994; cv=none; b=jqbOX+ENdF9awVl6pkiBiTfi258f1Tj8IMyCDfrOPAS1kLJqPiBx90alNOHhGsH0xXkPEMfrJ+PT9yu+jib+kgl6RbaJnQf2Hftzxkrh/r79QswANkq/3uCO8iTTuG4ghzORRXBzcX+TlAR3uU4ezkX3k/xPb2IlXqf1iB0XBz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861994; c=relaxed/simple;
	bh=8LyEG523PNZDEGVfuhbzy85BztBhvYEaH2eXSHA0nnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/hndNyXRHy1WPajqshYCQCUqmR/+Lj9ddyKQRgCKSmrnonYl/RKlW2Ecs/1hBTap9tphceG6acNnTyjIgJzivem4wHnxx3nwofLmriqS8s8xrb5wo2r88nQKBqYqA/flWXuq4u9c4Ts+hbyBFpY/sM2Jk0fHPcSsoDja+XCAlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7U1W7Ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7U1W7Ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0ACAC2BCB0;
	Fri, 15 May 2026 16:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861994;
	bh=8LyEG523PNZDEGVfuhbzy85BztBhvYEaH2eXSHA0nnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7U1W7Ic36xHRLyNDm45O941WBED0SLEe6wUs7KMA2I9PJTU4rO55tEoddQVXwAv2
	 CkbNglNSYwTRHR1ye7DIXU3d5ibnBfDGck53b1batTsv50BjNQeAdoT5JO6lsm44DQ
	 jDj7kvlrKUY0E9r43gRZ5ck65l6JIGFN/9Ih849w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 024/188] spi: st-ssc4: fix controller deregistration
Date: Fri, 15 May 2026 17:47:21 +0200
Message-ID: <20260515154657.832420039@linuxfoundation.org>
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

commit 19857374010d06ca6a2f7c2c53464122eb804df0 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 9e862375c542 ("spi: Add new driver for STMicroelectronics' SPI Controller")
Cc: stable@vger.kernel.org	# 4.0
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-18-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-st-ssc4.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-st-ssc4.c
+++ b/drivers/spi/spi-st-ssc4.c
@@ -349,7 +349,7 @@ static int spi_st_probe(struct platform_
 
 	platform_set_drvdata(pdev, host);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to register host\n");
 		goto rpm_disable;
@@ -371,10 +371,16 @@ static void spi_st_remove(struct platfor
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct spi_st *spi_st = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 
 	clk_disable_unprepare(spi_st->clk);
 
+	spi_controller_put(host);
+
 	pinctrl_pm_select_sleep_state(&pdev->dev);
 }
 


