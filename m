Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC772DA759;
	Mon, 17 Aug 2026 15:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980195; cv=none; b=UJEll8ud4l2Ir9Rv6Gu2i0lfjp0jcG5bZs4KHLKexsQxRcI0xwLyhEzB6S188HrdwRYSto+70NsvAOACTp4pBH+eI/Fm6DiXWMskON/G8o6XN3VnBPUsi259ACcjFHVbcXcb4YeFf5qVb+EbQuRdjOl065NIQFt4ijomz0e52aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980195; c=relaxed/simple;
	bh=4YM6MQRNwOYg0mDTNOmDjYJCV67O9lZxzdcvWX8um5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PaAACiUMF7kdEO7pxK9jhksE//jXJVUhfrDN8uIb6Cfg6XLSiJ5KW6n27H2ijW++/WDA/XBJoMYKcFJUsZtXl+Oy3VjYms1Y1if8qrkVHdYHnwSxAuC83VY7jeAKURZVT2pPScM64sYX2asWvdV0+ImPfwZAursEhYsBvcpg91k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQ/x5O3n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQ/x5O3n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CED1F000E9;
	Mon, 17 Aug 2026 15:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980194;
	bh=duZU/y58adbhOPZBL0pVks+tMNdqPHyUeyvixc4W2aU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQ/x5O3nXE8zEkpdlNDodUQ1ctsRI//k6ue9/58l+Tyxc9gG992jo5PaaUHtsSOr4
	 KGhEkjEROyoqGGIrNmPlvLFcFqXuIcHxGKdYR4fiWz+WDEccGUoUahwhhbaS9jTfhc
	 2GbQSawC947I7gmr57NHaR3/4gsggYSCRXJUmlfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.1 449/609] can: c_can: c_can_chip_config(): keep controller in init mode until bittiming is configured
Date: Mon, 17 Aug 2026 15:32:25 +0200
Message-ID: <20260817132559.086955221@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Martins Alves <lucas.alves@lumal21.com.br>

commit 26504844613fb44c7cab1c5f6fcff77861709baa upstream.

c_can_chip_config() was programming C_CAN_CTRL_REG without CONTROL_INIT,
which may allow the controller to become active before
c_can_set_bittiming() finishes.

That creates a short timing window where the peripheral can interact with
the bus using a different/default bitrate, potentially generating bus
errors and corrupting traffic.

Set CONTROL_INIT together with the control-mode writes in
c_can_chip_config() (normal, loopback and listen-only paths), so the
controller stays halted until bit timing is fully programmed.

This prevents transient bus disturbance during startup when the configured
bitrate differs from the active bus bitrate.

Signed-off-by: Lucas Martins Alves <lucas.alves@lumal21.com.br>
Link: https://patch.msgid.link/20260714164839.771123-1-lucas.alves@lumal21.com.br
Fixes: 881ff67ad450 ("can: c_can: Added support for Bosch C_CAN controller")
Cc: stable@kernel.org
[mkl: remove space before close parenthesis]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/c_can/c_can_main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/net/can/c_can/c_can_main.c
+++ b/drivers/net/can/c_can/c_can_main.c
@@ -597,20 +597,20 @@ static int c_can_chip_config(struct net_
 		return err;
 
 	/* enable automatic retransmission */
-	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_ENABLE_AR);
+	priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_ENABLE_AR | CONTROL_INIT);
 
 	if ((priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY) &&
 	    (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK)) {
 		/* loopback + silent mode : useful for hot self-test */
-		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST);
+		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST | CONTROL_INIT);
 		priv->write_reg(priv, C_CAN_TEST_REG, TEST_LBACK | TEST_SILENT);
 	} else if (priv->can.ctrlmode & CAN_CTRLMODE_LOOPBACK) {
 		/* loopback mode : useful for self-test function */
-		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST);
+		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST | CONTROL_INIT);
 		priv->write_reg(priv, C_CAN_TEST_REG, TEST_LBACK);
 	} else if (priv->can.ctrlmode & CAN_CTRLMODE_LISTENONLY) {
 		/* silent mode : bus-monitoring mode */
-		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST);
+		priv->write_reg(priv, C_CAN_CTRL_REG, CONTROL_TEST | CONTROL_INIT);
 		priv->write_reg(priv, C_CAN_TEST_REG, TEST_SILENT);
 	}
 


