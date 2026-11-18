Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046717;
	b=4Sk7XiUSBenah48hkALXZIrI3nj5x84HIm10SOSiw+cgI/9lNJdhUm8sJNHSf7kOM+3d
	 3T5aJ7ZUg6uggi8lchJtwDcbhhJpR7XuH92c7sJotjQSI3y5Khc2xpDXfSyPwYsXGsVQ7
	 PR6UL/LaRbqCGQ4cNxhpr3MMwSQciU4VZlop4iV5gbp1F7yeX7RkEmdR9YhRy3zLfkfnf
	 bJy/0qHEDq5fKCaZSpiMrW6JF25bgQLyNobEWIk8qQz3ttnv665T5ykiwrUd0bx1fcHwo
	 6k7XjC98tQqEMpOyg00lwv3BND5P+IngM3lISZjV+SsAxuZJ7mn6WFDYDdQlWvD3JBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J11wODjltwf226IhpPofrC0HViE+lWYiD+AX7Z+HPLQ=;
	b=m9cWNI/cOVWxMSoAhOSMZhMrPKm1iT+zyaysdGej9p843grLd1dyMgwbXJ5fuaKksQrb
	 ORzBC99jP+8+2WkaRXnEcY7qk3Oojalu5brrlUgcOhOMp59uIL67/fJCk+Cj3dhBzXJzc
	 zyfGD6uWDxZkvllSfhIYXCZ2kGRuEiGSUPO3RsbCoYDLg0V7S08yPrtEsG0lvtwIS2Vv3
	 YrZ3fsh8FkYQmJf3qYOTOor38buNCxFvEhQ5RzGkPymgi+5zPrqlGipikzuVAiqEpfyy3
	 kDQCBDLEiHw69HEEoadXWcBMEwPu8kCKT3MpX8lBHIjKkd8hLfIad8FuEEA4GzyvFgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBRnlaXb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F46606A320;
	Thu, 19 Nov 2026 00:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBRnlaXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 464E11F000C4;
	Thu, 19 Nov 2026 00:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046716;
	bh=J11wODjltwf226IhpPofrC0HViE+lWYiD+AX7Z+HPLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBRnlaXbNldIWQ305TJHyH6B6jhE/9E82GC+02xlspniHSV1uvSITW4pQ7Zm5OmNf
	 52jKNRThr/iHCPNJzTalL3laZH4iiw7RsfAinTiKxJ9LP51F1Ehz6GrQ+vn+E7O82k
	 UWI/15b6FXSb/vCawT98wnq40EeO/LIPwHJqFDgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1340/2857] batman-adv: Limit number of aggregated packets directly
Date: Wed, 18 Nov 2026 15:39:34 +0100
Message-ID: <20261118150249.675220437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7fd692b642e39..5f87db1ac9d9f 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -450,6 +450,7 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	struct batadv_ogm_packet *batadv_ogm_packet;
 	int aggregated_bytes = forw_packet->packet_len + packet_len;
 	struct batadv_hard_iface *primary_if = NULL;
+	u8 packet_num = forw_packet->num_packets + 1;
 	bool res = false;
 	unsigned long aggregation_end_time;
 
@@ -475,6 +476,9 @@ batadv_iv_ogm_can_aggregate(const struct batadv_ogm_packet *new_bat_ogm_packet,
 	if (aggregated_bytes > BATADV_MAX_AGGREGATION_BYTES)
 		return false;
 
+	if (packet_num >= BITS_PER_TYPE(forw_packet->direct_link_flags))
+		return false;
+
 	/* packet is not leaving on the same interface. */
 	if (forw_packet->if_outgoing != if_outgoing)
 		return false;
diff --git a/net/batman-adv/main.h b/net/batman-adv/main.h
index c48803b32bb01..e26bb8840f25b 100644
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



