Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B988470117;
	Tue, 25 Aug 2026 13:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665500; cv=none; b=gM9GJMsc+4Aq6wSeARtn0/jI3FTSqCsJjXe0QyloXDD2p1PE594ye9G/CHb/pbN5GIzJsR+9yA6ETnUNwrCDFyZ+mL859Zr14Fb+wEaBom0wXX2NBkzXYaeC2eCShYTJIviKRiB1rjDhImB2wLsHHhRdVVf/+L6yAvDQeokY/f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665500; c=relaxed/simple;
	bh=lDD2RDHtpV15xL+33SokLB8AU7rszFRkqeCxIK2J+ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PtQ4doM1fcQ5liXme/+mE1UorTKZWRE2bwHay3vK/9bzZkKAqjqHHTvNIlOQbHWkISfSVDaFPvTpkz946VFAiI6vZK6JLyZ30oehGVXkDTdl7MeKOUqoxoP2ns+SiF35LjbOxhUc1mK9/cfSr0sheaoBfc+oFH7sSv65OjAryhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=THMrLETk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="THMrLETk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD9D1F00A3E;
	Tue, 25 Aug 2026 13:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665499;
	bh=rwa3MFKGNN2T8HFDnhEGtuduzOVRrUC7M/nlK4GUmdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=THMrLETk+NysGYDoxQDlvxkboUJeLeZOuWEvtXMXGRjgLED6AENKWKL56pdt2ImYB
	 KNMrYDYZBOI54AVqfsVcX/OgisDpMXIAJEc2NNJrCSInAUAEXyt/C8c5nYqDJCVHOZ
	 hYoX2WQ3Nv9IV981QftGpzMiR+KZ7EEHDxSLJDng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Li Xiasong <lixiasong1@huawei.com>
Subject: [PATCH 6.12 45/77] ndisc: ndisc_send_redirect() cleanup
Date: Tue, 25 Aug 2026 15:26:07 +0200
Message-ID: <20260825132543.325737086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.580275153@linuxfoundation.org>
References: <20260825132541.580275153@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1683,7 +1683,7 @@ static void ndisc_fill_redirect_hdr_opti
 void ndisc_send_redirect(struct sk_buff *skb, const struct in6_addr *target)
 {
 	struct net_device *dev = skb->dev;
-	struct net *net = dev_net(dev);
+	struct net *net = dev_net_rcu(dev);
 	struct sock *sk = net->ipv6.ndisc_sk;
 	int optlen = 0;
 	struct inet_peer *peer;
@@ -1698,8 +1698,8 @@ void ndisc_send_redirect(struct sk_buff
 	   ops_data_buf[NDISC_OPS_REDIRECT_DATA_SPACE], *ops_data = NULL;
 	bool ret;
 
-	if (netif_is_l3_master(skb->dev)) {
-		dev = dev_get_by_index_rcu(dev_net(skb->dev), IPCB(skb)->iif);
+	if (netif_is_l3_master(dev)) {
+		dev = dev_get_by_index_rcu(net, IPCB(skb)->iif);
 		if (!dev)
 			return;
 	}
@@ -1737,12 +1737,10 @@ void ndisc_send_redirect(struct sk_buff
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


