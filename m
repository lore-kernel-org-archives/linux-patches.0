Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5147F19C554;
	Mon, 23 Jun 2025 21:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714062; cv=none; b=l25+7CW9fp1JHdhK5OwgggI8xk+SCFjhNi6smu8PxT/GohwJ8faTe+tPu4bRs1kSq/dcYRIHrsWEDkiveCF9w44+daQiKaqCLigG6XqBV2mzO1XXBkOYJ+vtxen32054NZmM3podk6i+vJeG48DYvKSUShFZGdY9C3bj+qy4+OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714062; c=relaxed/simple;
	bh=rjTqYtR6t9kcTXcwXjGihMn4i61bjaI5b+7L4iPyHXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQ2dkBmO94IYdAt9bf7ttxrn9xdciaJ5yNKct/1bEN0NktrYi+Kul6Ytt+3OvUJq+Oz324WlNEh8oR36SmDLFlfknxam3IPuSb8tNDjNfwEN2slY+O7c9u7xlvMwpSrMUUe57i1tT9fFe99i83jeDS2IlzBk9bBsML7G4Md7T8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4DO7uVi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4DO7uVi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF119C4CEEA;
	Mon, 23 Jun 2025 21:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714062;
	bh=rjTqYtR6t9kcTXcwXjGihMn4i61bjaI5b+7L4iPyHXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R4DO7uViGTOj3GSWS90Pf12Nm0+5rzqSxu7WJn7fWV/+5Aj2kWWeB5U/9YyfaIV0n
	 3O1CdbEXcK3IRmhIocFypHfa4SX68soCTDqt0FT7HzDpJlLUqNB/ggbgOGNJi0JdEL
	 HfUYdiuX0rnez6Sc6sInLeR0wMFD2DFZ3vwNEuvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 361/592] net/mlx5: HWS, fix counting of rules in the matcher
Date: Mon, 23 Jun 2025 15:05:19 +0200
Message-ID: <20250623130709.030368136@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 4c56b5cbc323a10ebb6595500fb78fd8a4762efd ]

Currently the counter that counts number of rules in a matcher is
increased only when rule insertion is completed. In a multi-threaded
usecase this can lead to a scenario that many rules can be in process
of insertion in the same matcher, while none of them has completed
the insertion and the rule counter is not updated. This results in
a rule insertion failure for many of them at first attempt, which
leads to all of them requiring rehash and requiring locking of all
the queue locks.

This patch fixes the case by increasing the rule counter in the
beginning of insertion process and decreasing in case of any failure.

Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1746992290-568936-8-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index 32de8bfc7644f..3f8f4306d90b3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -329,16 +329,12 @@ static void hws_bwc_rule_list_add(struct mlx5hws_bwc_rule *bwc_rule, u16 idx)
 {
 	struct mlx5hws_bwc_matcher *bwc_matcher = bwc_rule->bwc_matcher;
 
-	atomic_inc(&bwc_matcher->num_of_rules);
 	bwc_rule->bwc_queue_idx = idx;
 	list_add(&bwc_rule->list_node, &bwc_matcher->rules[idx]);
 }
 
 static void hws_bwc_rule_list_remove(struct mlx5hws_bwc_rule *bwc_rule)
 {
-	struct mlx5hws_bwc_matcher *bwc_matcher = bwc_rule->bwc_matcher;
-
-	atomic_dec(&bwc_matcher->num_of_rules);
 	list_del_init(&bwc_rule->list_node);
 }
 
@@ -391,6 +387,7 @@ int mlx5hws_bwc_rule_destroy_simple(struct mlx5hws_bwc_rule *bwc_rule)
 	mutex_lock(queue_lock);
 
 	ret = hws_bwc_rule_destroy_hws_sync(bwc_rule, &attr);
+	atomic_dec(&bwc_matcher->num_of_rules);
 	hws_bwc_rule_list_remove(bwc_rule);
 
 	mutex_unlock(queue_lock);
@@ -860,7 +857,7 @@ int mlx5hws_bwc_rule_create_simple(struct mlx5hws_bwc_rule *bwc_rule,
 	}
 
 	/* check if number of rules require rehash */
-	num_of_rules = atomic_read(&bwc_matcher->num_of_rules);
+	num_of_rules = atomic_inc_return(&bwc_matcher->num_of_rules);
 
 	if (unlikely(hws_bwc_matcher_rehash_size_needed(bwc_matcher, num_of_rules))) {
 		mutex_unlock(queue_lock);
@@ -874,6 +871,7 @@ int mlx5hws_bwc_rule_create_simple(struct mlx5hws_bwc_rule *bwc_rule,
 				    bwc_matcher->size_log - MLX5HWS_BWC_MATCHER_SIZE_LOG_STEP,
 				    bwc_matcher->size_log,
 				    ret);
+			atomic_dec(&bwc_matcher->num_of_rules);
 			return ret;
 		}
 
@@ -906,6 +904,7 @@ int mlx5hws_bwc_rule_create_simple(struct mlx5hws_bwc_rule *bwc_rule,
 
 	if (ret) {
 		mlx5hws_err(ctx, "BWC rule insertion: rehash failed (%d)\n", ret);
+		atomic_dec(&bwc_matcher->num_of_rules);
 		return ret;
 	}
 
@@ -921,6 +920,7 @@ int mlx5hws_bwc_rule_create_simple(struct mlx5hws_bwc_rule *bwc_rule,
 	if (unlikely(ret)) {
 		mutex_unlock(queue_lock);
 		mlx5hws_err(ctx, "BWC rule insertion failed (%d)\n", ret);
+		atomic_dec(&bwc_matcher->num_of_rules);
 		return ret;
 	}
 
-- 
2.39.5



