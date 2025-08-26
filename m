Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85C4618DF9D;
	Tue, 26 Aug 2025 11:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208131; cv=none; b=bJFxwNsfk/OsKHPt79bmbJbkC9TXRFG1v7z4DVS54ZKXsmYi44mbxXpkXqNI7LGRpS6LspK3zRhmQ/u3L51f5PA+khEbQenoE+RGMtUZ2Wnw8wbtdKaPIC5XiHnHXHJ+dKiAPsL3AEUS9DmH+02ktTE382RpqM0JFmhYkTMJ7W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208131; c=relaxed/simple;
	bh=POTNIC4sTAFeMYYWm8vHzvCynT4jzix+yRoJ9x4IuiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K6HSUFvNj30EZ6Si/m9D4kZu+Rj2FXhWTlQXilqwal4SU6k4TYVN0GOVM/s/145p1FJNvmxjvSZSYN8E+rSF1uCbD7LvGPAiTqKfnnbO7J4Y+pGE4baDvXM5hLyO7FmgnsTCLyly1+t8TZ17pg5rLFwOb26t1Po5gVkNJOWAoIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bw7aakSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bw7aakSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15A6EC4CEF1;
	Tue, 26 Aug 2025 11:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208131;
	bh=POTNIC4sTAFeMYYWm8vHzvCynT4jzix+yRoJ9x4IuiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bw7aakSNXWOLYnCGIPZaGnRp6tM3WkR6vaYckteANYIrDVUjoVrCSy4ZaBFs6gKS7
	 mme6s3cHI3SlGUOAJoXX1pzIvxZ77LYbVpG5FR3lvghxaSTSeRXGf6Hnpz8WPMlX5R
	 CHADQxLfhyge8qc0gzI7eDiboEVQhbj4kwICehKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Dogaru <vdogaru@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 419/457] net/mlx5: CT: Use the correct counter offset
Date: Tue, 26 Aug 2025 13:11:43 +0200
Message-ID: <20250826110947.649189413@linuxfoundation.org>
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

From: Vlad Dogaru <vdogaru@nvidia.com>

[ Upstream commit d2d6f950cb43be6845a41cac5956cb2a10e657e5 ]

Specifying the counter action is not enough, as it is used by multiple
counters that were allocated in a bulk. By omitting the offset, rules
will be associated with a different counter from the same bulk.
Subsequently, the CT subsystem checks the correct counter, assumes that
no traffic has triggered the rule, and ages out the rule. The end result
is intermittent offloading of long lived connections, as rules are aged
out then promptly re-added.

Fix this by specifying the correct offset along with the counter rule.

Fixes: 34eea5b12a10 ("net/mlx5e: CT: Add initial support for Hardware Steering")
Signed-off-by: Vlad Dogaru <vdogaru@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250817202323.308604-8-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c
index a4263137fef5..01d522b02947 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc/ct_fs_hmfs.c
@@ -173,6 +173,8 @@ static void mlx5_ct_fs_hmfs_fill_rule_actions(struct mlx5_ct_fs_hmfs *fs_hmfs,
 
 	memset(rule_actions, 0, NUM_CT_HMFS_RULES * sizeof(*rule_actions));
 	rule_actions[0].action = mlx5_fc_get_hws_action(fs_hmfs->ctx, attr->counter);
+	rule_actions[0].counter.offset =
+		attr->counter->id - attr->counter->bulk->base_id;
 	/* Modify header is special, it may require extra arguments outside the action itself. */
 	if (mh_action->mh_data) {
 		rule_actions[1].modify_header.offset = mh_action->mh_data->offset;
-- 
2.50.1



