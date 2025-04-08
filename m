Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAFA269823;
	Tue,  8 Apr 2025 12:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116978; cv=none; b=K2NAjeyDC3TE7+edcjDdcSEK9gCfruCCyZ9GdeRf2dWaf+qS2AZmYjWD123oSx1rJastFvOxCb0j2YOwNCVeGWBX0E4h4Ksf47A5Fo3FRa3IwNAIJsmpncgFrz8aHZRGcwfI/bYH5qdpiv/OdBUxjC0mfhG1tTVKh4IoVThRByw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116978; c=relaxed/simple;
	bh=HvXBhIuwCEX7KbQ7mJedKR6Tgph4YoROQHfsemk8Dls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oujvbqYv8u5OOlIBTYUFG+wVAAPUJo/Xh3PV5u5Rrkceipb24kdn22TkFmwOeg+CXDTKW2sQzHHpprG+w2x3sPLwJuJIv20B1F4kfL/xd6Jo2QPqqkzfpnDrtsnSM1tVAJfXuFkarPLYCfVqbQAD8I1uq6wdVWYdqfajmc6jeZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QefYRj1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QefYRj1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C475CC4CEE5;
	Tue,  8 Apr 2025 12:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116978;
	bh=HvXBhIuwCEX7KbQ7mJedKR6Tgph4YoROQHfsemk8Dls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QefYRj1S3DdI7iAtT23dk4txKXAG9TA9FrGrSFt0e6qznB06Nf4/zhLrSFVUm1TLY
	 5n7hbzzkgZeXAFbDrwWlZj/Z2cJwIDvYLBgpaOmpbJvJOEad0Nzs57rU+pW6psyBAV
	 QouktOHOigHfyOyk+ViVCb3onp9wndB/tGIfqars=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <ffmancera@riseup.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/423] ipv6: fix omitted netlink attributes when using RTEXT_FILTER_SKIP_STATS
Date: Tue,  8 Apr 2025 12:51:04 +0200
Message-ID: <20250408104853.708861980@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 7ac6ea4a3e0898db76aecccd68fb2c403eb7d24e ]

Using RTEXT_FILTER_SKIP_STATS is incorrectly skipping non-stats IPv6
netlink attributes on link dump. This causes issues on userspace tools,
e.g iproute2 is not rendering address generation mode as it should due
to missing netlink attribute.

Move the filling of IFLA_INET6_STATS and IFLA_INET6_ICMP6STATS to a
helper function guarded by a flag check to avoid hitting the same
situation in the future.

Fixes: d5566fd72ec1 ("rtnetlink: RTEXT_FILTER_SKIP_STATS support to avoid dumping inet/inet6 stats")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250402121751.3108-1-ffmancera@riseup.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index f7c17388ff6aa..f5d49162f7983 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -5807,6 +5807,27 @@ static void snmp6_fill_stats(u64 *stats, struct inet6_dev *idev, int attrtype,
 	}
 }
 
+static int inet6_fill_ifla6_stats_attrs(struct sk_buff *skb,
+					struct inet6_dev *idev)
+{
+	struct nlattr *nla;
+
+	nla = nla_reserve(skb, IFLA_INET6_STATS, IPSTATS_MIB_MAX * sizeof(u64));
+	if (!nla)
+		goto nla_put_failure;
+	snmp6_fill_stats(nla_data(nla), idev, IFLA_INET6_STATS, nla_len(nla));
+
+	nla = nla_reserve(skb, IFLA_INET6_ICMP6STATS, ICMP6_MIB_MAX * sizeof(u64));
+	if (!nla)
+		goto nla_put_failure;
+	snmp6_fill_stats(nla_data(nla), idev, IFLA_INET6_ICMP6STATS, nla_len(nla));
+
+	return 0;
+
+nla_put_failure:
+	return -EMSGSIZE;
+}
+
 static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 				  u32 ext_filter_mask)
 {
@@ -5829,18 +5850,10 @@ static int inet6_fill_ifla6_attrs(struct sk_buff *skb, struct inet6_dev *idev,
 
 	/* XXX - MC not implemented */
 
-	if (ext_filter_mask & RTEXT_FILTER_SKIP_STATS)
-		return 0;
-
-	nla = nla_reserve(skb, IFLA_INET6_STATS, IPSTATS_MIB_MAX * sizeof(u64));
-	if (!nla)
-		goto nla_put_failure;
-	snmp6_fill_stats(nla_data(nla), idev, IFLA_INET6_STATS, nla_len(nla));
-
-	nla = nla_reserve(skb, IFLA_INET6_ICMP6STATS, ICMP6_MIB_MAX * sizeof(u64));
-	if (!nla)
-		goto nla_put_failure;
-	snmp6_fill_stats(nla_data(nla), idev, IFLA_INET6_ICMP6STATS, nla_len(nla));
+	if (!(ext_filter_mask & RTEXT_FILTER_SKIP_STATS)) {
+		if (inet6_fill_ifla6_stats_attrs(skb, idev) < 0)
+			goto nla_put_failure;
+	}
 
 	nla = nla_reserve(skb, IFLA_INET6_TOKEN, sizeof(struct in6_addr));
 	if (!nla)
-- 
2.39.5



