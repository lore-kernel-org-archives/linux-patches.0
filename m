Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB83946EC8A;
	Tue, 21 Jul 2026 18:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658679; cv=none; b=KOUwbKZcE3GWqs1wWb2GyxMKXs3E6FphBwpT7ljo/miuS/L8l0YvDxi9/in9WWPLK9o7IeF82SnHG3frTT4um5DQoXJ7ax7O/6ZKQ08gx/Q+zUqV3T2ne3hucjiOUXy2mo/qfzOLHwdPiExrXuh/Wnz0xByep6TwzpLlnIMB3xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658679; c=relaxed/simple;
	bh=tpaI6sQAQ7eG0YiuvUsTbVFuH/I6nXiZLMbhHhLOBGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VdQcm0+H/8QCHTYIBksWB9gGQX9Mc4GelfbuehB/y6CYQ0na4BeMQOX/hLnnu9gRwcCCs/07qw9ORI+aHbz3aqUYmxE9ghoJXE6nCiGQ6Gm/gpIalKelTElAXXK1siIH/IcuA2w3Lb6Bew81akRTlCuEZBhZpyWgUY7e0HDuGEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyTuRv2g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyTuRv2g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C8311F000E9;
	Tue, 21 Jul 2026 18:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658678;
	bh=GRypxvOx+vpVIt1xZCVuEpcn4I7V/QwOL/mQWnhEa3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyTuRv2gH8mrzFLwRylXpA0gHLA9wMqNknAtHpDJyME6+B7MC9bPDmUDrRGs26Rr1
	 LCSDMCQTLlsvx5xYJeCZpP3ogkayw5lSHzGYByIEQOJcar4rKAuOfC3P1hsZ6i8b7j
	 u8sNbAwY8HWaqlxO7n74Be/V4jLeSdBDprLs5Swg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 1207/1611] batman-adv: mcast: avoid OOB read of num_dests header
Date: Tue, 21 Jul 2026 17:22:03 +0200
Message-ID: <20260721152542.583539142@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 38eaed28e250895d56f4b7989bd65479a511c5c3 upstream.

Before the access to struct batadv_tvlv_mcast_tracker's num_dests, it is
attempted to check whether enough space is actually in the network header.
But instead of using offsetofend() to check for the whole size (2) which
must be accessible, offsetof() of is called. The latter is always returning
0. The comparison with the network header length will always return that
enough data is available - even when only 1 or 0 bytes are accessible.

Instead of using offsetofend(), use the more common check for the whole
header.

Cc: stable@vger.kernel.org
Fixes: 07afe1ba288c ("batman-adv: mcast: implement multicast packet reception and forwarding")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/multicast_forw.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/net/batman-adv/multicast_forw.c
+++ b/net/batman-adv/multicast_forw.c
@@ -927,11 +927,11 @@ static int batadv_mcast_forw_packet(stru
 {
 	struct batadv_tvlv_mcast_tracker *mcast_tracker;
 	struct batadv_neigh_node *neigh_node;
-	unsigned long offset, num_dests_off;
 	struct sk_buff *nexthop_skb;
 	unsigned char *skb_net_hdr;
 	bool local_recv = false;
 	unsigned int tvlv_len;
+	unsigned long offset;
 	bool xmitted = false;
 	u8 *dest, *next_dest;
 	u16 num_dests;
@@ -940,9 +940,8 @@ static int batadv_mcast_forw_packet(stru
 	/* (at least) TVLV part needs to be linearized */
 	SKB_LINEAR_ASSERT(skb);
 
-	/* check if num_dests is within skb length */
-	num_dests_off = offsetof(struct batadv_tvlv_mcast_tracker, num_dests);
-	if (num_dests_off > skb_network_header_len(skb))
+	/* check if batadv_tvlv_mcast_tracker header is within skb length */
+	if (sizeof(*mcast_tracker) > skb_network_header_len(skb))
 		return -EINVAL;
 
 	skb_net_hdr = skb_network_header(skb);


