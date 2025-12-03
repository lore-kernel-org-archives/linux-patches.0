Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2102D3A1CEE;
	Wed,  3 Dec 2025 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781092; cv=none; b=o+L3rVO5h1S3BICwtxQNzW+owXNcc5k14lC8IaMyuRbi2intpmzKQA+qF55ujTUlrWhSJMxgv+1z4h7pLDM5OYsX8HtK3trpfxHQi6/atzH5cYad6kG+32JaI9K4f0BFv577iVY3Q/abjJSRWUi6X+6cZ3VezPCsoI+cRnHlfog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781092; c=relaxed/simple;
	bh=EbUegxFOvTcUfX0d+JPl0u8PZjxkwxVFrPij8yBB+gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tE4rnGE9pB8v4Bj78RhNmtcN9rSwKaAHB8J8ksJNHB37VJdzHDhYgKLkieSVNckhZNpMY45Mx1e1TWfAENeMFVZYKNUKaIbAkLLU8ir01VNd76UaP13fqg0hxMv8TvlymWETxdxbMZcn2UuKoyanBXZ3GW2QM7xUfvt2xwx7DTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlRmV4ju; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlRmV4ju"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3ACC4CEF5;
	Wed,  3 Dec 2025 16:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781091;
	bh=EbUegxFOvTcUfX0d+JPl0u8PZjxkwxVFrPij8yBB+gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rlRmV4juV4nSlZcPAv3wE1Ds+lmsniwqXNReRfJ5dppp69zpdYehNtHVPtRgOkib4
	 SJOOHhrzART6sKIsN+YeVQA+FocFsiaWFsdhzkvrarBSM4y1kxOgtMTVMTpf9phd1b
	 TPcYRALRWIyPNBXJ5uhGcBzZO+dQBI61hrbwJF3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 46/93] can: sun4i_can: sun4i_can_interrupt(): fix max irq loop handling
Date: Wed,  3 Dec 2025 16:29:39 +0100
Message-ID: <20251203152338.223601186@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152336.494201426@linuxfoundation.org>
References: <20251203152336.494201426@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


