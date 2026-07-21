Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86160403EA1;
	Tue, 21 Jul 2026 22:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672164; cv=none; b=IzL5OvrAE+rN8RnTaBuIDxmG4I7craEV8a2Ly1v/SdPtAfIw80ywUUN9G3In1n/njXv53UOwtTStPTqWUiMQu9G++hPzEbnUpR8qgK/Iw/rVNK7QNjT2k29KU7zAF/xrfy8QRdTNC4wUTG6ZeLjIPqcNTa8KiW8zRFCpp4MCaeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672164; c=relaxed/simple;
	bh=nzV33Tps/u7f3ksoguRWAis/VdRmfw/Wx1K6LJmaCfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lCV7wwce9l0tSe/TOYHp+6YZWRexwxG/gRZb71kTsQBEgU3+KGTuTX96Fce8IQyNRl/YFmjgQGjMh7SEgj0c2NvVxBfv7JDzYLEESU1Fdn8W8zY7581wuTAs/REHfaEeZmugY2nhnra0LS1xuVvMwDUri6jW5CO8mlHpCIzO4gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XNtVtGB3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XNtVtGB3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB56F1F000E9;
	Tue, 21 Jul 2026 22:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672163;
	bh=rIpioAq9B6loJjsGrkxTLln3NHuu7WTrNspTwZ4MgBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XNtVtGB3O5Xfc8NysHyaUtRJqQhMD6nctIHjPmum65J0hEseSuV+AsN6CmiHxfNOc
	 uwg1B7JCJNxCWqQV14Vj7ozOCi1hwmF5ECZ5c/yyedw3oDD/F/tq5EHqMw3GeuM8QU
	 R5uBkQDR2epz1QV1Tqt8R8AbDxjWlSfA13bGzdf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixing Chen <running910@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 521/843] netfilter: ip6tables: mark malformed IPv6 extension headers for hotdrop
Date: Tue, 21 Jul 2026 17:22:36 +0200
Message-ID: <20260721152417.751104745@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhixing Chen <running910@gmail.com>

[ Upstream commit 43ccc20b5a733226417832cf16ef45322e594990 ]

The ah, hbh and rt matches check that the fixed extension header is
present, then use the header length field to derive the advertised
extension header length for matching.

For the ah match, add the missing advertised-length check. For hbh
and rt, update the existing advertised-length checks. In all three
cases, set hotdrop to true before returning false when the advertised
extension header length exceeds the available skb data.

Returning false treats the packet as a rule mismatch. Set hotdrop to
true and drop malformed packets so they cannot bypass rules intended
to drop packets with these IPv6 extension headers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Zhixing Chen <running910@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/netfilter/ip6t_ah.c  | 5 +++++
 net/ipv6/netfilter/ip6t_hbh.c | 1 +
 net/ipv6/netfilter/ip6t_rt.c  | 3 ++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index 70da2f2ce064ca..1258783ed87629 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -56,6 +56,11 @@ static bool ah_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	hdrlen = ipv6_authlen(ah);
+	if (skb->len - ptr < hdrlen) {
+		/* Packet smaller than its length field */
+		par->hotdrop = true;
+		return false;
+	}
 
 	pr_debug("IPv6 AH LEN %u %u ", hdrlen, ah->hdrlen);
 	pr_debug("RES %04X ", ah->reserved);
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index 450dd53846a2f7..6d1a5d2026a678 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -75,6 +75,7 @@ hbh_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 	hdrlen = ipv6_optlen(oh);
 	if (skb->len - ptr < hdrlen) {
 		/* Packet smaller than it's length field */
+		par->hotdrop = true;
 		return false;
 	}
 
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 5561bd9cea8185..278b52752f3645 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -56,7 +56,8 @@ static bool rt_mt6(const struct sk_buff *skb, struct xt_action_param *par)
 
 	hdrlen = ipv6_optlen(rh);
 	if (skb->len - ptr < hdrlen) {
-		/* Pcket smaller than its length field */
+		/* Packet smaller than its length field */
+		par->hotdrop = true;
 		return false;
 	}
 
-- 
2.53.0



