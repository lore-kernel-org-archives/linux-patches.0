Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0A371E51FA;
	Wed, 19 Feb 2025 08:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955266; cv=none; b=bqG9VlhWf2c9n3a/YraM4lkb88/kTr2QjH57P2cdKRd4DIttJc/q/h5qDzmmsaQN3DU+a6hKIc2pqEZyvzhd7YES48SH45/WUAQ/IXoAjo2KOKSBuGEpHjNuO82Rcgaak6qL1rVU0kVc5nUmYoNvX2B/SAHMxUCpLyRMYCzL9Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955266; c=relaxed/simple;
	bh=5H7KCHcwEb+7HGI7zMTyMlHoW++P5ESdpcidAWfWnMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MC7FuQNk2yErodAmfVjaEHRfLD+J8YuaQGMMSgiPRpzi1OvFhfc+hfs3FSgRv8Ca347iq7xJFktxoHELEp5A01wMwWd0FJAEOjVhWS+xWNmR6xfvv6I5w04vNnfHIwI4snPSX9DiA30z3ACi60NoEfpGqWLVh0B1OkN6mq9Dpq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPftLL3k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPftLL3k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20702C4CEE8;
	Wed, 19 Feb 2025 08:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955266;
	bh=5H7KCHcwEb+7HGI7zMTyMlHoW++P5ESdpcidAWfWnMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPftLL3k1GAN9LccPcyzoAGgU6qWaVIyvOmpVNOT2dujfpDjdJzKthe1/CiWMaIOr
	 jkqs4v/Sd11WkHaeLKpTXpJwU/gL/2aELc7lt//SEv/gErCMEXfsifo6QDYLfIzbzj
	 TslA2Q7MytZayAiMvABQzrlehauQ+3rLbBF44Uj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/230] ipv4: use RCU protection in ip_dst_mtu_maybe_forward()
Date: Wed, 19 Feb 2025 09:28:20 +0100
Message-ID: <20250219082608.859325401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 071d8012869b6af352acca346ade13e7be90a49f ]

ip_dst_mtu_maybe_forward() must use RCU protection to make
sure the net structure it reads does not disappear.

Fixes: f87c10a8aa1e8 ("ipv4: introduce ip_dst_mtu_maybe_forward and protect forwarding path against pmtu spoofing")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250205155120.1676781-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index d92d3bc3ec0e2..fe4f854381143 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -465,9 +465,12 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 						    bool forwarding)
 {
 	const struct rtable *rt = dst_rtable(dst);
-	struct net *net = dev_net(dst->dev);
-	unsigned int mtu;
+	unsigned int mtu, res;
+	struct net *net;
+
+	rcu_read_lock();
 
+	net = dev_net_rcu(dst->dev);
 	if (READ_ONCE(net->ipv4.sysctl_ip_fwd_use_pmtu) ||
 	    ip_mtu_locked(dst) ||
 	    !forwarding) {
@@ -491,7 +494,11 @@ static inline unsigned int ip_dst_mtu_maybe_forward(const struct dst_entry *dst,
 out:
 	mtu = min_t(unsigned int, mtu, IP_MAX_MTU);
 
-	return mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+	res = mtu - lwtunnel_headroom(dst->lwtstate, mtu);
+
+	rcu_read_unlock();
+
+	return res;
 }
 
 static inline unsigned int ip_skb_dst_mtu(struct sock *sk,
-- 
2.39.5



