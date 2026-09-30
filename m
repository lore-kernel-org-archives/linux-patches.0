Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329735221C6;
	Wed, 30 Sep 2026 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789566; cv=none; b=B8WCOiL5vyQRvZL3XV2zh96sjCct9u3fGEARcMHZlJnvw1xLfCeoeWsKKCBgIPVLnFrtZwjpelfTEVquQM9t22WaZg3y6r6xONEb32N31MU4zhjkhVEgHFdcOSdGKuhe6QLPpo2w4x4JC0+tumftrYYwgGJxrUwLy2gJkDukN+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789566; c=relaxed/simple;
	bh=bBE0MwxRo5etOJgTngj7vQX9AnPLpVL3WvbaKrBKP18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YmgiEub43RTNY/e1djzInGkf66n0g+ev7lLaBTHJbc1fTN021gtwQFOaT1rwxfSZ0iT1ZI/7I5PqOqgBjRgghDMbAMuwwowlVwcshwRUcSnSxvuuubYqKGj2JCN7J+VsNEIHXIU5PQU4AEoyWXhLvZvDbPb+z0uUfTou0WCZkfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tByyi/K7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tByyi/K7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAC21F008A5;
	Wed, 30 Sep 2026 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789564;
	bh=7u2t6Q06VePeB1bpTGhiFSSiCa8ISaYUIP3QuOGlbOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tByyi/K7OvBgJRqXM88Ba6ATxEooGAlb2W5/swQJQ7uuv/KY/24AgTJpi0/zc25Re
	 O40JIxbTSnb3gLnEcXrKOu1Vc9h/W+g63TLP8GpUbOOhjAjunVxxY2FKQ9zQbL3uJx
	 3jftrO0Rklj9WBb7E1yqjwWj7tK6Fy5tCAnJUxLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aamir Ahmed <elb12345@hotmail.co.uk>,
	Simon Horman <horms@kernel.org>,
	David Heidelberg <david@ixit.cz>
Subject: [PATCH 6.12 522/877] nfc: llcp: drop truncated I/RR/RNR PDUs in nfc_llcp_recv_hdlc()
Date: Wed, 30 Sep 2026 17:23:53 +0200
Message-ID: <20260930152425.917031872@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
@@ -1099,6 +1099,9 @@ static void nfc_llcp_recv_hdlc(struct nf
 	struct sock *sk;
 	u8 dsap, ssap, ptype, ns, nr;
 
+	if (!pskb_may_pull(skb, LLCP_HEADER_SIZE + LLCP_SEQUENCE_SIZE))
+		return;
+
 	ptype = nfc_llcp_ptype(skb);
 	dsap = nfc_llcp_dsap(skb);
 	ssap = nfc_llcp_ssap(skb);


