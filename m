Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4F914A81
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D39C433C0;
	Mon, 26 Jun 2023 18:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804301;
	bh=e9BN1bGmFY7iZO681oDhauhSqqnPJnGovo/jqsR3Lc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6N8i+uTdGVZD1QbOYHXC8og+RQ09xfVHn0GgOrGf4squv86CS/VEKcRdTEVF2nz1
	 2k1qJA8O4sGot09qaBXGZg5tPcvaKH4NdFv2RH4x8t0BIrIjosYT2czVJyfGNvxMlW
	 vKz9K20itp1d2adqF4N6y539XNB/zF3RgFFeMBEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedict Wong <benedictwong@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/170] xfrm: Treat already-verified secpath entries as optional
Date: Mon, 26 Jun 2023 20:10:51 +0200
Message-ID: <20230626180804.279480166@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Benedict Wong <benedictwong@google.com>

[ Upstream commit 1f8b6df6a997a430b0c48b504638154b520781ad ]

This change allows inbound traffic through nested IPsec tunnels to
successfully match policies and templates, while retaining the secpath
stack trace as necessary for netfilter policies.

Specifically, this patch marks secpath entries that have already matched
against a relevant policy as having been verified, allowing it to be
treated as optional and skipped after a tunnel decapsulation (during
which the src/dst/proto/etc may have changed, and the correct policy
chain no long be resolvable).

This approach is taken as opposed to the iteration in b0355dbbf13c,
where the secpath was cleared, since that breaks subsequent validations
that rely on the existence of the secpath entries (netfilter policies, or
transport-in-tunnel mode, where policies remain resolvable).

Fixes: b0355dbbf13c ("Fix XFRM-I support for nested ESP tunnels")
Test: Tested against Android Kernel Unit Tests
Test: Tested against Android CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     |  1 +
 net/xfrm/xfrm_input.c  |  1 +
 net/xfrm/xfrm_policy.c | 12 ++++++++++++
 3 files changed, 14 insertions(+)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index dbc81f5eb5538..9ec6f2e92ad3a 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1039,6 +1039,7 @@ struct xfrm_offload {
 struct sec_path {
 	int			len;
 	int			olen;
+	int			verified_cnt;
 
 	struct xfrm_state	*xvec[XFRM_MAX_DEPTH];
 	struct xfrm_offload	ovec[XFRM_MAX_OFFLOAD_DEPTH];
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 2defd89da700d..ac1a645afa8df 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -131,6 +131,7 @@ struct sec_path *secpath_set(struct sk_buff *skb)
 	memset(sp->ovec, 0, sizeof(sp->ovec));
 	sp->olen = 0;
 	sp->len = 0;
+	sp->verified_cnt = 0;
 
 	return sp;
 }
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index e894c269affb1..7b1b93584bdbe 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3274,6 +3274,13 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 		if (xfrm_state_ok(tmpl, sp->xvec[idx], family, if_id))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
+			if (idx < sp->verified_cnt) {
+				/* Secpath entry previously verified, consider optional and
+				 * continue searching
+				 */
+				continue;
+			}
+
 			if (start == -1)
 				start = -2-idx;
 			break;
@@ -3648,6 +3655,9 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * Order is _important_. Later we will implement
 		 * some barriers, but at the moment barriers
 		 * are implied between each two transformations.
+		 * Upon success, marks secpath entries as having been
+		 * verified to allow them to be skipped in future policy
+		 * checks (e.g. nested tunnels).
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
@@ -3666,6 +3676,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		}
 
 		xfrm_pols_put(pols, npols);
+		sp->verified_cnt = k;
+
 		return 1;
 	}
 	XFRM_INC_STATS(net, LINUX_MIB_XFRMINPOLBLOCK);
-- 
2.39.2



