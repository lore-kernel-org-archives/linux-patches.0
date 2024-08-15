Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DEDA1714A1;
	Thu, 15 Aug 2024 13:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730013; cv=none; b=P4b6mRGb4e0r0FmnZslygU5z29KAQ4Yyx5/w2iZ7s4ZO7KQot1kPbuVt2OHEFdso4jEV6YfvSGUfFXOBstJkzAn3YFp6zzm9Y5rLvEO4AYZdOjq27CkEbP0egcgSGIGidC+oONCVoN7mbpAelresr0oIDWj8HJVHjQyzhQfSCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730013; c=relaxed/simple;
	bh=b0NivchqFeJFU8NTtcadKbEtCOFWz0Tjeo0oRSltDI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+24o7MUiCUk2Y3Yc9ryZZo3RrtrCI5ZNbDtOXpzfqEOw//XQAUEXEH0bR1/V8u+BZnfE9YfdtKdLnqNyzE0LKoMSEWv0nbe4pRKlwXt5AE1GQwdbMDA/UdobSD+jwvV/uE5LR/tB8KajgssRgjPmYJV24eewoYZYYkKsNBNJ24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKQm7TA3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKQm7TA3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33210C32786;
	Thu, 15 Aug 2024 13:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730011;
	bh=b0NivchqFeJFU8NTtcadKbEtCOFWz0Tjeo0oRSltDI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LKQm7TA3PJR+a4/pOBqRcyWIW6aNx0UQgK2wwWF/4vbsceLhdDsET9GyLUdLiFuM4
	 Apyp1DQPaQY9/Hej9Shmf+TY2vPDboVLMkrueZNSA63e6ItETqX38JE1KrjY1i6IKV
	 YWK4lDLW6EvpRYh5yWTmAzpo7vMFPII5r2oBhzSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Li <dracodingfly@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 277/484] bpf: Fix a segment issue when downgrading gso_size
Date: Thu, 15 Aug 2024 15:22:15 +0200
Message-ID: <20240815131952.106448525@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Fred Li <dracodingfly@gmail.com>

[ Upstream commit fa5ef655615a01533035c6139248c5b33aa27028 ]

Linearize the skb when downgrading gso_size because it may trigger a
BUG_ON() later when the skb is segmented as described in [1,2].

Fixes: 2be7e212d5419 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Fred Li <dracodingfly@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/all/20240626065555.35460-2-dracodingfly@gmail.com [1]
Link: https://lore.kernel.org/all/668d5cf1ec330_1c18c32947@willemb.c.googlers.com.notmuch [2]
Link: https://lore.kernel.org/bpf/20240719024653.77006-1-dracodingfly@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index a873c8fd51b67..a92a35c0f1e72 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3507,13 +3507,20 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	if (skb_is_gso(skb)) {
 		struct skb_shared_info *shinfo = skb_shinfo(skb);
 
-		/* Due to header grow, MSS needs to be downgraded. */
-		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
-			skb_decrease_gso_size(shinfo, len_diff);
-
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= gso_type;
 		shinfo->gso_segs = 0;
+
+		/* Due to header growth, MSS needs to be downgraded.
+		 * There is a BUG_ON() when segmenting the frag_list with
+		 * head_frag true, so linearize the skb after downgrading
+		 * the MSS.
+		 */
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO)) {
+			skb_decrease_gso_size(shinfo, len_diff);
+			if (shinfo->frag_list)
+				return skb_linearize(skb);
+		}
 	}
 
 	return 0;
-- 
2.43.0



