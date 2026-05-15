Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CE930566B;
	Fri, 15 May 2026 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860410; cv=none; b=XfJK+BrByenPRWGnQDcw/BktLJbvaH5lCUYTIGunGf8wlhBlUiJa38/74mK4imOw1FkH3614X+w1BLw3pPJD60cYr6CUecbA/duGXpWOL2QjNdB5lLsG/DneF3drcz0afAn3S/R4uFMSoFIc6Km5xo9uMgzdF7QVGrBWKcydamA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860410; c=relaxed/simple;
	bh=s0U7Xx7Qt5kIS+K6XkGOW+etE1u9LT+2GNd/m96OWq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iLnpTcty2FE689T5Sdw54DlhDz+p3jrR3y5ET072pwcId/4TXlsnvemDAKDdwVkhJBzdYv1Mpy+5UmwHVgjGzXgASVqk76CICyqsTQ/wsTUjFrO/tJEeHTUICej5b60JhJvicgwWOaJf2/fl5T7G2D3ak/FISKjB3i1FNaVn0pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gzP4t1Mf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gzP4t1Mf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94A7C2BCB0;
	Fri, 15 May 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860410;
	bh=s0U7Xx7Qt5kIS+K6XkGOW+etE1u9LT+2GNd/m96OWq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gzP4t1MfwdaAmWvWSHtAZ+LTELEh9hA0LaZ1UpJ5m0c/FKGmBTOgevqJJDkZz/fp2
	 F+O6PL/KTMseJaTSxrK1i4NAw8K1reEmgBKzBvS+oHqVjoLbAo1HIBI39jnaBuIqWy
	 e1mPCHtGdyVw+/lETB+jtk76WJOqjEgJgRk7MqzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grant Likely <grant.likely@secretlab.ca>,
	Luotao Fu <l.fu@pengutronix.de>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 061/144] spi: mpc52xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:07 +0200
Message-ID: <20260515154654.963885636@linuxfoundation.org>
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


