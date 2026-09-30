Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A364DEC26;
	Wed, 30 Sep 2026 18:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792472; cv=none; b=Y16o4E40wg7etEQjHyBntNJ5XgKbFHMA0aY8nk/6/NKXtRi+oCUAmQHm6cjBLRlkPHK6WQoUsqj5L6PCWltBbeMY3VNq9gEOZmxi8Heg76guCWSxbzBIMmwMWmO5RrxXPU6TWtDmz0pSiAu3CwYRRslBOWaGXv894A/siRaxVuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792472; c=relaxed/simple;
	bh=Ydvj9ZCDNm6zLu3qbVMCaLeq6xmNAk48hWnASlzBRE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXWcyZujvhUDS1pHMoDC77prNwrBEZNvUYAcyiEO8b6eDtV2pBNZClYP7OaOGsVG/7CpmCRZLt2M5/A7Nvos0RcsTZzek6mRorPqf57JWFIxWjJxIONf0Woyp6v2YgE4aatbXQeto8FRdYch6iOwhYM0aaxEc0EXe9AtbpEF/Yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jJxHElB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jJxHElB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DDE1F000FF;
	Wed, 30 Sep 2026 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792471;
	bh=13vrH4EoWcW8iaptOxwhLNFcMcwXIlpfGRt4Jfm/xKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jJxHElBkC3yje+jlHqqSKPZoGZAkW1+PB8XrxqW4Acx/mGHsMZWRooFUCjl3LS3c
	 zGXbmXqqoPcdgf25DNzKPtSA6xJnui+dJpxlsd6HvnVZUCrmnG0TVQh/iQfo6uKF6L
	 kbnJl6uZ3SwaR2iVTbbeQW5RHuq1UpZXWS431YKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 668/752] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 30 Sep 2026 17:28:58 +0200
Message-ID: <20260930152412.708950692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index c1ee03aebed51..0491ff123b38e 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2086,13 +2086,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
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
@@ -2100,7 +2102,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



