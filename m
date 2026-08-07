Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3587343F4C8;
	Fri,  7 Aug 2026 15:11:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115493; cv=none; b=hXa0N1cT3N12BzUZ+tbQsKbYITRKLHeDjxrZq7rUoG1JRPwssqvoLq5C6SdhzIlysNW457gxhg4WSDY3TEB3Y24gOGIJfJPmzKh3xaRcaPLfZ22P+llQ4RDTtNakiG21I4bfzPvDUGV0OBTnsYorzYhzSNwQV8zGuqLLGKK6DFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115493; c=relaxed/simple;
	bh=745sGN9E8fKOSntCxexQaIYcXlFnNAMwgLVSsJt5nNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R404yq3+kj+p6OUl3ZM2q+UjOruxioFGoKa8z4GSp+YImRMJSpMkDPtHkWsaYzxumSkuo7A53nq7wGm7KI/t/YrfmJ5i6VaAcIf9TJd3ar+MZJSFe02+UAlSpzYc6nchqrQfzhLqUt8/XyUB/MmUJfLMbyIqXAumtGCu9aZuFWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yd0RTOOW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yd0RTOOW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45431F00A3A;
	Fri,  7 Aug 2026 15:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115488;
	bh=UKPul2trLrOlgj1cN1tYeTSvIT4+LILBlNQd74HrlBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yd0RTOOWci5Pm0sYQKPOAxh6t8J3e3Mz0hH2WNe3gTYqxLvVOdKSKS0sToHteyHHf
	 VWB0i+WNXhPl4IZHxhnkAccz8Qxpjz1j2DYv0LoPYm4PEs5tp6e4Uz1YHcNlgpWF5P
	 7I7cR5KUkzTXKHBEWq8GcE3pOnHphpqkvgvtGu0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Martins Alves <lucas.alves@lumal21.com.br>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.18 295/396] can: c_can: c_can_chip_config(): keep controller in init mode until bittiming is configured
Date: Fri,  7 Aug 2026 16:37:35 +0200
Message-ID: <20260807143430.634099915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
 


