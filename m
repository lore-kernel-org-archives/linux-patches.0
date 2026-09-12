Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3B3D33F59A;
	Sat, 12 Sep 2026 11:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213407; cv=none; b=rnDxdFjN6ldflFjNKaFPO4666fadaEl0Kz6gVZi4KaQ5YQ3z1t7etcldxsblr9BHfUjZSiiytRRfrTGRfbtvFJbYG05ITO7gJkFxTOacAYRfvDP9yrvrKp+7oBz1+VhnLCiSSl68A82EZDpfwKRuzcGbPYRg+MVepxm5+spsfSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213407; c=relaxed/simple;
	bh=TlTnKbRy8ZV8WplRlNiyqI/WUMM3ato4vwF41XsGVPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3Rydqny/K77RubJek0er3a0PtsZkKtsQvZFG+9WDnCzMR+7pBYxgeG5T7kq7ckFevZMD8wodyNl38x4G0+VLZDCaE44DlilC70kSUF7HUo3zhAyzjz8MBB32o428A/4aKtoHRvSB+n9UPUgUVooe6EnLtsHYqOSGTAK4/9HQjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3HxVxxZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3HxVxxZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346E91F000FF;
	Sat, 12 Sep 2026 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213405;
	bh=67402YXsYm04DVobp5xyUMVXDPH+v8cf/BG9AZXgaFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3HxVxxZye1sszDroU4TNYI6meXf9dqA2/Acg/66k6HGxJ39GxDqgK25B9Rinxyff
	 dLrf+pLQJOBLXj9v94GSidRSYYLojkzYMF2WaTsyCY2fQCZixoCAKfv0fwEwCH+2Fc
	 wCICa5VBLMrB1aEYEgoB9PHUKM7MPWY/h/cumdc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.12 0115/1376] batman-adv: dat: avoid unaligned fault in IP extraction
Date: Sat, 12 Sep 2026 08:42:21 +0200
Message-ID: <20260912065610.116761714@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
@@ -250,7 +250,10 @@ static u8 *batadv_arp_hw_src(struct sk_b
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
@@ -275,8 +278,9 @@ static u8 *batadv_arp_hw_dst(struct sk_b
 static __be32 batadv_arp_ip_dst(struct sk_buff *skb, int hdr_size)
 {
 	u8 *dst = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4;
+	__be32 *ip = (__force __be32 *)dst;
 
-	return *(__force __be32 *)dst;
+	return get_unaligned(ip);
 }
 
 /**


