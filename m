Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E627737A825;
	Wed, 30 Sep 2026 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791824; cv=none; b=vFDLbCxCccJeCqZIItjBNsusDkm/E9lE9D0oWbDq3X6uNaC0crKkLLsDnRXKfOcIfRox711b7ACcLKVbrNi5rYbSG2/gldDM55wLgOyhkhSeDDYX0rB5+GCGvHn7id2xn+T1lCy3nxe+fQSOrubdGfrPrdgnn96aieX/ONssZiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791824; c=relaxed/simple;
	bh=NtNyAlxtx+7CSQnmJFJ7CzZRaVbUjiVSW+uFNhc4BMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sio4oWgFn0dNv7my5VuchjfhpHICR+boNICi9/ZlVjrdhJH2mn11zCPRUlRVJ9n4bLlfCN+nIwNX4jjGGYxsMN6isS2rllrx5OzF2jJtYVyDpPdRvrCN8wARYtGe5XZn6+fVb7XpyL+Ig68wciCFjFe4L3LogNTLNKcpW6uM7h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5LKaWE2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5LKaWE2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4A71F000FF;
	Wed, 30 Sep 2026 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791822;
	bh=X27zNLwnyDl52tCyFQlB7wgRvjpm/Z/8N7Ach24JAlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5LKaWE2EvlWzprZXQhX3Klntpvf1aT5wyx0/uvUX8kmwij0vXGXI4yxysK3/ZxvD
	 kbSs6GQlkdfsgn8KbXl9TPQObTt2DHhYXk+UgLfBZkz/D0arDF6TNZuRPd1PKNoPTm
	 S+w6DjwOrZd9fOuD0rY1uQAQhQQ8RIQGEBQ8ZVGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/752] xfrm: add extack to verify_sec_ctx_len
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152407.763395704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 08a717e4803798e066aa6b69ebf69da9fc8e1758 ]

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: d1ebd9081879 ("xfrm: fix compat ALLOCSPI request use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index cd720c6b87949..419e70b887512 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -101,7 +101,7 @@ static void verify_one_addr(struct nlattr **attrs, enum xfrm_attr_type_t type,
 		*addrp = nla_data(rt);
 }
 
-static inline int verify_sec_ctx_len(struct nlattr **attrs)
+static inline int verify_sec_ctx_len(struct nlattr **attrs, struct netlink_ext_ack *extack)
 {
 	struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 	struct xfrm_user_sec_ctx *uctx;
@@ -111,8 +111,10 @@ static inline int verify_sec_ctx_len(struct nlattr **attrs)
 
 	uctx = nla_data(rt);
 	if (uctx->len > nla_len(rt) ||
-	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len))
+	    uctx->len != (sizeof(struct xfrm_user_sec_ctx) + uctx->ctx_len)) {
+		NL_SET_ERR_MSG(extack, "Invalid security context length");
 		return -EINVAL;
+	}
 
 	return 0;
 }
@@ -267,7 +269,7 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 		goto out;
 	if ((err = verify_one_alg(attrs, XFRMA_ALG_COMP)))
 		goto out;
-	if ((err = verify_sec_ctx_len(attrs)))
+	if ((err = verify_sec_ctx_len(attrs, NULL)))
 		goto out;
 	if ((err = verify_replay(p, attrs)))
 		goto out;
@@ -1822,7 +1824,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(p);
 	if (err)
 		return err;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		return err;
 
@@ -2161,7 +2163,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2466,7 +2468,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2558,7 +2560,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(&ua->policy);
 	if (err)
 		goto free_state;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		goto free_state;
 
-- 
2.53.0



