Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2134935A3AD;
	Mon,  4 May 2026 14:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904576; cv=none; b=O1smlE9gAvTkFUKHdf5Un/RwPg+gy8gq7fvzoBBhOodFFSnf93l+NU7ldFEnfoxMud2XeLkdRtCMYBUihhEKUmfcJKYmXQOvGDFfviDXQFZbaUlwsihFV1xyh9PF9k4rBoIhz8f/QhRgXs5EttbTsHT9s2bI535g4zUfGggzhiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904576; c=relaxed/simple;
	bh=G/gc1VzAnsodX8Wtd6KozWIsTfVdo3TSPs0l/Qz2l+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPL+kC8Wg0I4nMsi13cjfG5JjEWUg0JnpbvvRHhYUkTf7+gQa6q3Cr3/H2AmnnRtmzjPGC2cXeoTgX2g5FuCa8/pknHXv9mq8IZp0bghfBHhw5c3COO4ifDLUr05+VMLwpavQjbr8dwO1orWwJbhdpP71o68NPRs3tLe/vpe+p0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6EkJc91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6EkJc91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB25DC2BCB8;
	Mon,  4 May 2026 14:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904576;
	bh=G/gc1VzAnsodX8Wtd6KozWIsTfVdo3TSPs0l/Qz2l+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6EkJc9123BB/LFIBISxqi3HBZLuuppYWm61Lxiv5PyH6ak7JAZlWO00NQEPnhVrw
	 SIs8oZFTxF9K/c+4frjn0RDl52mwd9l/KP3o497EYFA4MrKoaOVZj1y2HWgPo++VsE
	 4+VpDtsd/kvSIm0s73dPsDbk4XCOErYZlAElXfzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 092/215] net: ks8851: Avoid excess softirq scheduling
Date: Mon,  4 May 2026 15:51:51 +0200
Message-ID: <20260504135133.519018432@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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
@@ -389,9 +389,12 @@ static irqreturn_t ks8851_irq(int irq, v
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


