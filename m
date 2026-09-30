Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E199157A5A;
	Wed, 30 Sep 2026 15:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783842; cv=none; b=Gab8aEqOsZYkvsoXvA1im9uvng79y5X7yRoYTc+V5IG0IJvspKE2syb0I8UksYptRrAw8Eiy38sJY8jiSNRlwkHDD26lv5GBritFlmPwRRKhMr/gtP8QpyqUfX8hz3s9zxL4HpTCJilnuX/HGSileVF7zVRuKd7SusjCZTZw3FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783842; c=relaxed/simple;
	bh=uSf00G4APLbyhtLFhh7U6pLwUnypiyVrEnic90WDgWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtLPNnW9+sG2O/ivLlpubw/aZYUyrORV+hRKIrZtkvAkvhNfVmvvm/xoJMiw0bKfYMVa2kfV/Ws6vUTt8BskTW7CofCvp4IJpHObrKPqn2mbrNY1knwKpJowTWdKXcF8VLh6drUGNLBZk8QvxzL6ek0Rlbd/aF/lUyY11ggd/ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIoYrCXM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIoYrCXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C68521F00898;
	Wed, 30 Sep 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783838;
	bh=2pY+lDuPmhghb34j90Gvwk2/XaobvpKQOOiu6rpC9ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIoYrCXMD8dxQrU7TmRJln4INBAiiku5fAzKawGyfwWvflt+CZg9ZQ12m8bsUdF4D
	 S9Egn2weXbe53bSpOnPzpkzRGWmphpX/8//oSyvN+UV5q88KqLPL/oh2YZu1TADR+V
	 7xwRnsqNtnFnuHawd9ivioMbMMHVIEd7Uge8HwEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanghyun Park <sanghyun.park.cnu@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 538/595] vxlan: use one headroom snapshot for neighbour replies
Date: Wed, 30 Sep 2026 17:27:11 +0200
Message-ID: <20260930152359.279404394@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a2955729998cd..ac45cf9eea836 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2085,13 +2085,15 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
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
@@ -2099,7 +2101,7 @@ static struct sk_buff *vxlan_na_create(struct sk_buff *request,
 
 	reply->protocol = htons(ETH_P_IPV6);
 	reply->dev = dev;
-	skb_reserve(reply, LL_RESERVED_SPACE(request->dev));
+	skb_reserve(reply, headroom);
 	skb_push(reply, sizeof(struct ethhdr));
 	skb_reset_mac_header(reply);
 
-- 
2.53.0



