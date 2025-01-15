Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F18C248BA6;
	Wed, 15 Jan 2025 10:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937706; cv=none; b=i0K3PqDqG/0JPm4e41aWi6AitqT4mV303teJVPQCqAbsc/FiuNInngtMSUIphSMRTwqLC25LpnhymtT204dtUeZNYTzRTp8BGwZg3tw8GU44901f+XxZoVvct6OG+hv2YYaBMsYenPOFIwU5gj8RPhCyKdQfUOT82Vp3GxMY07I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937706; c=relaxed/simple;
	bh=dlkILevdgqa3WSkIor5mUZk2mQPy1O0Mcd9s6l/PPZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqEekRAGPXWRwUNLPTWdb9BzpxYbJFcRyHKpTn3a5a60DC26OCdIsdvgiaYh91CSylLA/D0dFORQ4ffQB7Edo8O7Z49j9PCe5OWlal7wBcCeMpGX4tzvwZDE99B9vH4fZMa628h3fBCVylSvUKyP+48BCO+f26wIkNqtN9kGQh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aPfSjsZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aPfSjsZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E09C4CEE2;
	Wed, 15 Jan 2025 10:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937706;
	bh=dlkILevdgqa3WSkIor5mUZk2mQPy1O0Mcd9s6l/PPZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aPfSjsZTyWwjUBV4gIew85T2Fz72D/Z+NSAcKrI4Trx64sK4ZYlmPgYqAv4UVvi7d
	 gbU6v4SZmsXm4ZkkREjKaG9krgEh/nEHo5rWLnQhCMlSC3Vv4LQRpAXDQ0+2xJiOtR
	 B0Vrkav/XTiiwrvFv1Gmxir6DcGAqkcVzOc/QjaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenguang Zhao <zhaochenguang@kylinos.cn>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 27/92] net/mlx5: Fix variable not being completed when function returns
Date: Wed, 15 Jan 2025 11:36:45 +0100
Message-ID: <20250115103548.613134866@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Chenguang Zhao <zhaochenguang@kylinos.cn>

[ Upstream commit 0e2909c6bec9048f49d0c8e16887c63b50b14647 ]

When cmd_alloc_index(), fails cmd_work_handler() needs
to complete ent->slotted before returning early.
Otherwise the task which issued the command may hang:

   mlx5_core 0000:01:00.0: cmd_work_handler:877:(pid 3880418): failed to allocate command entry
   INFO: task kworker/13:2:4055883 blocked for more than 120 seconds.
         Not tainted 4.19.90-25.44.v2101.ky10.aarch64 #1
   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
   kworker/13:2    D    0 4055883      2 0x00000228
   Workqueue: events mlx5e_tx_dim_work [mlx5_core]
   Call trace:
      __switch_to+0xe8/0x150
      __schedule+0x2a8/0x9b8
      schedule+0x2c/0x88
      schedule_timeout+0x204/0x478
      wait_for_common+0x154/0x250
      wait_for_completion+0x28/0x38
      cmd_exec+0x7a0/0xa00 [mlx5_core]
      mlx5_cmd_exec+0x54/0x80 [mlx5_core]
      mlx5_core_modify_cq+0x6c/0x80 [mlx5_core]
      mlx5_core_modify_cq_moderation+0xa0/0xb8 [mlx5_core]
      mlx5e_tx_dim_work+0x54/0x68 [mlx5_core]
      process_one_work+0x1b0/0x448
      worker_thread+0x54/0x468
      kthread+0x134/0x138
      ret_from_fork+0x10/0x18

Fixes: 485d65e13571 ("net/mlx5: Add a timeout to acquire the command queue semaphore")
Signed-off-by: Chenguang Zhao <zhaochenguang@kylinos.cn>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250108030009.68520-1-zhaochenguang@kylinos.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 4a1eb6cd699c..6dbb4021fd2f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1003,6 +1003,7 @@ static void cmd_work_handler(struct work_struct *work)
 				complete(&ent->done);
 			}
 			up(&cmd->vars.sem);
+			complete(&ent->slotted);
 			return;
 		}
 	} else {
-- 
2.39.5



