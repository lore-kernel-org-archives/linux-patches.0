Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75143D47C8;
	Fri, 15 May 2026 16:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862611; cv=none; b=rTBFcRETx36lEWzmBcijre4/whCQM6/fjYCrue1pAVaD8V32PtthjEGu5mzqpW0hmLdXbFvcemgIMqsW0c/UfDGGwfD3vzYlsEf+t2lLR38MSA4p+9Pb9zl1mHySdO/tcql2+/wNljuZeAJn2YC0iwICgQDoBx85VbLPxvrENaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862611; c=relaxed/simple;
	bh=PhipBECxW+MkfdtmeHo3mBuekl1jUwr32BjVOsxSGcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qy6OvQsG9FAuR36Hc21n9SVzi2qLdpI+Z9KOllt+RE8UHaRji8sR1YEUzoidme/E3ZnmE25t+UXJ+iRm6oLEL5iiRlX4SsRCVgtxQLEtab3vxnHC3WBVlkcYU4tVjgIa3dFvsHaICE+fsvLeuAdeHdSFRmvczwIv1x45WOls6Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pb6dShv2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pb6dShv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4B0C2BCB0;
	Fri, 15 May 2026 16:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862611;
	bh=PhipBECxW+MkfdtmeHo3mBuekl1jUwr32BjVOsxSGcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pb6dShv2dIgf8LLCaGAL3Zv5mbLRLKvMHHF/+UHsse4Kf2jA+ucKPq4hVApnjE6xD
	 qvxI0Ivro81kGYETI/fjThHDMoHtMMGcqC11iIzTwAx4WGOwc4auyI9ZGUp9DiHIsb
	 w09ca1wLC63BnZrftkES8UHsPYhh8I26NqAuur7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Luotao Fu <l.fu@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 114/201] spi: mpc52xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:52 +0200
Message-ID: <20260515154701.022677409@linuxfoundation.org>
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

commit 0f997fdae819a8c2cc83bd4ff7d935ad76c727c9 upstream.

Make sure to deregister the controller before disabling and releasing
underlying resources like interrupts and gpios during driver unbind.

Fixes: 42bbb70980f3 ("powerpc/5200: Add mpc5200-spi (non-PSC) device driver")
Fixes: b8d4e2ce60b6 ("mpc52xx_spi: add gpio chipselect")
Cc: stable@vger.kernel.org	# 2.6.33
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Luotao Fu <l.fu@pengutronix.de>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260414134319.978196-4-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mpc52xx.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -520,6 +520,8 @@ static void mpc52xx_spi_remove(struct pl
 	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
+	spi_unregister_controller(host);
+
 	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
@@ -528,7 +530,6 @@ static void mpc52xx_spi_remove(struct pl
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
-	spi_unregister_controller(host);
 	iounmap(ms->regs);
 	spi_controller_put(host);
 }


