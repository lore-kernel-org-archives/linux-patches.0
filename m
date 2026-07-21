Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F3D3D1CCA;
	Tue, 21 Jul 2026 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653447; cv=none; b=XxqS3BJ2A+fFKZJIooMt9EO914KYkaUEN0Eh9IFtQxePncDqgB7V9xUte7G1yooVvIVQUj1Q21YHs5P75D+BL8AJs/oCNPJLBV6hrxaC5GIx3+kL1xeGOZVdEi2tTjlOcbTKEuxtN2tGH/HeowmQLXJ0P06hOb0u6Kl+tH5rVdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653447; c=relaxed/simple;
	bh=znLpN5J8ewtOjsRpkH9WOkMLrZI5mNaFFnHnMIwKXZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0RBw9qLhWKF16j9LyX8zKsu4UWsT3Y4mpv4wryX9q2l0pOWU/alrSQGAIXEUlN9fuGTpTeadpxXamtRb5hTZVefRf+ebQtnONmpTNmhLv3LFDNpu6FLMTYd/efdPytGaqmBmBKXdSQ0Nf735e3vmmB4JIVu4Z+9Kvx52ko2qkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ygot9eTG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ygot9eTG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FAB1F000E9;
	Tue, 21 Jul 2026 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653446;
	bh=72vPzv6AEB2/NguI82yLQR72wGnYjDNdyQ7l8faCpxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ygot9eTG/YHciQylmrYlhRpw4hXtpGxyCmcB3+vmpuchEzvDYY89O58K1iavwgNfy
	 Kap7Da1km4HwegFyjtRukudQ5Kn33HoVIhtuqgPZOGRx8/vOM1bAlZb1mIQiyzL0+3
	 zYHPbJnN/F6tZQJR1JOszy6loe9eUvg1WDWga6MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1328/2077] eth: fbnic: dont cache shinfo across skb realloc
Date: Tue, 21 Jul 2026 17:16:41 +0200
Message-ID: <20260721152624.138693723@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 62b68b774f06bf52e329f254f0199bc43d350ccf ]

fbnic_tx_lso() calls skb_cow_head() which may reallocate the skb
including the shared info. We can't use the pointer calculated
before the call.

    BUG: KASAN: slab-use-after-free in fbnic_tx_lso.isra.0+0x668/0x8e0
    Read of size 4 at addr ff110000262edd98 by task swapper/5/0
    Call Trace:
     fbnic_tx_lso.isra.0+0x668/0x8e0
     fbnic_xmit_frame+0x622/0xba0
     dev_hard_start_xmit+0xf4/0x620

    Allocated by task 8653:
     __alloc_skb+0x11e/0x5f0
     alloc_skb_with_frags+0xcc/0x6c0
     sock_alloc_send_pskb+0x327/0x3f0
     __ip_append_data+0x188b/0x47a0
     ip_make_skb+0x24a/0x300
     udp_sendmsg+0x14d2/0x21e0

    Freed by task 0:
     kfree+0x123/0x5a0
     pskb_expand_head+0x36c/0xfa0
     fbnic_tx_lso.isra.0+0x500/0x8e0
     fbnic_xmit_frame+0x622/0xba0
     dev_hard_start_xmit+0xf4/0x620
     sch_direct_xmit+0x25b/0x1100

    The buggy address belongs to the object at ff110000262edc40
     which belongs to the cache skbuff_small_head of size 640
    The buggy address is located 344 bytes inside of
     freed 640-byte region [ff110000262edc40, ff110000262ede

Link: https://netdev.bots.linux.dev/logs/vmksft/fbnic-qemu-dbg/results/705762/15-uso-py/stderr
Fixes: b0b0f52042ac ("eth: fbnic: support TCP segmentation offload")
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Link: https://patch.msgid.link/20260625160508.3327986-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index 9cd85a0d0c3a7f..401f8b8ae1cae4 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -194,16 +194,18 @@ static bool fbnic_tx_tstamp(struct sk_buff *skb)
 
 static bool
 fbnic_tx_lso(struct fbnic_ring *ring, struct sk_buff *skb,
-	     struct skb_shared_info *shinfo, __le64 *meta,
-	     unsigned int *l2len, unsigned int *i3len)
+	     __le64 *meta, unsigned int *l2len, unsigned int *i3len)
 {
 	unsigned int l3_type, l4_type, l4len, hdrlen;
+	struct skb_shared_info *shinfo;
 	unsigned char *l4hdr;
 	__be16 payload_len;
 
 	if (unlikely(skb_cow_head(skb, 0)))
 		return true;
 
+	shinfo = skb_shinfo(skb);
+
 	if (shinfo->gso_type & SKB_GSO_PARTIAL) {
 		l3_type = FBNIC_TWD_L3_TYPE_OTHER;
 	} else if (!skb->encapsulation) {
@@ -258,7 +260,6 @@ fbnic_tx_lso(struct fbnic_ring *ring, struct sk_buff *skb,
 static bool
 fbnic_tx_offloads(struct fbnic_ring *ring, struct sk_buff *skb, __le64 *meta)
 {
-	struct skb_shared_info *shinfo = skb_shinfo(skb);
 	unsigned int l2len, i3len;
 
 	if (fbnic_tx_tstamp(skb))
@@ -273,8 +274,8 @@ fbnic_tx_offloads(struct fbnic_ring *ring, struct sk_buff *skb, __le64 *meta)
 	*meta |= cpu_to_le64(FIELD_PREP(FBNIC_TWD_CSUM_OFFSET_MASK,
 					skb->csum_offset / 2));
 
-	if (shinfo->gso_size) {
-		if (fbnic_tx_lso(ring, skb, shinfo, meta, &l2len, &i3len))
+	if (skb_is_gso(skb)) {
+		if (fbnic_tx_lso(ring, skb, meta, &l2len, &i3len))
 			return true;
 	} else {
 		*meta |= cpu_to_le64(FBNIC_TWD_FLAG_REQ_CSO);
-- 
2.53.0



