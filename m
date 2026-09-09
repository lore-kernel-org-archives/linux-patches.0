Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52940565112;
	Wed,  9 Sep 2026 14:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963625; cv=none; b=H7DDGVuDgQBZjlZU70Mi/eFCxSp9r549P5P6D89Mr/dtYLA1zaq91nNJD9FGcWSxbW2iIZFCnVldtzwEYzfw9VNBlQneQ4hLYHGbeFS+zSCvTnkxANEKB2t2ASp4Zjq94dDQKDxlroBf0/2vjPtnoJxDmfnPXe/Pvq8WBZ2pdow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963625; c=relaxed/simple;
	bh=8XC+B8MLjmRuKx7mvKvXQB8b9mZjVGAQWCN6wGI35PM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7amccXcwYaHDYSFpbudMcDZ2e1MOk8Y1cc//Z7Eq5epnGauFXINcqFdeAqIZ7S2AyUkSYtEazr11kK18QVdzYESVSAxf3SVr87tBq8h5QbStuu2TF03TsOxewjI62onLWUx0Rmrcvr6wrPBIEVH80qP7jIT99m70K8tBtJhOYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I/uLKmZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I/uLKmZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B071F00A3A;
	Wed,  9 Sep 2026 14:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963624;
	bh=oDqKW2YRs1IAvQftKnTVKH3AvzlqOxIvLDl4uMaUNRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I/uLKmZvmdwg5+UOt7zF9cSZ84on4F3uu27N/7oXJh3SmX6E3TeuCYP8KE6j6jjpE
	 Zje8/f6blbT7UI8/ffkR/CFat/EdvtPNiLfatevTu3lVTs9RpsGaEgaNzCfYsq47GK
	 MH9BAgQyTlcI0x34+XvXwf6wDCyiazXJ8TN/ptbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 143/583] batman-adv: dat: avoid unaligned fault in IP extraction
Date: Wed,  9 Sep 2026 15:37:08 +0200
Message-ID: <20260909134243.121127527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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
@@ -249,7 +249,10 @@ static u8 *batadv_arp_hw_src(struct sk_b
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
@@ -274,8 +277,9 @@ static u8 *batadv_arp_hw_dst(struct sk_b
 static __be32 batadv_arp_ip_dst(struct sk_buff *skb, int hdr_size)
 {
 	u8 *dst = batadv_arp_hw_src(skb, hdr_size) + ETH_ALEN * 2 + 4;
+	__be32 *ip = (__force __be32 *)dst;
 
-	return *(__force __be32 *)dst;
+	return get_unaligned(ip);
 }
 
 /**


