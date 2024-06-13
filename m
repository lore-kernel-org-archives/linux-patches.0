Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F88F441D;
	Thu, 13 Jun 2024 12:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282062; cv=none; b=oXk744I4Zeb9p5//hrhBMKmmyDYivJGsH4tzAQ5XfkEPbZ+LSQNYpSPo3kdsgvmzIK6Z5tilpHoO2kkBVenZAG4sO0tGIcsNB/+phHQPtpk8ND8xLGLVRhq7XkyGlvdpWGAUdokTTTAuIhBy3QtmGl3wyQnfjcn7LLkvYURXmws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282062; c=relaxed/simple;
	bh=fZBWfzaiCDXmJdv3n78ud+lKlH1FP+dfGbt7YbHLZAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnjEsqKGNyxUXoy1cW/QCnwtALYl0wCfEEOeCPPRMEOw9UKS33y4hgD2URuvCCO8UyLtKFs7QHUDdmvqCAHwAZA5aemvKawXOgzx8bzBRBMeCzKP2LX3KAs2fKsiv5AfDQQ72RcYbBjiI0BVPE53lk/PTOq1q1x9lZOzPZPD9jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QbhwRiZ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QbhwRiZ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB9FC32786;
	Thu, 13 Jun 2024 12:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282062;
	bh=fZBWfzaiCDXmJdv3n78ud+lKlH1FP+dfGbt7YbHLZAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QbhwRiZ3eFKppvDmWKZTn3xWh7KkccK44tA4+WhbUssRJu/OK4Xm5+AVn0iUqEKXt
	 UZeP5tVoDWn97KwtLnL+uGkxFdhRfAaMmb7AIpaSSTNyq11ujB18HYTbAaci7vl0xM
	 WwQSrBOCUVKUg8aw2ZDbx70aBtrOBYJrQI2qp4GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 118/402] net/mlx5: Discard command completions in internal error
Date: Thu, 13 Jun 2024 13:31:15 +0200
Message-ID: <20240613113306.735642385@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akiva Goldberger <agoldberger@nvidia.com>

[ Upstream commit db9b31aa9bc56ff0d15b78f7e827d61c4a096e40 ]

Fix use after free when FW completion arrives while device is in
internal error state. Avoid calling completion handler in this case,
since the device will flush the command interface and trigger all
completions manually.

Kernel log:
------------[ cut here ]------------
refcount_t: underflow; use-after-free.
...
RIP: 0010:refcount_warn_saturate+0xd8/0xe0
...
Call Trace:
<IRQ>
? __warn+0x79/0x120
? refcount_warn_saturate+0xd8/0xe0
? report_bug+0x17c/0x190
? handle_bug+0x3c/0x60
? exc_invalid_op+0x14/0x70
? asm_exc_invalid_op+0x16/0x20
? refcount_warn_saturate+0xd8/0xe0
cmd_ent_put+0x13b/0x160 [mlx5_core]
mlx5_cmd_comp_handler+0x5f9/0x670 [mlx5_core]
cmd_comp_notifier+0x1f/0x30 [mlx5_core]
notifier_call_chain+0x35/0xb0
atomic_notifier_call_chain+0x16/0x20
mlx5_eq_async_int+0xf6/0x290 [mlx5_core]
notifier_call_chain+0x35/0xb0
atomic_notifier_call_chain+0x16/0x20
irq_int_handler+0x19/0x30 [mlx5_core]
__handle_irq_event_percpu+0x4b/0x160
handle_irq_event+0x2e/0x80
handle_edge_irq+0x98/0x230
__common_interrupt+0x3b/0xa0
common_interrupt+0x7b/0xa0
</IRQ>
<TASK>
asm_common_interrupt+0x22/0x40

Fixes: 51d138c2610a ("net/mlx5: Fix health error state handling")
Signed-off-by: Akiva Goldberger <agoldberger@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://lore.kernel.org/r/20240509112951.590184-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 8d5dd8aba8cd4..81e517dbe60e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1535,6 +1535,9 @@ static int cmd_comp_notifier(struct notifier_block *nb,
 	dev = container_of(cmd, struct mlx5_core_dev, cmd);
 	eqe = data;
 
+	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		return NOTIFY_DONE;
+
 	mlx5_cmd_comp_handler(dev, be32_to_cpu(eqe->data.cmd.vector), false);
 
 	return NOTIFY_OK;
-- 
2.43.0



