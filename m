Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E73B3254B8;
	Sat, 12 Sep 2026 13:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220871; cv=none; b=cJoiJg7BqX4hf4aN3N/7szFRIn5/YccbqoR0r/MJui1gVdVDEyOU5VEb84P4yzNRGxQKZ6WV9bsR75guohCCKr+TSNqPqpdD6sOS+8iCnUiTwl2tYLICHcgAOA/Qk302aLVYtN3z5IV8sNcO3vx/7Pg5qqe/aGnd55UNAvb2tO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220871; c=relaxed/simple;
	bh=cxmL37GaBXrLAE7yVSocSASNj9YAIn3EcY5Yg2Mq83s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OElN9KgBBl2ZLqiqo1hgsA1go8Qlg0eQ7d23PeX9c0x9mTLpKV57oP+whrvmDqrb0/LDXWXT9uXk76TsS8vfflPdcWdLVaXzYAMc70a6ULdq5WoAtVIvfniZgAO1GmuG+lczs40w0Oe+ghI51o5xifp+SvsycSYaB4T8rZA6QeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uux+tZZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uux+tZZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF21F000FF;
	Sat, 12 Sep 2026 13:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220869;
	bh=UUlLVaviNeLP9uCvw+7zjX8HUGTEZrWhdXfVx4zm5lA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uux+tZZxjkB8IMT2aR0UfcwVTXhkuhKApuA9KLS+eRe2EEOJu9UdgWb5zBtRuB4b5
	 XZqDgMjaJbA6E6ounVinwXqQ2M+8e9mLNpk6kAO0TE0Xc9XB2pvvMXlg4bYiiuGX3+
	 eI9qVDfzlnXmj7iM4+7WsyUBueT1/4h8To9w/bxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0267/1424] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Sat, 12 Sep 2026 08:44:59 +0200
Message-ID: <20260912065613.254589345@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
 


