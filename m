Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037992;
	b=CijW2+QFLJgqy7isx3z9+DQg0dy+E8HD3USnOTqM6RInMAng4Gc36ZlEt1A2UDQ52jR6
	 tV3CSKJ9yliQKkD2qDw6e/BxJZsMGdZKPGdJmImhrXfxYcRWuf+wITrU8A3o1VniYBOw/
	 HQ9FlyyVRobgzD/XttkzNlAxho4RdaWzarjjNaU7j5LxZANf1BDraSsfEtMlMVGCHF/mi
	 Vp3eBpvqBK95yXueQ98s25PIe1AeCCgfS+QKSmBk0GA/BBUFT5IFX4Xjy05IIBjRlEqeE
	 40wwKw3QKNAfVUigJb/HsNHupGGgNbx6eTVsYzOBs9BzIddjyPL39HANWGv9/w8d55A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KEzhtKORgEiRcOYS9A+4xbz0/Bk4OioySgRTzwCWSfI=;
	b=qY/KgW0zYzBLtstShDOmZPfrQxMpqoIYzfR4v3i52ibRTdiPecWp9HNxbC7Ma4gWTw+M
	 /NG8bbYebioRsNkHKGh64WtdcQiRlXZ1KAhxNbLZk6z0pPOfwLwHfdBbHVegFwN0rfh9L
	 KoaZ7ozxGHqpVph+tUTN6NX/uP1FhbiLOrnviVPZhXJUKor2+0rxwUQH2XIJCdtTI4+u0
	 TPkrxHNNAkw7d20eZGssrVb8lmmJ1kzVNjth4O29vQNz1ExWnCRAMPvL0KI498FSZ5jCN
	 3AlktG8TaEiWODPQ2goBWFM/QUvzb0ZYRavwhn6/xEtOho6j8fw/Kt1Aj7zL1VENWaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOXw14hl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BFD3606A32C;
	Wed, 18 Nov 2026 21:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hOXw14hl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F341F000C5;
	Wed, 18 Nov 2026 21:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037992;
	bh=KEzhtKORgEiRcOYS9A+4xbz0/Bk4OioySgRTzwCWSfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hOXw14hlKYkyigWhjZ6WwLG8IM4xNXYWBGL9kbfKu2sTUOKSB0Ow3uxHhxdLpUxQj
	 sA38eOsQMe3vzNdix8bwB8D9PXRIK2d9L+2rhYyaacA1tNWLYdasrHlCqffvX4onrh
	 iNO4xujwZyIwFJn04yztaNozopt70jsiKAAnj3qM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1588/3318] batman-adv: Limit number of aggregated packets directly
Date: Wed, 18 Nov 2026 15:36:50 +0100
Message-ID: <20261118150408.774410305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit 434becf57bdc89f939db635ed3337b9d1da5967e upstream.

The currently selected size in BATADV_MAX_AGGREGATION_BYTES (512) is chosen
such that the number of possible aggregated packets is lower than 32. This
number must be limited so that the type of
batadv_forw_packet->direct_link_flags has enough bits to represent each
packet (with the size of at least 24 bytes).

This requirement is better implemented in code instead of having it inside
a comment.

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 4 ++++
 net/batman-adv/main.h       | 3 ---
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 5dd3e1f281bab..c8cf259f081af 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -449,6 +449,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	int aggregated_bytes = forw_packet->packet_len + packet_len;
 	struct batadv_hard_iface *primary_if = NULL;
+	u8 packet_num = forw_packet->num_packets + 1;
 	bool res = false;
 	unsigned long aggregation_end_time;
 
@@ -474,6 +475,9 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	if (aggregated_bytes > BATADV_MAX_AGGREGATION_BYTES)
 		return false;
 
+	if (packet_num >= BITS_PER_TYPE(forw_packet->direct_link_flags))
+		return false;
+
 	/* packet is not leaving on the same interface. */
 	if (forw_packet->if_outgoing != if_outgoing)
 		return false;
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index 10007c5894a14..784739a7b308d 100644
--- a/net/batman-adv/main.h
+++ b/net/batman-adv/main.h
@@ -102,9 +102,6 @@
  */
 #define BATADV_TQ_SIMILARITY_THRESHOLD 50
 
-/* should not be bigger than 512 bytes or change the size of
- * forw_packet->direct_link_flags
- */
 #define BATADV_MAX_AGGREGATION_BYTES 512
 #define BATADV_MAX_AGGREGATION_MS 100
 
-- 
2.53.0



