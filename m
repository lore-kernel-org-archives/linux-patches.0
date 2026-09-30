Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0A04F93A8;
	Wed, 30 Sep 2026 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786031; cv=none; b=qjHap3/k6ZM82J9uygZua6NZpzZc5cGU3AUioPTGPTT1EtEOYvcSuUGubBvFh8gKTgRjdAkwuxVb1EREF4SUV17AT6Kf45GJkfDCgFcBt/Aej0UIIuVV8wnSpXecJXdlmF4qeuiKdbr7x33Rzdb2vLPi9DzQcUJQNl+Nd0Kq2oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786031; c=relaxed/simple;
	bh=IYIWbQ24nCxRMcou4S91us+YUQxsOVS/O/e4B5Mzusk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHDFH6vViIFZF6CbBQnOOjMYkp5e03zFcfWhrN5NOvAvZWVtFbos6i84mA5bxM5/4eqtpeRuHceI94+o+ByCTRGrs9aA6Etmz574E97xCItbPbPSHZ+LmGn+vOAFcna3GFWC+zLjEyVUjIYyl+ZLhc96h/SiCpJWwxUfOgoloH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rk8uIbC7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rk8uIbC7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 209691F000FF;
	Wed, 30 Sep 2026 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786030;
	bh=YgF+oXja6cFLWhJfTAfXp5/HtSXViWxvO945ujqEusA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rk8uIbC7sXVSb1trNkKv6FOmi3s42wwcre5MHx14kCCUHVFR+PCPcGtHtX8Z8k1E6
	 PPHi4wP8mGSDZjUJTJAkVEr9dDCbJbcxnRlJDF53YdTd1aAftbYf4BDyCnjjSeZwUk
	 s/eDDA1RzVPRd/7tvvMvRGypMdBDF0TAE8n/g+1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 717/982] net: lan743x: fix RX checksum use-after-free
Date: Wed, 30 Sep 2026 17:24:13 +0200
Message-ID: <20260930152432.154491891@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: Mark Amirkan <markdamirkan@gmail.com>

commit a9ce4053dc945c5372dedba5017ee675b30dc0c5 upstream.

lan743x_rx_process_buffer() adds each non-first receive buffer to the
head skb's frag_list.  On the last descriptor, lan743x_rx_trim_skb()
linearizes the head and frees the fragment skb metadata.

The checksum-success path then writes ip_summed through the local skb
pointer, which still points to the final fragment.  This causes a
use-after-free write when a packet spans more than one receive buffer.

Set ip_summed on the surviving head skb instead.  Multi-buffer receive
can occur after a live MTU increase because existing ring entries keep
their old buffer size until they are replenished.

A KUnit test invoking lan743x_rx_process_buffer() with a two-buffer
packet produced a one-byte KASAN use-after-free write before this change.
The same test passed after the change.  The driver object also builds
with W=1.  This was not tested on physical LAN743x hardware.

Fixes: cd6910501cfd ("net: lan743x: Add support for Rx IP & TCP checksum offload")
Cc: stable@vger.kernel.org
Signed-off-by: Mark Amirkan <markdamirkan@gmail.com>
Reviewed-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Link: https://patch.msgid.link/20260913-b4-send-lan743x-uaf-v1-1-73d563d08ba9@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2720,7 +2720,7 @@ process_extension:
 							rx->adapter->netdev);
 		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
 			if (!is_ice && !is_tce && !is_icsm)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				rx->skb_head->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);


