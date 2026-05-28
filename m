Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75DF3346BE;
	Thu, 28 May 2026 20:35:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000552; cv=none; b=LN/cJ5P05THoqLM4rlLdbHbyCDxWusGvRi+FncNILeaCK50kbLRQ0WoyfETmgfCbOLkLJLes4MMF4w9N7KpL96bsO1gEbaruzmufImQnUAL/38J3yGX3SivtIWvvl8kfOHrnlc+Zmi7NWwveAjHKFqnmC383URhHRrIMx70YAHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000552; c=relaxed/simple;
	bh=lRG3ngZG/Ktra2ezqWHZ1mhR/z15yHRLhr5cgthADXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1CjC6EayolgqQGSJ1RxX3a3vNaY0A2UjU66y/jrv2cbcxsFKU+Arip5x9PdY1pvZ+iAhcQ0xJ7BsVcsNDZp+Kats6o1+EALMeXqHSv6NqL2EECTjqzeEn+cuI25uyBoU6EmwZ5MoFUZf6N0lJ0muSp80yQx+s7Nz/GpRRGWssg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NvPB0gfn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NvPB0gfn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411671F00A3A;
	Thu, 28 May 2026 20:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000551;
	bh=oojyrmjSb9hr31HOW+VH/vh8J1rbJti+S06ftYJMS3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NvPB0gfnXkOAn5FKMjyFmqMeczfUECfArXoX4eP7dPoplUhnOT+8cUAXcFJ6bF47W
	 E941i3l/k5gf3ZVXrc5Sswxw8SQwyC532GE8qimnGnvj6vPn/4RznTW5SLsitoZdfg
	 kEhJZTcYeiZVDL6qpi6xr+yBabsKfrK/eqSoUOAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Iurman <justin.iurman@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 084/272] ipv6: ioam: add NULL check for idev in ipv6_hop_ioam()
Date: Thu, 28 May 2026 21:47:38 +0200
Message-ID: <20260528194631.731510147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -912,16 +912,27 @@ static bool ipv6_hop_ra(struct sk_buff *
 
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
@@ -974,7 +985,7 @@ ignore:
 	return true;
 
 drop:
-	kfree_skb_reason(skb, SKB_DROP_REASON_IP_INHDR);
+	kfree_skb_reason(skb, drop_reason);
 	return false;
 }
 


