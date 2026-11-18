Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062032;
	b=lr9XwgOoHri4Zln1keelyZZ1E4s+cVITG727zSUX6wSMab+WX+IPSN4fPtB13ETsgZWi
	 tjYzl4+tKg6vHigmeXOsbiS+Kw8jblJgQOeLcFCucUMVvf60AGeEjh/81aZrZr/9JG5rJ
	 IbVkYMdMI+e/0ZDZ1QKpNe1IAK5sbaZjfabFJZXdBJW+EXLn95OZDd1P6QjGOykYOH8k9
	 sUlc+6Nycl1HiW0zK4oClJkJ6Ujw+O0yy+OA2e55prcrB1j7vGa1NN49p7zA5S7m9pJB8
	 Boed1U9YOmWgYzUDF0UBYf3AQibrMBJkAG9+5fwaZeNxpD2c1I6CI7Xu3s3ctTeOVmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062032;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/hAp7ztTfBTPkI1uE9szvJZOfp6C1RZvcxbz/m8AXeU=;
	b=C1De1HjgA6CNeSMHnJuM+sb9fXDZdyEUNvPjzbj/xoSg1a9xVQtAZ+n/5qmTU1QVl+5f
	 SuvbopHbGcUh+pCqxfjEANwkUgVCDLSOZ/zXGcaNswwv5Qex3O+syvjwHIaU1mDXeXbZR
	 eTy/ZvsQk5hCOa+QVQxBaaBEhLnZNrK6tGKSujfG9bvgCYtrjiOP3dH4Gyh4p70Q66bxh
	 xPv++5f8MQ1ZAp3H3eMrdIOBeaG87LiZpdnBj9+667ag+nQDY/sCJ3Q781NaLexSs+zE0
	 ZKo57pWdwHNq2E6pIea1PeAelk7gG7B7U6k5b+a0G4rC46RVdiDBcEBKWL5xv0y4cYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gf4/nH+b";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5867606A325;
	Thu, 19 Nov 2026 04:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gf4/nH+b
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD761F000C4;
	Thu, 19 Nov 2026 04:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062032;
	bh=/hAp7ztTfBTPkI1uE9szvJZOfp6C1RZvcxbz/m8AXeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gf4/nH+bJZ36IVUg6DhcyoTKiJevIO6V/v2Ofk3gR3F2Ss/aDWuLbD9oYuFVpZMsd
	 dAld6skFcwXeaDHLUxbKCDqVPUfns+ucLwFuVk0nRKRcVS2RwWsmBLKuOpJ0NYvlX7
	 FyaRo5ChH3va9ztaMhsaufQVNL2a2aFrPFEy46qU=
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
Subject: [PATCH 5.10 1764/1848] net: fix frag_list leak in skb_segment_list() error path
Date: Wed, 18 Nov 2026 16:03:22 +0100
Message-ID: <20261118150033.275044809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 394eef0c7c4a1..207c4d85fad78 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3838,10 +3838,13 @@ struct sk_buff *skb_segment_list(struct sk_buff *skb,
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



