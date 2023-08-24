Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6D14A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D672C433C8;
	Thu, 24 Aug 2023 17:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897548;
	bh=S/JbY81NrhZM+8p/vycPNnp41/mB2/EBts/2jZfv11U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DABR2fVfiBItBggn9r6diHwCQu78YquEJXTvqhemzTl8RnCTBdKI/KXz/g/L7INe2
	 vTzDqLHLfjvNIW4T2+KgU4eYF0mg+EnWCnAmwOYtEiJ1gTG9E9MVfj+ClEnvFtabvg
	 Pk+/ndMPNgR8l+cXKV6YjLyX6ltJrgRw/mvhd4Zk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 078/135] net: xfrm: Amend XFRMA_SEC_CTX nla_policy structure
Date: Thu, 24 Aug 2023 19:09:10 +0200
Message-ID: <20230824170620.623678557@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Lin Ma <linma@zju.edu.cn>

[ Upstream commit d1e0e61d617ba17aa516db707aa871387566bbf7 ]

According to all consumers code of attrs[XFRMA_SEC_CTX], like

* verify_sec_ctx_len(), convert to xfrm_user_sec_ctx*
* xfrm_state_construct(), call security_xfrm_state_alloc whose prototype
is int security_xfrm_state_alloc(.., struct xfrm_user_sec_ctx *sec_ctx);
* copy_from_user_sec_ctx(), convert to xfrm_user_sec_ctx *
...

It seems that the expected parsing result for XFRMA_SEC_CTX should be
structure xfrm_user_sec_ctx, and the current xfrm_sec_ctx is confusing
and misleading (Luckily, they happen to have same size 8 bytes).

This commit amend the policy structure to xfrm_user_sec_ctx to avoid
ambiguity.

Fixes: cf5cb79f6946 ("[XFRM] netlink: Establish an attribute policy")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_compat.c | 2 +-
 net/xfrm/xfrm_user.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index 8cbf45a8bcdc2..655fe4ff86212 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -108,7 +108,7 @@ static const struct nla_policy compat_policy[XFRMA_MAX+1] = {
 	[XFRMA_ALG_COMP]	= { .len = sizeof(struct xfrm_algo) },
 	[XFRMA_ENCAP]		= { .len = sizeof(struct xfrm_encap_tmpl) },
 	[XFRMA_TMPL]		= { .len = sizeof(struct xfrm_user_tmpl) },
-	[XFRMA_SEC_CTX]		= { .len = sizeof(struct xfrm_sec_ctx) },
+	[XFRMA_SEC_CTX]		= { .len = sizeof(struct xfrm_user_sec_ctx) },
 	[XFRMA_LTIME_VAL]	= { .len = sizeof(struct xfrm_lifetime_cur) },
 	[XFRMA_REPLAY_VAL]	= { .len = sizeof(struct xfrm_replay_state) },
 	[XFRMA_REPLAY_THRESH]	= { .type = NLA_U32 },
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 025401bfa3e1e..0de7d0cf7be0f 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2737,7 +2737,7 @@ const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
 	[XFRMA_ALG_COMP]	= { .len = sizeof(struct xfrm_algo) },
 	[XFRMA_ENCAP]		= { .len = sizeof(struct xfrm_encap_tmpl) },
 	[XFRMA_TMPL]		= { .len = sizeof(struct xfrm_user_tmpl) },
-	[XFRMA_SEC_CTX]		= { .len = sizeof(struct xfrm_sec_ctx) },
+	[XFRMA_SEC_CTX]		= { .len = sizeof(struct xfrm_user_sec_ctx) },
 	[XFRMA_LTIME_VAL]	= { .len = sizeof(struct xfrm_lifetime_cur) },
 	[XFRMA_REPLAY_VAL]	= { .len = sizeof(struct xfrm_replay_state) },
 	[XFRMA_REPLAY_THRESH]	= { .type = NLA_U32 },
-- 
2.40.1



