Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E4037B02A;
	Mon, 23 Mar 2026 16:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283136; cv=none; b=JzkTUtLbuFlfDPFAb5WBwtgovVQODjvivWACL7L4mXLvP/EUY9diw9TXpd8ZroOx3CBzkInjS7g2WZDDa4a7pJrGyGf6n36sDNkQWra7aFphY8y1h3IztevtmUA7I467UU6/EnebS43cUpa7o2S8K5X9kPAbCrDFhc/BepZKaVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283136; c=relaxed/simple;
	bh=I86M6LaDHe8nPInOsY7nL7cZU9EVBBDTZw4opVg5m6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FsMH9mPK3n7lYYVK1sbvZMUrOygMsAuro8Pr4S5ea4U8n1kBynsp19kBi8KE8LzimuTYPvT6jWUBwA9Ev7jbU2Q/KPR7nG9UB21TW5jjyBmjE1Eii+MndQIbL893+udGTzo2cehaoEDV+Tl8AqG71cWWK2OmMcBf47gK93HnbL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fE6b9OSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fE6b9OSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27347C4CEF7;
	Mon, 23 Mar 2026 16:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283136;
	bh=I86M6LaDHe8nPInOsY7nL7cZU9EVBBDTZw4opVg5m6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fE6b9OSEdj0dub3PSKoCfcZULXwDoPpUr/RN0Q4MiW1o4dlyD1kU0NVnjPtv1T3DX
	 kIWfF4cWG1HksPeVhHIs1BlJu8Z5MMXEkzYQe0CepEsdcO/cMU9zVCMbXM8s70untk
	 4rMeDnHh7ag27ykdGAgyY0yPtxbbvluIKuUjuE1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 413/481] netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()
Date: Mon, 23 Mar 2026 14:46:35 +0100
Message-ID: <20260323134535.248270644@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lukas Johannes Möller <research@johannes-moeller.dev>

[ Upstream commit fbce58e719a17aa215c724473fd5baaa4a8dc57c ]

sip_help_tcp() parses the SIP Content-Length header with
simple_strtoul(), which returns unsigned long, but stores the result in
unsigned int clen.  On 64-bit systems, values exceeding UINT_MAX are
silently truncated before computing the SIP message boundary.

For example, Content-Length 4294967328 (2^32 + 32) is truncated to 32,
causing the parser to miscalculate where the current message ends.  The
loop then treats trailing data in the TCP segment as a second SIP
message and processes it through the SDP parser.

Fix this by changing clen to unsigned long to match the return type of
simple_strtoul(), and reject Content-Length values that exceed the
remaining TCP payload length.

Fixes: f5b321bd37fb ("netfilter: nf_conntrack_sip: add TCP support")
Signed-off-by: Lukas Johannes Möller <research@johannes-moeller.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index d0eac27f6ba03..657839a58782a 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1534,11 +1534,12 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 {
 	struct tcphdr *th, _tcph;
 	unsigned int dataoff, datalen;
-	unsigned int matchoff, matchlen, clen;
+	unsigned int matchoff, matchlen;
 	unsigned int msglen, origlen;
 	const char *dptr, *end;
 	s16 diff, tdiff = 0;
 	int ret = NF_ACCEPT;
+	unsigned long clen;
 	bool term;
 
 	if (ctinfo != IP_CT_ESTABLISHED &&
@@ -1573,6 +1574,9 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
 		if (dptr + matchoff == end)
 			break;
 
+		if (clen > datalen)
+			break;
+
 		term = false;
 		for (; end + strlen("\r\n\r\n") <= dptr + datalen; end++) {
 			if (end[0] == '\r' && end[1] == '\n' &&
-- 
2.51.0



