Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591291;
	b=McN6Wiwd2btgWLoP4pTyHVlj3hkSP9YtjruYpTc2VaDF0Mg11nOfszG0t5QLM5cwKhT8
	 0BV++mWpx/iY5agum8Ztxte3gBFBdOznREskhq7Khx9z53HPiOtzNfZ/J7UhOKb6p1EhK
	 Bq6/VXip7B7JQSAX54mwIndPri7mSuXM6fyfkasU7NY3F1iA+et9NFFDb4BWEIwMqjsHC
	 6o22FZzQSEZtwcPTUn30Vzz3ZWtWy/ZklKrsQLNyfYQGNPsxVfXM0urkDtjiVGR2HQgoK
	 VMVcIdDA1FobzsWL4vaTYscDh0Pdjiuh+jrazsjUx/LowY6UtdCpzppFiJdG6hDpCLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591291;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aQEtKDRRRxAz0w9G10RZ74MZX4rOHkuiMMPikDXtN8k=;
	b=XecLMEwjYi7RHdcuCSbiZcvQX0Fpzas87fGofbnDQnSaO5atZ00C8iMwvtSxPW92+Zzs
	 2dhEeyFxWVZvRjXh7393smtD/tT3bjN28hnxeHdQOszr7b32gqtlM+9QCY2PGZHYwd0ft
	 mZQqzVgnBUEcdJmFfzDnr90ggj2XyU8oM0MVEQeH997OX8PkTRIdGH9Rnp6AshBYzmv6E
	 YpMa1y/0YJPPNZSj2fJuk0AcU8bz+KMf8drR+QVzvGA5sydyh4YFTAo8laWlmH4fVY0Ng
	 bJb4kfhQMJxJomUZYvDpqtiozXoqPivVNiW7UjmBLYsaMKCJn7jtAvO+422ZjUYMWSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xm6NJbxn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A63560776C5;
	Fri, 13 Nov 2026 17:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xm6NJbxn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAAA91F000C4;
	Fri, 13 Nov 2026 17:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591291;
	bh=aQEtKDRRRxAz0w9G10RZ74MZX4rOHkuiMMPikDXtN8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm6NJbxnOl2bo5mx/KFOrCHObo9wjOFkBjhR6BlsPAtiiyflNl1X85dA7DlkafXf1
	 dwPibjrdJmDJ2ImWT9vxpeY/dCx1dahkGdf8Cwj2/QdcvFGUQoLCXKrULXHrx2+2Qz
	 igHLPXjtV9VbwEvR0oaVJCZB0Irlfjp0JP0axAJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 409/670] batman-adv: Limit number of aggregated packets directly
Date: Fri, 13 Nov 2026 10:49:33 -0500
Message-ID: <20261113153825.612225509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3d4c36ae2e1ad..9f3c1134e0069 100644
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



