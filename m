Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF113197A9B;
	Thu,  6 Jun 2024 14:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683311; cv=none; b=fuotSnlYUkXH0el7nj8KCMLKIkDGcxGSleggbT/nUvf4LJsbRxB0p0OgvNHxa6vhFutNQu8eGvsaVd1+PQ6DBz6aZIFLvsLjMTgyJ22s7b4fH8/W+tDb1z+91OWD3svy2vrecZvpOf8jiXEXBjYCqzD0WwRUvvAnECxq2wN/SHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683311; c=relaxed/simple;
	bh=HaYdDD+9G9RzuhxMQDqghvvqw9rsfzwf7xJYNvc7+nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LzxTJcAQjGiyyXWxWZ+3DZrSu2GGQGDhybvXplFIqUk+4HqtATgA8xA8zySYa/TTOaDXUwLyUw4m0czimdElNlHwldRfP2tvUabx191eHRL35TbWRhfH93S/2ed7a5R4TTGZjncVLVoJzxAqXkQvGfzGygKlcLd+GonrpnQkjg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SslPVnNL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SslPVnNL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CE6EC2BD10;
	Thu,  6 Jun 2024 14:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683311;
	bh=HaYdDD+9G9RzuhxMQDqghvvqw9rsfzwf7xJYNvc7+nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SslPVnNLutWY+6SJ7X0IapQlWObw/Z4/l6Z51reNgEYovFDM/HMFG67W9V/Og6Rg/
	 ocmyRYH6P1e3JJX1TP3d2HS4pCbncWfMgGIQxb6GjrlX3jODCkbb2P3jZMYGYfnapG
	 Aw1f5brBmw9/46UzxjtyQD20dVpY/d9gMkhiKoVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/744] net/mlx5: Discard command completions in internal error
Date: Thu,  6 Jun 2024 15:58:44 +0200
Message-ID: <20240606131740.483201967@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3072f1c6c0ff7..48dc4ae87af09 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1632,6 +1632,9 @@ static int cmd_comp_notifier(struct notifier_block *nb,
 	dev = container_of(cmd, struct mlx5_core_dev, cmd);
 	eqe = data;
 
+	if (dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		return NOTIFY_DONE;
+
 	mlx5_cmd_comp_handler(dev, be32_to_cpu(eqe->data.cmd.vector), false);
 
 	return NOTIFY_OK;
-- 
2.43.0



