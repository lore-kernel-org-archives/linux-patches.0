Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E6E3A48E3;
	Thu,  2 Jul 2026 16:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009691; cv=none; b=Zf20OU6Tk7GCrKeesbwbMkBqYz9Sup406Gif/XPAWzOS7vTQdgUifmoS6JPmi+tqrLVtfrq0cFLy+fbbXBmQt5Lib1+vHao3OYZ4CV7+RnQ4DjRIAFyOrTxnIJNrjQJAAi6yn+UQJrIXqd9Ue/wTYaUAzpyQxfqqgUqq28acjbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009691; c=relaxed/simple;
	bh=QassIUHR7Iy4Zc6/6FbxWDE3rSqjnpt9lgX7Jd6Xxdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aC0GGudbraMedhLZAVe9u4R8O3mf4RXmGYshOBRA2QaoUh5ynU+JA6S3nU8n9wA75FVsNjaJDF7TZtLgQkC7xgdi74lz4xkxLiCN2YA9RahIx5z0BBRRzZJfPl3xFKntC42XYXGgcoVe46lRfTGbsP2SHcXcUFlVm1F8h7qEcaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7DtD07Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7DtD07Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A5A1F000E9;
	Thu,  2 Jul 2026 16:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009688;
	bh=kjRdR2wefWN2C9S6gQVOlyNbhXSdMqvZ6F6D3HiK3rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x7DtD07Z/4PaV0vrqhZqHtWSSbfrBiLgV0fuTM3uUkVnNQ6mnzJkcG40BW9ex58cO
	 UHnGFlXNfuQF2TtMbxxJjpShuANDXHTS/Dkbgifm5Eb59jlqSaAkrkDAnLMHyRapNy
	 w7j3Fnu5/wPfUwZ48clFC+bVBvBMssIXqTtqYLac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 51/95] batman-adv: tvlv: enforce 2-byte alignment
Date: Thu,  2 Jul 2026 18:19:54 +0200
Message-ID: <20260702155110.283092828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155109.196223802@linuxfoundation.org>
References: <20260702155109.196223802@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ Drop change for non-existing mcast handling ]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/bat_iv_ogm.c | 11 ++++++++++-
 net/batman-adv/bat_v_ogm.c  | 11 ++++++++++-
 net/batman-adv/tvlv.c       |  6 ++++++
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/net/batman-adv/bat_iv_ogm.c b/net/batman-adv/bat_iv_ogm.c
index 669f77eed073a0..a424c5b7a2462c 100644
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
index c7d15887c47c8e..641f3dbde1bde2 100644
--- a/net/batman-adv/bat_v_ogm.c
+++ b/net/batman-adv/bat_v_ogm.c
@@ -854,14 +854,23 @@ batadv_v_ogm_aggr_packet(int buff_pos, int packet_len,
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
diff --git a/net/batman-adv/tvlv.c b/net/batman-adv/tvlv.c
index de0c139426839c..66c2043dc1df91 100644
--- a/net/batman-adv/tvlv.c
+++ b/net/batman-adv/tvlv.c
@@ -448,6 +448,12 @@ int batadv_tvlv_containers_process(struct batadv_priv *bat_priv,
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



