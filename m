Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FF33B0AC6;
	Tue, 21 Jul 2026 20:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666890; cv=none; b=erdL7dnshPD57953R55jGWxj9sby+vXXrqB/FW3v0kI5WntTmEvz3AFOPlcQdhiAqKlynS1TuCyR4kzXZrh5UUSdYqPs9oMQRmAvQIPUNkBU4HwTVuw4rcnADz0XrRwaK09PhWWTv6hu/uh0pTzJQrbRuLbM1ouK5u0bGyctOrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666890; c=relaxed/simple;
	bh=Ai1rssvTNWNNv8R4PYyxgBfcUNxlz3RBfkbif9pPOn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VIVQUOkMeK3poS/QD9MK65UnikKJnlhd5DuXYdpRcGvImdP8U38PL0cdPNAk0oHHSabeIpbooZgLKlpvr3d7HgR1wV97+bMFM7FPIj5+c8Zlces36PW5//Ajpw2agxwPV748MJ+xE33NvKRAGnrikwkayEcQKxC3SNRBwvU9O0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV7M1gtw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV7M1gtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2F81F000E9;
	Tue, 21 Jul 2026 20:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666884;
	bh=DQj0BERvV8yMhPYPsgQJ5pUqxN2MrUYmS1bmtIo6HEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nV7M1gtw7E9lJ/c/8TreiNwoLxMjROYhvupTnQI+hI43mLLSApRXkPoriDEY+8RCl
	 ZocrTHJAAYXQyWmmgep92BYtEW40L+bY1qVLbOWbSU7RPUbQrZhD2Hm0zx+KcTNy58
	 oPlhUFeYHuolfK58ypTmtc7t8I2sCw5tOBjN9Cyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhixing Chen <running910@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0852/1266] netfilter: ip6tables: mark malformed IPv6 extension headers for hotdrop
Date: Tue, 21 Jul 2026 17:21:29 +0200
Message-ID: <20260721152500.919202300@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



