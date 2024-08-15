Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAAD81AC8AE;
	Thu, 15 Aug 2024 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731485; cv=none; b=tdeW4R+lPYvYAycwDzJdUi6X8dFvwDhIgx3HYbAAgVtjbW4uYl1ybWaTVDtH+0zFb/J/QAA4PZpeVdQKpwPDkT+bfDWvN2zxXXOB7/71vvzaUyiuiCbx5kuA5M2l/lmrFnm1XcGH43GtFY8sYoNwojQrrAZrygTMtqX4KZyHOBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731485; c=relaxed/simple;
	bh=oQNdgDxwgd3qET66lNGN3ZyYjz2g1M5oDotgoFiMeBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4Ps86hp9shmDvnhk8KJ3NK+coZaf+CD2nU/OKv55nu07tU8AzjiO+3QAipiTA4eGOoxUABTWznemgWyQaH5Me6t/PC9Kj+k8eVmiBwkjWIjhPZMP0mabLJrnK9y5qI7c7Cau5qq4JviR4GC/QKf5snhBJ6crW+o6iYa2ZrNgIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ufCZzdxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ufCZzdxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B5EC32786;
	Thu, 15 Aug 2024 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731485;
	bh=oQNdgDxwgd3qET66lNGN3ZyYjz2g1M5oDotgoFiMeBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ufCZzdxmpnqpViecjhOvGRVxfP8wUrAZBO3HyPTblkkS8i7up3REFUMIK8D19BNSh
	 2lemO8dcJGXTiJRdNyJdBQlwrn7tzZ1V1XaWWh9NpZ9yA4CouDo4KMYwTkCWLtTlXS
	 HLNhXxVNJj3tSNh4XWGl5rie6nrmlRM0d3SzU01I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Li <dracodingfly@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 145/259] bpf: Fix a segment issue when downgrading gso_size
Date: Thu, 15 Aug 2024 15:24:38 +0200
Message-ID: <20240815131908.390431209@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3c4dcdc7217e0..f82c27668623c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3126,13 +3126,20 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
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



