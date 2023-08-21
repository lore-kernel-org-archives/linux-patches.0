Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2994811703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A58C433C8;
	Mon, 21 Aug 2023 19:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647695;
	bh=N0Sm5C3CyWYTVHpMrVwth7L0Uk3+9DKC+c4KbGBEL/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pl2pxYvV22oj7F7C85Yq/MHPR/M5KbYtJURjX0fH7cLPrhLBCK+zRhxnEf0QzHbqj
	 +I2V8jvIsI1QZqTOhJIWoMIs8W/KPmf/NY2eV6AqJIykDEd75POpZn+HMRY+udtZvP
	 OZ2gsfwDyDnAGnWtDAy0fmzbfJf0zwAUW0SU/iUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lin Ma <linma@zju.edu.cn>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 106/194] net: xfrm: Amend XFRMA_SEC_CTX nla_policy structure
Date: Mon, 21 Aug 2023 21:41:25 +0200
Message-ID: <20230821194127.341966540@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index 3e32fe99a6818..c6803318ac63e 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2969,7 +2969,7 @@ const struct nla_policy xfrma_policy[XFRMA_MAX+1] = {
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



