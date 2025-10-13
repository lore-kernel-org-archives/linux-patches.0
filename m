Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D396930F930;
	Mon, 13 Oct 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369688; cv=none; b=DyboqbkkbvUUbVgUqozEqsQdMSm3sMI7J5MBCrhGuTG7GcpE0iEkW6rNltWxXg1HIGqDJCZpKF9EyGwd6UXhyWZTvQ2WyLu1PHl22MfAev5tHmFsH8aZeeyz58Kd7cOuaOzYJKTB6GWiVmpbHA/kv20SKzG8GpQDSUNsfxZyQBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369688; c=relaxed/simple;
	bh=ax6nfzvKgPmd4AfAbbxqQQFnfFy+y5McX5e3YB8lrag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tX7xuAODMMgrECYd1sy9fVqUB/v8lqPGfCofAAIf0/zK//ug8/zG0L/Y2fbd2g7J3SkTLExGk4Pf8Z7K/li09yMbki0WylevO/vJ2O3ALWKEOGECEeklHmUomKak/O4zxQfXAqFKxFynHyDweYs0qY/jRdNC2yDvV2sfHwRTA0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhRVmwa1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhRVmwa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55FC0C4CEE7;
	Mon, 13 Oct 2025 15:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369688;
	bh=ax6nfzvKgPmd4AfAbbxqQQFnfFy+y5McX5e3YB8lrag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yhRVmwa1y94bIOTXYtX2C1Cmj6xEPMVOh6M5dDBZLiR98cqTKzD3mgGzNGb6b4qbu
	 HEUHO1L1rDTzgdNCXMxXijrt9lUDRIsBkTXU452aXnhK51Ids96s1OoT+GB8G2Mq00
	 6pY8N35/WZnj7Hrxgze7fne8QJI4v7xZ29KYtPvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 333/563] ipv6: snmp: do not use SNMP_MIB_SENTINEL anymore
Date: Mon, 13 Oct 2025 16:43:14 +0200
Message-ID: <20251013144423.326533208@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ceac1fb2290d230eb83aff3761058c559440de13 ]

Use ARRAY_SIZE(), so that we know the limit at compile time.

Following patch needs this preliminary change.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://patch.msgid.link/20250905165813.1470708-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 2fab94bcf313 ("ipv6: snmp: do not track per idev ICMP6_MIB_RATELIMITHOST")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 24 ++++++++++++++++++++++++
 net/ipv6/proc.c  | 43 ++++++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 6dbd2bf8fa9c9..a1624e8db1abd 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -338,6 +338,19 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
 	} \
 }
 
+#define snmp_get_cpu_field64_batch_cnt(buff64, stats_list, cnt,	\
+				       mib_statistic, offset)	\
+{ \
+	int i, c; \
+	for_each_possible_cpu(c) { \
+		for (i = 0; i < cnt; i++) \
+			buff64[i] += snmp_get_cpu_field64( \
+					mib_statistic, \
+					c, stats_list[i].entry, \
+					offset); \
+	} \
+}
+
 #define snmp_get_cpu_field_batch(buff, stats_list, mib_statistic) \
 { \
 	int i, c; \
@@ -349,6 +362,17 @@ static inline u64 snmp_fold_field64(void __percpu *mib, int offt, size_t syncp_o
 	} \
 }
 
+#define snmp_get_cpu_field_batch_cnt(buff, stats_list, cnt, mib_statistic) \
+{ \
+	int i, c; \
+	for_each_possible_cpu(c) { \
+		for (i = 0; i < cnt; i++) \
+			buff[i] += snmp_get_cpu_field( \
+						mib_statistic, \
+						c, stats_list[i].entry); \
+	} \
+}
+
 static inline void inet_get_local_port_range(const struct net *net, int *low, int *high)
 {
 	u32 range = READ_ONCE(net->ipv4.ip_local_ports.range);
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 752327b10dde7..1a20d088bb13c 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -85,7 +85,6 @@ static const struct snmp_mib snmp6_ipstats_list[] = {
 	SNMP_MIB_ITEM("Ip6InECT0Pkts", IPSTATS_MIB_ECT0PKTS),
 	SNMP_MIB_ITEM("Ip6InCEPkts", IPSTATS_MIB_CEPKTS),
 	SNMP_MIB_ITEM("Ip6OutTransmits", IPSTATS_MIB_OUTPKTS),
-	SNMP_MIB_SENTINEL
 };
 
 static const struct snmp_mib snmp6_icmp6_list[] = {
@@ -96,7 +95,6 @@ static const struct snmp_mib snmp6_icmp6_list[] = {
 	SNMP_MIB_ITEM("Icmp6OutErrors", ICMP6_MIB_OUTERRORS),
 	SNMP_MIB_ITEM("Icmp6InCsumErrors", ICMP6_MIB_CSUMERRORS),
 	SNMP_MIB_ITEM("Icmp6OutRateLimitHost", ICMP6_MIB_RATELIMITHOST),
-	SNMP_MIB_SENTINEL
 };
 
 /* RFC 4293 v6 ICMPMsgStatsTable; named items for RFC 2466 compatibility */
@@ -129,7 +127,6 @@ static const struct snmp_mib snmp6_udp6_list[] = {
 	SNMP_MIB_ITEM("Udp6InCsumErrors", UDP_MIB_CSUMERRORS),
 	SNMP_MIB_ITEM("Udp6IgnoredMulti", UDP_MIB_IGNOREDMULTI),
 	SNMP_MIB_ITEM("Udp6MemErrors", UDP_MIB_MEMERRORS),
-	SNMP_MIB_SENTINEL
 };
 
 static const struct snmp_mib snmp6_udplite6_list[] = {
@@ -141,7 +138,6 @@ static const struct snmp_mib snmp6_udplite6_list[] = {
 	SNMP_MIB_ITEM("UdpLite6SndbufErrors", UDP_MIB_SNDBUFERRORS),
 	SNMP_MIB_ITEM("UdpLite6InCsumErrors", UDP_MIB_CSUMERRORS),
 	SNMP_MIB_ITEM("UdpLite6MemErrors", UDP_MIB_MEMERRORS),
-	SNMP_MIB_SENTINEL
 };
 
 static void snmp6_seq_show_icmpv6msg(struct seq_file *seq, atomic_long_t *smib)
@@ -182,35 +178,37 @@ static void snmp6_seq_show_icmpv6msg(struct seq_file *seq, atomic_long_t *smib)
  */
 static void snmp6_seq_show_item(struct seq_file *seq, void __percpu *pcpumib,
 				atomic_long_t *smib,
-				const struct snmp_mib *itemlist)
+				const struct snmp_mib *itemlist,
+				int cnt)
 {
 	unsigned long buff[SNMP_MIB_MAX];
 	int i;
 
 	if (pcpumib) {
-		memset(buff, 0, sizeof(unsigned long) * SNMP_MIB_MAX);
+		memset(buff, 0, sizeof(unsigned long) * cnt);
 
-		snmp_get_cpu_field_batch(buff, itemlist, pcpumib);
-		for (i = 0; itemlist[i].name; i++)
+		snmp_get_cpu_field_batch_cnt(buff, itemlist, cnt, pcpumib);
+		for (i = 0; i < cnt; i++)
 			seq_printf(seq, "%-32s\t%lu\n",
 				   itemlist[i].name, buff[i]);
 	} else {
-		for (i = 0; itemlist[i].name; i++)
+		for (i = 0; i < cnt; i++)
 			seq_printf(seq, "%-32s\t%lu\n", itemlist[i].name,
 				   atomic_long_read(smib + itemlist[i].entry));
 	}
 }
 
 static void snmp6_seq_show_item64(struct seq_file *seq, void __percpu *mib,
-				  const struct snmp_mib *itemlist, size_t syncpoff)
+				  const struct snmp_mib *itemlist,
+				  int cnt, size_t syncpoff)
 {
 	u64 buff64[SNMP_MIB_MAX];
 	int i;
 
-	memset(buff64, 0, sizeof(u64) * SNMP_MIB_MAX);
+	memset(buff64, 0, sizeof(u64) * cnt);
 
-	snmp_get_cpu_field64_batch(buff64, itemlist, mib, syncpoff);
-	for (i = 0; itemlist[i].name; i++)
+	snmp_get_cpu_field64_batch_cnt(buff64, itemlist, cnt, mib, syncpoff);
+	for (i = 0; i < cnt; i++)
 		seq_printf(seq, "%-32s\t%llu\n", itemlist[i].name, buff64[i]);
 }
 
@@ -219,14 +217,19 @@ static int snmp6_seq_show(struct seq_file *seq, void *v)
 	struct net *net = (struct net *)seq->private;
 
 	snmp6_seq_show_item64(seq, net->mib.ipv6_statistics,
-			    snmp6_ipstats_list, offsetof(struct ipstats_mib, syncp));
+			      snmp6_ipstats_list,
+			      ARRAY_SIZE(snmp6_ipstats_list),
+			      offsetof(struct ipstats_mib, syncp));
 	snmp6_seq_show_item(seq, net->mib.icmpv6_statistics,
-			    NULL, snmp6_icmp6_list);
+			    NULL, snmp6_icmp6_list,
+			    ARRAY_SIZE(snmp6_icmp6_list));
 	snmp6_seq_show_icmpv6msg(seq, net->mib.icmpv6msg_statistics->mibs);
 	snmp6_seq_show_item(seq, net->mib.udp_stats_in6,
-			    NULL, snmp6_udp6_list);
+			    NULL, snmp6_udp6_list,
+			    ARRAY_SIZE(snmp6_udp6_list));
 	snmp6_seq_show_item(seq, net->mib.udplite_stats_in6,
-			    NULL, snmp6_udplite6_list);
+			    NULL, snmp6_udplite6_list,
+			    ARRAY_SIZE(snmp6_udplite6_list));
 	return 0;
 }
 
@@ -236,9 +239,11 @@ static int snmp6_dev_seq_show(struct seq_file *seq, void *v)
 
 	seq_printf(seq, "%-32s\t%u\n", "ifIndex", idev->dev->ifindex);
 	snmp6_seq_show_item64(seq, idev->stats.ipv6,
-			    snmp6_ipstats_list, offsetof(struct ipstats_mib, syncp));
+			      snmp6_ipstats_list,
+			      ARRAY_SIZE(snmp6_ipstats_list),
+			      offsetof(struct ipstats_mib, syncp));
 	snmp6_seq_show_item(seq, NULL, idev->stats.icmpv6dev->mibs,
-			    snmp6_icmp6_list);
+			    snmp6_icmp6_list, ARRAY_SIZE(snmp6_icmp6_list));
 	snmp6_seq_show_icmpv6msg(seq, idev->stats.icmpv6msgdev->mibs);
 	return 0;
 }
-- 
2.51.0



