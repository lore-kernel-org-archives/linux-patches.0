Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 376A947127A;
	Tue, 21 Jul 2026 18:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659965; cv=none; b=DJFh4hXJjfg9LPka+RzNqFZNOevtsRivyTzi2/shN/1LyDXZI3U8gcNPGR5Ih+lkdY1siqkanrIRjD32SI2nI+dCzV6lV53pNGxSOKzi7JWBUaN1bJCC9t1tjh2fg2d80vapV+iQoZkpYy7VlclzgCoZHedlGtR0hyuUV1XHnnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659965; c=relaxed/simple;
	bh=8N/j75aoVK3sFaiCV2cZyLmpUa9PfmvS9ss4ZJ5fJjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRB7GjTcdfapElJsnI5LtLmNk5wW0oB/cFQzhKJHT5p2jI3UueDEfSbxxVYvpuivLhEs1gFeV6ypB/Y0V2LFgTMMWVSGZTdkooCeD3OJiCgiOp1KlTpbqsSGIGbq35DYqiGTVfXeQrlhUPsLbvCvH2GYevaNa6gtjeZt95mmaXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OVYQEKA7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OVYQEKA7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4971F00A3D;
	Tue, 21 Jul 2026 18:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659964;
	bh=WK34dgzD54cQq5QMZIZG6o5MFkLO3f6I4DvpIeXRYVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OVYQEKA70U8b+X5P1AQtzwWAv/AsJvKCClMMYuhro5eS1noJFa4p+hK4HZgj8IKwp
	 PLDpvitKNWtYkJP6wjpF8bt9NH/8+cAlidzxG0ARmerLe4XPyFoLQZ620j3mhAnBc+
	 o/MclFKLd4Ffo5oF+Ud8xqxh4ni2zUR85n+3/uxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0800/2077] net: ethernet: oa_tc6: Remove FCS size in RX frame
Date: Tue, 21 Jul 2026 17:07:53 +0200
Message-ID: <20260721152611.662080612@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>

[ Upstream commit a5a1d11dd3729146abe7420b874bab15870a42b4 ]

OA TC6 MAC-PHY appends FCS to the incoming frame. It must be
removed from the frame before being passed to the stack.

With FCS in the frame, many applications, like ping or any
application that uses IP layer may work as they may
carry the packet size information in the protocol.

Application like ptp4l, particularly if it uses layer 2
for its communication, it will fail with "bad message" due to
the extra 4 bytes added by the presence of FCS.

Fixes: d70a0d8f2f2d ("net: ethernet: oa_tc6: implement receive path to receive rx ethernet frames")
Signed-off-by: Selvamani Rajagopal <Selvamani.Rajagopal@onsemi.com>
Link: https://patch.msgid.link/20260611-level-trigger-v5-3-4533a9e85ce2@onsemi.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/oa_tc6.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/net/ethernet/oa_tc6.c
+++ b/drivers/net/ethernet/oa_tc6.c
@@ -751,6 +751,17 @@ static int oa_tc6_process_rx_chunk_foote
 
 static void oa_tc6_submit_rx_skb(struct oa_tc6 *tc6)
 {
+	/* MAC-PHY delivers each frame with its Ethernet FCS attached.
+	 * Strip it before handing over to the stack, unless the user
+	 * has asked to keep it via NETIF_F_RXFCS. Keeping the FCS
+	 * in the frame is harmless for IP traffic, but is parsed as
+	 * a (malformed) suffix TLV by PTP, which makes ptp4l reject
+	 * every message with "bad message" error.
+	 */
+	if (!(tc6->netdev->features & NETIF_F_RXFCS) &&
+	    tc6->rx_skb->len > ETH_FCS_LEN)
+		skb_trim(tc6->rx_skb, tc6->rx_skb->len - ETH_FCS_LEN);
+
 	tc6->rx_skb->protocol = eth_type_trans(tc6->rx_skb, tc6->netdev);
 	tc6->netdev->stats.rx_packets++;
 	tc6->netdev->stats.rx_bytes += tc6->rx_skb->len;


