Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A71242910;
	Fri,  4 Sep 2026 06:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501614; cv=none; b=pQy+0WlxbXz3on4ShPAZtPgeA2GW3otqRLhRrM5QRL6auTQhw9Q4CcsGJXqICu6FbuyHvd2aCvI5PfpE6R505bCM5EU4Pyi4cqy6IptwedwH9DgqkVOPsh9Xu10qzNJPJLgLajcd5yL8ZRQvtVD8Rr798ra0HOcwbUobKdzqIDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501614; c=relaxed/simple;
	bh=Jb3vlzQyMNx/gptzhqieouVrZDCeKiIV/Fk6KbzJImM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktABWbtkdi0J0Zh2NDMaH7IKyuFxHnc3RQThlHVkVR9lpTZOesDPB7Ha91SEdAVsOLS8Bfe27sHMhav8hWxH8+YhmQ1B9z5Aej5r0mVBOBqd42/M/xOW4Ev2blkBXgwv23ha6p+xQ+R9qJ4EHbPYaslFer8jIDBe4GfJjUAT4ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cB1aFXPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cB1aFXPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81B681F00A3D;
	Fri,  4 Sep 2026 06:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501613;
	bh=B5c8D5yuDuKlB91u70Rk5T7H6NoQczt3VBqHjNYsXSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cB1aFXPHh9Tb/etRf4ZXOmV2796xnaEgKe+onH+wKbuRLYsmcm72U0ZH5v9cnhDZH
	 9v5Ze50zFO/1HKGKlN805tn75LUKn6uoiAddw2NzBzp2VXo6OK7Bmyo5jhdaUV7Ol7
	 4UbpegKZcsGnVEiK22gP8eE1ny0ZPmt0K9GR5b9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Koichiro Den <den@valinux.co.jp>
Subject: [PATCH 6.18 470/552] net: ntb_netdev: Avoid double-accounting netif_rx() drops
Date: Fri,  4 Sep 2026 07:00:27 +0200
Message-ID: <20260904045801.347938574@linuxfoundation.org>
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
@@ -146,13 +146,9 @@ static void ntb_netdev_rx_handler(struct
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
 


