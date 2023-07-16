Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F5B8F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B594EC433C8;
	Sun, 16 Jul 2023 20:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539756;
	bh=LHOA4wHQDxp2qjmUi1s1VE2XQvdOjFI95I68dk3xoaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZVcQQ13zGOZ+pSw/tTi7JIog3+auINst4HZIgo91Uw4p/N4NIOQDF4Z9PbV7JLrZ
	 7xkh3RWsgnb228B4RxLOl1fTypt0zO6DumshAAhdvoXH22Y4zDFrf33y5s72iR3XB2
	 +bmCMab8mbaH1vgMyWaw2+R9uoCCoYAv91ZsxDJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gilad Sever <gilad9366@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Shmulik Ladkani <shmulik.ladkani@gmail.com>,
	Eyal Birger <eyal.birger@gmail.com>,
	Stanislav Fomichev <sdf@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 121/591] bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC hookpoint
Date: Sun, 16 Jul 2023 21:44:20 +0200
Message-ID: <20230716194927.005756273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gilad Sever <gilad9366@gmail.com>

[ Upstream commit 97fbfeb86917bdbe9c41d5143e335a929147f405 ]

skb->dev always exists in the tc flow. There is no need to use
bpf_skc_lookup(), bpf_sk_lookup() from this code path.

This change facilitates fixing the tc flow to be VRF aware.

Signed-off-by: Gilad Sever <gilad9366@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Shmulik Ladkani <shmulik.ladkani@gmail.com>
Reviewed-by: Eyal Birger <eyal.birger@gmail.com>
Acked-by: Stanislav Fomichev <sdf@google.com>
Link: https://lore.kernel.org/bpf/20230621104211.301902-3-gilad9366@gmail.com
Stable-dep-of: 9a5cb79762e0 ("bpf: Fix bpf socket lookup from tc/xdp to respect socket VRF bindings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index e0f73ed8821e1..1b60a6cc975a7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6649,8 +6649,12 @@ static const struct bpf_func_proto bpf_sk_lookup_udp_proto = {
 BPF_CALL_5(bpf_tc_skc_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_skc_lookup(skb, tuple, len, IPPROTO_TCP,
-					     netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_skc_lookup(skb, tuple, len, caller_net,
+					       ifindex, IPPROTO_TCP, netns_id,
+					       flags);
 }
 
 static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
@@ -6668,8 +6672,12 @@ static const struct bpf_func_proto bpf_tc_skc_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_tcp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_TCP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_TCP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
@@ -6687,8 +6695,12 @@ static const struct bpf_func_proto bpf_tc_sk_lookup_tcp_proto = {
 BPF_CALL_5(bpf_tc_sk_lookup_udp, struct sk_buff *, skb,
 	   struct bpf_sock_tuple *, tuple, u32, len, u64, netns_id, u64, flags)
 {
-	return (unsigned long)bpf_sk_lookup(skb, tuple, len, IPPROTO_UDP,
-					    netns_id, flags);
+	struct net *caller_net = dev_net(skb->dev);
+	int ifindex = skb->dev->ifindex;
+
+	return (unsigned long)__bpf_sk_lookup(skb, tuple, len, caller_net,
+					      ifindex, IPPROTO_UDP, netns_id,
+					      flags);
 }
 
 static const struct bpf_func_proto bpf_tc_sk_lookup_udp_proto = {
-- 
2.39.2



