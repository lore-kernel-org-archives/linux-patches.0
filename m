Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC09D6FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A02C433EF;
	Tue, 10 Jan 2023 18:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374655;
	bh=DgXGfryL/9xQiWxj/r9BrYqkmOTGeayp6MF9PvrFavo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2iW9Zc6b0yqQOHNVfCn7/W+6oXdnyvoywoB5iuHGwQDU4yYiEgupQzFYiLbfIJLR
	 OUCIbQjRO7Hc3e3m09pKW7wGaqoOss9bVf+7ZBNVxn5kPcVS4sILdIf/DL3rbOFLpD
	 sdGI5Rn32I72l5WQ5sc5/C5afHn4fDYheDYA2xCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=D0=9C=D0=B0=D1=80=D0=BA=20=D0=9A=D0=BE=D1=80=D0=B5=D0=BD=D0=B1=D0=B5=D1=80=D0=B3?= <socketpair@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 088/159] netfilter: ipset: fix hash:net,port,net hang with /0 subnet
Date: Tue, 10 Jan 2023 19:03:56 +0100
Message-Id: <20230110180021.106351520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit a31d47be64b9b74f8cfedffe03e0a8a1f9e51f23 ]

The hash:net,port,net set type supports /0 subnets. However, the patch
commit 5f7b51bf09baca8e titled "netfilter: ipset: Limit the maximal range
of consecutive elements to add/delete" did not take into account it and
resulted in an endless loop. The bug is actually older but the patch
5f7b51bf09baca8e brings it out earlier.

Handle /0 subnets properly in hash:net,port,net set types.

Fixes: 5f7b51bf09ba ("netfilter: ipset: Limit the maximal range of consecutive elements to add/delete")
Reported-by: Марк Коренберг <socketpair@gmail.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_netportnet.c | 40 ++++++++++----------
 1 file changed, 21 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_netportnet.c b/net/netfilter/ipset/ip_set_hash_netportnet.c
index 19bcdb3141f6..005a7ce87217 100644
--- a/net/netfilter/ipset/ip_set_hash_netportnet.c
+++ b/net/netfilter/ipset/ip_set_hash_netportnet.c
@@ -173,17 +173,26 @@ hash_netportnet4_kadt(struct ip_set *set, const struct sk_buff *skb,
 	return adtfn(set, &e, &ext, &opt->ext, opt->cmdflags);
 }
 
+static u32
+hash_netportnet4_range_to_cidr(u32 from, u32 to, u8 *cidr)
+{
+	if (from == 0 && to == UINT_MAX) {
+		*cidr = 0;
+		return to;
+	}
+	return ip_set_range_to_cidr(from, to, cidr);
+}
+
 static int
 hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 		      enum ipset_adt adt, u32 *lineno, u32 flags, bool retried)
 {
-	const struct hash_netportnet4 *h = set->data;
+	struct hash_netportnet4 *h = set->data;
 	ipset_adtfn adtfn = set->variant->adt[adt];
 	struct hash_netportnet4_elem e = { };
 	struct ip_set_ext ext = IP_SET_INIT_UEXT(set);
 	u32 ip = 0, ip_to = 0, p = 0, port, port_to;
-	u32 ip2_from = 0, ip2_to = 0, ip2, ipn;
-	u64 n = 0, m = 0;
+	u32 ip2_from = 0, ip2_to = 0, ip2, i = 0;
 	bool with_ports = false;
 	int ret;
 
@@ -285,19 +294,6 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 	} else {
 		ip_set_mask_from_to(ip2_from, ip2_to, e.cidr[1]);
 	}
-	ipn = ip;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip_to, &e.cidr[0]);
-		n++;
-	} while (ipn++ < ip_to);
-	ipn = ip2_from;
-	do {
-		ipn = ip_set_range_to_cidr(ipn, ip2_to, &e.cidr[1]);
-		m++;
-	} while (ipn++ < ip2_to);
-
-	if (n*m*(port_to - port + 1) > IPSET_MAX_RANGE)
-		return -ERANGE;
 
 	if (retried) {
 		ip = ntohl(h->next.ip[0]);
@@ -310,13 +306,19 @@ hash_netportnet4_uadt(struct ip_set *set, struct nlattr *tb[],
 
 	do {
 		e.ip[0] = htonl(ip);
-		ip = ip_set_range_to_cidr(ip, ip_to, &e.cidr[0]);
+		ip = hash_netportnet4_range_to_cidr(ip, ip_to, &e.cidr[0]);
 		for (; p <= port_to; p++) {
 			e.port = htons(p);
 			do {
+				i++;
 				e.ip[1] = htonl(ip2);
-				ip2 = ip_set_range_to_cidr(ip2, ip2_to,
-							   &e.cidr[1]);
+				if (i > IPSET_MAX_RANGE) {
+					hash_netportnet4_data_next(&h->next,
+								   &e);
+					return -ERANGE;
+				}
+				ip2 = hash_netportnet4_range_to_cidr(ip2,
+							ip2_to, &e.cidr[1]);
 				ret = adtfn(set, &e, &ext, &ext, flags);
 				if (ret && !ip_set_eexist(ret, flags))
 					return ret;
-- 
2.35.1



