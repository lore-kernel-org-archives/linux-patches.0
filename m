Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11C62E62D1;
	Tue, 15 Jul 2025 13:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585985; cv=none; b=JwOc9rKaE6uWGQZ4BuPdxrKOZO4IOcZKYAQf5Zuz43OQq4nnm4JlJ1li53d1cgO3DIFLi/QD5+YBp8EYKdbGogOMPqwaHargmuiyJNe0btkcWc8uMq61/iZWozw367WRCqGH8Q4ltD3CSZfBpUWi2/Z8tUFKckbhG8JUywTqVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585985; c=relaxed/simple;
	bh=5W2aCr8nEkOJ2UMam1uw7Wn9RBSbZyfKlyvHbWDGq2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tn5ybwmL27dP7yuq01M6rTJUliMrsA7Kbl1O9TIUj1R2VlvM4apNAcqjHVPg433egeaYycaaCEL7h8BKZbhD3SuWKoXGPHzCHs5fHg+ukAYlnuVUQQ0g78l+PpTCzdah+RzpnLsIVI+EkE0/4zVkwzRPHquJ91pYkvT+ucCDk+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUMDnmnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUMDnmnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61CA1C4CEE3;
	Tue, 15 Jul 2025 13:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585985;
	bh=5W2aCr8nEkOJ2UMam1uw7Wn9RBSbZyfKlyvHbWDGq2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUMDnmnEUpEc0/f2/JaoYwn9wTVSy1/TQw5KoYv1BZ1JOjvSE4cCVmfeBE0onfNHe
	 yo6CevEe9s3rcZpt7YGXGv60sMYiwSMcWXJ9370N8gDhlKRLOjKVGOkEYf61hj1UZJ
	 5UQIe0i23/VgJVlsZCrY768S09iy7ZD9ZJpv83mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 083/109] netfilter: flowtable: account for Ethernet header in nf_flow_pppoe_proto()
Date: Tue, 15 Jul 2025 15:13:39 +0200
Message-ID: <20250715130802.203864312@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 18cdb3d982da8976b28d57691eb256ec5688fad2 ]

syzbot found a potential access to uninit-value in nf_flow_pppoe_proto()

Blamed commit forgot the Ethernet header.

BUG: KMSAN: uninit-value in nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
  nf_flow_offload_inet_hook+0x7e4/0x940 net/netfilter/nf_flow_table_inet.c:27
  nf_hook_entry_hookfn include/linux/netfilter.h:157 [inline]
  nf_hook_slow+0xe1/0x3d0 net/netfilter/core.c:623
  nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
  nf_ingress net/core/dev.c:5742 [inline]
  __netif_receive_skb_core+0x4aff/0x70c0 net/core/dev.c:5837
  __netif_receive_skb_one_core net/core/dev.c:5975 [inline]
  __netif_receive_skb+0xcc/0xac0 net/core/dev.c:6090
  netif_receive_skb_internal net/core/dev.c:6176 [inline]
  netif_receive_skb+0x57/0x630 net/core/dev.c:6235
  tun_rx_batched+0x1df/0x980 drivers/net/tun.c:1485
  tun_get_user+0x4ee0/0x6b40 drivers/net/tun.c:1938
  tun_chr_write_iter+0x3e9/0x5c0 drivers/net/tun.c:1984
  new_sync_write fs/read_write.c:593 [inline]
  vfs_write+0xb4b/0x1580 fs/read_write.c:686
  ksys_write fs/read_write.c:738 [inline]
  __do_sys_write fs/read_write.c:749 [inline]

Reported-by: syzbot+bf6ed459397e307c3ad2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/686bc073.a00a0220.c7b3.0086.GAE@google.com/T/#u
Fixes: 87b3593bed18 ("netfilter: flowtable: validate pppoe header")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Link: https://patch.msgid.link/20250707124517.614489-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_flow_table.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index df7775afb92b9..0097791e1eede 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -353,7 +353,7 @@ static inline __be16 __nf_flow_pppoe_proto(const struct sk_buff *skb)
 
 static inline bool nf_flow_pppoe_proto(struct sk_buff *skb, __be16 *inner_proto)
 {
-	if (!pskb_may_pull(skb, PPPOE_SES_HLEN))
+	if (!pskb_may_pull(skb, ETH_HLEN + PPPOE_SES_HLEN))
 		return false;
 
 	*inner_proto = __nf_flow_pppoe_proto(skb);
-- 
2.39.5



