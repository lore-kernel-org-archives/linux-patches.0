Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03CDA30C371;
	Mon, 13 Apr 2026 16:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097749; cv=none; b=C0IG4Osjqc02GXpZt3UcSDm3De6gjCkEZ0DoZXM49o6pPZ1h83Xn1j5vnMngiJaqWCJw7Y5bBbAHl7FiTV4svh0SuLIUdmrI8OeUCvC1il3dPvCey/9HxFdpexK24kud4elM/kdAHwPqxB49G42oYG6/7cSuQSypbWx2QUa4TMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097749; c=relaxed/simple;
	bh=B1A8KM8J9PpGswvgXharqiNjKKWfZp+jUEI7quELocY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cr89fACTPto9B/OTiFm3elv8EWB1REzvy7FUEtM9Z2QgueC1VWgAWvGFPicblTrt0em7I3guhP2X1VTaUeS+J3iaJYTZ1tpBVnhiNtZf4F4PnEP1dwDEGOD6RB8Mb9CB4iQC4dbQlCMuXC4HrSM3G8ORDSjBUYTghXKbFRPfJ8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luwFRpWK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luwFRpWK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFAEC2BCAF;
	Mon, 13 Apr 2026 16:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097748;
	bh=B1A8KM8J9PpGswvgXharqiNjKKWfZp+jUEI7quELocY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luwFRpWKWQqRyWx8iXJ4HWDUHD3zPVN6Sju9AIfJ3RQ0R2vdgRfi0gIT94214ukdi
	 p/rBZteLSxioAjPpgXH+Dbg8feRKLOsS5k+fYKXUhPd+Fd+XtaL7/axRFvaNZq+eJM
	 hhLvRGIpQycOo3UuFa8xp1ofBap7NG00EUGP1H1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 256/570] netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()
Date: Mon, 13 Apr 2026 17:56:27 +0200
Message-ID: <20260413155840.062126272@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 751df19fe0f8a..5db17768ec2ad 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1529,11 +1529,12 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
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
@@ -1568,6 +1569,9 @@ static int sip_help_tcp(struct sk_buff *skb, unsigned int protoff,
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



