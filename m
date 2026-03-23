Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F4A33AE18C;
	Mon, 23 Mar 2026 13:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274174; cv=none; b=ax3ed+zR/NROrMXG7SHtqYIC3mJ4wUDf7sMImk3niWxpVWvjym9+LENBIkR+LLNdfe/3Wej92+vN9CMxfm3Kc32r593n5f0LCBMbt7JxomHblmfCJ+IQ6P9S29x/2IpfLw7Jd0TEIJnhw8G8HsfXrQOUiYBNy9NSqTxFIgWGia8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274174; c=relaxed/simple;
	bh=mlKYnV4pGP2gfWPzjQqTLwoeDm6ugKsaY+qZiOgy+HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qYIRFfviraM72kXeyZDyNrz4wS3YTE2l3QTs8lkJTjfhr+U4GYkx6R1GF9aNKM85/JXL0w7vjLK3XGcl0gpYC2WrZ769xkb3Q7a/BInWkq32J39Bt6LKePkMrb58CaqGgEaC/d/aHlZ3DcpRGfmXxbYy5Im2UhAXQYyF5zOgazM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Rv/TDjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Rv/TDjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B6C2BC9E;
	Mon, 23 Mar 2026 13:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274173;
	bh=mlKYnV4pGP2gfWPzjQqTLwoeDm6ugKsaY+qZiOgy+HY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Rv/TDjcPXx3XatlLCEDGFWLcRkJzMhd17BXp8QQ5CyvfeOVWnuQyrhboXMLXbxRh
	 8pYtzhPX+YsHKndeRgxYMPWe/0k/R4xAIjWMQ9vaH0DkdXcLA5+0Puk0KntcJERCmB
	 sToBH9VQxitybV3kUwGzYArIIEC7XZNBIpSONT+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Lukas=20Johannes=20M=C3=B6ller?= <research@johannes-moeller.dev>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 134/220] netfilter: nf_conntrack_sip: fix Content-Length u32 truncation in sip_help_tcp()
Date: Mon, 23 Mar 2026 14:45:11 +0100
Message-ID: <20260323134508.814584602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index ca748f8dbff13..4ab5ef71d96db 100644
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



