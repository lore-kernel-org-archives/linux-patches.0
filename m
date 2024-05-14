Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C59EE84D26;
	Tue, 14 May 2024 11:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686269; cv=none; b=oDJdHblrfvJ89kr6ZHEE7ZBb2x06ZQU4q0iU+qtpf2pOs6JyLkXIfW93Mr/rIxH3C3dsI8CKCt70S6QLnO7KE+vYrL1pcQJmHfigU9cGpCl8HAKUonNiA/kTz+zpe8Lz4/iWa9okFUuxisSc29MSfFqbwLsUPDqv3hdadKDqKBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686269; c=relaxed/simple;
	bh=aZB+F0QpHQnxbIN/ve6GQ5K3AC15BTf0LBQL9xBoBmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcEOKXAJE36rxnKnKGrKVF99qGw7UUBGVJqBZIL1sCb83/YUUAVcOtIQ6ABXE5E5EhJ+UVSsbHdX3OVmCPJMpGQ5QdGhJFKhAc/B4KYgovM26UuRyilpa0hwYfJNusV5x3gmt+/B9RcIn7wqfsoSY/0+4LBv5r0mKR79kVjzc8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyjXn8P8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyjXn8P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415AEC2BD10;
	Tue, 14 May 2024 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686269;
	bh=aZB+F0QpHQnxbIN/ve6GQ5K3AC15BTf0LBQL9xBoBmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyjXn8P8QCzLeWlfU7RK2yhVShBhV2xSfDy1m/Vst+H5rIrsJS6fn1Pd1GrFyDMKj
	 g+4aGo+dfHePd9fMr1XlzN9Tm9NogGPRxibfXU4CK9MsX2NIkd53YWppNT2PlemJtC
	 dxMzFy9XI8cLGATjNMGZR4T9rXuCEDrbBaaBIESQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 078/236] net: core: reject skb_copy(_expand) for fraglist GSO skbs
Date: Tue, 14 May 2024 12:17:20 +0200
Message-ID: <20240514101023.331927004@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit d091e579b864fa790dd6a0cd537a22c383126681 ]

SKB_GSO_FRAGLIST skbs must not be linearized, otherwise they become
invalid. Return NULL if such an skb is passed to skb_copy or
skb_copy_expand, in order to prevent a crash on a potential later
call to skb_gso_segment.

Fixes: 3a1296a38d0c ("net: Support GRO/GSO fraglist chaining.")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index e38a4c7449f62..4d46788cd493a 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1720,11 +1720,17 @@ static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 
 struct sk_buff *skb_copy(const struct sk_buff *skb, gfp_t gfp_mask)
 {
-	int headerlen = skb_headroom(skb);
-	unsigned int size = skb_end_offset(skb) + skb->data_len;
-	struct sk_buff *n = __alloc_skb(size, gfp_mask,
-					skb_alloc_rx_flag(skb), NUMA_NO_NODE);
+	struct sk_buff *n;
+	unsigned int size;
+	int headerlen;
+
+	if (WARN_ON_ONCE(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST))
+		return NULL;
 
+	headerlen = skb_headroom(skb);
+	size = skb_end_offset(skb) + skb->data_len;
+	n = __alloc_skb(size, gfp_mask,
+			skb_alloc_rx_flag(skb), NUMA_NO_NODE);
 	if (!n)
 		return NULL;
 
@@ -2037,12 +2043,17 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
 	/*
 	 *	Allocate the copy buffer
 	 */
-	struct sk_buff *n = __alloc_skb(newheadroom + skb->len + newtailroom,
-					gfp_mask, skb_alloc_rx_flag(skb),
-					NUMA_NO_NODE);
-	int oldheadroom = skb_headroom(skb);
 	int head_copy_len, head_copy_off;
+	struct sk_buff *n;
+	int oldheadroom;
+
+	if (WARN_ON_ONCE(skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST))
+		return NULL;
 
+	oldheadroom = skb_headroom(skb);
+	n = __alloc_skb(newheadroom + skb->len + newtailroom,
+			gfp_mask, skb_alloc_rx_flag(skb),
+			NUMA_NO_NODE);
 	if (!n)
 		return NULL;
 
-- 
2.43.0



