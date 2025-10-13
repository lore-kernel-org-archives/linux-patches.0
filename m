Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EB730F931;
	Mon, 13 Oct 2025 15:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367879; cv=none; b=NbK5kup+UY/M7FbXr1zqCXn4V1EumpI7mGbd+LRi44GaNyAVHTpoo/SGzjF5FbT/kJLQq3yWgs6yIs+uijW9d6+VLlnwrWpFz/vQXbKz9jjxYnBL+zd/1kXnXZdZ1I7rjmkFrN5CfpaByOspmQE/3zNSbTrYwQFJWbyViYezXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367879; c=relaxed/simple;
	bh=KByn+snmi7SjAzBtZZtoN/BzMKwF7XNUJh4M+hZ+VZ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PmXGjVs//fUFB/wRN5kmRcU3JxjtuOpHe/JNmWQocBpP3j4u+rAKqTK2JfE+b18Wb2M5mYRlqZNcpgEgIrtCfBtwr1cVEo3FZiQH/HxH/hHw4DkWo3+iExaHuwvyS9CVtk1vnoXfRsyQ5xAq0YPL5VDyIyi87jjJ90mJvDmCqHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DNTCKSQJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DNTCKSQJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 902C2C4CEE7;
	Mon, 13 Oct 2025 15:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367879;
	bh=KByn+snmi7SjAzBtZZtoN/BzMKwF7XNUJh4M+hZ+VZ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DNTCKSQJyRi87oOOEwCBokoX/n+KgehqZlH0Tn8YjdKsLItn5jnhU96wSGOhzxNXO
	 DCZfd/chIi84q80a1dXoeEVlSO8SrwBvio+Q/abVveA30Icv3jUy0eag9Gw5xB+6h8
	 ExbyHgJKVxyPznCl7PxkI1iYL2gF7j5St/d+YBxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 164/196] net/mlx5: fw reset, add reset timeout work
Date: Mon, 13 Oct 2025 16:45:55 +0200
Message-ID: <20251013144321.243674897@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit 5cfbe7ebfa42fd3c517a701dab5bd73524da9088 ]

Add sync reset timeout to stop poll_sync_reset in case there was no
reset done or abort event within timeout. Otherwise poll sync reset will
just continue and in case of fw fatal error no health reporting will be
done.

Fixes: 38b9f903f22b ("net/mlx5: Handle sync reset request event")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/fw_reset.c    | 24 +++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
index 1547704c89767..4d64d179b5dd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fw_reset.c
@@ -27,6 +27,7 @@ struct mlx5_fw_reset {
 	struct work_struct reset_reload_work;
 	struct work_struct reset_now_work;
 	struct work_struct reset_abort_work;
+	struct delayed_work reset_timeout_work;
 	unsigned long reset_flags;
 	u8 reset_method;
 	struct timer_list timer;
@@ -257,6 +258,8 @@ static int mlx5_sync_reset_clear_reset_requested(struct mlx5_core_dev *dev, bool
 		return -EALREADY;
 	}
 
+	if (current_work() != &fw_reset->reset_timeout_work.work)
+		cancel_delayed_work(&fw_reset->reset_timeout_work);
 	mlx5_stop_sync_reset_poll(dev);
 	if (poll_health)
 		mlx5_start_health_poll(dev);
@@ -327,6 +330,11 @@ static int mlx5_sync_reset_set_reset_requested(struct mlx5_core_dev *dev)
 	}
 	mlx5_stop_health_poll(dev, true);
 	mlx5_start_sync_reset_poll(dev);
+
+	if (!test_bit(MLX5_FW_RESET_FLAGS_DROP_NEW_REQUESTS,
+		      &fw_reset->reset_flags))
+		schedule_delayed_work(&fw_reset->reset_timeout_work,
+			msecs_to_jiffies(mlx5_tout_ms(dev, PCI_SYNC_UPDATE)));
 	return 0;
 }
 
@@ -700,6 +708,19 @@ static void mlx5_sync_reset_events_handle(struct mlx5_fw_reset *fw_reset, struct
 	}
 }
 
+static void mlx5_sync_reset_timeout_work(struct work_struct *work)
+{
+	struct delayed_work *dwork = container_of(work, struct delayed_work,
+						  work);
+	struct mlx5_fw_reset *fw_reset =
+		container_of(dwork, struct mlx5_fw_reset, reset_timeout_work);
+	struct mlx5_core_dev *dev = fw_reset->dev;
+
+	if (mlx5_sync_reset_clear_reset_requested(dev, true))
+		return;
+	mlx5_core_warn(dev, "PCI Sync FW Update Reset Timeout.\n");
+}
+
 static int fw_reset_event_notifier(struct notifier_block *nb, unsigned long action, void *data)
 {
 	struct mlx5_fw_reset *fw_reset = mlx5_nb_cof(nb, struct mlx5_fw_reset, nb);
@@ -783,6 +804,7 @@ void mlx5_drain_fw_reset(struct mlx5_core_dev *dev)
 	cancel_work_sync(&fw_reset->reset_reload_work);
 	cancel_work_sync(&fw_reset->reset_now_work);
 	cancel_work_sync(&fw_reset->reset_abort_work);
+	cancel_delayed_work(&fw_reset->reset_timeout_work);
 }
 
 static const struct devlink_param mlx5_fw_reset_devlink_params[] = {
@@ -826,6 +848,8 @@ int mlx5_fw_reset_init(struct mlx5_core_dev *dev)
 	INIT_WORK(&fw_reset->reset_reload_work, mlx5_sync_reset_reload_work);
 	INIT_WORK(&fw_reset->reset_now_work, mlx5_sync_reset_now_event);
 	INIT_WORK(&fw_reset->reset_abort_work, mlx5_sync_reset_abort_event);
+	INIT_DELAYED_WORK(&fw_reset->reset_timeout_work,
+			  mlx5_sync_reset_timeout_work);
 
 	init_completion(&fw_reset->done);
 	return 0;
-- 
2.51.0



