Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7727369D67;
	Sat, 12 Sep 2026 18:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238824; cv=none; b=fceFGKZaLKp/OUrFwooAJ5t+Z1uhltsaymOx56LXlUvULvP4dlBDLmnT3/qzFt7E9QeUIvbDdZ/jf5sSUKESiLt0bWZcL7y19clZliXXO5QrUTFdpw3VM6o4B+JWjPuyI/oE22mtmKH7fw+giqi9TiCbMepc69DQiSk9d6gC6Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238824; c=relaxed/simple;
	bh=grC0+cFdM5Au+beWJxHjZXN4fG1F/+gPtX/tL0AtY8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMsZgVuGzicV9+CLOjiONrdoXB7bzyPvMdG5xoc7cWsmqRjQnR5dbADfoxYCJvHE9E+2kDEGMgfV65+b+l2c/XNGA2Q1RYw2Vdtz+k0ercyqDqovfZGF5JzYCWxr/aKZ+8sNDMYfWcSP7Pip7kK2WBepJkBQqeIlF3afoNjINi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IQbgcIAy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IQbgcIAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A341F000FF;
	Sat, 12 Sep 2026 18:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238822;
	bh=jHfFoZDi6l2J8DFSiPOjh87wwODIw25eCELenOjmJIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQbgcIAyYrLFv3Gcjv2bjLP506DozD+VoKq9siFvyA4BSPn3z7Yoc/mpHCBZakv/0
	 nhfHQhFa7ZoK2k3CgEjKKS0+3kgbR5tYT+3/CVItiEtDrxIZEJo2igFf394ABUuV0G
	 7dMUX+/27WjkE6gWyY2NkbDG0mamNjbkVnCRoW84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 497/935] RDMA/mlx4: Avoid flush_scheduled_work() usage
Date: Sat, 12 Sep 2026 08:58:47 +0200
Message-ID: <20260912065538.217657663@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 9cf62d91e4b78d8165e68aab3f8041b6bc3a0874 ]

Flushing system-wide workqueues is dangerous and will be forbidden.
Replace system_wq with local cm_wq.

Link: https://lore.kernel.org/r/22f7183b-cc16-5a34-e879-7605f5efc6e6@I-love.SAKURA.ne.jp
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: e37cdd75f8d6 ("RDMA/mlx5: Drain RCU callbacks during module teardown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx4/cm.c      | 29 +++++++++++++++++++++-------
 drivers/infiniband/hw/mlx4/main.c    | 10 +++++++++-
 drivers/infiniband/hw/mlx4/mlx4_ib.h |  3 +++
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cm.c b/drivers/infiniband/hw/mlx4/cm.c
index 4aff1c8298b1e..12b481d138cf4 100644
--- a/drivers/infiniband/hw/mlx4/cm.c
+++ b/drivers/infiniband/hw/mlx4/cm.c
@@ -80,6 +80,7 @@ struct cm_req_msg {
 	union ib_gid primary_path_sgid;
 };
 
+static struct workqueue_struct *cm_wq;
 
 static void set_local_comm_id(struct ib_mad *mad, u32 cm_id)
 {
@@ -288,10 +289,10 @@ static void schedule_delayed(struct ib_device *ibdev, struct id_map_entry *id)
 	/*make sure that there is no schedule inside the scheduled work.*/
 	if (!sriov->is_going_down && !id->scheduled_delete) {
 		id->scheduled_delete = 1;
-		schedule_delayed_work(&id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
+		queue_delayed_work(cm_wq, &id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	} else if (id->scheduled_delete) {
 		/* Adjust timeout if already scheduled */
-		mod_delayed_work(system_wq, &id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
+		mod_delayed_work(cm_wq, &id->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 	}
 	spin_unlock_irqrestore(&sriov->going_down_lock, flags);
 	spin_unlock(&sriov->id_map_lock);
@@ -370,7 +371,7 @@ static int alloc_rej_tmout(struct mlx4_ib_sriov *sriov, u32 rem_pv_cm_id, int sl
 			ret =  xa_err(item);
 		else
 			/* If a retry, adjust delayed work */
-			mod_delayed_work(system_wq, &item->timeout, CM_CLEANUP_CACHE_TIMEOUT);
+			mod_delayed_work(cm_wq, &item->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 		goto err_or_exists;
 	}
 	xa_unlock(&sriov->xa_rej_tmout);
@@ -393,7 +394,7 @@ static int alloc_rej_tmout(struct mlx4_ib_sriov *sriov, u32 rem_pv_cm_id, int sl
 		return xa_err(old);
 	}
 
-	schedule_delayed_work(&item->timeout, CM_CLEANUP_CACHE_TIMEOUT);
+	queue_delayed_work(cm_wq, &item->timeout, CM_CLEANUP_CACHE_TIMEOUT);
 
 	return 0;
 
@@ -500,7 +501,7 @@ static void rej_tmout_xa_cleanup(struct mlx4_ib_sriov *sriov, int slave)
 	xa_lock(&sriov->xa_rej_tmout);
 	xa_for_each(&sriov->xa_rej_tmout, id, item) {
 		if (slave < 0 || slave == item->slave) {
-			mod_delayed_work(system_wq, &item->timeout, 0);
+			mod_delayed_work(cm_wq, &item->timeout, 0);
 			flush_needed = true;
 			++cnt;
 		}
@@ -508,7 +509,7 @@ static void rej_tmout_xa_cleanup(struct mlx4_ib_sriov *sriov, int slave)
 	xa_unlock(&sriov->xa_rej_tmout);
 
 	if (flush_needed) {
-		flush_scheduled_work();
+		flush_workqueue(cm_wq);
 		pr_debug("Deleted %d entries in xarray for slave %d during cleanup\n",
 			 cnt, slave);
 	}
@@ -540,7 +541,7 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 	spin_unlock(&sriov->id_map_lock);
 
 	if (need_flush)
-		flush_scheduled_work(); /* make sure all timers were flushed */
+		flush_workqueue(cm_wq); /* make sure all timers were flushed */
 
 	/* now, remove all leftover entries from databases*/
 	spin_lock(&sriov->id_map_lock);
@@ -587,3 +588,17 @@ void mlx4_ib_cm_paravirt_clean(struct mlx4_ib_dev *dev, int slave)
 
 	rej_tmout_xa_cleanup(sriov, slave);
 }
+
+int mlx4_ib_cm_init(void)
+{
+	cm_wq = alloc_workqueue("mlx4_ib_cm", 0, 0);
+	if (!cm_wq)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void mlx4_ib_cm_destroy(void)
+{
+	destroy_workqueue(cm_wq);
+}
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 67a1ef0260b24..51f2be8cad937 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -3319,10 +3319,14 @@ static int __init mlx4_ib_init(void)
 	if (!wq)
 		return -ENOMEM;
 
-	err = mlx4_ib_mcg_init();
+	err = mlx4_ib_cm_init();
 	if (err)
 		goto clean_wq;
 
+	err = mlx4_ib_mcg_init();
+	if (err)
+		goto clean_cm;
+
 	err = mlx4_register_interface(&mlx4_ib_interface);
 	if (err)
 		goto clean_mcg;
@@ -3332,6 +3336,9 @@ static int __init mlx4_ib_init(void)
 clean_mcg:
 	mlx4_ib_mcg_destroy();
 
+clean_cm:
+	mlx4_ib_cm_destroy();
+
 clean_wq:
 	destroy_workqueue(wq);
 	return err;
@@ -3341,6 +3348,7 @@ static void __exit mlx4_ib_cleanup(void)
 {
 	mlx4_unregister_interface(&mlx4_ib_interface);
 	mlx4_ib_mcg_destroy();
+	mlx4_ib_cm_destroy();
 	destroy_workqueue(wq);
 }
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 4574a6f9ab539..8813f3ef76a8b 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -938,4 +938,7 @@ mlx4_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table)
 int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem, u64 start_va,
 				       int *num_of_mtts);
 
+int mlx4_ib_cm_init(void);
+void mlx4_ib_cm_destroy(void);
+
 #endif /* MLX4_IB_H */
-- 
2.53.0



