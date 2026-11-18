Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042005;
	b=lKjS2yBqVVYa2tlRameaN4aaCXmgZSkoLd1f9MNjvtFelso+jby2HWXYHr9mlmojHWZd
	 8lMKbEng1a4drtGnVSVsHonIzvR6Fp/8ojCGEk1kGeJal0soMng2zO1zFa/bUlQYyV6PT
	 L1be7Ncw2oW4lgRze6i+8iKSS+d9qzlZ+zkNivU+o4oTL2+4oxvOF/VkMasb8jmqyB0tR
	 2UzwIRuUa8oi2mUIzcCGTPbO4HDPWxhQ3eeuOV8P8PTXkFftZWLTf2/okmB4okq3gh/Ih
	 InLgF//sjAYIewkGmLDgauDGCjzaw1rCxPeRSpqNNZ+m78EStJizwcCy/cfIhkt3v4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042005;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lB2fZX7GqZkkXvK2boSoQE1oJBRE1wWrVtqeI5rJ7Ck=;
	b=cDPnl2G1z7RVFO4w7guKRrB1kVl1UDjTrmEXxJ03mmA7OkxLXJqKisGiDwPXI9yQDRwh
	 fzNFGM0O00FK1W60+flm/XMRbqBNR0N0LKGdTmIrmYELRqv8ckoUbV/wOjpKFxa0jeUDB
	 Sg203XksbEVBAGE9yezkVmmuiFSuLPUWIBsv2WvvXfQv/z4HOXFf8JQvUDhkyf4LE986M
	 WmKnl7c0LKDWWB+6oV/H2J7LiuBMjTk593eVn3qFoU75oRFcj+txmwMkelwNyIU/LF/9l
	 Ma03yHx+8YLMUKXQS/pluUbkEDQQa2TzDI1Gda3N/DtgAVe+6sV9lLzKZVJasEV3bzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpSBlmM2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E63606A31C;
	Wed, 18 Nov 2026 22:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SpSBlmM2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E44EB1F000C4;
	Wed, 18 Nov 2026 22:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042005;
	bh=lB2fZX7GqZkkXvK2boSoQE1oJBRE1wWrVtqeI5rJ7Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SpSBlmM2r2UaKp6SaUnggsJc3J/IdG4kjRchrjKswwLFAMQklYR7x/YCaBIPFUbcZ
	 l62cOqosgEieij3bbaxtMS9c4WePApngPIGLB0J4P6b1FmIyJt0NV13JUOOFL51yn6
	 ToMb9Gidaxfz4PynlYun+a1kcAxXM8clkJfIcPwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3015/3318] bpf: Refactor cleanup of bpf_prog_test_run_skb
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150450.674008064@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d70543fb6849b..2522b0f79d15f 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -959,10 +959,10 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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
 
@@ -981,8 +981,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	ctx = bpf_ctx_init(kattr, sizeof(struct __sk_buff));
 	if (IS_ERR(ctx)) {
-		kfree(data);
-		return PTR_ERR(ctx);
+		ret = PTR_ERR(ctx);
+		ctx = NULL;
+		goto out;
 	}
 
 	switch (prog->type) {
@@ -1002,21 +1003,20 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
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
 
@@ -1136,7 +1136,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
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



