Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41F7E55B;
	Tue, 25 Mar 2025 12:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905921; cv=none; b=Jy4qxdyYsHh10YvlDVo74Ka6fikYA4lWATGulEjXxxQv5l3RxfadJpP9/z4doIHu0iUDY75jkGShHYw+zwNOK5kEZ1go9EgehYLmkYnTzOM1CIW0av9xFJmCE+hKjBlsRtfK2wfnWH2nenq0cQaKJmdBKoa17Pu5SZKzjyL4J7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905921; c=relaxed/simple;
	bh=VIJ8mnOVkB+AZ+CBftavfYr7liKq7PyddXWQSTBfabo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLI9VYzEbHXIySsrTcSJoezMtdkghO9Ek0xNvSJDD0cRfLxk3l+X7k/0GBwF+1OPXnN9RxJfH/YIVK0BwIBo9cNj9U3Fg6+QzYvXRfizP+q/KpVuwR/6ffJL47NV4GZ7K8spuoN8wPKRDoyiQbTweXHYxQhB4MrPEjJ86peZPUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvCPkkco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvCPkkco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829EAC4CEE4;
	Tue, 25 Mar 2025 12:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905921;
	bh=VIJ8mnOVkB+AZ+CBftavfYr7liKq7PyddXWQSTBfabo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvCPkkcos+Lpql4aaYAdsvYvH6uxrYO2/SxR82buJDUxfFiaTQs9Oa3U+RmRriMfn
	 d9JvRdoAjnHd/i7YN2UNzJmrS76r6K6CvMNCuoQbsyO7apCUiExu3cHSwEeWIxUFgU
	 eERYcaS5bdaM2es4cy6VJ2Tbgpygtuu62vDXo7OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 038/119] net: ipv6: fix TCP GSO segmentation with NAT
Date: Tue, 25 Mar 2025 08:21:36 -0400
Message-ID: <20250325122150.034289532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



