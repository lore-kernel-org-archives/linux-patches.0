Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3A148CCC;
	Tue, 14 May 2024 11:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687633; cv=none; b=tGWDedhdZ3SZZoFyC5cJOFJBr6ZSHDkNCZEkmLYMVWCUzXFic32C3IF+o3Jwua+705e3pHWljcmJf3KpOzb3CsAVUb6b+Nd7MjptH9yZiXtlqS2qKdKaxwwQCZRGst9tQ/Jle4gityGyUcCB1Xtjb/ZQ83i6kPJU36/fxfr2R5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687633; c=relaxed/simple;
	bh=kLWrf5Dpb3xMzGB3j0DsXT7eDIKhjYoFMk/PK4gvCl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gwRrrmYZDlFRSh9EJ4zR9pbPlujuwaeOjDIcQcUG0U4qzyRnUwOkLRoQvdecfFFXwoUvnzf3omZW5ImtZRUH3is2ahk1eOa8AR/OUmj+DmVqwGxq6fL73nJbchw2X1ZFGkEaRL4Gz8G98iVTMCIOnOOm+Ba9kA7+P1zgJkcQDhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAGWl1PP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAGWl1PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D59FC2BD10;
	Tue, 14 May 2024 11:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687632;
	bh=kLWrf5Dpb3xMzGB3j0DsXT7eDIKhjYoFMk/PK4gvCl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wAGWl1PPE30iAWNWi49p/uskutiwkCN5FOYqp/oIRiEMUnK45EZc+kyaMZSBIMhxB
	 oDPNKKMiJwLAEfnknVo5YCmZPqKZhkBXms9JIKQgdnA2SJi8lTJfq/KjeKrGIXDN1t
	 6mtpPXry730Zzbw3ulobtfxha86NRPAHKAK8dW8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/168] net: core: reject skb_copy(_expand) for fraglist GSO skbs
Date: Tue, 14 May 2024 12:19:10 +0200
Message-ID: <20240514101008.653909281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a42431860af9a..4ec8cfd357eba 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1583,11 +1583,17 @@ static inline int skb_alloc_rx_flag(const struct sk_buff *skb)
 
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
 
@@ -1899,12 +1905,17 @@ struct sk_buff *skb_copy_expand(const struct sk_buff *skb,
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



