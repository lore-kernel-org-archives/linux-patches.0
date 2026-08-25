Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FDB3FAE19;
	Tue, 25 Aug 2026 13:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665742; cv=none; b=rme1doCE22bE5B4v/VsZoVHI839qnoulYK4E7bmGhOFniLNDCGwaguOYKQLnHVp9VcgYStdboWyGC0mtYYUEAEYyWi4IclXhN0MHjBjeE0i7KqcTYtZDtH1KXWyxBNeb1DzAjhoYCxJmaB9UPo3/09UyXj0Q/IYbHx+ULI0k6rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665742; c=relaxed/simple;
	bh=TfirFQVqOoZ/5b3HsK25u1bC8He96mFqkw5L+ZzRABg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p576o6dqPN6F3EmXOPjrcFsimICzE5nsHpPbMrw6wjgt6QBwVCKb7/th4oF2wnCbH+c49LJ9a1W1K9kiVW7DPihngLziIQvK1Nnji82yHN888YcMZ3eVGjxRYkVQB+VtGZWaE+XyC+/YwX5eLKMNwgc366/fy6VpCLsMPkn5pfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0Ti/vv4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0Ti/vv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E6B1F000E9;
	Tue, 25 Aug 2026 13:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665741;
	bh=iOemIYvVjXueG45zQ5hUR+V8uiOesOtAWAp10LI4XnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0Ti/vv4g5ZaU2XGYDWLhm8/8JOYDcqYPjWb5o/NAXEiNhbfkDYAekWkIgRUEKE4C
	 yVgYQmLNe4V/MyafoUTfMfCQpn8iozK3aHOM42jMbYrnQD/gvyRcJRhsEeJh9v8qqp
	 nBIPjms/NH919hYvVEtz5N4hG79KqtsGhRTeYBnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li Xiasong <lixiasong1@huawei.com>
Subject: [PATCH 6.6 49/87] ndisc: ndisc_send_redirect() cleanup
Date: Tue, 25 Aug 2026 15:26:12 +0200
Message-ID: <20260825132543.768037327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@google.com>

commit 0784d83df3bfc977c13252a0599be924f0afa68d upstream.

ndisc_send_redirect() is always called under rcu_read_lock().

It can use dev_net_rcu() and avoid one redundant
rcu_read_lock()/rcu_read_unlock() pair.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250214140705.2105890-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ndisc.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1675,7 +1675,7 @@ static void ndisc_fill_redirect_hdr_opti
 void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 {
 	struct net_device *dev = skb->dev;
-	struct net *net = dev_net(dev);
+	struct net *net = dev_net_rcu(dev);
 	struct sock *sk = net->ipv6.ndisc_sk;
 	int optlen = 0;
 	struct inet_peer *peer;
@@ -1690,8 +1690,8 @@ void ndisc_send_redirect(struct sk_buff
 	   ops_data_buf[NDISC_OPS_REDIRECT_DATA_SPACE], *ops_data = NULL;
 	bool ret;
 
-	if (netif_is_l3_master(skb->dev)) {
-		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
+	if (netif_is_l3_master(dev)) {
+		dev = dev_get_by_index_rcu(net, IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
@@ -1729,12 +1729,10 @@ void ndisc_send_redirect(struct sk_buff
 		goto release;
 	}
 
-	rcu_read_lock();
 	peer = inet_getpeer_v6(net->ipv6.peers, &ipv6_hdr(skb)->saddr);
 	if (!peer)
 		goto release;
 	ret = inet_peer_xrlim_allow(peer, 1*HZ);
-	rcu_read_unlock();
 
 	if (!ret)
 		goto release;


