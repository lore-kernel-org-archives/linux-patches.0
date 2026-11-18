Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032351;
	b=2CfecnjaFevwmirbIa/MbDWAfzbbKNaUhgR06XSQDOn22GQcJ3qpROD4uUDBSTy77OoA
	 TghgcKYcGo9EDqSVAkN0l8JWF1tKVORqkUwWhAnTn4FI6zpMA+NS2hYC9sN0XncFWtlTk
	 YOs56Dxz+Yyvv1WDSFSC6cNUxVxTHQ/fkHfMNkrDrWNZdn3G6/9LQJ+7QEkbCuNfdsd++
	 RczZKqjZfWIYfWMDRA+L14PzpeK4/5uTkmObRhlZDd2ZaDVfKuj6c6VTYBH3arDNdf7I3
	 iYmPJUYLxz9CbtQh8zEXxAirF8NeGEAdAM9tKRF7N0inNCikiPXvKZ/5jvkLequwkkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=19m997yyxh5fWnZQOlYCjYwFiHk+5lxzaUCc1ZLjEy4=;
	b=r/tbPM58O20QhtQ7x4syMzN6cko7SU+gomDjJ2WOfzJCOkU4uv4d4dCYpXBd1EPLAAp7
	 sCyR1LT8UyZokpWmChIZkYx1CF+uFOQMvi9qXVh9VEskhuPJrg7HVw0dXuWl6h61e7SJH
	 NBHuXb4bzSqwjiqlS0hhQA3kYKwtITT4AlB/slmE2+cazjMRuEbwJ9XUrF9rcpBj45WLq
	 w2QoOa6xy19rY7EvdDmnEIEomcuBQO/9JYD1SCwZ02jL551KTmzRBdHXHEd/I/y8MxmPO
	 wtPqEQITfA1F3/obqsuXoQG5gqV8iuqlhvxX8XcoX7u2VPfEvuwCA69h+Rj5G1hAi8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKpXwDp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1319B606A332;
	Wed, 18 Nov 2026 20:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jKpXwDp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216861F000C4;
	Wed, 18 Nov 2026 20:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032350;
	bh=19m997yyxh5fWnZQOlYCjYwFiHk+5lxzaUCc1ZLjEy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKpXwDp+9d2Bwvu4iJYti+Xt/uAgoGp/1Q0I7upsRK25EMP480nMVzZ9pt5KIvwfd
	 MNK7INJF1XtMklkaMxkx3Q/k+xX1Q2Aa87WpafgmUjsSzEExqPa3t0h5SLLb2xM3le
	 f5+mpftlGOmVRXSeQ5yedm4fJFIoYZUSMjxNmk0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1382/1756] bpf: Reorder bpf_prog_test_run_skb initialization
Date: Wed, 18 Nov 2026 15:58:29 +0100
Message-ID: <20261118150104.203334483@linuxfoundation.org>
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

[ Upstream commit 57bb2f6717930a5e670da179c316159719b724a2 ]

This patch reorders the initialization of bpf_prog_test_run_skb to
simplify the subsequent patch. Program types are checked first, followed
by the ctx init, and finally the data init. With the subsequent patch,
program types and the ctx init provide information that is used in the
data init. Thus, we need the data init to happen last.

Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/063475176f15828a882c07846017394baf72f682.1760037899.git.paul.chaignon@gmail.com
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index afc4caf6be928..34ce8bc15d7cc 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1003,19 +1003,6 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (size < ETH_HLEN)
 		return -EINVAL;
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     size, NET_SKB_PAD + NET_IP_ALIGN,
-			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
-	if (IS_ERR(data))
-		return PTR_ERR(data);
-
-	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
-	if (IS_ERR(ctx)) {
-		ret = PTR_ERR(ctx);
-		ctx = NULL;
-		goto out;
-	}
-
 	switch (prog->type) {
 	case BPF_PROG_TYPE_SCHED_CLS:
 	case BPF_PROG_TYPE_SCHED_ACT:
@@ -1031,6 +1018,19 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 		break;
 	}
 
+	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	data = bpf_test_init(kattr, kattr->test.data_size_in,
+			     size, NET_SKB_PAD + NET_IP_ALIGN,
+			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (IS_ERR(data)) {
+		ret = PTR_ERR(data);
+		data = NULL;
+		goto out;
+	}
+
 	sk = sk_alloc(net, AF_UNSPEC, GFP_USER, &bpf_dummy_proto, 1);
 	if (!sk) {
 		ret = -ENOMEM;
-- 
2.53.0



