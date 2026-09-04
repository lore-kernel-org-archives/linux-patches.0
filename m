Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A001F418A34;
	Fri,  4 Sep 2026 06:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502851; cv=none; b=uosMGbwYX8smanmmLr2uN/5whqDzvRRLEvYqKIrBAebHZLvZDpb54Y/SJYhbl9fzur09c/g2GcNf1q720KDa9VUjujJSSHogiMbFR2MVN+aDhSjSS3W5JMi7lDu7NhrjbZaXFf/QKcrv+QR44kgnr24T2d5cM5yIemENBIwfZks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502851; c=relaxed/simple;
	bh=o5N2Y7CohIK52SDo7dTYxqZnwl+iDeOHGrbwsYHToKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2KZNMq/ojyPQGCK27gEWyTNe7OPGuENgrWOzP7Z16hsMnXYSPDQAj+SMT+8hOiv8urcbNdmHteGlvLzyXv7gBrTUman704mHti6j2TqlRmRqyf9xWKkjK9bRjfFgutUsVzH9R65cg+Ihoc3vD+zvVAkdSRO1YHeLs77FiHceQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GxXSbcHr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GxXSbcHr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA9E1F00A3D;
	Fri,  4 Sep 2026 06:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502850;
	bh=b5rkFrSUh5eTr0KvvCdXIpUzW+aDhOMniV0FZ+jAbIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GxXSbcHrPOYmvjqHi/qqdD6GcWO8YUdn/iKg9/Zw+ndowvZoJcUnYxtwoBTej5Cyi
	 t6c1lkJIQ3j7MRNCg0FBDfKxLGVVwLP9MBEZqGbx1TC4IUw/P98CDhYQwIn8MHMC79
	 BJbE1NHTju/dcx0Sg4B1PDCgprVsjPmuUIZwGxLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 351/403] net: ntb_netdev: Count packets dropped on RX refill failure
Date: Fri,  4 Sep 2026 07:02:34 +0200
Message-ID: <20260904045742.795047206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
 


