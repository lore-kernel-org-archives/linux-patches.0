Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E02D73D300A;
	Mon,  4 May 2026 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904039; cv=none; b=Y/7BgojogpIKKLfr8WvxSmYk2MWmzVvNP1hWxNivhTkc8SYuu/hPr3aAcaaS9lcQzxc3sopaIogNJaXo0R5SpSNGhD4k5KAmELfhYOVeKCwS7+JeA7l8hhIepgdbP0qgGDTGj3YIHFgn0gtcy/BJnoo5Flwv+IxtRmGd3lccSwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904039; c=relaxed/simple;
	bh=0ALTWFAwfwxj9XnztntS1/J4qvVfAd1+hQ0jwP/KfCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuAa/M9Hq0qfkIpC28icN6WJO+TdJv8nnaYsxIi6c5gPd+tuToGJzHiavlNZYqKcOwMAUgBB8dXsLkL3dOc2R1js866eFalrqpO6tt+VqQKmc52tPWgEJPwo6vAulNd7tmEn2kL6YAx3ReLaeqoq5Ql0+HBT49cwwBd+b0sgXn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgMachsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgMachsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A5C2BCC4;
	Mon,  4 May 2026 14:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904038;
	bh=0ALTWFAwfwxj9XnztntS1/J4qvVfAd1+hQ0jwP/KfCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgMachscgVlCo5Jii8eKULP3lkiByLZ0Ytz+TYvWgZ71edZHCkkCjvQPRQCfMxN38
	 g6Gw/yXzu5GYUdGXu75bKpTqI2qfkCi/Vzg9jBkBdwUI1iELaY4iFgaDKz84GGv5b1
	 0NOagYQzlNuJgJ/tKdUvxluHpOdHxpz4ToU33RdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marek Vasut <marex@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 127/275] net: ks8851: Avoid excess softirq scheduling
Date: Mon,  4 May 2026 15:51:07 +0200
Message-ID: <20260504135147.621237231@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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


