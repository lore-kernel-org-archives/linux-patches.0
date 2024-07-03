Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A1E180A99;
	Wed,  3 Jul 2024 11:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005505; cv=none; b=mmKuTDTCavFshWjj67Om5vVz1zDqDA8M0uN/uR+3XzbUduFGR0tCVqSrMLZyaUd5bI0Tbp0wco0WepZRzovALtHzpCZ37uekHyNEgf9EdMaOtYKRLbCq/wWuIhcEzcXZhqhvCU6ftB/LjSnamlszfcYPrqBSNqrJvzwcTjzm/jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005505; c=relaxed/simple;
	bh=BMZXlhuxYT6Zr8qvJY1cFalk/Fe+6TtFvP4aYyWk2xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blkOzOxnUw1WGS+qtRcSaolDZnZgILOpQ98hcimjAdEIf8Bsc8Xtc3H87H7IDVJY8mzJhcRVSl5Fza8GQnk81tNAcIr++0wGGp8lV8GkmCSPzX8tJx2hK/rEwvYnP7sEAvfDy3NtW3/cBl/tiguOXK+agqSTN+AD0TY6fwwPd4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uHauJ237; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uHauJ237"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4799C2BD10;
	Wed,  3 Jul 2024 11:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005505;
	bh=BMZXlhuxYT6Zr8qvJY1cFalk/Fe+6TtFvP4aYyWk2xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uHauJ2377XzKxRJzoCrYvRn5LWBQwsNgtsjUuX6yxyytdnJGCKMXsNPqQhaZY26wH
	 Z/Gyq2nb4yBnWhsKaRibT1amR/hzghB6m3Ry7hz6+N1Jpb58AMgGWjpFWZtvKR/LQt
	 z9BBHlFtKmhreYCvFlqS7zOS3sHw2DxBvBIhB4MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 103/356] tcp: fix race in tcp_v6_syn_recv_sock()
Date: Wed,  3 Jul 2024 12:37:19 +0200
Message-ID: <20240703102916.997217362@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d37fe4255abe8e7b419b90c5847e8ec2b8debb08 ]

tcp_v6_syn_recv_sock() calls ip6_dst_store() before
inet_sk(newsk)->pinet6 has been set up.

This means ip6_dst_store() writes over the parent (listener)
np->dst_cookie.

This is racy because multiple threads could share the same
parent and their final np->dst_cookie could be wrong.

Move ip6_dst_store() call after inet_sk(newsk)->pinet6
has been changed and after the copy of parent ipv6_pinfo.

Fixes: e994b2f0fb92 ("tcp: do not lock listener to process SYN packets")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index c18fdddbfa09d..c1f1fa6e33161 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1331,7 +1331,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	 */
 
 	newsk->sk_gso_type = SKB_GSO_TCPV6;
-	ip6_dst_store(newsk, dst, NULL, NULL);
 	inet6_sk_rx_dst_set(newsk, skb);
 
 	inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
@@ -1342,6 +1341,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
 
+	ip6_dst_store(newsk, dst, NULL, NULL);
+
 	newsk->sk_v6_daddr = ireq->ir_v6_rmt_addr;
 	newnp->saddr = ireq->ir_v6_loc_addr;
 	newsk->sk_v6_rcv_saddr = ireq->ir_v6_loc_addr;
-- 
2.43.0



