Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C1814B08A;
	Fri, 15 May 2026 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860382; cv=none; b=aqNjULJmIn+jkw/vUX3Io8xVgH4pTKgYpF/G30XAB63YfzkmwugsaOJMN66N58S7/r/5OF84NCSqpvXmUrFZU30PXgBlJoCFuqpnS+HYbRnTwsYw2kLIf9Kuh1Kp8CXtlPTkzxI0b9JopXa3mlzrMtcnMaqgAzAAZENaX3k2P1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860382; c=relaxed/simple;
	bh=fsHmJpCuDMOgKkMd/uolAiHIGhIw8v1uuHyUzCP4i8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kaDx4fKUmpi/TqN7QlvxaLCzrzNX/1L/etunjZHGvSvcbWb50DTBri/B+iZD8BxLXZGakhZa86c+p8PcDG5hW7VHFPLxyXwYdmBlelWJd2TICoj9GdFc4UoBqbx2zCE/WNzzhwHdFieegkWYpn3vPaCBWEp2QIrrN5zROPXjxX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vg2fWuWe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vg2fWuWe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E15AC2BCB0;
	Fri, 15 May 2026 15:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860381;
	bh=fsHmJpCuDMOgKkMd/uolAiHIGhIw8v1uuHyUzCP4i8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vg2fWuWe+BDhik+odTpn6TCfWPqYi/YABF9RK7k567JGBRCXPgoq/SzvPsLaOaTso
	 p7sv6TNCrqJ8ilGpOMA/zADQYNSLVRtdpaGLgHo3gVTts2NIT9orlJKtWmeHMhrRno
	 +b6seO7JeERFhKjrVv0ucxOfGPPcOEkXOzULp1nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 060/144] spi: mpc52xx: fix use-after-free on registration failure
Date: Fri, 15 May 2026 17:48:06 +0200
Message-ID: <20260515154654.941182930@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit f62c060272b9d7423b1650b844e8e4e7b8f9f925 upstream.

Make sure to disable and free the interrupts in case controller
registration fails to avoid a potential use-after-free and resource
leak.

This issue was flagged by Sashiko when reviewing a controller
deregistration fix.

Fixes: 42bbb70980f3 ("powerpc/5200: Add mpc5200-spi (non-PSC) device driver")
Cc: stable@vger.kernel.org	# 2.6.33
Cc: Grant Likely <grant.likely@secretlab.ca>
Link: https://sashiko.dev/#/patchset/20260414134319.978196-1-johan%40kernel.org?part=3
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260421125800.1537361-1-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mpc52xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -501,6 +501,9 @@ static int mpc52xx_spi_probe(struct plat
 
  err_register:
 	dev_err(&ms->host->dev, "initialization failed\n");
+	free_irq(ms->irq0, ms);
+	free_irq(ms->irq1, ms);
+	cancel_work_sync(&ms->work);
  err_gpio:
 	while (i-- > 0)
 		gpiod_put(ms->gpio_cs[i]);


