Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9252D51D521;
	Wed, 30 Sep 2026 18:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792645; cv=none; b=O8FQ4ZVKxuU1v9JgXQjOVbmU+y4+jWmuW+qFUFl5+lerl6hCqB/YJe6bGICHY1jZF8nfMcVbSVavFYc5L9JiWFBZmQq+J8F4yarjCvZBBDgBMqkAVwaHv6zi0UIEDNhmS/jq2rOAXX63jZJ1Yi96sr118HSV3rNT67My3ZL1G0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792645; c=relaxed/simple;
	bh=6qiSUM+eDaPFkw5Mfp2wHMW8UzUsmP7CLRJ6fiPOrS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSNBqu7AoJ5SubnTDYTCzi9dwH3jiYV2ETBGZnYmYxlZDZpFTkmNXAbeYuFBpKdvH48AqIuO13+7JU4JIL+ZIZmoywRFBDDUrtn4Fx+d9sR5g4eHJMUDNv84wmfW70KP/lZQxncVajDPAG7cLK1plV9yfdCmtc8Svg1A1KBvFgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izVDltW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izVDltW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40B01F000FF;
	Wed, 30 Sep 2026 18:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792644;
	bh=Bs3+1nO93OgiwuGg/d5PVnZJNZca1KOFCYEeMqgGNpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=izVDltW0gMmdri2SF1FWj2Viqq+TFLMInYumQ/8xCr5FMqige8UM/h9DVdzeEzEo9
	 WQGI4d04dIyOJ/he/dd3UXqR40Y+vO3nHS7uk8eJUVRNDb/1psDnWrhIDxficBiPhK
	 c39pGqdYWe78cP8XQ3lYdomLEo88HpyY6KKD3evY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 5.15 728/752] nfc: llcp: drop truncated I/RR/RNR PDUs in nfc_llcp_recv_hdlc()
Date: Wed, 30 Sep 2026 17:29:58 +0200
Message-ID: <20260930152413.970382126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

From: Aamir Ahmed <elb12345@hotmail.co.uk>

commit 273f9d667cde649f8de9d72b1303cc2f4b658c50 upstream.

nfc_llcp_recv_hdlc() reads the sequence byte skb->data[2], via
nfc_llcp_ns()/nfc_llcp_nr(), before any length check. The receive path
only guarantees the two-byte LLCP header -- __nfc_llcp_recv() checks it
with pskb_may_pull() and nfc_llcp_recv_agf() admits two-byte inner PDUs
-- so a two-byte I, RR or RNR PDU reads one byte of uninitialised skb
tailroom. The byte becomes N(R)/N(S); a peer can already set those with
a well-formed PDU, so this is acting on uninitialised memory, not new
peer control.

Guard the read with pskb_may_pull(), as commit 95674f506c63 ("nfc: llcp:
reject PDUs shorter than the LLCP header") did for the two-byte header,
so the sequence byte is present and linear before it is read. RR and RNR
PDUs are LLCP_HEADER_SIZE + LLCP_SEQUENCE_SIZE bytes and an I PDU is
longer, so no valid frame is rejected; a truncated PDU is malformed, so
return without a DM reply.

Fixes: d646960f7986 ("NFC: Initial LLCP support")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Aamir Ahmed <elb12345@hotmail.co.uk>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/AS8P251MB0001789BBF04B72745C7D96BC8BA2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM
Signed-off-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/nfc/llcp_core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1108,6 +1108,9 @@ static void nfc_llcp_recv_hdlc(struct nf
 	struct sock *sk;
 	u8 dsap, ssap, ptype, ns, nr;
 
+	if (!pskb_may_pull(skb, LLCP_HEADER_SIZE + LLCP_SEQUENCE_SIZE))
+		return;
+
 	ptype = nfc_llcp_ptype(skb);
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);


