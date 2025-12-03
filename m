Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3668B3AA1A3;
	Wed,  3 Dec 2025 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779606; cv=none; b=gn/Ace5UJa4hm4/JMeQPivEKtsTl7vn+ke44pdqkDIexlkZXmMLJmVSR95jt3ueCjo1etSEvsU2JMc4p/PMMGeNnez72IJmvmhn06T5zH0d1G3+CPGgC6dZR5H0AvhLD1P2EXDDCzoXBd2HoIEXUP26IOkeqZzVhr8WsMl1PDko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779606; c=relaxed/simple;
	bh=rQXZPpImnR77ZoHyZ319P5fTfo1iqe9BtQO4caCd+ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4wR4L5MVpcgsO+uh1MKVIKIhmiSmbJ4P0/X3yStkPmwQ7uFrFMaz+ghL+qtO11qc45aSYdtRDIZGmkRKiQKat/9q1zWcQnyN+3DdrNL4X7v+huz/RL7kcrFruxpbESImK2nf6vZ5m3IIVJCJrPsCHkhMOeN/baumH4sIMlWf6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p+9yuO3g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p+9yuO3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA6BC116B1;
	Wed,  3 Dec 2025 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779606;
	bh=rQXZPpImnR77ZoHyZ319P5fTfo1iqe9BtQO4caCd+ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p+9yuO3gLJxB16Pjn0pIA+IL68Jx31+3Z7F/k65gENKcouEqpHYJq2Nk/Qk33EXUo
	 AeFssQkXGIrGmyXyh51T7v30yRAsOY6l7qbTywj5iuo1ERsPtq6oRy9k7ieI9qpwDb
	 f4WWGeuWgK9lmnvLMKCme97V0o2bORsfTQeKX5rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Gobert <richardbgobert@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 307/568] selftests/net: fix GRO coalesce test and add ext header coalesce tests
Date: Wed,  3 Dec 2025 16:25:09 +0100
Message-ID: <20251203152451.952938876@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Gobert <richardbgobert@gmail.com>

[ Upstream commit 4e321d590cec6053cb3c566413794706035ee638 ]

Currently there is no test which checks that IPv6 extension header packets
successfully coalesce. This commit adds a test, which verifies two IPv6
packets with HBH extension headers do coalesce, and another test which
checks that packets with different extension header data do not coalesce
in GRO.

I changed the receive socket filter to accept a packet with one extension
header. This change exposed a bug in the fragment test -- the old BPF did
not accept the fragment packet. I updated correct_num_packets in the
fragment test accordingly.

Signed-off-by: Richard Gobert <richardbgobert@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/69282fed-2415-47e8-b3d3-34939ec3eb56@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f8e8486702ab ("selftests/net: use destination options instead of hop-by-hop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.c | 93 +++++++++++++++++++++++++++++--
 1 file changed, 87 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index ad7b07084ca24..9c6f5b4033c37 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -71,6 +71,12 @@
 #define MAX_PAYLOAD (IP_MAXPACKET - sizeof(struct tcphdr) - sizeof(struct ipv6hdr))
 #define NUM_LARGE_PKT (MAX_PAYLOAD / MSS)
 #define MAX_HDR_LEN (ETH_HLEN + sizeof(struct ipv6hdr) + sizeof(struct tcphdr))
+#define MIN_EXTHDR_SIZE 8
+#define EXT_PAYLOAD_1 "\x00\x00\x00\x00\x00\x00"
+#define EXT_PAYLOAD_2 "\x11\x11\x11\x11\x11\x11"
+
+#define ipv6_optlen(p)  (((p)->hdrlen+1) << 3) /* calculate IPv6 extension header len */
+#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
 static const char *addr6_src = "fdaa::2";
 static const char *addr6_dst = "fdaa::1";
@@ -104,7 +110,7 @@ static void setup_sock_filter(int fd)
 	const int dport_off = tcp_offset + offsetof(struct tcphdr, dest);
 	const int ethproto_off = offsetof(struct ethhdr, h_proto);
 	int optlen = 0;
-	int ipproto_off;
+	int ipproto_off, opt_ipproto_off;
 	int next_off;
 
 	if (proto == PF_INET)
@@ -116,14 +122,30 @@ static void setup_sock_filter(int fd)
 	if (strcmp(testname, "ip") == 0) {
 		if (proto == PF_INET)
 			optlen = sizeof(struct ip_timestamp);
-		else
-			optlen = sizeof(struct ip6_frag);
+		else {
+			BUILD_BUG_ON(sizeof(struct ip6_hbh) > MIN_EXTHDR_SIZE);
+			BUILD_BUG_ON(sizeof(struct ip6_dest) > MIN_EXTHDR_SIZE);
+			BUILD_BUG_ON(sizeof(struct ip6_frag) > MIN_EXTHDR_SIZE);
+
+			/* same size for HBH and Fragment extension header types */
+			optlen = MIN_EXTHDR_SIZE;
+			opt_ipproto_off = ETH_HLEN + sizeof(struct ipv6hdr)
+				+ offsetof(struct ip6_ext, ip6e_nxt);
+		}
 	}
 
+	/* this filter validates the following:
+	 *	- packet is IPv4/IPv6 according to the running test.
+	 *	- packet is TCP. Also handles the case of one extension header and then TCP.
+	 *	- checks the packet tcp dport equals to DPORT. Also handles the case of one
+	 *	  extension header and then TCP.
+	 */
 	struct sock_filter filter[] = {
 			BPF_STMT(BPF_LD  + BPF_H   + BPF_ABS, ethproto_off),
-			BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, ntohs(ethhdr_proto), 0, 7),
+			BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, ntohs(ethhdr_proto), 0, 9),
 			BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, ipproto_off),
+			BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, IPPROTO_TCP, 2, 0),
+			BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, opt_ipproto_off),
 			BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, IPPROTO_TCP, 0, 5),
 			BPF_STMT(BPF_LD  + BPF_H   + BPF_ABS, dport_off),
 			BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, DPORT, 2, 0),
@@ -576,6 +598,39 @@ static void add_ipv4_ts_option(void *buf, void *optpkt)
 	iph->check = checksum_fold(iph, sizeof(struct iphdr) + optlen, 0);
 }
 
+static void add_ipv6_exthdr(void *buf, void *optpkt, __u8 exthdr_type, char *ext_payload)
+{
+	struct ipv6_opt_hdr *exthdr = (struct ipv6_opt_hdr *)(optpkt + tcp_offset);
+	struct ipv6hdr *iph = (struct ipv6hdr *)(optpkt + ETH_HLEN);
+	char *exthdr_payload_start = (char *)(exthdr + 1);
+
+	exthdr->hdrlen = 0;
+	exthdr->nexthdr = IPPROTO_TCP;
+
+	memcpy(exthdr_payload_start, ext_payload, MIN_EXTHDR_SIZE - sizeof(*exthdr));
+
+	memcpy(optpkt, buf, tcp_offset);
+	memcpy(optpkt + tcp_offset + MIN_EXTHDR_SIZE, buf + tcp_offset,
+		sizeof(struct tcphdr) + PAYLOAD_LEN);
+
+	iph->nexthdr = exthdr_type;
+	iph->payload_len = htons(ntohs(iph->payload_len) + MIN_EXTHDR_SIZE);
+}
+
+static void send_ipv6_exthdr(int fd, struct sockaddr_ll *daddr, char *ext_data1, char *ext_data2)
+{
+	static char buf[MAX_HDR_LEN + PAYLOAD_LEN];
+	static char exthdr_pck[sizeof(buf) + MIN_EXTHDR_SIZE];
+
+	create_packet(buf, 0, 0, PAYLOAD_LEN, 0);
+	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_HOPOPTS, ext_data1);
+	write_packet(fd, exthdr_pck, total_hdr_len + PAYLOAD_LEN + MIN_EXTHDR_SIZE, daddr);
+
+	create_packet(buf, PAYLOAD_LEN * 1, 0, PAYLOAD_LEN, 0);
+	add_ipv6_exthdr(buf, exthdr_pck, IPPROTO_HOPOPTS, ext_data2);
+	write_packet(fd, exthdr_pck, total_hdr_len + PAYLOAD_LEN + MIN_EXTHDR_SIZE, daddr);
+}
+
 /* IPv4 options shouldn't coalesce */
 static void send_ip_options(int fd, struct sockaddr_ll *daddr)
 {
@@ -697,7 +752,7 @@ static void send_fragment6(int fd, struct sockaddr_ll *daddr)
 		create_packet(buf, PAYLOAD_LEN * i, 0, PAYLOAD_LEN, 0);
 		write_packet(fd, buf, bufpkt_len, daddr);
 	}
-
+	sleep(1);
 	create_packet(buf, PAYLOAD_LEN * 2, 0, PAYLOAD_LEN, 0);
 	memset(extpkt, 0, extpkt_len);
 
@@ -760,6 +815,7 @@ static void check_recv_pkts(int fd, int *correct_payload,
 	vlog("}, Total %d packets\nReceived {", correct_num_pkts);
 
 	while (1) {
+		ip_ext_len = 0;
 		pkt_size = recv(fd, buffer, IP_MAXPACKET + ETH_HLEN + 1, 0);
 		if (pkt_size < 0)
 			error(1, errno, "could not receive");
@@ -767,7 +823,7 @@ static void check_recv_pkts(int fd, int *correct_payload,
 		if (iph->version == 4)
 			ip_ext_len = (iph->ihl - 5) * 4;
 		else if (ip6h->version == 6 && ip6h->nexthdr != IPPROTO_TCP)
-			ip_ext_len = sizeof(struct ip6_frag);
+			ip_ext_len = MIN_EXTHDR_SIZE;
 
 		tcph = (struct tcphdr *)(buffer + tcp_offset + ip_ext_len);
 
@@ -888,7 +944,21 @@ static void gro_sender(void)
 			sleep(1);
 			write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 		} else if (proto == PF_INET6) {
+			sleep(1);
 			send_fragment6(txfd, &daddr);
+			sleep(1);
+			write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
+
+			sleep(1);
+			/* send IPv6 packets with ext header with same payload */
+			send_ipv6_exthdr(txfd, &daddr, EXT_PAYLOAD_1, EXT_PAYLOAD_1);
+			sleep(1);
+			write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
+
+			sleep(1);
+			/* send IPv6 packets with ext header with different payload */
+			send_ipv6_exthdr(txfd, &daddr, EXT_PAYLOAD_1, EXT_PAYLOAD_2);
+			sleep(1);
 			write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 		}
 	} else if (strcmp(testname, "large") == 0) {
@@ -1005,6 +1075,17 @@ static void gro_receiver(void)
 			 */
 			printf("fragmented ip6 doesn't coalesce: ");
 			correct_payload[0] = PAYLOAD_LEN * 2;
+			correct_payload[1] = PAYLOAD_LEN;
+			correct_payload[2] = PAYLOAD_LEN;
+			check_recv_pkts(rxfd, correct_payload, 3);
+
+			printf("ipv6 with ext header does coalesce: ");
+			correct_payload[0] = PAYLOAD_LEN * 2;
+			check_recv_pkts(rxfd, correct_payload, 1);
+
+			printf("ipv6 with ext header with different payloads doesn't coalesce: ");
+			correct_payload[0] = PAYLOAD_LEN;
+			correct_payload[1] = PAYLOAD_LEN;
 			check_recv_pkts(rxfd, correct_payload, 2);
 		}
 	} else if (strcmp(testname, "large") == 0) {
-- 
2.51.0



