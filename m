Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950BB25D525;
	Tue, 25 Mar 2025 12:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906343; cv=none; b=JoMfm3qnEKxvHUm+C96CJQ4rVmUGK4QRZTI7M+cU62gM7LrtPjwcMfEFEHvX5YJpx5WQasLUFPuCzR+0fodcBasdkw8P1c5B5qhbv8+79EVh7rKBLLoDg4I8n8yEf35jlEaprnJAahTm3fVO7foW8A8AoHY+OE0LjC8oWShqWqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906343; c=relaxed/simple;
	bh=irZaXBWk107geJvwoQUUjXJsO/Wv8i13debshdW9Wu4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGHZlMdVPMfRzq59W0h2phIGIoc5D1/VAyM5/gipRHuDUEe6igQbT4+A/rUNhM/ytwB1+NXeQ7r7ZQKkp5vrKZzilcDe1p0SuzauUSPD3fCSCC8KhZe0Cy9f82uRB/RyuoQn9VePM2+2pzYVxQQF1aEItARmCnEhiZ/1o0ej/cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KVQGPdW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KVQGPdW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19829C4CEF0;
	Tue, 25 Mar 2025 12:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906343;
	bh=irZaXBWk107geJvwoQUUjXJsO/Wv8i13debshdW9Wu4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KVQGPdW37wm1ZGVIG8mVWRRqz9lRAE6n+8UjHdtqpGA12U2DRlufDiNGmk6vTFwey
	 qcmi4MyaxIW7LQ4qHkCp4BIRR++JoUar3R04cTn6oXAcSLSNIKS2TpMafW8Mxx4dEs
	 dHAgK5H39xWkXIXfp/FbysVN/dvnGyMzHZ+lDNOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 037/116] net: ipv6: fix TCP GSO segmentation with NAT
Date: Tue, 25 Mar 2025 08:22:04 -0400
Message-ID: <20250325122150.155928815@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit daa624d3c2ddffdcbad140a9625a4064371db44f ]

When updating the source/destination address, the TCP/UDP checksum needs to
be updated as well.

Fixes: bee88cd5bd83 ("net: add support for segmenting TCP fraglist GSO packets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20250311212530.91519-1-nbd@nbd.name
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcpv6_offload.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/tcpv6_offload.c b/net/ipv6/tcpv6_offload.c
index a45bf17cb2a17..ae2da28f9dfb1 100644
--- a/net/ipv6/tcpv6_offload.c
+++ b/net/ipv6/tcpv6_offload.c
@@ -94,14 +94,23 @@ INDIRECT_CALLABLE_SCOPE int tcp6_gro_complete(struct sk_buff *skb, int thoff)
 }
 
 static void __tcpv6_gso_segment_csum(struct sk_buff *seg,
+				     struct in6_addr *oldip,
+				     const struct in6_addr *newip,
 				     __be16 *oldport, __be16 newport)
 {
-	struct tcphdr *th;
+	struct tcphdr *th = tcp_hdr(seg);
+
+	if (!ipv6_addr_equal(oldip, newip)) {
+		inet_proto_csum_replace16(&th->check, seg,
+					  oldip->s6_addr32,
+					  newip->s6_addr32,
+					  true);
+		*oldip = *newip;
+	}
 
 	if (*oldport == newport)
 		return;
 
-	th = tcp_hdr(seg);
 	inet_proto_csum_replace2(&th->check, seg, *oldport, newport, false);
 	*oldport = newport;
 }
@@ -129,10 +138,10 @@ static struct sk_buff *__tcpv6_gso_segment_list_csum(struct sk_buff *segs)
 		th2 = tcp_hdr(seg);
 		iph2 = ipv6_hdr(seg);
 
-		iph2->saddr = iph->saddr;
-		iph2->daddr = iph->daddr;
-		__tcpv6_gso_segment_csum(seg, &th2->source, th->source);
-		__tcpv6_gso_segment_csum(seg, &th2->dest, th->dest);
+		__tcpv6_gso_segment_csum(seg, &iph2->saddr, &iph->saddr,
+					 &th2->source, th->source);
+		__tcpv6_gso_segment_csum(seg, &iph2->daddr, &iph->daddr,
+					 &th2->dest, th->dest);
 	}
 
 	return segs;
-- 
2.39.5



