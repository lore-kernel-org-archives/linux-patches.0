Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249F134F483;
	Mon,  4 May 2026 14:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903214; cv=none; b=QLYMHa/9ln1ccaN58Jd0qFPWMtwCACA47bU3jeUhvkp1K605dILl6ZoYZ7Vho1a7/r8BSCty2Opux5Fq504ZfiLkA6ld2f1L6U2qAfVSJoKjKSUWdojY5/4MK/YWSRJHQj56XP0zQYlQHNE4hk9r9YvtnOPJ+0TokpH/RxNO97o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903214; c=relaxed/simple;
	bh=mKwOo9ROOshfz4MnhuSdau3JLx1gEMmzmT1lrNj6S+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RpZpjQWM/oW/OAriV9Bq8e+HIt+ZkZHqC6/hPflTk1+kHfq2hjdiuXjR6Q84nTl9gL3Qm0N0oH4p1eRh7c6U2DI8g7yeAhC/chMWeq7gNGGjAfuxJhEqyST174IC6HpuWO5Fh+hs7x62Ja+tZsawuYpxQO5CRoOTbw+s7QWnCIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+8MZjB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+8MZjB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4A3C2BCB8;
	Mon,  4 May 2026 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903213;
	bh=mKwOo9ROOshfz4MnhuSdau3JLx1gEMmzmT1lrNj6S+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+8MZjB2IcTnIVHYeu3gXSlZ6CHMPKwIE3vFDy4b8shfHmyhSPdtWv7LOWxzGiDtu
	 nsXFttzBnTYKWZiz4aRtaMvTnqQhRp2EoLpaHdHPFoTDx1ZHR3WP1apBu3bXUcF8q7
	 KXYYtU51RXiZfUEGoQdiSyzKlKm3Ib0N5LWBIqAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 148/307] net: ks8851: Avoid excess softirq scheduling
Date: Mon,  4 May 2026 15:50:33 +0200
Message-ID: <20260504135148.353513909@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@nabladev.com>

commit 22230e68b2cf1ab6b027be8cf1198164a949c4fa upstream.

The code injects a packet into netif_rx() repeatedly, which will add
it to its internal NAPI and schedule a softirq, and process it. It is
more efficient to queue multiple packets and process them all at the
local_bh_enable() time.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Fixes: e0863634bf9f ("net: ks8851: Queue RX packets in IRQ handler instead of disabling BHs")
Cc: stable@vger.kernel.org
Signed-off-by: Marek Vasut <marex@nabladev.com>
Link: https://patch.msgid.link/20260415231020.455298-2-marex@nabladev.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/micrel/ks8851_common.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -373,9 +373,12 @@ static irqreturn_t ks8851_irq(int irq, v
 	if (status & IRQ_LCI)
 		mii_check_link(&ks->mii);
 
-	if (status & IRQ_RXI)
+	if (status & IRQ_RXI) {
+		local_bh_disable();
 		while ((skb = __skb_dequeue(&rxq)))
 			netif_rx(skb);
+		local_bh_enable();
+	}
 
 	return IRQ_HANDLED;
 }


