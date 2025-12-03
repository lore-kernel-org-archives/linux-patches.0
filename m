Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7261036829B;
	Wed,  3 Dec 2025 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780725; cv=none; b=UWwEi3Csh0K4XCSu1+vm3Os1ML2nvBG1tcDDqjYGOCoQhzorJtHuf8vO7/nKODpuNQvCL98TAULUMHCDHkBV1zeHi/vun/pBbtL801fUhorwAlb43Qd+O4nhbiXg0uf5rZ4UTfg+WCkMmuw2nk1U7ysZG/0iDlWg/0Opue/PXTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780725; c=relaxed/simple;
	bh=mTnMKLI8uoWXR/o+KlGTh0z65sbhbuR5BAQhnULa5go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfjFvvs2tBxj8nBI+HbTrRUVsxGk9zsXpsgPAT+71A0JdkbwhZLn2/V+Zn3iYhwQ06Kd+4ckHTpwvNdLuUaOo0bCE62M+2wBRePzD7Ocvl/vw15SXQdb75aDr9MVaPKdLLpC8WqzIiOa7D1anDvNxoSILyfOquTGmkUcfzmzMto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ReM7lM8C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ReM7lM8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8113C4CEF5;
	Wed,  3 Dec 2025 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780725;
	bh=mTnMKLI8uoWXR/o+KlGTh0z65sbhbuR5BAQhnULa5go=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ReM7lM8Cep2D84y5lJoQSRiMLRHgJ+Xe56BgDtV7yMLV6E+VlxaDHfbBZmytZuFF4
	 /t7LIlSBcRSL2UfBDAJaB55wlVF3Hk/vVxkrRCVBy5iJEBtDDy1OoY6n5yZfc9TrX5
	 NcFC5JUIjXFfH2fG6zgPqelEf3s31dYln7d9m99s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 072/132] can: sja1000: fix max irq loop handling
Date: Wed,  3 Dec 2025 16:29:11 +0100
Message-ID: <20251203152345.961907302@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152343.285859633@linuxfoundation.org>
References: <20251203152343.285859633@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -548,8 +548,8 @@ irqreturn_t sja1000_interrupt(int irq, v
 	if (priv->read_reg(priv, SJA1000_IER) == IRQ_OFF)
 		goto out;
 
-	while ((isrc = priv->read_reg(priv, SJA1000_IR)) &&
-	       (n < SJA1000_MAX_IRQ)) {
+	while ((n < SJA1000_MAX_IRQ) &&
+	       (isrc = priv->read_reg(priv, SJA1000_IR))) {
 
 		status = priv->read_reg(priv, SJA1000_SR);
 		/* check for absent controller due to hw unplug */


