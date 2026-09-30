Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FC6451DE1D;
	Wed, 30 Sep 2026 18:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793354; cv=none; b=GUiDCgYMaJY0DhyuDIvlm8B71s9eqKTy3/3EoFuUCy+0IWmIq97ToBCdf6ZxZunaj4EETzZ+r6pU7LCgFv+AdOoy69trK59lFc+l6mL+Tzreg3Z6twUu5NrgY894bSjmFpmtvsCMkZ+qIO//NBTC/Z5rOwa4pW9NEHtr1EZ9NIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793354; c=relaxed/simple;
	bh=AjlPjFSLCmsAnMn++2knlc59NA7fEeXm9o9bEqg2o/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvv4bNYqWV4qu4dCE2Ya/cWoEdIBDo+DvFfZlzQmmfSIRcmmioGFYp1DIYeLTPFylvcgr3eiwyZYMl/pecgScySHyZV7gMhcmDV31JAI/taN3hC9K9DqBFnGIsuJ1fcT+J9GfdEPg92KhhabnPo9DpnbXCuiAAQ0PlE7YPoRIuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OM1BqK7s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OM1BqK7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3FD1F000FF;
	Wed, 30 Sep 2026 18:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793353;
	bh=loze2TGrczCqCbpDM20/64DhqqiqYqROYVcVviNDnz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OM1BqK7sasel0mqYJk/CXbhw2kxReQBlPCz+ajkpRGeVNbHue00UE2O8IbKVoTOdK
	 2rM6U8qGwOX+P3fzRYHBpqW0PCZtLS9pamlj8lQHcFbhsDx2xxRHWK33Vc23AB4dfV
	 d5iCrzXBAboZDkkiUmpSNoRd8+82UsY5SaQxf1g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/395] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 30 Sep 2026 17:27:12 +0200
Message-ID: <20260930152344.339849079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Sanghyun Park <sanghyun.park.cnu@gmail.com>

[ Upstream commit 481506a756dcd828ef42391cb08f38d8d96d38fc ]

vxlan_na_create() samples LL_RESERVED_SPACE() to size the reply skb and then
samples it again to reserve headroom. A concurrent vxlan_changelink() can
update needed_headroom between the two reads, creating a TOCTOU race. The
second value can exceed the allocation and make the Ethernet header write out
of bounds.

The race is reproducible on the unpatched kernel. It occurred when
vxlan_na_create() generated a neighbour reply while vxlan_changelink() changed
the link headroom. KASAN caught a four-byte write two bytes beyond a 704-byte
skbuff_small_head allocation.

Snapshot the headroom once and use that value for both allocation and
reservation.

Fixes: 4b29dba9c085 ("vxlan: fix nonfunctional neigh_reduce()")
Signed-off-by: Sanghyun Park <sanghyun.park.cnu@gmail.com>
Link: https://patch.msgid.link/20260918032842.502409-2-sanghyun.park.cnu@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 1e411a57d1fe7..02cc791699458 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1956,13 +1956,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 	struct ipv6hdr *pip6;
 	u8 *daddr;
 	int na_olen = 8; /* opt hdr + ETH_ALEN for target */
+	int headroom;
 	int ns_olen;
 	int i, len;
 
 	if (dev == NULL || !pskb_may_pull(request, request->len))
 		return NULL;
 
-	len = LL_RESERVED_SPACE(dev) + sizeof(struct ipv6hdr) +
+	headroom = LL_RESERVED_SPACE(dev);
+	len = headroom + sizeof(struct ipv6hdr) +
 		sizeof(*na) + na_olen + dev->needed_tailroom;
 	reply = alloc_skb(len, GFP_ATOMIC);
 	if (reply == NULL)
@@ -1970,7 +1972,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



