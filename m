Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A92139A1;
	Tue, 12 Nov 2024 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407840; cv=none; b=Il8sSzK1LT/7banAaUtsUpaGsW+ZXOUahKx4E+QcTOsQlUHljTUOMgWAz9rnxnrzMC3grv9PzCY28f9oSdlBJjjyk+hJ+WowSH3u4hwzzihzTbkDnmOwbeIb0xgGw9fTlnuyMRc5j9nXiyqSCFPYs/K8VxX7sKXaasu0gX83wak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407840; c=relaxed/simple;
	bh=PBm0/4ht76Ez0NREHdI+rwCQjvaDAVOmv/KZJp7eDnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEiYemUCeiIOOxDztCh/D4f1YE8mupO4sYgUIzor2y49ToyCZUSZcWtz3Ww62TTc0E9v7ARLUM1CAw79Cgxhb1AyJIerJtfu4agzSXxzQ1XDV3HtiX07a2FmGzi6mALaMlKCcVDRBX2xOlcbPv7bGXyDYAhV45W4/xSI2hdVji8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/C8bYcp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/C8bYcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F03CC4CED4;
	Tue, 12 Nov 2024 10:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407840;
	bh=PBm0/4ht76Ez0NREHdI+rwCQjvaDAVOmv/KZJp7eDnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/C8bYcpFDLRCE0PzCpiBGta1TKqjqACUd9hSPn68PxG+gAJdCJtWeS0CxeGOwhWw
	 zXY1iGPjRdtqxQUyyjGw7hLreLx6Mu7zQNdbA8IG8sBoX9CXe9voOkXRhJ2NOtpStJ
	 dKjMneVqa/M4hz73R7XD92v611Q+PN7qXkct9qPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.6 067/119] can: m_can: m_can_close(): dont call free_irq() for IRQ-less devices
Date: Tue, 12 Nov 2024 11:21:15 +0100
Message-ID: <20241112101851.272002553@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit e4de81f9e134c78ff7c75a00e43bd819643530d0 upstream.

In commit b382380c0d2d ("can: m_can: Add hrtimer to generate software
interrupt") support for IRQ-less devices was added. Instead of an
interrupt, the interrupt routine is called by a hrtimer-based polling
loop.

That patch forgot to change free_irq() to be only called for devices
with IRQs. Fix this, by calling free_irq() conditionally only if an
IRQ is available for the device (and thus has been requested
previously).

Fixes: b382380c0d2d ("can: m_can: Add hrtimer to generate software interrupt")
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Link: https://patch.msgid.link/20240930-m_can-cleanups-v1-1-001c579cdee4@pengutronix.de
Cc: <stable@vger.kernel.org> # v6.6+
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/m_can/m_can.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1600,7 +1600,8 @@ static int m_can_close(struct net_device
 	netif_stop_queue(dev);
 
 	m_can_stop(dev);
-	free_irq(dev->irq, dev);
+	if (dev->irq)
+		free_irq(dev->irq, dev);
 
 	if (cdev->is_peripheral) {
 		cdev->tx_skb = NULL;


