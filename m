Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D8030D401;
	Wed, 30 Sep 2026 19:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796415; cv=none; b=lsyYgUvaZ72teu+LWNFJYWZJFeitkmvICbuBJorj3vQ9k0Wifc2Ox3Rnx6MOjt+DKwBs/IG4fZ5jbrA9Jse3I/Z+m+E9RyTcd2JTXMmaR0Mmps2Vvjg4HixRusRztv3/rBG9Mkfe8rieiZgsmzaKYgdefZKuwMMh262hOErA4iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796415; c=relaxed/simple;
	bh=mJRp42XwmEEyZ523XfF6JnUHMuBfjsMFFrbNKLv2H+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jzVw2Y9P1Q/TD/KLOs0UuWT97XCFDFHPr7fw/UtaE61lup/GKtfQvFGZale9baz98qaL7jz13iEHSDFWfvwpwbN23qpSOi8rmJjdlEQ2B7YeSe68Za4V3kFk3F0BoQGPV90cSL1Vwc2BfRvDFUTk89HPe4RXYCOoSRAFWL4vqG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zE3+6dCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zE3+6dCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1DD1F000FF;
	Wed, 30 Sep 2026 19:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796414;
	bh=7PpqLlOAXCGCbjjsvU4xOjWllISBUdqqag/QP6+oXSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zE3+6dCqsyZpjA/THhRmH1xFTcgmEmQH4KAawZVoocOWGSvh93ezvnYlxRzbpZpF5
	 gBmNSInwphZq3iKNDqCVA9fOVA5je/j/IHZeoUGgDqBnzpYup7YtQ4WvSHlrcNPG4k
	 ZGFBh1v9Qi+lUoliMNS8Qn5AYhq8bpVg27RjJYt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Amirkan <markdamirkan@gmail.com>,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0860/1193] net: lan743x: fix RX checksum use-after-free
Date: Wed, 30 Sep 2026 17:25:44 +0200
Message-ID: <20260930152453.341121021@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -2726,7 +2726,7 @@ process_extension:
 							rx->adapter->netdev);
 		if (rx->adapter->netdev->features & NETIF_F_RXCSUM) {
 			if (!is_ice && !is_tce && !is_icsm)
-				skb->ip_summed = CHECKSUM_UNNECESSARY;
+				rx->skb_head->ip_summed = CHECKSUM_UNNECESSARY;
 		}
 		netdev_dbg(netdev, "sending %d byte frame to OS",
 			   rx->skb_head->len);


