Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056789;
	b=oWatWavjA+oE7RvWbEofT+rGOieLpsCy4AA1cmTpobK/xFpurtlBp+nbqSrS1vVBnB74
	 jztCvgwm2wlbph8XaSCdb6bwu7t11FWEs5LJDKeE8KNm5suJaWEHUpyTXCYGH6Kf0ICR8
	 0lm7uMfPSqm6LbipwGi+qJBRbeWn+X7ARZB+NBcSh5XhG+T8u7dwKZ8GlMsZtGMgZpTcM
	 z6jo6Ly8q0dnwQ4lExt+uOyMEWRSfG8yMLiSYvTZOG4rF09rM9yRUC88DE6wcjrk9Co9Z
	 lNA/dLKC8Aa8E/albkIsxGPok7MtEX1Ezgbh/DhHgLN8uTBXVNbndr0NstseYqpFPng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/KivnGzRi+JTxraoPA4OH4q85b+gNP5BTPmH2T5oCg=;
	b=p/EhTckneUOIyZ0EZ09sEa180LklKBZi77oAOIShqDryVa6eZey+c+IIyQ1z6Kd/NmEf
	 qAg+c4wWedJ8RtzqrV2RB4bZxhvloxOqX6aHzrEXg0X9gMIR4ZwThXFRW9TofFU0v0IX2
	 wGJ+wPhrDyYa5o4+QGdvkudlKNhBHia/QWxurpQiRM8uYAusXqKDljWJnjhwX7rof6CFV
	 A3/kXklZIZ3XqD5Q1KkG9YDOeCGJiYSciixgxwYaU3tW/Sr5MruyPd8GWu6dZTMKhdVVP
	 LyM2YnJOP6UGhMfCXlyESFMwTTS8UkfIQrkbusNYKght6iE9PpUJlEZ8wwzBvAWS3IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhpAvi+X;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BEB606A31C;
	Thu, 19 Nov 2026 02:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UhpAvi+X
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0C31F000C4;
	Thu, 19 Nov 2026 02:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056788;
	bh=j/KivnGzRi+JTxraoPA4OH4q85b+gNP5BTPmH2T5oCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UhpAvi+XM3D+fC/ogFQoJiSGoLJ2ukNbfzBhuuaAk5J7rEvXZaXHFchIRcMGkIKu0
	 MKTCOgOnEdanKph2KNIPx4wogwsnzPKtaSVPieAVOoHMFvOOjOVvuf93RtKKUJbN5t
	 yMWY94owOKvmvVoL1ABkxs/7Olp6BudKFEZpo4EE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Simon Polack <spolack+git@mailbox.org>,
	Willem de Bruijn <willemb@google.com>,
	Wang Zhan <wang.zhan@smartx.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2112/2214] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:03:08 +0100
Message-ID: <20261118150135.100239505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@kernel.org>

[ Upstream commit 546daf344420b5dce27eded3ad15be12628dd185 ]

skb_segment_list() detaches the frag_list from the head skb and moves
its members one by one to the skb->next chain. On error, err_linearize
frees that chain with kfree_skb_list(skb->next), relying on the members
not yet processed to still be linked after the current one.

This does not hold when the current member was shared: it is replaced
by skb_clone(), and __skb_clone() clears ->next. If __skb_linearize()
then fails on that clone, the remaining members are no longer reachable
from skb->next nor from skb_shinfo(skb)->frag_list, and they leak.

The skb_shared() error branch already relinks nskb->next to list_skb
before jumping to err_linearize. Do it unconditionally right after nskb
is added to the chain, so every error exit sees the remaining members.
On the last member list_skb is NULL, which still terminates the chain.

Fixes: 53475c5dd856 ("net: fix use-after-free when UDP GRO with shared fraglist")
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Cc: Simon Polack <spolack+git@mailbox.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Reviewed-by: Wang Zhan <wang.zhan@smartx.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Link: https://patch.msgid.link/20261021161858.761205-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5867fcac3f05b..32511b77d8122 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3965,10 +3965,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
 		else
 			tail->next = nskb;
 
-		if (unlikely(err)) {
-			nskb->next = list_skb;
+		/* nskb may be a clone with a NULL ->next: keep the remaining
+		 * members linked so that err_linearize frees them.
+		 */
+		nskb->next = list_skb;
+
+		if (unlikely(err))
 			goto err_linearize;
-		}
 
 		tail = nskb;
 
-- 
2.53.0



