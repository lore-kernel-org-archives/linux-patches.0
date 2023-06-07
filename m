Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D763922F
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:59:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53DC1C433D2;
	Wed,  7 Jun 2023 20:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171547;
	bh=kvlpBW7tWVIYJdrSGv/0wHiFnZ1LPozZ+CToK+q9Zlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBGpX9zKI3wbsykDCntEG25stLJ2di1Vh6n/AbOUyl7TQ464acAVBpZIKt+L7mcxM
	 sjgb1oYuMpdgd2p5HianccpI8oxYkByfUe8lB8ub0B6t/yzRNsXqbyDus7+HOxzYHQ
	 xxEInilM35t8CG2q9jexdFWed4RGoSYQI2bBP/QA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benedict Wong <benedictwong@google.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/159] xfrm: Check if_id in inbound policy/secpath match
Date: Wed,  7 Jun 2023 22:16:03 +0200
Message-ID: <20230607200905.652344637@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
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

[ Upstream commit 8680407b6f8f5fba59e8f1d63c869abc280f04df ]

This change ensures that if configured in the policy, the if_id set in
the policy and secpath states match during the inbound policy check.
Without this, there is potential for ambiguity where entries in the
secpath differing by only the if_id could be mismatched.

Notably, this is checked in the outbound direction when resolving
templates to SAs, but not on the inbound path when matching SAs and
policies.

Test: Tested against Android kernel unit tests & CTS
Signed-off-by: Benedict Wong <benedictwong@google.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index c15ef8003caa9..3e28a84ab9227 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3238,7 +3238,7 @@ xfrm_secpath_reject(int idx, struct sk_buff *skb, const struct flowi *fl)
 
 static inline int
 xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
-	      unsigned short family)
+	      unsigned short family, u32 if_id)
 {
 	if (xfrm_state_kern(x))
 		return tmpl->optional && !xfrm_state_addr_cmp(tmpl, x, tmpl->encap_family);
@@ -3249,7 +3249,8 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
 		(tmpl->allalgs || (tmpl->aalgos & (1<<x->props.aalgo)) ||
 		 !(xfrm_id_proto_match(tmpl->id.proto, IPSEC_PROTO_ANY))) &&
 		!(x->props.mode != XFRM_MODE_TRANSPORT &&
-		  xfrm_state_addr_cmp(tmpl, x, family));
+		  xfrm_state_addr_cmp(tmpl, x, family)) &&
+		(if_id == 0 || if_id == x->if_id);
 }
 
 /*
@@ -3261,7 +3262,7 @@ xfrm_state_ok(const struct xfrm_tmpl *tmpl, const struct xfrm_state *x,
  */
 static inline int
 xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int start,
-	       unsigned short family)
+	       unsigned short family, u32 if_id)
 {
 	int idx = start;
 
@@ -3271,7 +3272,7 @@ xfrm_policy_ok(const struct xfrm_tmpl *tmpl, const struct sec_path *sp, int star
 	} else
 		start = -1;
 	for (; idx < sp->len; idx++) {
-		if (xfrm_state_ok(tmpl, sp->xvec[idx], family))
+		if (xfrm_state_ok(tmpl, sp->xvec[idx], family, if_id))
 			return ++idx;
 		if (sp->xvec[idx]->props.mode != XFRM_MODE_TRANSPORT) {
 			if (start == -1)
@@ -3648,7 +3649,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * are implied between each two transformations.
 		 */
 		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
-			k = xfrm_policy_ok(tpp[i], sp, k, family);
+			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
 			if (k < 0) {
 				if (k < -1)
 					/* "-2 - errored_index" returned */
-- 
2.39.2



