Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FE7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:56:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199CDC433C1;
	Wed,  2 Nov 2022 02:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357759;
	bh=wOESc5C2EZVFg12sNJlBMfCoM9Mw6B/9/TpwRcR439Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FNkAIOc6FRa0zT0JHLA3zxyIrTPDorAmKHfrOQvfYVExVRLnXAKUQQudRDZivC73y
	 WJfxqmBClPzxj9Bzrna/49ClD0UqUHrgHxfGGhCA5887861kaQNZFxI/dc+w3pcpXb
	 RKH8yAdpNtVlft8rgd+nzZ3mbKezjmzVnuGf6j60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rongwei Liu <rongweil@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 225/240] net/mlx5: DR, Fix matcher disconnect error flow
Date: Wed,  2 Nov 2022 03:33:20 +0100
Message-Id: <20221102022116.489657879@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rongwei Liu <rongweil@nvidia.com>

[ Upstream commit 4ea9891d66410da5030dababb4b825d8e41cd7bb ]

When 2nd flow rules arrives, it will merge together with the
1st one if matcher criteria is the same.

If merge fails, driver will rollback the merge contents, and
reject the 2nd rule. At rollback stage, matcher can't be
disconnected unconditionally, otherise the 1st rule can't be
hit anymore.

Add logic to check if the matcher should be disconnected or not.

Fixes: cc2295cd54e4 ("net/mlx5: DR, Improve steering for empty or RX/TX-only matchers")
Signed-off-by: Rongwei Liu <rongweil@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20221026135153.154807-4-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
index ddfaf7891188..91ff19f67695 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c
@@ -1200,7 +1200,8 @@ dr_rule_create_rule_nic(struct mlx5dr_rule *rule,
 	}
 
 remove_from_nic_tbl:
-	mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
+	if (!nic_matcher->rules)
+		mlx5dr_matcher_remove_from_tbl_nic(dmn, nic_matcher);
 
 free_hw_ste:
 	mlx5dr_domain_nic_unlock(nic_dmn);
-- 
2.35.1



