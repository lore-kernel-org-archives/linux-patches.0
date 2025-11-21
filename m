Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D635934CFC6;
	Fri, 21 Nov 2025 13:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733394; cv=none; b=o6dxsglTS7dx3xPfy6vg8soN9SNmmP/A+3+E2ohvOK8PGIemN8u80JlYXCLJMAimXxdo2jIp3HiA8jl5PZ9E32Yg14zJv+iowcXBsMAs9pEDcscX2yXpJHUSbGYfqaMAVTsiFoak22I690I+MBzrMFKESld0USD/pwo9Dd3sR9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733394; c=relaxed/simple;
	bh=e+zUI+foOeFJpJTJdsSV9dSl8Cnl2JgiBYUAaeIOIQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRwV+mWvaWI8OZQdXntOqy99UeEAeFr9eT1eGKOaPYk7TwJL5HhuSXKUG4ioq338959l3FSBlknocYH1nJ+VdAw03SeLHXCium8QbRkD7yVC66DZQKWiyza+1rjuV4iNocOGT+3SnWn2IgoYqj70Xj1gFnG1QrMZ4s1HVLUeSYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqVgjiU/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqVgjiU/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1575C116D0;
	Fri, 21 Nov 2025 13:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733394;
	bh=e+zUI+foOeFJpJTJdsSV9dSl8Cnl2JgiBYUAaeIOIQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqVgjiU/3f70dafZIN1ok94MtAvPLtGKSRAIiXwweSsEFIB4mU00Mza7OWg5IvEg+
	 wtxwaDQUGoIAonS9ITZjyhRqgDVK9MGBCg10Ejymwa7mSyFbg1dMxSuUqx46RgyzgT
	 8MlhKJgxCBOKrmeW966OiAr0yhRxVPoHlo7zz35E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Ruohan Lan <ruohanlan@aliyun.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 452/529] espintcp: fix skb leaks
Date: Fri, 21 Nov 2025 14:12:31 +0100
Message-ID: <20251121130247.092082979@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 63c1f19a3be3169e51a5812d22a6d0c879414076 ]

A few error paths are missing a kfree_skb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
[ Minor context change fixed. ]
Signed-off-by: Ruohan Lan <ruohanlan@aliyun.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/esp4.c     | 4 +++-
 net/ipv6/esp6.c     | 4 +++-
 net/xfrm/espintcp.c | 4 +++-
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/esp4.c b/net/ipv4/esp4.c
index 49fd664f50fc0..2caf6a2a819b2 100644
--- a/net/ipv4/esp4.c
+++ b/net/ipv4/esp4.c
@@ -152,8 +152,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/ipv6/esp6.c b/net/ipv6/esp6.c
index 7e4c8628cf983..2caaab61b9967 100644
--- a/net/ipv6/esp6.c
+++ b/net/ipv6/esp6.c
@@ -169,8 +169,10 @@ static int esp_output_tcp_finish(struct xfrm_state *x, struct sk_buff *skb)
 
 	sk = esp6_find_tcp_sk(x);
 	err = PTR_ERR_OR_ZERO(sk);
-	if (err)
+	if (err) {
+		kfree_skb(skb);
 		goto out;
+	}
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk))
diff --git a/net/xfrm/espintcp.c b/net/xfrm/espintcp.c
index d3b3f9e720b3b..427072285b8c7 100644
--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -169,8 +169,10 @@ int espintcp_queue_out(struct sock *sk, struct sk_buff *skb)
 {
 	struct espintcp_ctx *ctx = espintcp_getctx(sk);
 
-	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog))
+	if (skb_queue_len(&ctx->out_queue) >= READ_ONCE(netdev_max_backlog)) {
+		kfree_skb(skb);
 		return -ENOBUFS;
+	}
 
 	__skb_queue_tail(&ctx->out_queue, skb);
 
-- 
2.51.0



