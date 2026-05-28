Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD81257854;
	Thu, 28 May 2026 20:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999481; cv=none; b=JMTqQA2Vgiyhyc2HHLMwgNstlhP0E4mGKNqeVaS8zZxADCvVNwJmpUDno30gNcnKANiPrQzrVZ1VG2EPvZ3EPVHFybSsNlmc1MOUZuskFGMrQe1HyFkHIO1jkisxyvx3FgrPnIgtfgRK4xELjgyP/qBITIVb+GMlveF5MRWnv7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999481; c=relaxed/simple;
	bh=JerZbnRYFg5UmT/o9MXZw0DUwZAHpi8l3XTrpk3AQls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URPWMNySDQjZJwcqOZzuj/371La+KEVX1SK6tOZCfffqMu9RcV2n5rzsFJ3mWVjSt0TFy3K/HVIZyn6iQJCQMBHm7ZJ5O0klIchOu0cQmXAzpXcOakBKERQ8Cmh5PYMjmtFWTZTNpbbZ1MRKExGr2VTn2H6hIQGoH6dCv+nXpwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nq67Or+A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nq67Or+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED041F000E9;
	Thu, 28 May 2026 20:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999480;
	bh=D4X3FaFMq8R0bHFzYTZ5tY9fglUwy8Fc9FXhtIi5Jbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nq67Or+A+Y8gsO+OpfaMt7GhII8n4/KQqbzQzR3vTP9bYHKGMRJ22mKaucfYFIjwZ
	 O18SEhcGHznwRnbXc1R7PoOuMGI6qfarP3PCLDv/D/U12eIaiIUnMD60uCRBry1Fj9
	 /sAfRPYSBTyvnVDNJ4StxKIQfgQJIKRtMi/Px8yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 083/377] ipv6: ioam: add NULL check for idev in ipv6_hop_ioam()
Date: Thu, 28 May 2026 21:45:21 +0200
Message-ID: <20260528194640.779926911@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Iurman <justin.iurman@gmail.com>

commit d4ea0dfd75011b78cebf3808f98ac4c4f51a6fb9 upstream.

Reported by Sashiko:

The function ipv6_hop_ioam() accesses
__in6_dev_get(skb->dev)->cnf.ioam6_enabled without validating the returned
idev pointer. Because addrconf_ifdown() can concurrently clear dev->ip6_ptr
via RCU, __in6_dev_get() can return NULL during interface teardown, which
could cause a NULL pointer dereference when processing an IOAM Hop-by-Hop
option.

Let's add a check and use SKB_DROP_REASON_IPV6DISABLED accordingly.

Fixes: 9ee11f0fff20 ("ipv6: ioam: Data plane support for Pre-allocated Trace")
Cc: stable@vger.kernel.org
Signed-off-by: Justin Iurman <justin.iurman@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260517183059.29140-1-justin.iurman@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -910,16 +910,27 @@ static bool ipv6_hop_ra(struct sk_buff *
 
 static bool ipv6_hop_ioam(struct sk_buff *skb, int optoff)
 {
+	enum skb_drop_reason drop_reason;
 	struct ioam6_trace_hdr *trace;
 	struct ioam6_namespace *ns;
+	struct inet6_dev *idev;
 	struct ioam6_hdr *hdr;
 
+	drop_reason = SKB_DROP_REASON_IP_INHDR;
+
 	/* Bad alignment (must be 4n-aligned) */
 	if (optoff & 3)
 		goto drop;
 
+	/* Does the device still have IPv6 configuration? */
+	idev = __in6_dev_get(skb->dev);
+	if (!idev) {
+		drop_reason = SKB_DROP_REASON_IPV6DISABLED;
+		goto drop;
+	}
+
 	/* Ignore if IOAM is not enabled on ingress */
-	if (!READ_ONCE(__in6_dev_get(skb->dev)->cnf.ioam6_enabled))
+	if (!READ_ONCE(idev->cnf.ioam6_enabled))
 		goto ignore;
 
 	/* Truncated Option header */
@@ -972,7 +983,7 @@ ignore:
 	return true;
 
 drop:
-	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
+	kfree_skb_reason(skb, drop_reason);
 	return false;
 }
 


