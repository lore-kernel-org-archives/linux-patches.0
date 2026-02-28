Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA71532AABE
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301221; cv=none; b=O39LqcvpQ+GZrUznBdvgkMT72AffIYVA1+xEF4lTY/GBiQ+ZHhO9OllvHKwtsAH2obBOTCXHepofy6s+Vx0turp0lPDbK7mgBSgin7PTu/V1E9FkT9K1M8j79vELzGnOXpfXomzs6in6+DxHsNwXWojgGz/ia4JmGTEDTrSR5YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301221; c=relaxed/simple;
	bh=fQBx7ID8R19kwDXm1s3pbxKnmBmO0qJDPrYFYhjrKog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMnAM7mHGO2OdTfBbO5Peg4a3M9hMXX2pT/IJabNg9PCQwM1TE6TXQibNcfVYMCvgxXG/YenAWER5S0mxjKg4XFlPdGl2wTabCrlTS086Ng6mUIvEo15pRt06munUvnqVV973vGleWb6qa/uIE6NrVmR89jHpKaDE9wohhuAEXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T8MuY5oo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T8MuY5oo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC682C19423;
	Sat, 28 Feb 2026 17:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301221;
	bh=fQBx7ID8R19kwDXm1s3pbxKnmBmO0qJDPrYFYhjrKog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T8MuY5oo5Ny1Co9TlYEGoASUjpaWwbBrpBc5HaDTN72aHKeWDRDLvmFIjpR+oL9NI
	 2Ia1npwgMGNPwk5JQxjZg9roqut1zOkH9GDQ9zqUGJ50CU5BHDaMJxXZa+1Fgi0x/X
	 fcAHn1iSL+eG9riUnZ0rwu+fKSR8MO8fahObVF3FkiT9r2g+jDZMKr29tmMUCcXTx3
	 MuUXryekCgtr4AEonnM+B8vNrh27/CQYz8hNv4VW1v2zo8NjN4V5kXzSl7xpcsLZ2n
	 EfkUZgqJw2NgNpug1X+g0FOi3gy90+bZRNfpBsUx/vcpdVkRnLd9cIJ3qVIPllydk5
	 ed5z5sr1uiokw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 398/752] xfrm: skip templates check for packet offload tunnel mode
Date: Sat, 28 Feb 2026 12:41:49 -0500
Message-ID: <20260228174750.1542406-398-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 0a4524bc69882a4ddb235bb6b279597721bda197 ]

In packet offload, hardware is responsible to check templates. The
result of its operation is forwarded through secpath by relevant
drivers. That secpath is actually removed in __xfrm_policy_check2().

In case packet is forwarded, this secpath is reset in RX, but pushed
again to TX where policy is rechecked again against dummy secpath
in xfrm_policy_ok().

Such situation causes to unexpected XfrmInTmplMismatch increase.

As a solution, simply skip template mismatch check.

Fixes: 600258d555f0 ("xfrm: delete intermediate secpath entry in packet offload mode")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 62486f8669752..5428185196a1f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -3801,8 +3801,8 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		struct xfrm_tmpl *tp[XFRM_MAX_DEPTH];
 		struct xfrm_tmpl *stp[XFRM_MAX_DEPTH];
 		struct xfrm_tmpl **tpp = tp;
+		int i, k = 0;
 		int ti = 0;
-		int i, k;
 
 		sp = skb_sec_path(skb);
 		if (!sp)
@@ -3828,6 +3828,12 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			tpp = stp;
 		}
 
+		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET && sp == &dummy)
+			/* This policy template was already checked by HW
+			 * and secpath was removed in __xfrm_policy_check2.
+			 */
+			goto out;
+
 		/* For each tunnel xfrm, find the first matching tmpl.
 		 * For each tmpl before that, find corresponding xfrm.
 		 * Order is _important_. Later we will implement
@@ -3837,7 +3843,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 		 * verified to allow them to be skipped in future policy
 		 * checks (e.g. nested tunnels).
 		 */
-		for (i = xfrm_nr-1, k = 0; i >= 0; i--) {
+		for (i = xfrm_nr - 1; i >= 0; i--) {
 			k = xfrm_policy_ok(tpp[i], sp, k, family, if_id);
 			if (k < 0) {
 				if (k < -1)
@@ -3853,6 +3859,7 @@ int __xfrm_policy_check(struct sock *sk, int dir, struct sk_buff *skb,
 			goto reject;
 		}
 
+out:
 		xfrm_pols_put(pols, npols);
 		sp->verified_cnt = k;
 
-- 
2.51.0

