Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0C36921B;
	Wed, 30 Sep 2026 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783297; cv=none; b=cGNoUvVIdd2uApC33+gCzgh0Ls3OaLxQQ21l26r2qtdXvzXEfqrwXM7dMZF5QUnF+siKF3Nxy4DkQsXo9sY14v3MjjmpKpLCVZjUZCqHMpLyeG7sb8VaSompdgbICfXo/KbaCudDZESQ4UpzHcxajLRy6v981J/1x+SlYksude8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783297; c=relaxed/simple;
	bh=IAZhhpoorQ0H2/7FUOIzSjpvP7hnPhqMu8oRAnLp4XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UiFtJ0UKdAqV84nNnOe7YDv9yBWLooWlNB6NvXnO2oCoY478jQ+LmS0fd1nLc6x4gmOCDPGNk1IrtVaDENNXawZLOxSCAS/nx7C0ZGFW+rsTVaprNAaY4P20ydBu6kSZqGzjIwFbQJkv3B2LYCoRpGLcT29CK14RIsX3yynLob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFx79Noz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFx79Noz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E9461F000FF;
	Wed, 30 Sep 2026 15:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783293;
	bh=DFEV+DBons3AYWnPuwnRgrgrj42SwGVO7qjDc6QAXec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NFx79NozEwqL/xpiDqEQjFEPlcxwwrLFpu4WcBEGYe7AzAnzY/QnhJ4TWNDyc6SDj
	 1gX2zvmJAl1ve6bpjdmwpK+yTeaTKJ61XKwDXImTnWdFMysSJHBBXLBWoiZt1AhrdK
	 ZzNOcPZw1fQVUFknafect59PDWwC2f7FNv78mtLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 346/595] xfrm: add extack to verify_sec_ctx_len
Date: Wed, 30 Sep 2026 17:23:59 +0200
Message-ID: <20260930152355.121060281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ecc3926ed8f65..d0f68609b6952 100644
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
@@ -1723,7 +1725,7 @@ static int xfrm_add_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(p);
 	if (err)
 		return err;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		return err;
 
@@ -2062,7 +2064,7 @@ static int xfrm_get_policy(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2367,7 +2369,7 @@ static int xfrm_add_pol_expire(struct sk_buff *skb, struct nlmsghdr *nlh,
 		struct nlattr *rt = attrs[XFRMA_SEC_CTX];
 		struct xfrm_sec_ctx *ctx;
 
-		err = verify_sec_ctx_len(attrs);
+		err = verify_sec_ctx_len(attrs, extack);
 		if (err)
 			return err;
 
@@ -2459,7 +2461,7 @@ static int xfrm_add_acquire(struct sk_buff *skb, struct nlmsghdr *nlh,
 	err = verify_newpolicy_info(&ua->policy);
 	if (err)
 		goto free_state;
-	err = verify_sec_ctx_len(attrs);
+	err = verify_sec_ctx_len(attrs, extack);
 	if (err)
 		goto free_state;
 
-- 
2.53.0



