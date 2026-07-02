Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CEF3290C9;
	Thu,  2 Jul 2026 16:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010964; cv=none; b=sGEzWScNa4824mQ5FGrPEtdEeIBxcTHb03caVEAkTuCD9TVdOpw640M0P940eAxmOA4id2KsJH3V0d/acRb7uTgq4FnvATffhQGOgapoMve6X3bfz5itvgXNSIeD2GP3qEAlEbWhl8GCyRzBnRCgDIVXDS5bdoy1jZzlyPx95XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010964; c=relaxed/simple;
	bh=ee5+5rymqqCRy6F1enZPoaLCcXWdq4eddfNSjBLzkIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXsD5o//hFJRnlu38jW7othB5rJxXp4ZI5sezM/IhfHpr/ePjQjmWcHD2iyLSWP/zMrGDZg07r6pR9ZQds7M72BDxVlX/EFMCGxQwolW/rqKymR8Y/deoqHyaONLrGViStzSH60N+WA8NKG7F/wuLeWaibygloiJh56uwIy6WIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+tuLqbA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+tuLqbA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3021F000E9;
	Thu,  2 Jul 2026 16:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010963;
	bh=Vc1LQrGJqWIv0P9sh264hbEpQKHto8bGDLAAYDirfNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+tuLqbAWbiqktWNC49eiUeU13+WztDwF2FQH+gAEwfVPlOvo6U5lS4ltAsm3jRAk
	 OitMBam6u3VVc08rS8elHeief6mcStW5SADv/xZ6WHQRRdb2Q7QP0DsNrZDzuIo/Pr
	 qSVOo1xhB29PoGg2HnucCe+sYt2zhObPOQCOyKVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/175] batman-adv: frag: avoid underflow of TTL
Date: Thu,  2 Jul 2026 18:20:06 +0200
Message-ID: <20260702155117.978885751@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 493d9d2528e1a09b090e4b37f0f553def7bd5ce9 upstream.

Packets with a TTL are using it to limit the amount of time this packet can
be forwarded. But for batadv_frag_packet, the TTL was always only reduced
but it was never evaluated. It could even underflow without any effect.

Check the TTL in batadv_frag_skb_fwd() before attempting to prepare it for
forwarding. This keeps it in sync with the not fragmented unicast packet.

Cc: stable@kernel.org
Fixes: 610bfc6bc99b ("batman-adv: Receive fragmented packets and merge")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/fragmentation.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/batman-adv/fragmentation.c b/net/batman-adv/fragmentation.c
index fbf030c57ac04d..0138b0953e10b5 100644
--- a/net/batman-adv/fragmentation.c
+++ b/net/batman-adv/fragmentation.c
@@ -420,6 +420,13 @@ bool batadv_frag_skb_fwd(struct sk_buff *skb,
 	 */
 	total_size = ntohs(packet->total_size);
 	if (total_size > neigh_node->if_incoming->net_dev->mtu) {
+		if (packet->ttl < 2) {
+			kfree_skb(skb);
+			*rx_result = NET_RX_DROP;
+			ret = true;
+			goto out;
+		}
+
 		if (skb_cow(skb, ETH_HLEN) < 0) {
 			kfree_skb(skb);
 			*rx_result = NET_RX_DROP;
-- 
2.53.0



