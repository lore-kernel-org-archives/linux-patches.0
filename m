Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A406313271;
	Wed,  3 Dec 2025 15:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776734; cv=none; b=ipVv4QZiiDuGhdToWLpu7IbuS4XqX6OJXMHrX8XjqKWLBNHZK9gRPZ8cbn70qO3r4MIgAJcbMh12nqhEX83g182HoXEO9Vc4AwUUjf0BTRUHWVTnQ4QvaLXDNYrXwpO3f97clOv1L+cgtgxBzK+sGpN1OrNS5yFFK+5BwGr1WyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776734; c=relaxed/simple;
	bh=Tad13/xYU6yfN617JCpNU47Ak3rchB+qMRXCNh1RxcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kdC5fiSmiIm4SgJway60q7Lj0l3T1N5KvMCQVthDTnc/CD+RBuYYuSkxjeFtDK/lTHnL4NKMG3M7xhV6SLGwRgBvI2uacU0fG7SzmB5MGAifyptmpkK8AE8wRjQpeQcyeDeEF/6a6hSu+YGtpersfpZRCIE3PGBCFz5ofoP/PjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMkz20Pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMkz20Pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF0EC4CEF5;
	Wed,  3 Dec 2025 15:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776734;
	bh=Tad13/xYU6yfN617JCpNU47Ak3rchB+qMRXCNh1RxcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AMkz20PnJXsDM/pk9jaMWf0wydriXHqwrODDiyVixwZDeofchU5QzpCYZEBYUm/dj
	 7u39EtIEKsjtWPZL4JIpFnTR8LG6do070EDFVTkgW9g3zFsgFmz9YDKpA7i9rGQInJ
	 D2/ajy3gNbGoUD+Zlj6RUqmp4ptu9+liw+iYTl0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 270/300] can: sja1000: fix max irq loop handling
Date: Wed,  3 Dec 2025 16:27:54 +0100
Message-ID: <20251203152410.636354452@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Mühlbacher <tmuehlbacher@posteo.net>

commit 30db4451c7f6aabcada029b15859a76962ec0cf8 upstream.

Reading the interrupt register `SJA1000_IR` causes all of its bits to be
reset. If we ever reach the condition of handling more than
`SJA1000_MAX_IRQ` IRQs, we will have read the register and reset all its
bits but without actually handling the interrupt inside of the loop
body.

This may, among other issues, cause us to never `netif_wake_queue()`
again after a transmission interrupt.

Fixes: 429da1cc841b ("can: Driver for the SJA1000 CAN controller")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://patch.msgid.link/20251115153437.11419-1-tmuehlbacher@posteo.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/sja1000/sja1000.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -511,8 +511,8 @@ irqreturn_t sja1000_interrupt(int irq, v
 	if (priv->read_reg(priv, SJA1000_IER) == IRQ_OFF)
 		goto out;
 
-	while ((isrc = priv->read_reg(priv, SJA1000_IR)) &&
-	       (n < SJA1000_MAX_IRQ)) {
+	while ((n < SJA1000_MAX_IRQ) &&
+	       (isrc = priv->read_reg(priv, SJA1000_IR))) {
 
 		status = priv->read_reg(priv, SJA1000_SR);
 		/* check for absent controller due to hw unplug */


