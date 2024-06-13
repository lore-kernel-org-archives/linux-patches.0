Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700C03209;
	Thu, 13 Jun 2024 12:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280921; cv=none; b=Gv3pj1i4QZwpDNmtpyUejj+zkky69PmUn2X6XuLc3iEwMH18dSjGh9IczRJ/nhOaQIp/6VWYRwQJtyTD3ncPwDkg3aNNWIjxDPiTWpzi0b7jN+m1yo0+q/yZMS1Wy+DJxViuLKG3AvgnXEKS+x6r6mfTDYSUEvHQSVz9tM40dH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280921; c=relaxed/simple;
	bh=zysZwLqa5aCUToIwWvZidHak+fpY+4ymn1nSPIooiDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvYV3p26PY1GE+Nt5N4UCZ8hWFDA/rPhsGe79Dz2DjJI25loVrDZaxv531LOhtbE+G16C0eK6NcX2ETSw/mPVQ+GDaQYaIWbO5Eb7viOMq2X52GF/xSMltzpbaYUmjPDRcxcm2gzWcFPXiF04kHQp/HCBhsdXaAZI7oR+XbmbWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e8093rr5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e8093rr5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB5DC2BBFC;
	Thu, 13 Jun 2024 12:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280921;
	bh=zysZwLqa5aCUToIwWvZidHak+fpY+4ymn1nSPIooiDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8093rr56fcVi2GRM0z+w0qIab2QqY3ZCMCtowQnM2j2Shlhi8Is3mzKR31qHWFmh
	 A14M/umuHa/ytLPM8/mQiiPg9DNh5l54NX4F9EXi509HkjcvM9Hv5CUOBjBs0FG3l4
	 aPWD/WSzFDwCtUu0zm6Nb9KkRwoszB5mOw6gcEQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xingwang <gaoxingwang1@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/317] net: ipv6: fix wrong start position when receive hop-by-hop fragment
Date: Thu, 13 Jun 2024 13:31:38 +0200
Message-ID: <20240613113250.644324034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: gaoxingwang <gaoxingwang1@huawei.com>

[ Upstream commit 1cd354fe1e4864eeaff62f66ee513080ec946f20 ]

In IPv6, ipv6_rcv_core will parse the hop-by-hop type extension header and increase skb->transport_header by one extension header length.
But if there are more other extension headers like fragment header at this time, the skb->transport_header points to the second extension header,
not the transport layer header or the first extension header.

This will result in the start and nexthdrp variable not pointing to the same position in ipv6frag_thdr_trunced,
and ipv6_skip_exthdr returning incorrect offset and frag_off.Sometimes,the length of the last sharded packet is smaller than the calculated incorrect offset, resulting in packet loss.
We can use network header to offset and calculate the correct position to solve this problem.

Fixes: 9d9e937b1c8b (ipv6/netfilter: Discard first fragment not including all headers)
Signed-off-by: Gao Xingwang <gaoxingwang1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/reassembly.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/reassembly.c b/net/ipv6/reassembly.c
index 28e44782c94d1..6993675171556 100644
--- a/net/ipv6/reassembly.c
+++ b/net/ipv6/reassembly.c
@@ -363,7 +363,7 @@ static int ipv6_frag_rcv(struct sk_buff *skb)
 	 * the source of the fragment, with the Pointer field set to zero.
 	 */
 	nexthdr = hdr->nexthdr;
-	if (ipv6frag_thdr_truncated(skb, skb_transport_offset(skb), &nexthdr)) {
+	if (ipv6frag_thdr_truncated(skb, skb_network_offset(skb) + sizeof(struct ipv6hdr), &nexthdr)) {
 		__IP6_INC_STATS(net, __in6_dev_get_safely(skb->dev),
 				IPSTATS_MIB_INHDRERRORS);
 		icmpv6_param_prob(skb, ICMPV6_HDR_INCOMP, 0);
-- 
2.43.0



