Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B2E1DDCE;
	Tue, 16 Jul 2024 16:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721146194; cv=none; b=r/r3qAph8nQOSmMyVXt34UALwNx2ufLn7Oq+vwwMVTviTADX+lGqJwaBEk4RwMyb5xWHPxo70LXqxbjPGZarAE1ZTOmLSKt6fDjed9VX4TZ/of99rARvT/PmXDJmsh/QpXN4ciwyMHWB4c4jYPmwEUSAmxViTcpi3kuvglY4dpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721146194; c=relaxed/simple;
	bh=T9WbLFWec4B0+DrG6LL+1sUfnzk6nk5DAcJoJipGfdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKi+nF89gJiV2Tt50yoh+ByF62t7xpdfP0vM4Jq6qfVXP+zQud+mgFeo8GAWhEsSGj2jhZyTWem90PlJFThI7khixW2NLiGzLsHJgnVEce7HKQHpHPG6o8EemmxkKsCW3PyOiK88md5XbLFQwf6W/YO4Q5J+TflPpkrUKJynVMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJztWwGd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJztWwGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1C3EC116B1;
	Tue, 16 Jul 2024 16:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721146194;
	bh=T9WbLFWec4B0+DrG6LL+1sUfnzk6nk5DAcJoJipGfdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EJztWwGdCrdO9NeIwOxaAln75R9FSVUQVGBbJGyixrYvMxzBEm5AJ3zRKxI160MGN
	 1Hlt5Xhhd77+FDvqLxA1BYVzSCRaW/fpn4sLh9o1cEM/JS/U35U//1m1reV52ssEdo
	 YbeT1MwbkBYCD+XfcPGRQDh/cACGktslg6/Dd02s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugh Dickins <hughd@google.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 086/144] net: fix rc7s __skb_datagram_iter()
Date: Tue, 16 Jul 2024 17:32:35 +0200
Message-ID: <20240716152755.847401413@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

From: Hugh Dickins <hughd@google.com>

[ Upstream commit f153831097b4435f963e385304cc0f1acba1c657 ]

X would not start in my old 32-bit partition (and the "n"-handling looks
just as wrong on 64-bit, but for whatever reason did not show up there):
"n" must be accumulated over all pages before it's added to "offset" and
compared with "copy", immediately after the skb_frag_foreach_page() loop.

Fixes: d2d30a376d9c ("net: allow skb_datagram_iter to be called from any context")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Link: https://patch.msgid.link/fef352e8-b89a-da51-f8ce-04bc39ee6481@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/datagram.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 6b7db06eafe68..13f4bf82b2ee8 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -447,11 +447,12 @@ static int __skb_datagram_iter(const struct sk_buff *skb, int offset,
 			if (copy > len)
 				copy = len;
 
+			n = 0;
 			skb_frag_foreach_page(frag,
 					      skb_frag_off(frag) + offset - start,
 					      copy, p, p_off, p_len, copied) {
 				vaddr = kmap_local_page(p);
-				n = INDIRECT_CALL_1(cb, simple_copy_to_iter,
+				n += INDIRECT_CALL_1(cb, simple_copy_to_iter,
 					vaddr + p_off, p_len, data, to);
 				kunmap_local(vaddr);
 			}
-- 
2.43.0



