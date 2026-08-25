Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965B0471431;
	Tue, 25 Aug 2026 13:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664896; cv=none; b=d6Zn8TBCY3/h7TQ1PkHZzRCB9j5AdBqF8OksQtnu7Y0BQxlL30mvVdpufWYMJt1exQo+UJkRWiKOazXRxKL3rY/3bFH8FX+YZt7loG248Xm8traLhdXOU+sddnakx9bHT/Joac/sx7l7Rmhe7JRUlFcEgQSNZUthlBT3eKPNw+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664896; c=relaxed/simple;
	bh=9CqTKpmiYsBL57H6wyrhuN4+scI3enVpdkYFPN9RKZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaNW0Lk/SEKsqf2Ku22ybAq6+c8STCWT53Qf3QT5QrT+XlCerysSjZGcAM4T4iAPkSAMVU0H03b7MQeK84Zdpv4K0H5Lrq/CnQpg4cAJ/AjYDBnFxHWgs4yQ40IwJrmSI6HO0G4vbAQ5TpN1HaIg4qf3XUGRwBW5bR5Rx+Ozulg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tqtdBOUp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tqtdBOUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4C41F000E9;
	Tue, 25 Aug 2026 13:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664895;
	bh=7dPi1ya4XR3g75qfa2h0O7dOsJVUXNCu71FeaAcg94I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqtdBOUp0YklI9C9YPrO9NeTSvPdI18om9vPRxuN1JsoSs2bIA+fThXfLvfardlg3
	 7SXHCM+dbkZ0FVfwfzE/Ob54HpkP2Jijgvwed6tKxSilNZyBpg+5QNeQMrtAr2POIt
	 UepHaKf8d0MBIIOW97pX+tWZk4wpcDG4RK6i6Eis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doruk Tan Ozturk <doruk@0sec.ai>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 7.1 040/101] nfc: llcp: bound the connect_sn TLV walk to the skb
Date: Tue, 25 Aug 2026 15:25:18 +0200
Message-ID: <20260825132543.581091248@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
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
@@ -849,13 +849,16 @@ static struct nfc_llcp_sock *nfc_llcp_so
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
@@ -863,7 +866,6 @@ static const u8 *nfc_llcp_connect_sn(con
 			return &tlv[2];
 		}
 
-		offset += length + 2;
 		tlv += length + 2;
 	}
 


