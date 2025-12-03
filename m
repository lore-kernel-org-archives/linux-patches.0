Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4823C32FA07;
	Wed,  3 Dec 2025 15:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777108; cv=none; b=Mxwyrgt1WyL4FGJLlGHPyaAMRk8Hgjo1oF7kLalCOaTrRMpWg73w7G59NAqR1hCSZOUW37GUzkmvmeVWr6iol8jhAUlqGD2j7uMlSFz/hW9gnpXw3jvPTA21GQmwpm4EvRCotQRYxwo10AvReoOeDo1mChIriCY0SZzTHvz9Ths=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777108; c=relaxed/simple;
	bh=Nn67rhH3+VlOiSHlaP6SW5uCvBSF4OpFjQHlmUH+gQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OoJ2fOiY5jr7a4jMA9Lqroaj1eZV5yQzQkWA1AQ52J8nvTsXwQXkumgvvIBR03CVnX68ixbjyOJvVNYNBGJaEj3A65DPhcko5ylw4Fyzo0Hbaqhqi38qNoBs8YQc8jVU3mkQ1dlWra5PJFbY1HuHHEPNjCa2Wi/XuHEoOdpU1BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYoNdTWl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYoNdTWl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA65DC4CEF5;
	Wed,  3 Dec 2025 15:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777108;
	bh=Nn67rhH3+VlOiSHlaP6SW5uCvBSF4OpFjQHlmUH+gQU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zYoNdTWlX8aHklo1AbY8euVfrX6ugSwfWMo2wHiri0oCq8CNfa0nWmUhFnSxw0M60
	 0yBtX9MSihB3Nnk4oqvvbSwQ65iNaEh2Gjp7LxgfKjbRGPwAcLJNpywD5axJfWAaSY
	 saYTeP080As5diQTXgcbNnERpiDMXQB1j+ua7z00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.17 085/146] can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling
Date: Wed,  3 Dec 2025 16:27:43 +0100
Message-ID: <20251203152349.573255217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 76544beea7cfe5bcce6d60f53811657b88ec8be1 upstream.

Reading the interrupt register `SUN4I_REG_INT_ADDR` causes all of its bits
to be reset. If we ever reach the condition of handling more than
`SUN4I_CAN_MAX_IRQ` IRQs, we will have read the register and reset all its
bits but without actually handling the interrupt inside of the loop body.

This may, among other issues, cause us to never `netif_wake_queue()` again
after a transmission interrupt.

Fixes: 0738eff14d81 ("can: Allwinner A10/A20 CAN Controller support - Kernel module")
Cc: stable@vger.kernel.org
Co-developed-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
Signed-off-by: Thomas Mühlbacher <tmuehlbacher@posteo.net>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20251116-sun4i-fix-loop-v1-1-3d76d3f81950@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/sun4i_can.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -657,8 +657,8 @@ static irqreturn_t sun4i_can_interrupt(i
 	u8 isrc, status;
 	int n = 0;
 
-	while ((isrc = readl(priv->base + SUN4I_REG_INT_ADDR)) &&
-	       (n < SUN4I_CAN_MAX_IRQ)) {
+	while ((n < SUN4I_CAN_MAX_IRQ) &&
+	       (isrc = readl(priv->base + SUN4I_REG_INT_ADDR))) {
 		n++;
 		status = readl(priv->base + SUN4I_REG_STA_ADDR);
 


