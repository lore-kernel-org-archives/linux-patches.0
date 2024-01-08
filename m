Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B2551032;
	Mon,  8 Jan 2024 15:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="koys0xBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 003A7C433CB;
	Mon,  8 Jan 2024 15:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728495;
	bh=uKjPlYKySLCr3LcoHuHlakQS83NOlngjHzjNgf7aOFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=koys0xBubI3YrDs2TP3Ne5OUh2opPnR7s+DkVzCf3l57vlUakC6viMFLvqt0iKyGT
	 I20pg2EIeEXk9zLTHLPSe/vmqeifKqP5mRbmCmO69LiO3QSQn48kCU9IFPm4w0wJig
	 LJt+Qyl1uNj41wcaEGuZb5EaxdkNsgSCd26/YjPw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/150] net/mlx5: Increase size of irq name buffer
Date: Mon,  8 Jan 2024 16:35:38 +0100
Message-ID: <20240108153515.238297969@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

[ Upstream commit 3338bebfc26a1e2cebbba82a1cf12c0159608e73 ]

Without increased buffer size, will trigger -Wformat-truncation with W=1
for the snprintf operation writing to the buffer.

    drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c: In function 'mlx5_irq_alloc':
    drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:296:7: error: '@pci:' directive output may be truncated writing 5 bytes into a region of size between 1 and 32 [-Werror=format-truncation=]
      296 |    "%s@pci:%s", name, pci_name(dev->pdev));
          |       ^~~~~
    drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c:295:2: note: 'snprintf' output 6 or more bytes (assuming 37) into a destination of size 32
      295 |  snprintf(irq->name, MLX5_MAX_IRQ_NAME,
          |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      296 |    "%s@pci:%s", name, pci_name(dev->pdev));
          |    ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Fixes: ada9f5d00797 ("IB/mlx5: Fix eq names to display nicely in /proc/interrupts")
Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=6d4ab2e97dcfbcd748ae71761a9d8e5e41cc732c
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-13-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c | 6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h | 3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
index d136360ac6a98..a6d3fc96e1685 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c
@@ -25,7 +25,7 @@
 struct mlx5_irq {
 	struct atomic_notifier_head nh;
 	cpumask_var_t mask;
-	char name[MLX5_MAX_IRQ_NAME];
+	char name[MLX5_MAX_IRQ_FORMATTED_NAME];
 	struct mlx5_irq_pool *pool;
 	int refcount;
 	u32 index;
@@ -236,8 +236,8 @@ struct mlx5_irq *mlx5_irq_alloc(struct mlx5_irq_pool *pool, int i,
 	else
 		irq_sf_set_name(pool, name, i);
 	ATOMIC_INIT_NOTIFIER_HEAD(&irq->nh);
-	snprintf(irq->name, MLX5_MAX_IRQ_NAME,
-		 "%s@pci:%s", name, pci_name(dev->pdev));
+	snprintf(irq->name, MLX5_MAX_IRQ_FORMATTED_NAME,
+		 MLX5_IRQ_NAME_FORMAT_STR, name, pci_name(dev->pdev));
 	err = request_irq(irq->irqn, irq_int_handler, 0, irq->name,
 			  &irq->nh);
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
index 5c7e68bee43a0..4047179307c4a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pci_irq.h
@@ -7,6 +7,9 @@
 #include <linux/mlx5/driver.h>
 
 #define MLX5_MAX_IRQ_NAME (32)
+#define MLX5_IRQ_NAME_FORMAT_STR ("%s@pci:%s")
+#define MLX5_MAX_IRQ_FORMATTED_NAME \
+	(MLX5_MAX_IRQ_NAME + sizeof(MLX5_IRQ_NAME_FORMAT_STR))
 /* max irq_index is 2047, so four chars */
 #define MLX5_MAX_IRQ_IDX_CHARS (4)
 #define MLX5_EQ_REFS_PER_IRQ (2)
-- 
2.43.0



