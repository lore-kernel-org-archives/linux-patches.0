Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 914A91581E1;
	Mon, 16 Sep 2024 12:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488367; cv=none; b=X4SFFP6f9mE9JuasAQsXBQlBs9o+xOhjv97ObHXctvzWUXi4hvRx1pAYWM3jK67P2ygKSl1WQ+xEok+c4whiqJWXJlhJgXAx8EOc+ZXmEvtpqx9iGqZqLPko3wo514SQ+j4t7CyrNhs2oaFQyNp3/d8N4Kuw86hSpnlsXPAbwng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488367; c=relaxed/simple;
	bh=TqHnj9To1Sl7Ldm4hfQMYsvl840jCZSNxLdOb6P+q4U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFPmc5q/clQkKVQVHXobXlzDcVw+8+RanpocLUxGuS8uR3A0/OQs+HGvg0aN1rZb6YGn/tBejmwZ8o7q/2dbSexCqeAEJJlXB648gM5+mgHeEbDIiiFjuRz5ta5Kg1yJFys69tvNo/gruvbSFlrpmU0hU0YkSuj6neuEw0zT50E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gjFmQrC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gjFmQrC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B164C4CECC;
	Mon, 16 Sep 2024 12:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488367;
	bh=TqHnj9To1Sl7Ldm4hfQMYsvl840jCZSNxLdOb6P+q4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gjFmQrC8iOAS6yuL59ihORljlKmF16CJiB/YXz1MnayTyNFK2y77bUvgO3N/4sXk1
	 ex4m7jcM+EXil1Ej2hrY5BdjzakabzvbxErRELw9BWp23XKqiW1OqbasjszkzyjWDY
	 O1nzJjxdi1qiCNeAHr91MTABmbwF5mCZNaXJzpLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 088/121] selftests: net: csum: Fix checksums for packets with non-zero padding
Date: Mon, 16 Sep 2024 13:44:22 +0200
Message-ID: <20240916114232.055888737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Anderson <sean.anderson@linux.dev>

[ Upstream commit e8a63d473b49011a68a748aea1c8aefa046ebacf ]

Padding is not included in UDP and TCP checksums. Therefore, reduce the
length of the checksummed data to include only the data in the IP
payload. This fixes spurious reported checksum failures like

rx: pkt: sport=33000 len=26 csum=0xc850 verify=0xf9fe
pkt: bad csum

Technically it is possible for there to be trailing bytes after the UDP
data but before the Ethernet padding (e.g. if sizeof(ip) + sizeof(udp) +
udp.len < ip.len). However, we don't generate such packets.

Fixes: 91a7de85600d ("selftests/net: add csum offload test")
Signed-off-by: Sean Anderson <sean.anderson@linux.dev>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240906210743.627413-1-sean.anderson@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/lib/csum.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/lib/csum.c b/tools/testing/selftests/net/lib/csum.c
index b9f3fc3c3426..e0a34e5e8dd5 100644
--- a/tools/testing/selftests/net/lib/csum.c
+++ b/tools/testing/selftests/net/lib/csum.c
@@ -654,10 +654,16 @@ static int recv_verify_packet_ipv4(void *nh, int len)
 {
 	struct iphdr *iph = nh;
 	uint16_t proto = cfg_encap ? IPPROTO_UDP : cfg_proto;
+	uint16_t ip_len;
 
 	if (len < sizeof(*iph) || iph->protocol != proto)
 		return -1;
 
+	ip_len = ntohs(iph->tot_len);
+	if (ip_len > len || ip_len < sizeof(*iph))
+		return -1;
+
+	len = ip_len;
 	iph_addr_p = &iph->saddr;
 	if (proto == IPPROTO_TCP)
 		return recv_verify_packet_tcp(iph + 1, len - sizeof(*iph));
@@ -669,16 +675,22 @@ static int recv_verify_packet_ipv6(void *nh, int len)
 {
 	struct ipv6hdr *ip6h = nh;
 	uint16_t proto = cfg_encap ? IPPROTO_UDP : cfg_proto;
+	uint16_t ip_len;
 
 	if (len < sizeof(*ip6h) || ip6h->nexthdr != proto)
 		return -1;
 
+	ip_len = ntohs(ip6h->payload_len);
+	if (ip_len > len - sizeof(*ip6h))
+		return -1;
+
+	len = ip_len;
 	iph_addr_p = &ip6h->saddr;
 
 	if (proto == IPPROTO_TCP)
-		return recv_verify_packet_tcp(ip6h + 1, len - sizeof(*ip6h));
+		return recv_verify_packet_tcp(ip6h + 1, len);
 	else
-		return recv_verify_packet_udp(ip6h + 1, len - sizeof(*ip6h));
+		return recv_verify_packet_udp(ip6h + 1, len);
 }
 
 /* return whether auxdata includes TP_STATUS_CSUM_VALID */
-- 
2.43.0



