Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E680723909F;
	Sat, 12 Sep 2026 11:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210938; cv=none; b=BgziPDU4ieEhZ0fW2Tc+4FIWbmFekdmNHfY4eyvT7V2uBbTC5g2v21TcGQp3Fk9XG8qbt5OJpn8q7Hpx5jLgOzYt7WqQ/edPgLx/EEM7MUuptN89FxsTBgM3LF1iJkcUFI1HanfLoUmwETEgmoNxzkK4StcytpOeSSPIKCiC4Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210938; c=relaxed/simple;
	bh=Pgy89FeP6cU9Lh2IdaawWR+yvGWFXD2gMPvFCkyuVss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+fqYQAD+4Y5rMVjwBQm9/0pFvU3eknyQeklxrTWitpD0Z4FKvic1KuiZ5m1WRK8Ug7t3wSUaPO/PxyiW+Qk2E3cJwU5M/iuxcLRhE9cXGb5N3mUJ8z2eWRUy/ACPhb0qo3k1vWQkRDKB5V1CHaKiBvj1wOnliyiJ8fuSfe2Hr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2+Ei62M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2+Ei62M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E979E1F000FF;
	Sat, 12 Sep 2026 11:02:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210936;
	bh=NKIpphpFP4+MU8J6U6jCpAPTdYu4vpSaaNUVKQsXlkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K2+Ei62Mp4OgNSecPJjAp47xm+TkNFxm0ieHR/Qgmp8+ZwW/avBIbIkAw+Wau+itR
	 LbVticRWfmvopgBPjBO7juj2sSfsjU2ZJol/dSnkL1NvUOt2GZy9NVD4su8EaDxpvT
	 j7x/2L0FsmkhTn/uZIp7+OP6kEYJ5I7tRvaOCiE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1128/1518] nfc: llcp: bound SNL TLV parsing to the skb and add length checks
Date: Sat, 12 Sep 2026 08:54:57 +0200
Message-ID: <20260912065648.971265664@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Doruk Tan Ozturk <doruk@0sec.ai>

[ Upstream commit f4c7f37f0ab990952539dc68d931d65c3657600a ]

nfc_llcp_recv_snl() walked the SNL TLV list using a u16 offset/length
pair derived from skb->len, without bounding reads to the actual skb
data. Three problems followed:

  - For a short frame (skb->len < LLCP_HEADER_SIZE), tlv_len underflowed.
  - The per-TLV header (type, length) was read without checking that two
    bytes remained.
  - A declared TLV length could run past the end of the buffer, and an
    SDREQ with length == 0 made "service_name_len = length - 1" underflow
    (size_t), driving an out-of-bounds read in the following strncmp() /
    nfc_llcp_sock_from_sn(). The SDRES case likewise read tlv[2]/tlv[3]
    without a length check.

A nearby NFC device can reach this without authentication; LLCP link
activation happens automatically after NFC-DEP.

Walk the TLV list by pointer, bounded by skb_tail_pointer() over the
linear skb data, and validate each TLV declared length before use. Add
explicit length checks for SDREQ (>= 1) and SDRES (exactly 2).

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: 19cfe5843e86 ("NFC: Initial SNL support")
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260609202543.42282-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_core.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index e671483d28ef5..41f8e2f7875a0 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1288,10 +1288,9 @@ static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
 {
 	struct nfc_llcp_sock *llcp_sock;
 	u8 dsap, ssap, type, length, tid, sap;
-	const u8 *tlv;
-	u16 tlv_len, offset;
+	const u8 *tlv, *tlv_end;
 	const char *service_name;
-	size_t service_name_len;
+	int service_name_len;
 	struct nfc_llcp_sdp_tlv *sdp;
 	HLIST_HEAD(llc_sdres_list);
 	size_t sdres_tlvs_len;
@@ -1307,22 +1306,34 @@ static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
 		return;
 	}
 
+	/*
+	 * Walk the SNL TLV list in the linear part of the skb only,
+	 * bounded by skb_tail_pointer(). Each TLV needs a two-byte
+	 * header (type, length) and its declared length must fit before
+	 * the end; this also keeps the walk safe for very short frames.
+	 */
 	tlv = &skb->data[LLCP_HEADER_SIZE];
-	tlv_len = skb->len - LLCP_HEADER_SIZE;
-	offset = 0;
+	tlv_end = skb_tail_pointer(skb);
 	sdres_tlvs_len = 0;
 
-	while (offset < tlv_len) {
+	while (tlv + 2 < tlv_end) {
 		type = tlv[0];
 		length = tlv[1];
 
+		if (tlv + 2 + length > tlv_end)
+			break;
+
 		switch (type) {
 		case LLCP_TLV_SDREQ:
+			if (length < 1)
+				break;
+
 			tid = tlv[2];
 			service_name = (char *) &tlv[3];
 			service_name_len = length - 1;
 
-			pr_debug("Looking for %.16s\n", service_name);
+			pr_debug("Looking for %.*s\n", service_name_len,
+				 service_name);
 
 			if (service_name_len == strlen("urn:nfc:sn:sdp") &&
 			    !strncmp(service_name, "urn:nfc:sn:sdp",
@@ -1382,6 +1393,9 @@ static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
 			break;
 
 		case LLCP_TLV_SDRES:
+			if (length != 2)
+				break;
+
 			mutex_lock(&local->sdreq_lock);
 
 			pr_debug("LLCP_TLV_SDRES: searching tid %d\n", tlv[2]);
@@ -1410,7 +1424,6 @@ static void nfc_llcp_recv_snl(struct nfc_llcp_local *local,
 			break;
 		}
 
-		offset += length + 2;
 		tlv += length + 2;
 	}
 
-- 
2.53.0



