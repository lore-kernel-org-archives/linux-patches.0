Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7184A3B19BC;
	Fri,  4 Sep 2026 05:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500005; cv=none; b=BELWsSB7w4few9TFTOHHkyNYa6wyvk1KaAmCbl8pHwhWLRBvusgnTMQF5H+l/DrtOpbZrsVA9+9hgC8NnFb56zZW2mlqMfMDIZUos18vpYXT9G285TrXo95jrDsQO0fOpkeFCIDpaAzxeqascdrMufncU7IyQnUPHAxvKccYggI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500005; c=relaxed/simple;
	bh=Yy7A1oHvxMTHK7xhK+Z4+vQpvYxUgyIvm0G+IJaISSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ChhPxOZ5nx4mLhoLUoXohty46RQ3bjmgMj5tUsbpq16LBiklfkPE67q0qmwQv9bP/YV1593Iep8YZ3NNgKBUcaptXmiDylcD3oUKjirWeFapjOZCuLctlnHO/Va9T6Tb7E8Bq2Rf2t/gmy+TCQGHqeah1ZBLBeMqOWGE+nIC3Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pEoMyqV7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pEoMyqV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCEEC1F00A3D;
	Fri,  4 Sep 2026 05:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500004;
	bh=nCp4ZdvoA4gDxDJLtf7OekZR6Mrq1026ALkA7aMfyuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pEoMyqV7vMvjh8L6BTAO4RI/1XTQj7I5jWjaAWNoW+VZBbcM9+AS+4Js6Y0smStVM
	 gNAVeyEluEBECn3TFD15Sd022K3uom40OqbCovs391mmEYqiHjCjFC1gNwyQUIfzTA
	 uxTqpQ4J23hby4pNxCCADWM00F67rokEsbFYZ7h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 7.2 616/713] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Fri,  4 Sep 2026 06:59:44 +0200
Message-ID: <20260904045817.636281565@linuxfoundation.org>
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

commit 82e15be2d8b9efa6fb1750528d9b6f40e6a8eea7 upstream.

netif_rx() already accounts packets it drops in the core rx_dropped
counter. ntb_netdev counts them again as both errors and drops.

Leave netif_rx() drops to the core. Count the packet and bytes
unconditionally since it was received successfully by the driver.

Fixes: 548c237c0a99 ("net: Add support for NTB virtual ethernet device")
Cc: stable@vger.kernel.org
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Link: https://patch.msgid.link/20260819172539.1450821-2-den@valinux.co.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ntb_netdev.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -155,13 +155,9 @@ static void ntb_netdev_rx_handler(struct
 	skb->ip_summed = CHECKSUM_NONE;
 	skb_record_rx_queue(skb, q->qid);
 
-	if (netif_rx(skb) == NET_RX_DROP) {
-		ndev->stats.rx_errors++;
-		ndev->stats.rx_dropped++;
-	} else {
-		ndev->stats.rx_packets++;
-		ndev->stats.rx_bytes += len;
-	}
+	netif_rx(skb);
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


