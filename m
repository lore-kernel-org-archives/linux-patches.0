Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2203382CB;
	Sat, 12 Sep 2026 19:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242108; cv=none; b=GEtzpE+qiRdXXPzhrhsxVr/Fx9p09b7n20CkbX3Cg05lhkFjlEB4+zFdv/xVC5zCeOQL+zX1b5dJfcEdZAexFxp22W6/2BuQMla5iEtqz9Lfp1hT4qAy490427XK9Wh5sWyI0n2x+Pl6+zfA/hFU2NnGNszJNMPfRM25vG31+pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242108; c=relaxed/simple;
	bh=f67tlfjP1781AGMcsjq7z+KCTxCuEVLDYiwm45fl50o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZEM/1v9FhQKhBCMgw+TjW9fPrWUJgEaKf4MLFj7hkFpDv6PrirFFiYiiOuwUzs5H0td3FqdFOCSP6Pnb3RdgD4piIdMvW3bSsApBk6qD8D6U7vQnCfAe7QwSWoi8ZK/35AG8Ty70IWbGefXl+v696zff3EeBd1ftK4ICeaKmPiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkGVXDv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkGVXDv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795851F000FF;
	Sat, 12 Sep 2026 19:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242107;
	bh=G5d+JT2c5I3TourIAsLeJQDEfKwpXDT5aAzH5QzQGyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkGVXDv4guxHDCy5YJUyJNFGg0zr0AagRpNI8Q6fnf87OV2XylObj2dZx4rXJ1fzr
	 lahQ/C1sfEI1vjK7yWCJR6cBa36zflXFTINmPwEGyHP3Vg7Z7zFCtMxEpRPFjVY0wk
	 /0V8cJrag5mFUac2FU60aoSRfLQW1nm5BHVpYXZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.10 245/798] batman-adv: dat: avoid unaligned fault in IP extraction
Date: Sat, 12 Sep 2026 08:57:53 +0200
Message-ID: <20260912065522.771490866@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 0121afa52cdb88cfb4d5d7bd126a23a9100121d8 upstream.

Independent of the alignment of the ARP packet in the SKB, either the
batadv_arp_ip_src or the batadv_arp_ip_dst will have an unaligned access
(on HW without native unaligned read support).

Use get_unaligned() to handle this properly on all architectures.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 5c3a0e553593 ("batman-adv: Distributed ARP Table - add ARP parsing functions")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -251,7 +251,10 @@ static u8 *batadv_arp_hw_src(struct sk_b
  */
 static __be32 batadv_arp_ip_src(struct sk_buff *skb, int hdr_size)
 {
-	return *(__force __be32 *)(batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN);
+	u8 *src = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN;
+	__be32 *ip = (__force __be32 *)src;
+
+	return get_unaligned(ip);
 }
 
 /**
@@ -276,8 +279,9 @@ static u8 *batadv_arp_hw_dst(struct sk_b
 static __be32 batadv_arp_ip_dst(struct sk_buff *skb, int hdr_size)
 {
 	u8 *dst = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4;
+	__be32 *ip = (__force __be32 *)dst;
 
-	return *(__force __be32 *)dst;
+	return get_unaligned(ip);
 }
 
 /**


