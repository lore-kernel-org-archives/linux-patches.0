Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9489F20126A;
	Mon, 18 Aug 2025 13:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522206; cv=none; b=tSsMWtdu59TM8feOXhJ0VuOYE39jD8BX0XDEdXUvtJH6R7IXBWaxhdH4gp23XrZKI6p/ScbKZeVUS/yFU4NMYCc7kClzMan3jhWdP9n9M4vG77cl9hEz6vKxX+7imQDehiQBXUpfS1NaLn4CA8XNlkAVK13o8LCCYScOGP/WYlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522206; c=relaxed/simple;
	bh=+74382a2JOmPgHZUjZNCDkbO+2a6vPKqUEBu7euPN6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TlqNVF6N2wrsJbGJvcow8fghitFhhlxIMvIA51okFCgazZSkBhmy7q6ATSpQh5YQ3YfC//Pw3AsjpEfonUSRjBfNWoKtaMVwwf0BMvYmxj1V6iRLXudogPZReofEot1AMZX8SduMVzeb210m9pSp8f7CmzPrs+pg3EnEFqHG7Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wD95vIVb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wD95vIVb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1410CC4CEEB;
	Mon, 18 Aug 2025 13:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522206;
	bh=+74382a2JOmPgHZUjZNCDkbO+2a6vPKqUEBu7euPN6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wD95vIVb6WwDuUKIr0etA1XUIsiiNs4fhjAk0PxKZPGdP7iOuSFzGXcRjGFDErE+t
	 rtaOUeBZOvote3VtrpWtJgimjDab+Wf+BGF9SFGm+jc0ELyuxMT3w1/WEVf1DIyfVX
	 Bx5vN+Kjz7KseVUWuUVv5PcLPq231Jx4UbxIMsCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aakash Kumar S <saakashkumar@marvell.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 220/444] xfrm: Duplicate SPI Handling
Date: Mon, 18 Aug 2025 14:44:06 +0200
Message-ID: <20250818124457.097047251@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Aakash Kumar S <saakashkumar@marvell.com>

[ Upstream commit 94f39804d891cffe4ce17737d295f3b195bc7299 ]

The issue originates when Strongswan initiates an XFRM_MSG_ALLOCSPI
Netlink message, which triggers the kernel function xfrm_alloc_spi().
This function is expected to ensure uniqueness of the Security Parameter
Index (SPI) for inbound Security Associations (SAs). However, it can
return success even when the requested SPI is already in use, leading
to duplicate SPIs assigned to multiple inbound SAs, differentiated
only by their destination addresses.

This behavior causes inconsistencies during SPI lookups for inbound packets.
Since the lookup may return an arbitrary SA among those with the same SPI,
packet processing can fail, resulting in packet drops.

According to RFC 4301 section 4.4.2 , for inbound processing a unicast SA
is uniquely identified by the SPI and optionally protocol.

Reproducing the Issue Reliably:
To consistently reproduce the problem, restrict the available SPI range in
charon.conf : spi_min = 0x10000000 spi_max = 0x10000002
This limits the system to only 2 usable SPI values.
Next, create more than 2 Child SA. each using unique pair of src/dst address.
As soon as the 3rd Child SA is initiated, it will be assigned a duplicate
SPI, since the SPI pool is already exhausted.
With a narrow SPI range, the issue is consistently reproducible.
With a broader/default range, it becomes rare and unpredictable.

Current implementation:
xfrm_spi_hash() lookup function computes hash using daddr, proto, and family.
So if two SAs have the same SPI but different destination addresses, then
they will:
a. Hash into different buckets
b. Be stored in different linked lists (byspi + h)
c. Not be seen in the same hlist_for_each_entry_rcu() iteration.
As a result, the lookup will result in NULL and kernel allows that Duplicate SPI

Proposed Change:
xfrm_state_lookup_spi_proto() does a truly global search - across all states,
regardless of hash bucket and matches SPI and proto.

Signed-off-by: Aakash Kumar S <saakashkumar@marvell.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 72 ++++++++++++++++++++++++++-----------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ad0fe8849471..6f99fd2d966c 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1637,6 +1637,26 @@ struct xfrm_state *xfrm_state_lookup_byspi(struct net *net, __be32 spi,
 }
 EXPORT_SYMBOL(xfrm_state_lookup_byspi);
 
+static struct xfrm_state *xfrm_state_lookup_spi_proto(struct net *net, __be32 spi, u8 proto)
+{
+	struct xfrm_state *x;
+	unsigned int i;
+
+	rcu_read_lock();
+	for (i = 0; i <= net->xfrm.state_hmask; i++) {
+		hlist_for_each_entry_rcu(x, &net->xfrm.state_byspi[i], byspi) {
+			if (x->id.spi == spi && x->id.proto == proto) {
+				if (!xfrm_state_hold_rcu(x))
+					continue;
+				rcu_read_unlock();
+				return x;
+			}
+		}
+	}
+	rcu_read_unlock();
+	return NULL;
+}
+
 static void __xfrm_state_insert(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -2465,10 +2485,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 	unsigned int h;
 	struct xfrm_state *x0;
 	int err = -ENOENT;
-	__be32 minspi = htonl(low);
-	__be32 maxspi = htonl(high);
+	u32 range = high - low + 1;
 	__be32 newspi = 0;
-	u32 mark = x->mark.v & x->mark.m;
 
 	spin_lock_bh(&x->lock);
 	if (x->km.state == XFRM_STATE_DEAD) {
@@ -2482,38 +2500,34 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 
 	err = -ENOENT;
 
-	if (minspi == maxspi) {
-		x0 = xfrm_state_lookup(net, mark, &x->id.daddr, minspi, x->id.proto, x->props.family);
-		if (x0) {
-			NL_SET_ERR_MSG(extack, "Requested SPI is already in use");
-			xfrm_state_put(x0);
+	for (h = 0; h < range; h++) {
+		u32 spi = (low == high) ? low : get_random_u32_inclusive(low, high);
+		newspi = htonl(spi);
+
+		spin_lock_bh(&net->xfrm.xfrm_state_lock);
+		x0 = xfrm_state_lookup_spi_proto(net, newspi, x->id.proto);
+		if (!x0) {
+			x->id.spi = newspi;
+			h = xfrm_spi_hash(net, &x->id.daddr, newspi, x->id.proto, x->props.family);
+			XFRM_STATE_INSERT(byspi, &x->byspi, net->xfrm.state_byspi + h, x->xso.type);
+			spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+			err = 0;
 			goto unlock;
 		}
-		newspi = minspi;
-	} else {
-		u32 spi = 0;
-		for (h = 0; h < high-low+1; h++) {
-			spi = get_random_u32_inclusive(low, high);
-			x0 = xfrm_state_lookup(net, mark, &x->id.daddr, htonl(spi), x->id.proto, x->props.family);
-			if (x0 == NULL) {
-				newspi = htonl(spi);
-				break;
-			}
-			xfrm_state_put(x0);
+		xfrm_state_put(x0);
+		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+
+		if (signal_pending(current)) {
+			err = -ERESTARTSYS;
+			goto unlock;
 		}
+
+		if (low == high)
+			break;
 	}
-	if (newspi) {
-		spin_lock_bh(&net->xfrm.xfrm_state_lock);
-		x->id.spi = newspi;
-		h = xfrm_spi_hash(net, &x->id.daddr, x->id.spi, x->id.proto, x->props.family);
-		XFRM_STATE_INSERT(byspi, &x->byspi, net->xfrm.state_byspi + h,
-				  x->xso.type);
-		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
-		err = 0;
-	} else {
+	if (err)
 		NL_SET_ERR_MSG(extack, "No SPI available in the requested range");
-	}
 
 unlock:
 	spin_unlock_bh(&x->lock);
-- 
2.39.5



