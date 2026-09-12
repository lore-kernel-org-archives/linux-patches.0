Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D920274B46;
	Sat, 12 Sep 2026 18:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237515; cv=none; b=AeVxyhC3ni7fZQOz8yt1CE1VWr6+dJ0igFWK9PbBSXsMGIupdxCjla9Qx2bLioAPw4dcSEPh9n7Dn+GoEaXXSU7b2SvVm++31rUYR2a1hb/kKy/nmfBOzyHSWTQSFM2gHDmI1NoNsy5bnzQPMZw52QfbnaZXb3/6qoAk6VN9OBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237515; c=relaxed/simple;
	bh=M8rpg901iSsXGH3BhDdqEb7BqEF0uVf65kjrnF2s6dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLjdC7v20RwvtQ1aE27mrIgQBeRKDX0iBAg/Q0lt2bZ+0V7u18x3+1NA3/GPp0FNFACKkXMaT0ZWuabQfNeVkdZSPLpjfwAzADqsgRSsmFTNbldK8/ae63vSsO5IS83HYfPHjFmXq5XejrL3fvbX2/waUi4JFXBksRab2k7KgUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8sjpzgP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8sjpzgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68B0E1F000FF;
	Sat, 12 Sep 2026 18:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237514;
	bh=TlRY387jEzFCbGnDNkUSqfhP8WeZJaqk8VvWGj1C4zM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8sjpzgPSDf7o46FHzx26xkY8wMJxPnIC0r4ZbcPegSZ1O4pKrCU5Z+MBhAoJTgTa
	 /DrSpfia46IEw0Ki6uzu8A3TzXIzP0k8z5PnYO55kW+lAAUeaTAsgHB09coDLZab4Y
	 r26LSBawd7lwtzpXFhwGhuNfYlM7m47CCEzwf6XM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 5.15 275/935] batman-adv: dat: avoid unaligned fault in IP extraction
Date: Sat, 12 Sep 2026 08:55:05 +0200
Message-ID: <20260912065533.131770110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


