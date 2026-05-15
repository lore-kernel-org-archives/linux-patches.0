Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764AC3FF1D8;
	Fri, 15 May 2026 16:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862059; cv=none; b=QoOiXOwuNXjNr2AwhlC4Mgic0xZejOZdxhri2m4OR7qQjnLxzSR/V6gw/dnglJDbS2/RNOColMXZvg9sYZCsKzPlXCGpkCcGLhTKQXBtC09+8smZ9DvGictZH3rkMI/6w1qWhgQ0n19AkJLhOJKH1FFZ2yZMxQ5+14UR5EM7UUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862059; c=relaxed/simple;
	bh=2HKzQeYl5m3di659Rn0veOEq7IJevCsqwaFHjYlJc3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qSb5HwcFlCOAFXlJoUugJ1+oHPmJfk7IkfQZ0hI9wWXSg9+T318f43nHY871zUvfYUhq8wuoz+SDDBqKziIOyjwx1sc3aZp8W5PclXc0b4+Pcq0ns9s4v0ey9CIJoKZkS7lHOsw2Sa1jdpuT5xc2c2mKPud9HatK4+cHRkr7AqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WrCYWtUN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WrCYWtUN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BDAC2BCF7;
	Fri, 15 May 2026 16:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862059;
	bh=2HKzQeYl5m3di659Rn0veOEq7IJevCsqwaFHjYlJc3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WrCYWtUN7gfoJNySABA8R6zfBPSCH+B+AZEXk1/g12KuhnOMqNlywYdsa37XfviSV
	 OnPmOcId4dpt7u2IEM6AkSqM7qhLPaGd1oHGwRdAJ25oY0B0gwNYDJQj+zMJ9apGs/
	 qeRWjlwpcjq63pU/QGURi+Q6WPg5G24AxXp7/N7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Luotao Fu <l.fu@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 092/188] spi: mpc52xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:29 +0200
Message-ID: <20260515154659.325071074@linuxfoundation.org>
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
@@ -523,6 +523,8 @@ static void mpc52xx_spi_remove(struct pl
 	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
+	spi_unregister_controller(host);
+
 	cancel_work_sync(&ms->work);
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
@@ -531,7 +533,6 @@ static void mpc52xx_spi_remove(struct pl
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
-	spi_unregister_controller(host);
 	iounmap(ms->regs);
 	spi_controller_put(host);
 }


