Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34FAB47AF75;
	Thu, 20 Aug 2026 16:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243887; cv=none; b=qv3xBav+pxCGSYGB5hOhZmI7vDcY75hksoR6/btEmLpkj0Oz8Akhj0Yhjl+nP4g+i2x/59d2iFPPs5Gb7hVR66h7yfifnhJkMNqgANn7Anqn7fAsLohPKcIRRhI1GBUfFtUmUs5POGTtvRivAdKJiTvuh781maMofIso9J/U9jM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243887; c=relaxed/simple;
	bh=08G7Xb9ZXRpJltu3LqauPuzUvyTedWh+1qYFv3lyZfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BU9IHObP3agSn/94uD+ouSwPWipe2QV2jtcAm8ckP9+V4gW+U1jvhhp52jwIPKm8iHsnXfBxP92+9QymLL+kqORy9+K7VuU2fkK2Difg3VBzpYpCr7KUgzeKFQqn6Fzdb3jELuiXA4OkqwyWWBre7r5ZRtpXpjOK529QcxjWKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5BMc1n6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5BMc1n6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E9191F000E9;
	Thu, 20 Aug 2026 16:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243886;
	bh=AwHv3yOn5iGkT5gx7HODOP4W+WCkKLlAHyyAJgTk5Cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5BMc1n6E2QQWBDte3j9rABBRHDowm3f87jv1OgKQZHhnVImsF2XAUjkF3aLtfLcI
	 g/fqNmaVLllU+kXySrOBF4nxQGXhSpOTT/f3i/KTz7gAi0zqSdlcvIti/EUaVEcsBV
	 bOpy6jaBWKUnFe5129+o/HFsBxfMtEjLsxj5iba0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/272] net: sched: use skb_ip_totlen and iph_totlen
Date: Thu, 20 Aug 2026 16:57:15 +0200
Message-ID: <20260820145239.152607241@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 043e397e48c58b4442ea5124dc1bdc95367a0a33 ]

There are 1 action and 1 qdisc that may process IPv4 TCP GSO packets
and access iph->tot_len, replace them with skb_ip_totlen() and
iph_totlen() accordingly.

Note that we don't need to replace the one in tcf_csum_ipv4(), as it
will return for TCP GSO packets in tcf_csum_ipv4_tcp().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8a7ed561671a ("net/sched: act_ct: fix sk_buff leak when the header checks reject a packet")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_ct.c   |    2 +-
 net/sched/sch_cake.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -629,7 +629,7 @@ static int tcf_ct_skb_network_trim(struc
 
 	switch (family) {
 	case NFPROTO_IPV4:
-		len = ntohs(ip_hdr(skb)->tot_len);
+		len = skb_ip_totlen(skb);
 		break;
 	case NFPROTO_IPV6:
 		len = sizeof(struct ipv6hdr)
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -1269,7 +1269,7 @@ static struct sk_buff *cake_ack_filter(s
 			    iph_check->daddr != iph->daddr)
 				continue;
 
-			seglen = ntohs(iph_check->tot_len) -
+			seglen = iph_totlen(skb, iph_check) -
 				       (4 * iph_check->ihl);
 		} else if (iph_check->version == 6) {
 			ipv6h = (struct ipv6hdr *)iph;


