Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2609E1C7D76;
	Thu,  6 Jun 2024 14:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683707; cv=none; b=Jtgu/QtQfYAjVlVxwuiqrmdIxKycr1sc7w6DFYzfCGbYaLwQySU+fvamUOGTogccYS3zqBxSfaLyv3MgxVRFxjThW4xEnmunt3WI/5fATmPPVc7FLBqu4D5K9J3W2t3cUsZFpPYnjgG+hg4eSh56K3LBFYp+6Z49tOYAK+PAr6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683707; c=relaxed/simple;
	bh=Ko88NHpCHNitBZJ6lDs1lKvfQB3MeoHflwI1F2njMbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C1bOgnjT5EZHrsAthDnp3pFR9rHm8oTbNF//TNt5DhdndQNwjvnDNVFav/L6HkJNlT2noCxFD9xRxk2bjk+TlqEooHlI7e1a2iTrWACydHQxCQTo3MXnLKHF/BetMhIrqWwVnYZGxBOqouwFzWHWBsXmBJXifJzgAOrUSCxU4b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9PUduSU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9PUduSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A9AC2BD10;
	Thu,  6 Jun 2024 14:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683707;
	bh=Ko88NHpCHNitBZJ6lDs1lKvfQB3MeoHflwI1F2njMbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9PUduSUm3sW5CXNKuyKisquprMEIjI2zTSjJJEjsBPbSkP8UnQHZeKWT1mvC0QAe
	 n1x1jeXGigU7yaCwAr1weJptM7c66r1wIy7v//Q9i4XaygSVvnrHjMHZYiHbgwaqP9
	 5g7QTp3Qt8EIzsmrNkpGQTyEXgJCACWlMY3Rul5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 634/744] ipv6: sr: fix missing sk_buff release in seg6_input_core
Date: Thu,  6 Jun 2024 16:05:06 +0200
Message-ID: <20240606131752.814720406@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Andrea Mayer <andrea.mayer@uniroma2.it>

[ Upstream commit 5447f9708d9e4c17a647b16a9cb29e9e02820bd9 ]

The seg6_input() function is responsible for adding the SRH into a
packet, delegating the operation to the seg6_input_core(). This function
uses the skb_cow_head() to ensure that there is sufficient headroom in
the sk_buff for accommodating the link-layer header.
In the event that the skb_cow_header() function fails, the
seg6_input_core() catches the error but it does not release the sk_buff,
which will result in a memory leak.

This issue was introduced in commit af3b5158b89d ("ipv6: sr: fix BUG due
to headroom too small after SRH push") and persists even after commit
7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane"),
where the entire seg6_input() code was refactored to deal with netfilter
hooks.

The proposed patch addresses the identified memory leak by requiring the
seg6_input_core() function to release the sk_buff in the event that
skb_cow_head() fails.

Fixes: af3b5158b89d ("ipv6: sr: fix BUG due to headroom too small after SRH push")
Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_iptunnel.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/seg6_iptunnel.c b/net/ipv6/seg6_iptunnel.c
index 03b877ff45588..a75df2ec8db0d 100644
--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -459,10 +459,8 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 	int err;
 
 	err = seg6_do_srh(skb);
-	if (unlikely(err)) {
-		kfree_skb(skb);
-		return err;
-	}
+	if (unlikely(err))
+		goto drop;
 
 	slwt = seg6_lwt_lwtunnel(orig_dst->lwtstate);
 
@@ -486,7 +484,7 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 
 	err = skb_cow_head(skb, LL_RESERVED_SPACE(dst->dev));
 	if (unlikely(err))
-		return err;
+		goto drop;
 
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_OUT,
@@ -494,6 +492,9 @@ static int seg6_input_core(struct net *net, struct sock *sk,
 			       skb_dst(skb)->dev, seg6_input_finish);
 
 	return seg6_input_finish(dev_net(skb->dev), NULL, skb);
+drop:
+	kfree_skb(skb);
+	return err;
 }
 
 static int seg6_input_nf(struct sk_buff *skb)
-- 
2.43.0



