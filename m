Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863574C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:49:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB255C433D6;
	Mon, 14 Nov 2022 12:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430142;
	bh=v2cINQZ2lreRu4mW95qcEtdhWScM5zrLrXsV1GEMq3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RhxE1mEzKlNiWXFlEFlxrOZdMOu7f+rI55HHSftVzMC1ShBd4JwmNGqHiq80bM0UY
	 jsEWPksDrjT2TDj7/W+lbeHsiJ4LSO7MgJV11M9ctLUgmDmhK7q1kb4mUCEOCnfR5N
	 K6qWJFxmWWweEpRBrFpbm34MBBlkOnGRc7MRBx8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Schmidt <alexschm@de.ibm.com>,
	Roy Novich <royno@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 39/95] net/mlx5: Allow async trigger completion execution on single CPU systems
Date: Mon, 14 Nov 2022 13:45:33 +0100
Message-Id: <20221114124444.191238049@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roy Novich <royno@nvidia.com>

[ Upstream commit 2808b37b59288ad8f1897e3546c2296df3384b65 ]

For a single CPU system, the kernel thread executing mlx5_cmd_flush()
never releases the CPU but calls down_trylock(&cmd→sem) in a busy loop.
On a single processor system, this leads to a deadlock as the kernel
thread which executes mlx5_cmd_invoke() never gets scheduled. Fix this,
by adding the cond_resched() call to the loop, allow the command
completion kernel thread to execute.

Fixes: 8e715cd613a1 ("net/mlx5: Set command entry semaphore up once got index free")
Signed-off-by: Alexander Schmidt <alexschm@de.ibm.com>
Signed-off-by: Roy Novich <royno@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 6612b2c0be48..cf07318048df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1687,12 +1687,17 @@ void mlx5_cmd_flush(struct mlx5_core_dev *dev)
 	struct mlx5_cmd *cmd = &dev->cmd;
 	int i;
 
-	for (i = 0; i < cmd->max_reg_cmds; i++)
-		while (down_trylock(&cmd->sem))
+	for (i = 0; i < cmd->max_reg_cmds; i++) {
+		while (down_trylock(&cmd->sem)) {
 			mlx5_cmd_trigger_completions(dev);
+			cond_resched();
+		}
+	}
 
-	while (down_trylock(&cmd->pages_sem))
+	while (down_trylock(&cmd->pages_sem)) {
 		mlx5_cmd_trigger_completions(dev);
+		cond_resched();
+	}
 
 	/* Unlock cmdif */
 	up(&cmd->pages_sem);
-- 
2.35.1



