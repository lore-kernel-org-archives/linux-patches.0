Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050445;
	b=RcmGGd2rMwr+9i85yB/zQHgWb8sopF53+ujGE/PC4R9OFjiXy4UnK02tM3zID1vwhIxI
	 sh72BfOHwhOCfpX2gP21q4jxHxYDFpcSz0dm8gwy+XfTBEEV5KbpFBu0M6bm7N7IcqQUx
	 wzrMD0GyHpkxMIZbtX6Iqu7R5g6wBx1WRtgQKLFQxl5vC3kCVVX10ncEUYZH2GTaKatWn
	 IL+DayaOEiG42GT0iUbj+ZsDzS0n1XYXDVpK5ogXhCcQwLh2xG+AprcsXc4hS97jcxRQ3
	 g316WWekUoUPdasENWbTU8PhJH4MPbXctj9anxIzQIuLEdeGozvSPKmuvfB5x/bzw6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DNgS3SIFTWbl6V+jMx9VScauieSZfM01Ct5K0DR4ENs=;
	b=JUimTkSmfViuLA8ZHjwAwKXixDN4fGwRwf1Vu+KpP4+c54q50t0Kt0aDbIRApOoXcjGh
	 zCH8m0xdz5NDxvZJqriTD0nq70xFpxjZKLcoMIslN+cnMttiPe6f58vcJLj2Vi9mBIZJo
	 CMkVBkbGjXnWU2CY4H7siw2yWApTj1bN2g/DK4DkqUc9olJkjJEdruQCJ5SBRYSiaHbwR
	 wneE6NJY/8y02LCLM4Yf6YxIPb7N4Z0+y6INNM5PcyRYI8SU/j1jKI3t800XNPqHfE99j
	 GmUA9tbYxaDBapASXRvBwKk6VfQyKgeUketX8sXPUhL960IPC4hY+gJSUfwrYiUEsFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="kPBNnt/c";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EB6A606A320;
	Thu, 19 Nov 2026 01:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kPBNnt/c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A6C61F000C4;
	Thu, 19 Nov 2026 01:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050445;
	bh=DNgS3SIFTWbl6V+jMx9VScauieSZfM01Ct5K0DR4ENs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kPBNnt/cTt9jb9x6BTRb3VjcaWMtfy354zv6EUakQWa1cpLM3WYMxPzoM5kLpZGKH
	 A3auQ4HXNx85HJB4XtA4o6hVIwxB1BACedj1Ugm/bIUUZZS6TqlCRpfNM8Bwxd7d15
	 yQDu/ze+nE+eXrePlQIufpsLoPPFEP5YN7p5Xx/Y=
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
Subject: [PATCH 6.1 2708/2857] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:02:22 +0100
Message-ID: <20261118150339.100874747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea5faa225e759..96286a16199b0 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4103,10 +4103,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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



