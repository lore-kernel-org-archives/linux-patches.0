Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFD8C30C373;
	Mon, 13 Oct 2025 15:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369691; cv=none; b=sCXQ8gRBj9VHFKnwh+ylDlJcyJhlD+TgUc9v548BVboCRmohGn1A6vADO4+TKUTG/INpIwx5YAUgv3b1+z8JmHXhDtM63yJo5PbjgMLpGFvgBIExNi6UdSo/bqFobWT+E6bdTeUguLu/tZUu6hgKM33Uq94//V+ZBA3V0KvQTtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369691; c=relaxed/simple;
	bh=NZ/SIcTzbJcXiZj7RztLIH6wsQEFR2euZywUdk+cgdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adTFoM13wJ02/3HUtdT9Xo2WLhCS+D6APLcqqKmmF3BXXFBG/WDFpNu7odUtg+z1CS8o5E3/ggh8Gzdwrx06/8fTM1lCEZRn4lHHRvmJK5Cw0LyrEtdMyJNKJkC9qBuLkhR9MhTmmE2F7dUvIRPs6SeoSAgQMWTGEUW5WASyKvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qjWPosi+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qjWPosi+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441E3C4CEE7;
	Mon, 13 Oct 2025 15:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369691;
	bh=NZ/SIcTzbJcXiZj7RztLIH6wsQEFR2euZywUdk+cgdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qjWPosi+lsfqYQo1F0mEJY8hFEd362tZFv/iEhOqISZR6vtryb1ZX2Br58XSj/pYM
	 MZIS8cOyClEDBVXp6tDARTAA6LmzrOaKgQ54NcRQakR2vA8v8Xsj8bKnAGI2AnkfRn
	 JwIdZLHcyYalIhHCPdOIvP6QvmOBTwvzTmTNsjX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamie Bainbridge <jamie.bainbridge@gmail.com>,
	Abhishek Rawal <rawal.abhishek92@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 334/563] ipv6: snmp: do not track per idev ICMP6_MIB_RATELIMITHOST
Date: Mon, 13 Oct 2025 16:43:15 +0200
Message-ID: <20251013144423.362088992@linuxfoundation.org>
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

[ Upstream commit 2fab94bcf313480336b0a41eb45a24ffd5087490 ]

Blamed commit added a critical false sharing on a single
atomic_long_t under DOS, like receiving UDP packets
to closed ports.

Per netns ICMP6_MIB_RATELIMITHOST tracking uses per-cpu
storage and is enough, we do not need per-device and slow tracking.

Fixes: d0941130c9351 ("icmp: Add counters for rate limits")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Jamie Bainbridge <jamie.bainbridge@gmail.com>
Cc: Abhishek Rawal <rawal.abhishek92@gmail.com>
Link: https://patch.msgid.link/20250905165813.1470708-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 3 +--
 net/ipv6/proc.c | 6 +++++-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 95cdd4cacb004..56c974cf75d15 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -230,8 +230,7 @@ static bool icmpv6_xrlim_allow(struct sock *sk, u8 type,
 	}
 	rcu_read_unlock();
 	if (!res)
-		__ICMP6_INC_STATS(net, ip6_dst_idev(dst),
-				  ICMP6_MIB_RATELIMITHOST);
+		__ICMP6_INC_STATS(net, NULL, ICMP6_MIB_RATELIMITHOST);
 	else
 		icmp_global_consume(net);
 	dst_release(dst);
diff --git a/net/ipv6/proc.c b/net/ipv6/proc.c
index 1a20d088bb13c..eb268b0700258 100644
--- a/net/ipv6/proc.c
+++ b/net/ipv6/proc.c
@@ -94,6 +94,7 @@ static const struct snmp_mib snmp6_icmp6_list[] = {
 	SNMP_MIB_ITEM("Icmp6OutMsgs", ICMP6_MIB_OUTMSGS),
 	SNMP_MIB_ITEM("Icmp6OutErrors", ICMP6_MIB_OUTERRORS),
 	SNMP_MIB_ITEM("Icmp6InCsumErrors", ICMP6_MIB_CSUMERRORS),
+/* ICMP6_MIB_RATELIMITHOST needs to be last, see snmp6_dev_seq_show(). */
 	SNMP_MIB_ITEM("Icmp6OutRateLimitHost", ICMP6_MIB_RATELIMITHOST),
 };
 
@@ -242,8 +243,11 @@ static int snmp6_dev_seq_show(struct seq_file *seq, void *v)
 			      snmp6_ipstats_list,
 			      ARRAY_SIZE(snmp6_ipstats_list),
 			      offsetof(struct ipstats_mib, syncp));
+
+	/* Per idev icmp stats do not have ICMP6_MIB_RATELIMITHOST */
 	snmp6_seq_show_item(seq, NULL, idev->stats.icmpv6dev->mibs,
-			    snmp6_icmp6_list, ARRAY_SIZE(snmp6_icmp6_list));
+			    snmp6_icmp6_list, ARRAY_SIZE(snmp6_icmp6_list) - 1);
+
 	snmp6_seq_show_icmpv6msg(seq, idev->stats.icmpv6msgdev->mibs);
 	return 0;
 }
-- 
2.51.0



