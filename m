Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B755718DF9D;
	Tue, 26 Aug 2025 11:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208118; cv=none; b=gF9u3K+rZWeCYm6Q9aMJ0gP5E+7TnfZWmzsJJKei28UCKkK4cDbLJ+IeoFXOkGJHhH19EK/FDMmHQbspyWtCfTcdzL0LQm8UqT0Hg8W7KHv8dArYFEubtpHzXc0mIv0uv/c9Iauss/mL9OtkE/p/Q03dZxUwfZRfp7OYAoXVvkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208118; c=relaxed/simple;
	bh=z0iHdEifPBUbkLFyUokutelBdFn0AaB3U2Z0jZivJcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLH9WkPEByGQ9gXeNLoxXEU8KLoZwkSHAtBireiXa5TZV/1FPu5VqJ2o9fX7ja2dMrvlw6O1o6+paNEq+FPYHCh2v0oVsMXYzlGhBkfYd9V5onI6aWNb8+hRsPO3jBij0r7ln5uMNaqG85zdkBV5CkK38n+1Dc2O5nvjx7ptRj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyVgD/S9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyVgD/S9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DD6C4CEF1;
	Tue, 26 Aug 2025 11:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208118;
	bh=z0iHdEifPBUbkLFyUokutelBdFn0AaB3U2Z0jZivJcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyVgD/S9BXarcSxA95/LcnF+Uml/VmLDdgq6JMDnThjNrMWCSbo6vZ1Q9wPpXC4Fz
	 V5xS+MPAJNA4S3GUAl3v1GaYQ9sbWTIl/eCM9s5zNkqlNAs8Yg+HocgCGrlVg6BVOv
	 tYkF8D+R8FWv/6wZXkwds+nNnCkMUP3lYSFtX6eQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 417/457] net/mlx5: HWS, fix complex rules rehash error flow
Date: Tue, 26 Aug 2025 13:11:41 +0200
Message-ID: <20250826110947.599147971@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 4a842b1bf18a32ee0c25dd6dd98728b786a76fe4 ]

Moving rules from matcher to matcher should not fail.
However, if it does fail due to various reasons, the error flow
should allow the kernel to continue functioning (albeit with broken
steering rules) instead of going into series of soft lock-ups or
some other problematic behaviour.

Similar to the simple rules, complex rules rehash logic suffers
from the same problems. This patch fixes the error flow for moving
complex rules:
 - If new rule creation fails before it was even enqeued, do not
   poll for completion
 - If TIMEOUT happened while moving the rule, no point trying
   to poll for completions for other rules. Something is broken,
   completion won't come, just abort the rehash sequence.
 - If some other completion with error received, don't give up.
   Continue handling rest of the rules to minimize the damage.
 - Make sure that the first error code that was received will
   be actually returned to the caller instead of replacing it
   with the generic error code.

All the aforementioned issues stem from the same bad error flow,
so no point fixing them one by one and leaving partially broken
code - fixing them in one patch.

Fixes: 17e0accac577 ("net/mlx5: HWS, support complex matchers")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250817202323.308604-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mlx5/core/steering/hws/bwc_complex.c      | 41 +++++++++++++------
 1 file changed, 28 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc_complex.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc_complex.c
index ca7501c57468..14e79579c719 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc_complex.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc_complex.c
@@ -1328,11 +1328,11 @@ mlx5hws_bwc_matcher_move_all_complex(struct mlx5hws_bwc_matcher *bwc_matcher)
 {
 	struct mlx5hws_context *ctx = bwc_matcher->matcher->tbl->ctx;
 	struct mlx5hws_matcher *matcher = bwc_matcher->matcher;
-	bool move_error = false, poll_error = false;
 	u16 bwc_queues = mlx5hws_bwc_queues(ctx);
 	struct mlx5hws_bwc_rule *tmp_bwc_rule;
 	struct mlx5hws_rule_attr rule_attr;
 	struct mlx5hws_table *isolated_tbl;
+	int move_error = 0, poll_error = 0;
 	struct mlx5hws_rule *tmp_rule;
 	struct list_head *rules_list;
 	u32 expected_completions = 1;
@@ -1391,11 +1391,15 @@ mlx5hws_bwc_matcher_move_all_complex(struct mlx5hws_bwc_matcher *bwc_matcher)
 			ret = mlx5hws_matcher_resize_rule_move(matcher,
 							       tmp_rule,
 							       &rule_attr);
-			if (unlikely(ret && !move_error)) {
-				mlx5hws_err(ctx,
-					    "Moving complex BWC rule failed (%d), attempting to move rest of the rules\n",
-					    ret);
-				move_error = true;
+			if (unlikely(ret)) {
+				if (!move_error) {
+					mlx5hws_err(ctx,
+						    "Moving complex BWC rule: move failed (%d), attempting to move rest of the rules\n",
+						    ret);
+					move_error = ret;
+				}
+				/* Rule wasn't queued, no need to poll */
+				continue;
 			}
 
 			expected_completions = 1;
@@ -1403,11 +1407,19 @@ mlx5hws_bwc_matcher_move_all_complex(struct mlx5hws_bwc_matcher *bwc_matcher)
 						     rule_attr.queue_id,
 						     &expected_completions,
 						     true);
-			if (unlikely(ret && !poll_error)) {
-				mlx5hws_err(ctx,
-					    "Moving complex BWC rule: poll failed (%d), attempting to move rest of the rules\n",
-					    ret);
-				poll_error = true;
+			if (unlikely(ret)) {
+				if (ret == -ETIMEDOUT) {
+					mlx5hws_err(ctx,
+						    "Moving complex BWC rule: timeout polling for completions (%d), aborting rehash\n",
+						    ret);
+					return ret;
+				}
+				if (!poll_error) {
+					mlx5hws_err(ctx,
+						    "Moving complex BWC rule: polling for completions failed (%d), attempting to move rest of the rules\n",
+						    ret);
+					poll_error = ret;
+				}
 			}
 
 			/* Done moving the rule to the new matcher,
@@ -1422,8 +1434,11 @@ mlx5hws_bwc_matcher_move_all_complex(struct mlx5hws_bwc_matcher *bwc_matcher)
 		}
 	}
 
-	if (move_error || poll_error)
-		ret = -EINVAL;
+	/* Return the first error that happened */
+	if (unlikely(move_error))
+		return move_error;
+	if (unlikely(poll_error))
+		return poll_error;
 
 	return ret;
 }
-- 
2.50.1



