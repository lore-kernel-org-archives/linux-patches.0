Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3F436E47E;
	Tue, 16 Jun 2026 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629984; cv=none; b=R/drklC8bgKHJIz+0n1xY+EsErF3FxCz0jOfMp2yB8AG76Hnf9HYHov8en8e+X4F6GVhgCuP87zVrIHiQt37Uu1jd03klKNGl7L6znu1QwL7vTmZ3JjKHe8n6wzm8l8T3aevymxvordDJGuW/0hl7xoGlDGuC1xK+M+/PIxfLy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629984; c=relaxed/simple;
	bh=j7y1EkcRqxfTF/Cd4SskjXTgboYqobVg9nga2Did+Wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MpUMxUH0UeHDqjPeL4rb9m7pXYAyePNBpWY3TDzUMkHb0QECZodZ7iMNlppTYaVvyK8UEegT43U0g4NdKpa2IMSsTnec01SgMeoTEY9lOewUc+VxhM8a04jDrJsmJaWAq/bDgSJ/MP+gwYgCxjQVPx8PdXqGUJ3euH0+g1Tuj5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8lid7ui; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8lid7ui"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC71D1F000E9;
	Tue, 16 Jun 2026 17:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629983;
	bh=YtPxw4geeFgODUwe3HnyXocR1ODzatz+waBOZ88qD9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F8lid7uicUMfydP4g+FZO7yJHlIBdqtgV3PWgQkcQNgBLCDIVUJ67pU6veRkoVaZS
	 sDvxG80syG6G3Nyj7kt4IfZHZ6T3hBbxkC1MR1MxkU/kQGKWL+DiiMUsc78wDjvRc3
	 YN5VwjPNQRGMiAPEs7nD6tcPn/HdTbpXD1LOzZ/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 390/452] ipv6: ioam: add NULL check for idev in ipv6_hop_ioam()
Date: Tue, 16 Jun 2026 20:30:17 +0530
Message-ID: <20260616145137.408384987@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/exthdrs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -923,16 +923,27 @@ static bool ipv6_hop_ra(struct sk_buff *
 
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
@@ -982,7 +993,7 @@ ignore:
 	return true;
 
 drop:
-	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
+	kfree_skb_reason(skb, drop_reason);
 	return false;
 }
 


