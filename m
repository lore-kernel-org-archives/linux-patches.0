Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032348;
	b=Hu8mMwWVfPTFJsqw3x5AOw/bNXoVvc5RCg4t7fy5lM1Lnv63yhvGN7BjiHgFvmBeAWnO
	 0AB1qF7N8WAI6sLYFsdOEpM17D0rsqnf8rUOv09SWdqG2wYDEJPHzguK1zqe9vZMfga0p
	 gnqG7CrfuKGW2LvMra7z8MciWxQfx0Q49F464k3V72dhidOst7gxUUPGcrV2VWnydEVez
	 qE2Wt3n7I+KVEFN4x/lDcEVuixPMDgxtJjEIzwnaiXwOLA4ASAy2xGkkZBzKxzxdOxtCc
	 nplM20/5UuOIGZqzhh0RMBhLGGNdSnhQl6LORI8PRrlNQd2lZZtBLtnBpxe4D220obg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O8vur5BuQozn7/zdT0859IQb3tpKsIfXZsFHDfw2vk0=;
	b=omQqQavzoUulxEe3NxqML6yXpcpStHR5dQhQIp7QJfbZH5lAdGkr6SMyAcoOCcLA8FSb
	 UyfQfj0fYjcJLrCghKKbGtN0RDyOwc+kz4xTXNsW3p01QYKRAC0D6hnT08mppctZXxl37
	 6L4c+Li3pI91Hq34HuICXwYY8VNHW/HYNxkM/K8QAu8adIBVOeuOCPTPOMeloo8RIGV6F
	 tjUD2uKjb7KXP3fk//9vZViVJx7isU8bdCDK8mSC4c+BmEl1L7vdoUXRkIQMl9vmzU7sA
	 dWWL48XwQjY0IaAxj1o39FWoHA0wBhlFmhDwi91otup8ncg3yopcGYrL0blto/HjQ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMUrHY1y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1435606A332;
	Wed, 18 Nov 2026 20:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CMUrHY1y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EAE1F000C5;
	Wed, 18 Nov 2026 20:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032347;
	bh=O8vur5BuQozn7/zdT0859IQb3tpKsIfXZsFHDfw2vk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CMUrHY1yxMPdR/sGneGfvTGUDqDeFB34fz6qnBKBxglxBbQcMzHqMHGif8WH7pq+G
	 YeKaa9em+9PwivNAqKk5E0cg0cSZgPdESrhkugnMp9XVWbqv2csl+SuGQJAICvk5HL
	 Ytsjx4i0krwPw/oGYLPo5AC/B1dLN+XrNzpzMuZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1381/1756] bpf: Refactor cleanup of bpf_prog_test_run_skb
Date: Wed, 18 Nov 2026 15:58:28 +0100
Message-ID: <20261118150104.165882950@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit d8accf661fcf3088ef4c349ab56ecd19a5071b19 ]

This bit of refactoring aims to simplify how we free memory in
bpf_prog_test_run_skb to avoid code duplication.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Link: https://patch.msgid.link/8971e01ae87b84f5af6b8b40defd3c310faf1c0f.1760037899.git.paul.chaignon@gmail.com
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index daafbaa488f25..afc4caf6be928 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -989,10 +989,10 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	u32 size = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
+	struct sk_buff *skb = NULL;
+	struct sock *sk = NULL;
 	u32 retval, duration;
 	int hh_len = ETH_HLEN;
-	struct sk_buff *skb;
-	struct sock *sk;
 	void *data;
 	int ret;
 
@@ -1011,8 +1011,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
 	if (IS_ERR(ctx)) {
-		kfree(data);
-		return PTR_ERR(ctx);
+		ret = PTR_ERR(ctx);
+		ctx = NULL;
+		goto out;
 	}
 
 	switch (prog->type) {
@@ -1032,21 +1033,20 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
-		kfree(data);
-		kfree(ctx);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 	sock_init_data(NULL, sk);
 
 	skb = slab_build_skb(data);
 	if (!skb) {
-		kfree(data);
-		kfree(ctx);
-		sk_free(sk);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 	skb->sk = sk;
 
+	data = NULL; /* data released via kfree_skb */
+
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
 	__skb_put(skb, size);
 
@@ -1166,7 +1166,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (dev && dev != net->loopback_dev)
 		dev_put(dev);
 	kfree_skb(skb);
-	sk_free(sk);
+	kfree(data);
+	if (sk)
+		sk_free(sk);
 	kfree(ctx);
 	return ret;
 }
-- 
2.53.0



