Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E6B4D98F1;
	Fri, 15 May 2026 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862606; cv=none; b=aY+NrMhaP+buhFLcpDYv8LLKkZhCxtUPU916sVI+HuhNraKtMmjC8X0PnI1g5OD6tn9okzuMiFS3kGfDts7zp0I1HagT+E/2LqmwmFnKJ9Oaa65899d4FwLHPeSCa/f/P6aIzZDT19AMSYEi5U69xXYZHGaokBeHjMaiCDcAMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862606; c=relaxed/simple;
	bh=tYixHNIh9pMwJO40X9nzzWV9jd6InBCDuKfbw7iNVgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S3iXAKVhLMVu/W2P63itdoPSzSHcu57MRwpOPyQ0Ze0HBc8gc0VgKNUlRirxJAYofgOPzITom2FwfrBnfcLjeDAmT0myV7MQ66g9jbeaolXtA/MjhuwTLH4HYBk3podhRC34PdPqeg7v0MMpq/YzNupUu+cHVSGQ9SnGY0WYgaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=efAzfOeA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="efAzfOeA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AD3C2BCB0;
	Fri, 15 May 2026 16:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862606;
	bh=tYixHNIh9pMwJO40X9nzzWV9jd6InBCDuKfbw7iNVgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=efAzfOeA3mDckP0bxHy13hUGPN7zV1qV8ApgpfTc9zJLzBV5GJCj8JfCHX601LcoP
	 ssJDDSQdpaqGDqESST9SObWnrStdZV3tBqlhMRWGP/yO4WNG6FdT809F4zXp9dA5ro
	 4AUA1rhQ3qC9vs3huH9VEngJ3rBi4WyZmWC75qqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 113/201] spi: mpc52xx: fix use-after-free on registration failure
Date: Fri, 15 May 2026 17:48:51 +0200
Message-ID: <20260515154701.000658379@linuxfoundation.org>
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
@@ -498,6 +498,9 @@ static int mpc52xx_spi_probe(struct plat
 
  err_register:
 	dev_err(&ms->host->dev, "initialization failed\n");
+	free_irq(ms->irq0, ms);
+	free_irq(ms->irq1, ms);
+	cancel_work_sync(&ms->work);
  err_gpio:
 	while (i-- > 0)
 		gpiod_put(ms->gpio_cs[i]);


