Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6E76FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:27:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00E73C433C1;
	Wed, 30 Nov 2022 18:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832867;
	bh=Vg63VjB7VjkCEK/YPPOMaCXy/dJhx+HXH2uLJfRwXKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Db3XCvALPICwI1LZ5a2Trp1dzNR2fbGP1ZfqZRFnd3BY6se3bjrHU1uk2CXpR7XR2
	 Ss+GP6Q01PkuSbETTQKVdpH7KXYZ1J5cfQUFBywRuEcTRrqJS5j5eu/bGjqzYKRotk
	 jkZ5zZMK2q0sawgKA1JfeIYAfA35Sa2BB+2MYP9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eran Ben Elisha <eranbe@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 068/162] net/mlx5: Fix handling of entry refcount when command is not issued to FW
Date: Wed, 30 Nov 2022 19:22:29 +0100
Message-Id: <20221130180530.349292790@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit aaf2e65cac7f2e1ae729c2fbc849091df9699f96 ]

In case command interface is down, or the command is not allowed, driver
did not increment the entry refcount, but might have decrement as part
of forced completion handling.

Fix that by always increment and decrement the refcount to make it
symmetric for all flows.

Fixes: 50b2412b7e78 ("net/mlx5: Avoid possible free of command entry while timeout comp handler")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reported-by: Jack Wang <jinpu.wang@ionos.com>
Tested-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index cf07318048df..c838d8698eab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -959,6 +959,7 @@ static void cmd_work_handler(struct work_struct *work)
 		cmd_ent_get(ent);
 	set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
 
+	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* Skip sending command to fw if internal error */
 	if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
 		u8 status = 0;
@@ -972,7 +973,6 @@ static void cmd_work_handler(struct work_struct *work)
 		return;
 	}
 
-	cmd_ent_get(ent); /* for the _real_ FW event on completion */
 	/* ring doorbell after the descriptor is valid */
 	mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 << ent->idx);
 	wmb();
@@ -1586,8 +1586,8 @@ static void mlx5_cmd_comp_handler(struct mlx5_core_dev *dev, u64 vec, bool force
 				cmd_ent_put(ent); /* timeout work was canceled */
 
 			if (!forced || /* Real FW completion */
-			    pci_channel_offline(dev->pdev) || /* FW is inaccessible */
-			    dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+			     mlx5_cmd_is_down(dev) || /* No real FW completion is expected */
+			     !opcode_allowed(cmd, ent->op))
 				cmd_ent_put(ent);
 
 			ent->ts2 = ktime_get_ns();
-- 
2.35.1



