Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B96481AA4;
	Tue, 25 Aug 2026 13:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666102; cv=none; b=HdxjUok3Qz6dQ7EozsrxJqfcUc+Y2xY7wH2APDGB6On8sxx8Gftf6KrytJwDfEH5sjP8AGx7chwsit4TyCSZszPTpeSibcq8OoncqNlpCl8OI+HqrN70mD7sfizUiIQes4P/CK5VGJVw5PX4fh+Wf1DCG7cq9+G9zcpQR9US6y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666102; c=relaxed/simple;
	bh=Bv1BWB38dX/LdaoYgDjR3eYqAbyRaErLuUtj4QWCK/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gj6V5ztIY9WPncNYexYUKGAduO0lhprKvhh8thdc79uxpQ/iH3ffqjJ2sPbqJEuu6NPXNuVNvV9JdaTcfYCPO/kxoaMP8/Mno4y15Ccm6OdP+kNGERJCPEeUzazlNC3p4YbhnpcX73E55330D1I2qh/MT257xkhN/K9DM470ti4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ayqmQ3Ut; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ayqmQ3Ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4709C1F000E9;
	Tue, 25 Aug 2026 13:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666100;
	bh=vGNGTsjHYYldfmafxjjAnL3DFzCyXYBuFi8u21Yia88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ayqmQ3Uth03BT/3w7xcEw9BrMfUepYCVyx5OMkts23ApUV2unsvbsArgtsFdkKGp9
	 AFHtmXqY391gJ3ZRwqRP85TmaZjg2Zyz77TbjKhav/XBbRWBDdzqpcbuzQW+4P86Ei
	 Q7QrLRKZ+A5s36L5yI0Xi64eDVEpsUg9p9Qxp1fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li Xiasong <lixiasong1@huawei.com>
Subject: [PATCH 6.1 53/79] ndisc: ndisc_send_redirect() cleanup
Date: Tue, 25 Aug 2026 15:26:33 +0200
Message-ID: <20260825132543.780023511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.677185791@linuxfoundation.org>
References: <20260825132541.677185791@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1671,7 +1671,7 @@ static void ndisc_fill_redirect_hdr_opti
 void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 {
 	struct net_device *dev = skb->dev;
-	struct net *net = dev_net(dev);
+	struct net *net = dev_net_rcu(dev);
 	struct sock *sk = net->ipv6.ndisc_sk;
 	int optlen = 0;
 	struct inet_peer *peer;
@@ -1686,8 +1686,8 @@ void ndisc_send_redirect(struct sk_buff
 	   ops_data_buf[NDISC_OPS_REDIRECT_DATA_SPACE], *ops_data = NULL;
 	bool ret;
 
-	if (netif_is_l3_master(skb->dev)) {
-		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
+	if (netif_is_l3_master(dev)) {
+		dev = dev_get_by_index_rcu(net, IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
@@ -1725,12 +1725,10 @@ void ndisc_send_redirect(struct sk_buff
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


