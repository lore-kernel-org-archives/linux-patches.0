Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185E31A76A8;
	Tue, 30 Jul 2024 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359831; cv=none; b=XcSGNZvgxZ2GoOgL+99Rgr+MlFiqlO3eFNlmFk0xGwh15/C0doIzFZJg73zcrWGESBPREOAIONf17utb1cxTkiYu6QKr33W1MonasZ/avodflr+71zdABnc4CW48nfFCvKZar6KtO6XQ43s7CdFqg0rckEOntfw11xmIcjsOBwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359831; c=relaxed/simple;
	bh=V8wT8Ne+G9KloKsGvtuT85upV/yT4OM6vFVxKpjmPJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OOoXUuKYnYJNgHfZoJ312AUEQd9wrJU+Lh6J2Q+0XklT1rtAHaojXmJTsAJmgZ1Xh+rB9jw3hp8fpqfBd8BKzK56Cl9AjboZ/8yEW309oK/m9mQEOriRj+8N1K9qOMDpHEj5fw9BcDaWZ47RckD9O631oAfjh5OqEWNG9n2ifEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hjGOujD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hjGOujD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74881C32782;
	Tue, 30 Jul 2024 17:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359830;
	bh=V8wT8Ne+G9KloKsGvtuT85upV/yT4OM6vFVxKpjmPJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hjGOujD+t9spbW6HTDDpJCFYpqgW91bws5QqkA3gejhrXaWg+sSBtFRxUMj/swQwa
	 eqVfPdM3PvqgBQ7aysAs3aNVnjQkL5NP6G6Q59Dlc36NozdRso33uuGkwjUtn0JILl
	 cWvoYiKUE1f+Dn67XDW8+Ugmp0tbXI118hN6I5gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fred Li <dracodingfly@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Willem de Bruijn <willemb@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 543/568] bpf: Fix a segment issue when downgrading gso_size
Date: Tue, 30 Jul 2024 17:50:50 +0200
Message-ID: <20240730151701.383690194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index afe38b8dee024..8cb44cd29967b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3530,13 +3530,20 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
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



