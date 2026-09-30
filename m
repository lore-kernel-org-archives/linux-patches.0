Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D863AEB2C;
	Wed, 30 Sep 2026 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788632; cv=none; b=nK53dEoxK/tcW0Aj4vhZG/ci994yZ6U5VrMTLzU/AvJ1fKW7skTqLrpBLQ53tCtzBLL80osl3Zrid/EXm7MlTJ5atfBrnoJlGuXLC1pRtueHXchWbP7ifauEkKpRxep1zShHTwMZlMoo1OwCC3a7WQ2MJEoJG9E62bll2U17qQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788632; c=relaxed/simple;
	bh=J20cJpon76rr/39U6p+5h6J4hQlufCnA6Dd0YraEmuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gNsjp71243X8Qmq3O7p6owY552apQMp13u8ffMmXs38xVM5uloqFVVg0LWFZBwMJDmoZnHufkdqW1FRU5oqXCDPrGis0TfIxPI3klDB3tR5mYXUzkMSErCq4TSeJuJZ0cqx5MxbfPPLbZsln8ZAerXMvuYduZ4B8MYbJea51h30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JkQE63vT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JkQE63vT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA8901F000FF;
	Wed, 30 Sep 2026 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788631;
	bh=TS1rsF8b1ChXVNbOYIsIbfBu9rS7tSTBjhAlroE+6+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JkQE63vTmbUxv45S03NAgKnYfy8ApA/JLticHIsog9mRK7Xi8KqKbG539AaVeBOaZ
	 y+ZdnV/7XQrgYRx3SW/2I+dYFD8qXvInc6D5JLhou9xffjp2KrFNMZkg90/mZ9rKFr
	 kIWhSTdA1mMac5LlRAs9Fc8U1o7EC0d9BVxMNUi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 192/877] net: lan743x: fix RX checksum use-after-free
Date: Wed, 30 Sep 2026 17:18:23 +0200
Message-ID: <20260930152418.870777420@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -2587,7 +2587,7 @@ process_extension:
 							rx->adapter->netdev);
 		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
 			if (!is_ice && !is_tce && !is_icsm)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				rx->skb_head->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);


