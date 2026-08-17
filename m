Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ED45175A99;
	Mon, 17 Aug 2026 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976305; cv=none; b=m4MqtvsA1hH9MZMJWY/JjDxV7MU/G4Ekmj1QcF+5+lEyzxm8H9g5yv2dhGIzRFPXB/akT4UgqLyFewRR1JCXbXk1nFUKp8D923ypfHzZ0zVuVpFVy2yOhh0tQwuBSUYB1XiBs+IQ0uNJNpLMolgGaIEgSIJWnQ20Bh7DNU1X3RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976305; c=relaxed/simple;
	bh=pR7ECm2f27ZYdXb9VWFwK+tB9n4uZT0ZHoratJgrOec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u8MmL1RG6tKcJ0hOd1xmOIfY73BX2kzKpqvtrwb7kQJWEzrJ0ua5Sxb1sJIxnjGPkOda9Efwic+fondYcpV240bftUpqn7DJHr8r4DvMG2GoOnPpKzCTe3PVcoLKw7fmwhQWIjXDfY0EuyyLRlkZieftcGIiOe8CEsInEuQ1hnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ruiQmuIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ruiQmuIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9063A1F000E9;
	Mon, 17 Aug 2026 14:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976304;
	bh=k+krlHvfcfYkiaefINEeFnG5LLPaNHRg26b6HQiOE7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ruiQmuIEhktVJOruD1rvXVEc6aj+sVGpsqO5cNqrUZOexwPN1WJBmd1xbkQiub9ss
	 5RoFDHIYy0yio6QkmPFofgysu3UBur6Pvs3fSMghMN0MfOJRZaC7YAe/nEQ5vxcEji
	 ybwRAmjKLu2tuobBSUTO4vveiHCfxm2GdrCebii0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 320/389] net/mlx5: fw_tracer, return NULL on create error
Date: Mon, 17 Aug 2026 15:32:39 +0200
Message-ID: <20260817132551.431272819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit af39eb111ce6b5eba9c08513b62c4868eb7e7fd5 ]

Tracer creation can fail by returning either NULL or ERR_PTR.
The return value is stored without a check on the device, and users
treat ERR_PTR and NULL the same way.
This also causes a crash in the core dump logic, which is missing the
ERR_PTR check and ends up dereferencing it, as shown in the trace below.

Switch tracer creation to return NULL on failure only, so callers only
need a single NULL check.

  Internal error: Oops: 0000000096000006 [#1]  SMP
  Modules linked in: mlx5_ib ib_uverbs ib_core ipv6 mlx5_core
  CPU: 1 UID: 0 PID: 12 Comm: kworker/u16:0 Not tainted 6.19.7 #1 PREEMPT(none)
  Workqueue: mlx5_health0001:01:00.0 mlx5_fw_reporter_err_work [mlx5_core]
  pstate: a3400009 (NzCv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
  pc : mlx5_fw_tracer_trigger_core_dump_general+0x58/0xe0 [mlx5_core]
  lr : mlx5_fw_tracer_trigger_core_dump_general+0x40/0xe0 [mlx5_core]
  sp : ffff800081cf3c40
  x29: ffff800081cf3c90 x28: 0000000000000000 x27: 0000000000000000
  x26: ffff000080018828 x25: 0000000000000000 x24: ffff000080304a05
  x23: ffff800081cf3d80 x22: ffff0000847e01a0 x21: 0000000000000000
  x20: ffff0000847e01a0 x19: ffffffffffffffa1 x18: ffff80008310bbf0
  x17: ffff800080119650 x16: ffff80008010df54 x15: ffff80008010d4ac
  x14: ffff800079c202e4 x13: ffff80008002fe60 x12: ffff800080119650
  x11: ffff80008010df54 x10: ffff80008010d4ac x9 : ffff800079c203d8
  x8 : ffff800081cf3c88 x7 : 0000000000000000 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000008 x3 : 0000000000000030
  x2 : 0000000000000008 x1 : 0000000000000000 x0 : 00000000c5c4000e
  Call trace:
   mlx5_fw_tracer_trigger_core_dump_general+0x58/0xe0 [mlx5_core] (P)
   mlx5_fw_reporter_dump+0x30/0x2e0 [mlx5_core]
   devlink_health_do_dump+0x9c/0x160
   devlink_health_report+0x1c0/0x288
   mlx5_fw_reporter_err_work+0xac/0xc0 [mlx5_core]
   process_one_work+0x15c/0x3d8
   worker_thread+0x18c/0x320
   kthread+0x148/0x228
   ret_from_fork+0x10/0x20
  Code: b9400000 5ac00800 7a401800 540003ca (3940a260)
  ---[ end trace 0000000000000000 ]---
  Kernel panic - not syncing: Oops: Fatal exception
  SMP: stopping secondary CPUs
  Kernel Offset: disabled
  CPU features: 0x000000,00078031,75fce5a1,35fffe67
  Memory Limit: none
  ---[ end Kernel panic - not syncing: Oops: Fatal exception ]---

Fixes: fd1483fe1f9f ("net/mlx5: Add support for FW reporter dump")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260729080402.2427184-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index a83bfdfe51325..9817de5590b56 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -1036,13 +1036,11 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 
 	tracer = kvzalloc(sizeof(*tracer), GFP_KERNEL);
 	if (!tracer)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
 
 	tracer->work_queue = create_singlethread_workqueue("mlx5_fw_tracer");
-	if (!tracer->work_queue) {
-		err = -ENOMEM;
+	if (!tracer->work_queue)
 		goto free_tracer;
-	}
 
 	tracer->dev = dev;
 
@@ -1082,7 +1080,7 @@ struct mlx5_fw_tracer *mlx5_fw_tracer_create(struct mlx5_core_dev *dev)
 	destroy_workqueue(tracer->work_queue);
 free_tracer:
 	kvfree(tracer);
-	return ERR_PTR(err);
+	return NULL;
 }
 
 static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void *data);
@@ -1093,7 +1091,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 	struct mlx5_core_dev *dev;
 	int err;
 
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return 0;
 
 	dev = tracer->dev;
@@ -1136,7 +1134,7 @@ int mlx5_fw_tracer_init(struct mlx5_fw_tracer *tracer)
 /* Stop tracer + Cleanup HW resources */
 void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 {
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return;
 
 	mlx5_core_dbg(tracer->dev, "FWTracer: Cleanup, is owner ? (%d)\n",
@@ -1155,7 +1153,7 @@ void mlx5_fw_tracer_cleanup(struct mlx5_fw_tracer *tracer)
 /* Free software resources (Buffers, etc ..) */
 void mlx5_fw_tracer_destroy(struct mlx5_fw_tracer *tracer)
 {
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return;
 
 	mlx5_core_dbg(tracer->dev, "FWTracer: Destroy\n");
@@ -1204,7 +1202,7 @@ int mlx5_fw_tracer_reload(struct mlx5_fw_tracer *tracer)
 	struct mlx5_core_dev *dev;
 	int err;
 
-	if (IS_ERR_OR_NULL(tracer))
+	if (!tracer)
 		return 0;
 
 	dev = tracer->dev;
-- 
2.53.0



