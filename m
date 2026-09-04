Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F281347532;
	Fri,  4 Sep 2026 05:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500008; cv=none; b=dJ4nUjQnPaaqn7bOnu5+ladSihZT2koEeJnx+CMS4pAtPoHoh6QN7o16x6OP9Lg6Q4+nppSiLRFJCMLyRJpgo3jVYkSBHKcYXRXY0YOYp/kQrDSJaglwhEtlU8ALaMMMDafw5PNZx0T+VvG853/e1myu7A9A3qM2MrUUo0MRRXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500008; c=relaxed/simple;
	bh=iwOEuLInZ73WBaQzueR6wjUJ9bXdbhImImT0xml2Guc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyoGTgDvRAnPM0r0XheISwmUIa4tKYJwEx7QWdYlIEolYBzu9tBPxrGSdg49sPKDnnsgn3oDVjDWKS9aXX8vl1sChrQfhmas+pkmxZhy2pt8dEblvFrlRQD5k5tM2wSwG6YeIlbc43wngp3LV9hbAq3FlWfdmC1cpeokWIvVa+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0zYuc/Kd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0zYuc/Kd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F5181F00A3D;
	Fri,  4 Sep 2026 05:33:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500007;
	bh=JDtVfzj9srISpl028EFQLLKMoEqzDkUnp/wSQPBr/ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0zYuc/Kd6wcTCF3R0MrGbO3DbdJk6OUTezpdr26ePxsGSipyqpNrnCG65GU2bCUbN
	 sPrw/bT6oSSWtwUFMw6OChsDaovqLvyOuKHa0aLFe31N58kTyjjf1OVGKQG5JHB+ns
	 iQ6ah/uwOve9Lrx+VvxX9NI3JAGm/cONyzILdFkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 617/713] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Fri,  4 Sep 2026 06:59:45 +0200
Message-ID: <20260904045817.657522047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit 31ded341c375bb2faac1d77ab0012a732ba3e2a6 upstream.

When replacement skb allocation fails, ntb_netdev drops a packet that
was received successfully and requeues the original buffer. The drop is
counted, but rx_packets and rx_bytes are not.

Count every good packet before allocating its replacement.

Fixes: d2121faf133a ("NTB: ntb_netdev: Preserve RX queue depth on allocation failure")
Cc: stable@vger.kernel.org
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260819172539.1450821-3-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -144,6 +144,9 @@ static void ntb_netdev_rx_handler(struct
 		goto enqueue_again;
 	}
 
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
+
 	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
 	if (!new_skb) {
 		ndev->stats.rx_dropped++;
@@ -156,8 +159,6 @@ static void ntb_netdev_rx_handler(struct
 	skb_record_rx_queue(skb, q->qid);
 
 	netif_rx(skb);
-	ndev->stats.rx_packets++;
-	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


