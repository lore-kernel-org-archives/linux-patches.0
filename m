Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0174F3F0A9E;
	Fri,  4 Sep 2026 06:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501617; cv=none; b=RcZJ/ucb2oi6hTVFkUzaZY70MpmIF8zDECHVpYIAk7Ml0ELsVViZSZSp7PfldKr7Q7ZHFqVFbp5m85bUN4pNoJOzt83obb+qzQd/Ib9BnzrnSS6Qoq30IJex4VfDbEiV69Qg+BnjP5ksprYPt08/IydXdZIkhAwQJsXxJ0a0jvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501617; c=relaxed/simple;
	bh=Q2/xH44ZU+V/LaedyfUTKxbEq5b6weslkCT3yAWya/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5rlCKv3qq9BbmdTGDQFHRoGQyEYsRF9q9ddaj0VNzRUpoAoZidRI+F+3+WiD5BfhI8aM1dLZffz74wJcT/BCZwtQfLbAf7ZG8zsMVnTuMn/i/k/bWHSEB2TudBR+2vZx0kWuIlgG0IZFWI5FLSwrRwl/Ogs2xlk0vwLQReAoBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khJJwpQ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khJJwpQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDB31F00A3D;
	Fri,  4 Sep 2026 06:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501615;
	bh=jVFX8TTiAeA3nWnizaRuIBa3+We7gj/aq+JC/ZCKZUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=khJJwpQ55AJEgRTjoVfTVCgyx9MwJaiSsOBT8pGji4h3NT5qSfGF0obSLWYlB4zJu
	 EphfjsJroJYHp81NRKB36ez/3/01OsCOrmZXg8sNfgMrxAB9+Hur8ERvOcWO1e/BzG
	 IIAPww6IHrWf/NoLKBLX2UpKwid16URcbZ3QGeME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 471/552] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Fri,  4 Sep 2026 07:00:28 +0200
Message-ID: <20260904045801.368904154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -135,6 +135,9 @@ static void ntb_netdev_rx_handler(struct
 		goto enqueue_again;
 	}
 
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
+
 	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
 	if (!new_skb) {
 		ndev->stats.rx_dropped++;
@@ -147,8 +150,6 @@ static void ntb_netdev_rx_handler(struct
 	skb_record_rx_queue(skb, q->qid);
 
 	netif_rx(skb);
-	ndev->stats.rx_packets++;
-	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


