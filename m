Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE2F24E4C3;
	Thu,  2 Jul 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011508; cv=none; b=phTbpCo0lBorAeUswPC5bUXHMMlisJMkasD20U5qHIGPb1mCpHPvGQpSlq8SX/HkirYfYoOdUZfQmaBqL0MZRmzUMAx4i47FQipmGWzwlf10Gv5W7ZiW1/tvc0Z0AYLiUQ2HGAZNxKPXd/8FfGDyHGdSEcGjnqLskUNQGWmw84g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011508; c=relaxed/simple;
	bh=ZRnU1Ggy/o6NA/yrCGyXQJbRskCMLxwuH5QgI7p/6Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoW9cn6HeFKfKrzl+l8OIa/fhkjaPL8Lj4bQWHCKS1l+uGxdk3/A0Kr34Z23HPCbfUpRZyK/jYqsZhraam3NSRXP15SlLZpSpX4OALuj7HsTkoeFanWgyG4WRpZ3yuCbD4+OmF1ukgJH+UlkgVPpX53uQxM/kMasy8P6Pt1to3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rSrEO4fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rSrEO4fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F37B1F00A3D;
	Thu,  2 Jul 2026 16:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011506;
	bh=obTC9mdEO/RRpNpNDb1WHV+Rv/Y+HHuMi4caper8Ueg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rSrEO4fnXwJLY0dp/SIiiAQSWlZj6bueO24Lf6PduCPreyVZcFEAtxoiFUeLyfSjd
	 FfTySDtA2vT4leWuakECV7fDpEura4y9EtIlsAORwvuKp5kZuU2h+OKaGMvlNGM3ox
	 J1L9auUCxk3yPNGsHl95xUFvcntHbBE7xNIAcvuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 026/120] batman-adv: tvlv: enforce 2-byte alignment
Date: Thu,  2 Jul 2026 18:20:22 +0200
Message-ID: <20260702155113.502525111@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 32a6799255525d6ea4da0f7e9e0e521ad9560a46 upstream.

The fields of an aggregated OGM(v2) are accessed assuming (at least) 2-byte
alignment, so a following OGM must start at an even offset. As the header
length is even, an odd tvlv_len would misalign it and trigger unaligned
accesses on strict-alignment architectures.

Such a misaligned TVLV/OGM/OGMv2 is not created by a normal participant in
the mesh. Therefore, reject such malformed packets.

Cc: stable@kernel.org
Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 11 ++++++++++-
 net/batman-adv/bat_v_ogm.c  | 11 ++++++++++-
 net/batman-adv/routing.c    |  6 ++++++
 net/batman-adv/tvlv.c       |  6 ++++++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index b8b1b997960a96..6e79f69c2fedec 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -311,14 +311,23 @@ batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
 			  const struct batadv_ogm_packet *ogm_packet)
 {
 	int next_buff_pos = 0;
+	u16 tvlv_len;
 
 	/* check if there is enough space for the header */
 	next_buff_pos += buff_pos + sizeof(*ogm_packet);
 	if (next_buff_pos > packet_len)
 		return false;
 
+	tvlv_len = ntohs(ogm_packet->tvlv_len);
+
+	/* the fields of an aggregated OGM are accessed assuming (at least)
+	 * 2-byte alignment, so a following OGM must start at an even offset.
+	 */
+	if (tvlv_len & 1)
+		return false;
+
 	/* check if there is enough space for the optional TVLV */
-	next_buff_pos += ntohs(ogm_packet->tvlv_len);
+	next_buff_pos += tvlv_len;
 
 	return next_buff_pos <= packet_len;
 }
diff --git a/net/batman-adv/bat_v_ogm.c b/net/batman-adv/bat_v_ogm.c
index 6852bf5da8c558..1f9b2d2b4831ce 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -849,14 +849,23 @@ batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
 			 const struct batadv_ogm2_packet *ogm2_packet)
 {
 	int next_buff_pos = 0;
+	u16 tvlv_len;
 
 	/* check if there is enough space for the header */
 	next_buff_pos += buff_pos + sizeof(*ogm2_packet);
 	if (next_buff_pos > packet_len)
 		return false;
 
+	tvlv_len = ntohs(ogm2_packet->tvlv_len);
+
+	/* the fields of an aggregated OGMv2 are accessed assuming (at least)
+	 * 2-byte alignment, so a following OGMv2 must start at an even offset.
+	 */
+	if (tvlv_len & 1)
+		return false;
+
 	/* check if there is enough space for the optional TVLV */
-	next_buff_pos += ntohs(ogm2_packet->tvlv_len);
+	next_buff_pos += tvlv_len;
 
 	return next_buff_pos <= packet_len;
 }
diff --git a/net/batman-adv/routing.c b/net/batman-adv/routing.c
index 4483f8d9c75831..41951c7a1c50b2 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1366,6 +1366,12 @@ int batadv_recv_mcast_packet(struct sk_buff *skb,
 	if (tvlv_buff_len > skb->len - hdr_size)
 		goto free_skb;
 
+	/* the fields of an multicast payload are accessed assuming (at least)
+	 * 2-byte alignment, so a following packet must start at an even offset.
+	 */
+	if (tvlv_buff_len & 1)
+		goto free_skb;
+
 	ret = batadv_tvlv_containers_process(bat_priv, BATADV_MCAST, NULL, skb,
 					     tvlv_buff, tvlv_buff_len);
 	if (ret >= 0) {
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index cc6ac580c62085..baadf97f98e5f0 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -464,6 +464,12 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
 		if (tvlv_value_cont_len > tvlv_value_len)
 			break;
 
+		/* the next tvlv header is accessed assuming (at least) 2-byte
+		 * alignment, so it must start at an even offset.
+		 */
+		if (tvlv_value_cont_len & 1)
+			break;
+
 		tvlv_handler = batadv_tvlv_handler_get(bat_priv,
 						       tvlv_hdr->type,
 						       tvlv_hdr->version);
-- 
2.53.0



