Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43B8113E037;
	Wed, 19 Jun 2024 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803905; cv=none; b=twtbSdMHGq3TEFPK9fk1h+WSeiCzhP+HacHJiMawCdI0J9NQ5aFd8JMwW5m4zejpHMwsmSTDSWWnYm6ddrPwRilKeI6A70Lc3FaDRdmtm9861rIgz+a/h4tR5RCMcI4nBdVU+aroUmkblmospHD19UMG1AaPBjoMRRTA1kyGnhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803905; c=relaxed/simple;
	bh=TCMBcqHCvT8L+HGaxImCuEy47dX4w0wiT5ycJxrhRWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Md1wcn8UJsyyzdcLLwU4/TZQQxOGP/Ohe89mWxO8DYAgrVhkKUjfqUV+5pHn0u2y3wUzoppvkAKiY3BTEdIFGW8KsXIknHxYrsS/c8Bp0FxQs4aQS7wIO3YwZcCckgN8o8w8wBzJDbzHgvCKT2oZ1dOOt6siqH4M0lusVpYr2Uw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPftiq0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPftiq0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC772C2BBFC;
	Wed, 19 Jun 2024 13:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803905;
	bh=TCMBcqHCvT8L+HGaxImCuEy47dX4w0wiT5ycJxrhRWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YPftiq0H1e61rJfmx06bUg0lDm2abNGrLB4BLUvhjy/xqxBE2Np5PwqquivHwSTWo
	 e6EuBXFkLHaUfC0DlGd2Y7pERUeGQZSNZTMKRDFe/Wwrhw8cXjyWn80ey2mc/C6Y1q
	 4TPQgGd3rmoo0Pt9h3Za3NXTYGeWZTrqsTzwWBHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/217] tcp: fix race in tcp_v6_syn_recv_sock()
Date: Wed, 19 Jun 2024 14:56:27 +0200
Message-ID: <20240619125602.248174468@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ba9a22db5805c..4b0e05349862d 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1291,7 +1291,6 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	 */
 
 	newsk->sk_gso_type = SKB_GSO_TCPV6;
-	ip6_dst_store(newsk, dst, NULL, NULL);
 	inet6_sk_rx_dst_set(newsk, skb);
 
 	inet_sk(newsk)->pinet6 = tcp_inet6_sk(newsk);
@@ -1302,6 +1301,8 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 	memcpy(newnp, np, sizeof(struct ipv6_pinfo));
 
+	ip6_dst_store(newsk, dst, NULL, NULL);
+
 	newsk->sk_v6_daddr = ireq->ir_v6_rmt_addr;
 	newnp->saddr = ireq->ir_v6_loc_addr;
 	newsk->sk_v6_rcv_saddr = ireq->ir_v6_loc_addr;
-- 
2.43.0



