Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD10146A79;
	Mon, 16 Sep 2024 12:11:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488667; cv=none; b=Yq2iLWI5KEtFFF6dxvketj6A+VC+Ahhm2u6i4Sg2L0XRn1zEbhaObQdJP0J2Cnc7NqpDjfVHNOnMxwNjfftGbYY4SViPsRxuo8XzuQDwXZ3jN9pvwuyh861/qKkOq8NWnjVjAQdOPnh8TTNm48gpRnd2tC7zzsr1UsI0BYYdtTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488667; c=relaxed/simple;
	bh=xvN8dTVDLzwQ5vTs0crGmMKf9v9XGF/cyniXEuyl8gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOVeKnjqARUJfpg7aPs8OV9i4cNR53njcdOSjtuJtiWX1ZvGU02rSOHy0QqG9yLz3auwNmGyhIWxxqShhyGdel8DsKpV8eNTIIgPLgyVoyfcW9bpWaxQ9YMuQpPN8PuBXq4A/EXpOlsW75YLGtoeHx1pdnZrpnvCb8J+cCcTeNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QJ38r5pn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QJ38r5pn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D6C4CEC4;
	Mon, 16 Sep 2024 12:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488667;
	bh=xvN8dTVDLzwQ5vTs0crGmMKf9v9XGF/cyniXEuyl8gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QJ38r5pnx/coDXcsMMNxt8NywEcPlXjRRARE1CRsatbhJH5dw7uvYenn26jIvMPM9
	 YlUJjl6pDL2gCX7mNQi0VJ5n08I1DiXNSnfkNyF2PugtMnCvIQgIxSnCGLL6n767fJ
	 0940U84/Zk7+bFA36TdJ2NytRxjXTZEVv8BR7smY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Anderson <sean.anderson@linux.dev>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 71/91] selftests: net: csum: Fix checksums for packets with non-zero padding
Date: Mon, 16 Sep 2024 13:44:47 +0200
Message-ID: <20240916114226.819719076@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 tools/testing/selftests/net/csum.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/csum.c b/tools/testing/selftests/net/csum.c
index 90eb06fefa59..eef72b50270c 100644
--- a/tools/testing/selftests/net/csum.c
+++ b/tools/testing/selftests/net/csum.c
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



