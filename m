Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365EA2F617C;
	Sat, 12 Sep 2026 18:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238615; cv=none; b=BdECm6zn76Sl7SQnPzI1osLb91QubeieN8q9Q9VB2fZTQKvgYdzEerUOcNH86JXZqRNUPXu1rjDr0rNpRALODKRzoz+6wS0lX3JethZivRG4qnztc/IK/Xn1ENHN6l6qK5dV30BGcJuxLtiaUT2u8ZCXGI7UcNB6caM3N1aujYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238615; c=relaxed/simple;
	bh=1YuMV62ipWG2XG+G/3qpqApeIIXC9euenJDs6yENPcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvLGWx/DCbppqtX/jfXDIyLCIbKjum0KuO8EN4pLPwftFV4t+G2hNG+IPKnG6i/oIggWffRc89kTiZCwfmP+2wLhVOW8dLimCjYOnHuVMR6ko2c+PEf4lcZDkEM+Gb3o8yRUvYR8q+UKszPLYjJY9oswpYLiYwsZx5XHjn9tMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uSR4SatE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uSR4SatE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 900431F000FF;
	Sat, 12 Sep 2026 18:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238613;
	bh=TaH7QjAQ6txjm7EU4WuxtFKnBwUI/HG9opU0jXAURNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uSR4SatENE+euVbAQ6EHIpg2buasLUiCvucQ+0K4oojsELtsvYJ0KZGlieS6fdgTT
	 auS2A8EvG2NXqBJt6+iYERlV0huUBFgS0X5ZSuvVgpbtcEPSRy16e5j4/X3HTmrkLR
	 8PPJVL3nrLRHKCeBxHLTboAJLVVl7tmkf1n+GMhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 499/935] RDMA/mlx5: Drain RCU callbacks during module teardown
Date: Sat, 12 Sep 2026 08:58:49 +0200
Message-ID: <20260912065538.263861975@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit e37cdd75f8d61c1123d324ae5667ac3da562290e ]

devx_free_subscription() can remain queued after the last DevX event file
drops its module reference or an auxiliary driver detaches its devices.
mlx5_ib can then unload before the callback runs.

Registration error unwind has the same risk because driver registration
can attach existing devices before failing. Wait after all drivers have
stopped.

Fixes: 6898d1c661d7 ("RDMA/mlx5: Use RCU and direct refcounts to keep memory alive")
Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Closes: https://lore.kernel.org/linux-rdma/20260708092316.Qb39F_B0@linutronix.de/
Link: https://patch.msgid.link/20260709-unload-rcu-v1-2-fccd27211e5a@nvidia.com
Acked-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c81327887f0ec..3d4eb71904bcb 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4592,6 +4592,7 @@ static int __init mlx5_ib_init(void)
 mp_err:
 	mlx5r_rep_cleanup();
 rep_err:
+	rcu_barrier();
 	mlx5_ib_qp_event_cleanup();
 qp_event_err:
 	destroy_workqueue(mlx5_ib_event_wq);
@@ -4604,6 +4605,7 @@ static void __exit mlx5_ib_cleanup(void)
 	auxiliary_driver_unregister(&mlx5r_driver);
 	auxiliary_driver_unregister(&mlx5r_mp_driver);
 	mlx5r_rep_cleanup();
+	rcu_barrier();
 
 	mlx5_ib_qp_event_cleanup();
 	destroy_workqueue(mlx5_ib_event_wq);
-- 
2.53.0



