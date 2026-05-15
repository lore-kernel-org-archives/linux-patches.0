Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F60A3F58D7;
	Fri, 15 May 2026 16:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862056; cv=none; b=ER2zcNleL/YxJ25JKocw0qIfGWuaOOfai79m2MJal9nRJ5NEYJhM7cGKQ9D3ZBhsHz1ZMWJTM7IiAb9bh8Mr3dnXeJKIlpmW9sCZ8seEmXqTIDk/f93UKmMzdLptXRRuob+TQSyxkfXQXOJD1A6cVyKGItVeJ9RrJPnj7aVWFYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862056; c=relaxed/simple;
	bh=QIFW6hJ0O6OamG3yf45z8llAXMaLN4rRR96X9Hys2xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsAeMIzleNqFHEEY+OlwF6nzlisqvmCOvkK3T9OcQYtbpHHrRO6PC41RkKxUqUBfl88T6PRXX4fMUClXGu7UFtQAlQHm58ls4NFuWcyNNRNVzfYZOD/4RX5W9qGJ+JEv1YcFNCrqukNujoWLngWrasNcTt6WwNYzrbZoM6BLlOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=foB15lPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="foB15lPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 361A2C2BCB0;
	Fri, 15 May 2026 16:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862056;
	bh=QIFW6hJ0O6OamG3yf45z8llAXMaLN4rRR96X9Hys2xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=foB15lPr4JMnltJv3rlA4DtOzBTmTpENCyZEqHWx/3U3gw/TpYKz0QKjag8R202vV
	 OyMsQ/S7Fiu1xqqzqq9LG2XRU15Q0Vo0hI7Q7hgCEvxLUX8/cCVpLrqk0GqWTSWRYa
	 igDsp5OpCCvICuMc4jeO5rxQUY0YogLVMT1QsjVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 091/188] spi: mpc52xx: fix use-after-free on registration failure
Date: Fri, 15 May 2026 17:48:28 +0200
Message-ID: <20260515154659.302610231@linuxfoundation.org>
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


