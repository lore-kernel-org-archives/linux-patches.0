Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BF03043C8;
	Tue, 16 Jun 2026 17:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632595; cv=none; b=WO/oN2MiAVDHkCeiCU4q9IjBW0ipf6t2icz+ItRPRhAHYESOuCRDySsmqV9P4agnoOMZ59SxVRIWpIfP9Ru7ZADCrCSjMHxK0Ucv6i2XyTjXqXnUJXB1Wee9czSQTEXwBlWEq0pZ+iEe56rS3lVloRAm5DoGqRxAy75q3k4TTDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632595; c=relaxed/simple;
	bh=UFyl6jESsqJf9UfDXvp2r6a+EiujMpZmDrYpJBremYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9uh1MyLwzZImGRju2tSbBh+BWONYC4LphIfCZL5mXF/N26a9d9171Dl9GnipzxXqXeP8ln6JJ20jI2jq+vdf/G1sX4Qou5jA8gh48+pTIHjq6N6/uSB8cQgphR2NquvE6srP0CTa/J0UwomTiv/zy3bn3nsVGnOFkgrU0N4/F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iKcNsl87; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iKcNsl87"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88F51F000E9;
	Tue, 16 Jun 2026 17:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632593;
	bh=irC/sh9LcE70WnitiL0ng+lm1oXonRL6lpdUWnPgU1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iKcNsl87PD9xYspdTWwRFMq6BrUfktHtWi0JdUJkbOpKDT9mozhov1B9VYR+tgwYW
	 5GwiqDJH9Xq6vXyhVTFSad+udrnQSDUWCmB+pJ+UpJ0nN+cFXjI6pH2rcT8DNa5zXd
	 /aE3QqsfsejK9AFX0V2DrhwKWJeaEh1FWNJoEIF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 439/522] ipv6: ioam: add NULL check for idev in ipv6_hop_ioam()
Date: Tue, 16 Jun 2026 20:29:46 +0530
Message-ID: <20260616145146.487747866@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

From: Justin Iurman <justin.iurman@gmail.com>

[ Upstream commit d4ea0dfd75011b78cebf3808f98ac4c4f51a6fb9 ]

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
[ dropped READ_ONCE() wrapper from idev->cnf.ioam6_enabled ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -952,16 +952,27 @@ static bool ipv6_hop_ra(struct sk_buff *
 
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
-	if (!__in6_dev_get(skb->dev)->cnf.ioam6_enabled)
+	if (!idev->cnf.ioam6_enabled)
 		goto ignore;
 
 	/* Truncated Option header */
@@ -1011,7 +1022,7 @@ ignore:
 	return true;
 
 drop:
-	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
+	kfree_skb_reason(skb, drop_reason);
 	return false;
 }
 


