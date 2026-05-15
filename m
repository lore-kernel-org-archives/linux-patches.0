Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506933B0ADB;
	Fri, 15 May 2026 16:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860885; cv=none; b=UbZpEhaiKdi2FrEweFa5yeteTPu5gSuAtdMFQ0Db1CEM4Ek3HPaFWnM0FOgSw3ip5L+tDoBCl+9riw8OALTD1YU5kbeWKYC4bFw77+dzpO6rhB7EaL6PQjjIVoQ9BcysaXGr8pBwxjJJgb95TGDqcz38TFb/PVRrKqasrE3zC4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860885; c=relaxed/simple;
	bh=JNz4yJu87R0ec8FO6QYJDvCTkSio2K6T6qQfEefbdwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxYo29HNhSEqU8iZ379uR6a1AGJoHzcsCZGnO1xehLzIm3UmennYSJGSLL8mOF7Q+NiWey/eml4HEyMZwpJ7UmFezLUw0Ol7bRg/4Rabs9tMewVdQTGAnBCOxU7p61FUz5LOGPAVpFjYhpcVDXHyKAWdaacJt9MAXQvWCUXD8xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NCnPWFl8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NCnPWFl8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB2CAC2BCB3;
	Fri, 15 May 2026 16:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860885;
	bh=JNz4yJu87R0ec8FO6QYJDvCTkSio2K6T6qQfEefbdwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NCnPWFl8iQFp3t+Eymj9WgPSQ19XJcjpavZHbVA9UOxc1ZxwYCUlbudcNS4GIczpV
	 nITcCz0N9yGvLRArQutj1Pq13ot/w6/w4KKdguHxpm0ZQbgQer09t2oNbEzRZhFiyq
	 UzXOMzz0rS45pz1whwmBw42lvJ6QsLZ4jF0A9jyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 074/474] net: ks8851: Avoid excess softirq scheduling
Date: Fri, 15 May 2026 17:43:03 +0200
Message-ID: <20260515154716.642044812@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


