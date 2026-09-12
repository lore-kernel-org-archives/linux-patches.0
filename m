Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F36E38757A;
	Sat, 12 Sep 2026 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227595; cv=none; b=tXee+SpBaHWEzdqGzWpNf5HshbkF57A/8qpYwnMaxB/gCRlmQRWdeap/quApiCIa9OxdpuObNsY3JIWL5OBkHnfrdT1oBhWlAHgGh+sKaCTbbTUUJZavB9enc7TN5ZkS2QIduqJqmHR5GVkeTwHEFiBV2q34aFQY7CTcfR5w4tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227595; c=relaxed/simple;
	bh=6+SCr9QmB7X2KRX3ZwhU5QB8nzThdv04nJati22mdS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZXtDvR2uetQwGj06dzs/5O45VNhce2u7zqY8Kg3l8mv2PLJpPwr/1E/bC9UYyBuO4ut/osQlUEJx0HVzHpBCe3pmhSOPQepTqVdotQCh4nRgcnJGF4rEy4jWyiQvMCjWU1vJi76mDeSAt3UGv3s2zJxuJ9QUatvSREWu9wxhz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxKyGAYn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxKyGAYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE441F00893;
	Sat, 12 Sep 2026 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227594;
	bh=4ndfcMgFMa1FygtmCj40OSVhLdOaU+OP7DrVzc7lh2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxKyGAYn16JyaP47Ef14O2evXv5/c+BivAlOuUho0aCf8qBypxm1OqmyGdKHauRiX
	 6COvE9rqMgdJ+FQ2fDXnv/x/txmKBo9UTPFZxILk+08B7VNc0tsPx7fM/hnEo0AGTh
	 3f/NSffz3m7NE13tXNuaFlHw73EbMQw21RPLI/gM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0213/1191] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Sat, 12 Sep 2026 08:49:01 +0200
Message-ID: <20260912065552.995943796@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -115,6 +115,9 @@ static void ntb_netdev_rx_handler(struct
 		goto enqueue_again;
 	}
 
+	ndev->stats.rx_packets++;
+	ndev->stats.rx_bytes += len;
+
 	new_skb = netdev_alloc_skb(ndev, ndev->mtu + ETH_HLEN);
 	if (!new_skb) {
 		ndev->stats.rx_dropped++;
@@ -126,8 +129,6 @@ static void ntb_netdev_rx_handler(struct
 	skb->ip_summed = CHECKSUM_NONE;
 
 	netif_rx(skb);
-	ndev->stats.rx_packets++;
-	ndev->stats.rx_bytes += len;
 
 	skb = new_skb;
 


