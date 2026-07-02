Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6210315D33;
	Thu,  2 Jul 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010470; cv=none; b=m92Na6iZCIrexVTtUAi99DH478HrAjHWHuAmk5Ni1b53bogynHhVd7uVxNG2fXEuCs6Refm2C6fvpE9tiBqnKtuOlNJ+1B6q8NgrNbDE+kyqDftaGQBhwQ1Hj3tr6WCGEJK9y5geQItvBqDTNj5YHKXyPTVq34GjZMfjSo3xyL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010470; c=relaxed/simple;
	bh=lAHeCnbPch4JmCgg53IzBk6H1Xn4qbpwu+loCNrDGiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WM3azi46uGwMPUgRvUZ50GhMvTCZIeV1u2kgF6LVdJff2/EZbjn3fK9EGgWidoJ2axWd+7+CA4ihIJyeIRpdPcSAIFAclkVI+NNmGKGRXT6NhdVNl3IAjg8UnSFOTJFteWSvaH+S/DPxFVwyq7k6qQUOnyAIkZuQk1Yd5eGEJ9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIVMGgmR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIVMGgmR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D14C31F000E9;
	Thu,  2 Jul 2026 16:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010469;
	bh=HXJeOBd5gWk+bOS2mIRFCPEYh7xLBMZPw+hxhV97Q54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mIVMGgmRt2pH+Eey3l31kkfD8Ga2sr5566AtEWAt+8J9Ox0h/Z+28NYSMpaJYHGCj
	 JWp+QJc+jJx1Gc64ahgWjMkWjNtBOAHfIqk74kmKAnRIZzObG4apV2FZdl/p1yfJ4H
	 +qxT27gRZS7jL+FgH4ML6LkFgJ49DoYiOCkOCA8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/204] batman-adv: tvlv: enforce 2-byte alignment
Date: Thu,  2 Jul 2026 18:19:39 +0200
Message-ID: <20260702155121.215585795@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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
index b37c9fb178ae50..5dd3e1f281bab2 100644
--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -310,14 +310,23 @@ batadv_iv_ogm_aggr_packet(int buff_pos, int packet_len,
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
index 48a67705eba85c..c5c4d33cb19838 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -853,14 +853,23 @@ batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
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
index 6fd18b69e5f6be..f828d8143f7526 100644
--- a/net/batman-adv/routing.c
+++ b/net/batman-adv/routing.c
@@ -1373,6 +1373,12 @@ int batadv_recv_mcast_packet(struct sk_buff *skb,
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
index 8d6b017c433cc9..e1cd27b99bd119 100644
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



