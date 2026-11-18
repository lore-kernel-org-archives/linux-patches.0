Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027414;
	b=JW1Z1Q5mtS32dVrecIaS43PPDdtp90Xn8HfrRq5gE2fdT2ytKamLpmTXP9dIPNp+vvIG
	 PakDZIq506baz2j8eGqKF4pCB20DgeCaZQP3348G64zYej5PfAhFE38FAjobGwWU/rLDU
	 +E/+6YhiQTqabHDnhrvmmxINSWsDU1aZG6X6PBxNK6I4yOi2YxQm6Xj+ZuAdd0MZB9XLo
	 zYvPlxFTGuz9GZ4GXe+l2ULBx6MJawEqaZ8kYKbY1bJlfCPmZIqnLWducficPMDAd71mI
	 ASq80zF+gKaOoh62a8WOFjgsTWYGOuw1bOcn1ztWMmjiBR306w1Gk/NgMp9d/rcaUgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027414;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KS+moDPmWetIMAhHTkHWjXM2J0NrKOfuWkr8TMYezrs=;
	b=wdyW/ZqxoWN2RAWVeHgkaRlXdAzhLOzcQv+JCUen0RwE9Hpsb6wQ5kXp+3HnSQ3k6Npo
	 mLwPdxlI+g/7IB3/XlwGbpMpvXCGlZpFaWKP7Qq+BwOZMxZXrwiQhCiT42LvhHVyvsOh9
	 NUWGBksm1nlR3Por5Rh7K40zGWHqw8yYqTtq6TTSErslxXCN6EJkf9f/a1Aa8L4WdGDRh
	 eosOlHlnFEVqafr4N2Fy/86+v/aLnOlOpvC4dt7ypWaLUEJr4wtsy6D6/JqHoIk0j4tQO
	 ozw6aDW/y8WMcH2ftnAqC5KiPojlfNXjIuXOEmU6FLBieJqLRa3YdYBJf5K47adQA5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWcWUJbq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68969606A32C;
	Wed, 18 Nov 2026 18:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWcWUJbq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8FBF1F000C4;
	Wed, 18 Nov 2026 18:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027414;
	bh=KS+moDPmWetIMAhHTkHWjXM2J0NrKOfuWkr8TMYezrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWcWUJbqt5a2J3092tXt405Kv7c3Wz5vVW7zwChfNn04R7JmrXz9o47bzONx4ZiXW
	 +15zNijXAGFnOszGEJNc29m+VOJw0SaPetLhT/NJhqPEbw80mIqNCv4m/aF3w1h5Ld
	 iY8b6ycMMrf53yL8QqCIjgnxmH13ink/6N0V4H0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1739/2151] bpf: Refactor cleanup of bpf_prog_test_run_skb
Date: Wed, 18 Nov 2026 15:57:54 +0100
Message-ID: <20261118150225.210473068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6648d88b76a5..ad95b37743959 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -984,10 +984,10 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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
 
@@ -1006,8 +1006,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
 	if (IS_ERR(ctx)) {
-		kfree(data);
-		return PTR_ERR(ctx);
+		ret = PTR_ERR(ctx);
+		ctx = NULL;
+		goto out;
 	}
 
 	switch (prog->type) {
@@ -1027,21 +1028,20 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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
 
@@ -1161,7 +1161,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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



