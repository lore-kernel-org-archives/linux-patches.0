Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9A1423A85;
	Tue, 25 Aug 2026 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665992; cv=none; b=YsMi2D/2oSwn8Y8YQZ4PQYr7T3fdyaEpSUaQ1qowVGMtWybeYuyn4A9LzhMQA7IrXzu6Co0fYwouNZq/h3NE2hvSkdUx/shWb9DwnhHLM3zPCpGrwOqRtXyZByr2E+biCVVP/0Pdc8v0cmTpEb1LeQCyRkieer4oeP3678kfpYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665992; c=relaxed/simple;
	bh=zlZvqgKRcMgd1+IP3xVIdZZbMx94hucwIvkAxMlKeNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IzwstY4qd9CpY3ElvIc0+bhewtAl3mPybbUx48VWbJrMDtJrUyi3KYFcVck915MTu4+sqIELh7LcfzH8F0JJ/eWIALERv0ymSpnVyS+co3Ue6oH10QiYiBd6eAz1fQGL+WiF7+oAHnDCbEtEss24X4ncM4p94QKkem6pA2wfDzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ITvg05Mw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ITvg05Mw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC421F000E9;
	Tue, 25 Aug 2026 13:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665991;
	bh=7bFfDDOesSyJJnaZ7+s4pSBHfYFPcW+dAnCIYUAQ4AU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITvg05MwTJWOoa0lfxQlVJIPZ7XWjdiVdZbirx9c749Ef+SjZ8K14FDrKX7oCCr0J
	 JQQH8iUUSixw7HgI5H758yyt40CkW3m/kUxpaFrt++IWEzfRdqO422i6aXEOQPc6rZ
	 vEkVOS6XkuASj7js6JA8Biy88JEGLjLFsaRmx6DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.1 45/79] nfc: llcp: bound the connect_sn TLV walk to the skb
Date: Tue, 25 Aug 2026 15:26:25 +0200
Message-ID: <20260825132543.470510417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doruk Tan Ozturk <doruk@0sec.ai>

commit 55c68ac93e7dacc0f5f608b9c39dd4ff48cf28e8 upstream.

Commit 27256cdb290e ("nfc: llcp: bound SNL TLV parsing to the skb and
add length checks") fixed the unbounded TLV walk in nfc_llcp_recv_snl(),
and commit d8bd2dedbde5 ("nfc: llcp: fix OOB read and u8 offset wrap in
TLV parsers") subsequently bounded nfc_llcp_parse_gb_tlv() and
nfc_llcp_parse_connection_tlv(). One sibling parser sharing the same
pattern remains unbounded: nfc_llcp_connect_sn().

nfc_llcp_connect_sn() walks a TLV list, reading a two-byte header
(type, length) followed by length bytes of value, without checking that
the two header bytes or the declared length stay within the buffer. It
returns a pointer to a service name of up to 255 bytes that may point
past the end of the skb; it is subsequently consumed by memcmp() in
nfc_llcp_sock_from_sn(). In addition tlv_array_len was computed as
"skb->len - LLCP_HEADER_SIZE" in size_t, so a CONNECT/CC frame shorter
than the LLCP header underflows to a huge length and the walk runs far
past the buffer.

nfc_llcp_connect_sn() is reachable from nfc_llcp_recv_connect() and
nfc_llcp_recv_cc(), i.e. from received CONNECT and CC PDUs. A nearby
NFC device can reach this without authentication; LLCP link activation
happens automatically after NFC-DEP, and the nfc_llcp_rx_skb()
dispatcher applies no minimum-length guard.

Walk the TLV list by pointer, bounded by skb_tail_pointer(skb), and
validate each declared length before use, matching the approach already
used for nfc_llcp_recv_snl(). Starting the walk at
&skb->data[LLCP_HEADER_SIZE] against the tail pointer also removes the
size_t underflow for short frames.

Found by 0sec automated security-research tooling (https://0sec.ai).

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: stable@vger.kernel.org
Assisted-by: 0sec:claude-opus-4-8
Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260709131229.44477-1-doruk@0sec.ai
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_core.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -847,13 +847,16 @@ static struct nfc_llcp_sock *nfc_llcp_so
 static const u8 *nfc_llcp_connect_sn(const struct sk_buff *skb, size_t *sn_len)
 {
 	u8 type, length;
-	const u8 *tlv = &skb->data[2];
-	size_t tlv_array_len = skb->len - LLCP_HEADER_SIZE, offset = 0;
+	const u8 *tlv = &skb->data[LLCP_HEADER_SIZE];
+	const u8 *tlv_end = skb_tail_pointer(skb);
 
-	while (offset < tlv_array_len) {
+	while (tlv + 2 < tlv_end) {
 		type = tlv[0];
 		length = tlv[1];
 
+		if (tlv + 2 + length > tlv_end)
+			break;
+
 		pr_debug("type 0x%x length %d\n", type, length);
 
 		if (type == LLCP_TLV_SN) {
@@ -861,7 +864,6 @@ static const u8 *nfc_llcp_connect_sn(con
 			return &tlv[2];
 		}
 
-		offset += length + 2;
 		tlv += length + 2;
 	}
 


