Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAB51F16B;
	Sat, 17 Oct 2026 17:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258698; cv=none; b=PNij/j+pbOIJiVjlXUl4xTYz/W2LV67NrWit3BcIRY/e20ySFtrBk1oYY21j2U5lOukJCsMjp6+l+L2f96Rj9qwkvva8BsulJl301lmI9PEpkeigR+4D/qjSkzJl7BL05ZyrZKYIdIWF9E0C2zGp4eH7S2Jw3liu4harKx6duvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258698; c=relaxed/simple;
	bh=T4Z1Cp3CrXa4EY4NADfC/F7K4Np8PndGbhbZdmQI4io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLRxk8NfnZVvXD+PPGqKduyRt/Wm7AH0eRVVASeM1WFBJzn4+0ny4Kk7JU5apxw94WShRvMMyJ1Hv+BMmWa+eODg40sMNMDRiVl6UaL95Bua/F2tHJvBYyxHdMn8Y9ZjoSYJne9nF+2dbECdanTykmOCUy7Nz/t8ML+yQNSOuRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HaAb61/N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HaAb61/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 036DF1F000C4;
	Sat, 17 Oct 2026 17:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258697;
	bh=yVnxjRYb3c5WzzrO/OXMSxKXDnxJKQU/tm9W+MoHLas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaAb61/NZb+TQCk24TMSneNpKu3mqNL3cNJxxPrFhFlpwWs++2z5IDwbJx5ras8wC
	 HbJ2oRDhcnyCHpN3K9CJgvd0TghLzyAhOpFwe6wPCrvhkvc29z4oWSeaPyRvP2uhvk
	 aGYweT5q/ZBL/mynFosU7+UDGpjGIRePwAm1yXc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Luotao Fu <l.fu@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0968/1674] spi: mpc52xx: fix controller deregistration
Date: Sat, 17 Oct 2026 17:54:00 +0200
Message-ID: <20261017160455.968671264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 0f997fdae819a8c2cc83bd4ff7d935ad76c727c9 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mpc52xx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mpc52xx.c b/drivers/spi/spi-mpc52xx.c
index 2da5e19eaade9..9b758efb0b7fa 100644
--- a/drivers/spi/spi-mpc52xx.c
+++ b/drivers/spi/spi-mpc52xx.c
@@ -519,6 +519,8 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 	struct mpc52xx_spi *ms = spi_controller_get_devdata(host);
 	int i;
 
+	spi_unregister_controller(host);
+
 	free_irq(ms->irq0, ms);
 	free_irq(ms->irq1, ms);
 
@@ -528,7 +530,6 @@ static void mpc52xx_spi_remove(struct platform_device *op)
 		gpiod_put(ms->gpio_cs[i]);
 
 	kfree(ms->gpio_cs);
-	spi_unregister_controller(host);
 	iounmap(ms->regs);
 	spi_controller_put(host);
 }
-- 
2.53.0



