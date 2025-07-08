Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49366217722;
	Tue,  8 Jul 2025 16:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993356; cv=none; b=azgYgrfE2475Hax1JQlBg8JDe1VYkzy4hPOLXP+pUTcvtf1+eyDtbLcErc55PohVwjpvwMLQHgSW/9kuye3SKLhchimFdp2CGn377lBlqw5Jjh1AFNlwJjdoBCiNXJOUGHj2OPxY8G1QMbS7/27Ye9qdawK2G0ykJO+As8pMc3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993356; c=relaxed/simple;
	bh=QTXZuXgHuWcOrS59oC6QO4zT8sW3JHlIxZ4I7PSxaX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ06484T5Zp70LoZ8VNIDUn91UtB0NB+DXgp5iAt4fAIBm1w321ccBkl9JZgxjE4G6adIHUsp0gpn0WEkW+WztUPFmdHnxlWte0TJtljGzbKiX3rqd12Iq1d1vuflDeROrzV78O+KaYwf0NjcKlQP57oxbT80XoFzX/rcJIGOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vhDacSkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vhDacSkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E7CC4CEED;
	Tue,  8 Jul 2025 16:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993356;
	bh=QTXZuXgHuWcOrS59oC6QO4zT8sW3JHlIxZ4I7PSxaX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vhDacSkLG5hcaQReRUOTWzQPgQkhJFdTRR5RHY8icR/W08aZTIdctKhT+jhe8f2pU
	 dpfAOP+Pvq8bF6dQ0UYow9jgbO8SR5PU1jvab4I4TmM2V9aLefUFkTYVJ+OD0ccYoA
	 +LHH4ahwxeSjpkiaEtLkah5cDtmOrpI0eLtXdFz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 038/178] RDMA/mlx5: reduce stack usage in mlx5_ib_ufile_hw_cleanup
Date: Tue,  8 Jul 2025 18:21:15 +0200
Message-ID: <20250708162237.675950943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b26852daaa83f535109253d114426d1fa674155d ]

This function has an array of eight mlx5_async_cmd structures, which
often fits on the stack, but depending on the configuration can
end up blowing the stack frame warning limit:

drivers/infiniband/hw/mlx5/devx.c:2670:6: error: stack frame size (1392) exceeds limit (1280) in 'mlx5_ib_ufile_hw_cleanup' [-Werror,-Wframe-larger-than]

Change this to a dynamic allocation instead. While a kmalloc()
can theoretically fail, a GFP_KERNEL allocation under a page will
block until memory has been freed up, so in the worst case, this
only adds extra time in an already constrained environment.

Fixes: 7c891a4dbcc1 ("RDMA/mlx5: Add implementation for ufile_hw_cleanup device operation")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250610092846.2642535-1-arnd@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/devx.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/devx.c b/drivers/infiniband/hw/mlx5/devx.c
index 2479da8620ca9..bceae1c1f9801 100644
--- a/drivers/infiniband/hw/mlx5/devx.c
+++ b/drivers/infiniband/hw/mlx5/devx.c
@@ -2669,7 +2669,7 @@ static void devx_wait_async_destroy(struct mlx5_async_cmd *cmd)
 
 void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile)
 {
-	struct mlx5_async_cmd async_cmd[MAX_ASYNC_CMDS];
+	struct mlx5_async_cmd *async_cmd;
 	struct ib_ucontext *ucontext = ufile->ucontext;
 	struct ib_device *device = ucontext->device;
 	struct mlx5_ib_dev *dev = to_mdev(device);
@@ -2678,6 +2678,10 @@ void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile)
 	int head = 0;
 	int tail = 0;
 
+	async_cmd = kcalloc(MAX_ASYNC_CMDS, sizeof(*async_cmd), GFP_KERNEL);
+	if (!async_cmd)
+		return;
+
 	list_for_each_entry(uobject, &ufile->uobjects, list) {
 		WARN_ON(uverbs_try_lock_object(uobject, UVERBS_LOOKUP_WRITE));
 
@@ -2713,6 +2717,8 @@ void mlx5_ib_ufile_hw_cleanup(struct ib_uverbs_file *ufile)
 		devx_wait_async_destroy(&async_cmd[head % MAX_ASYNC_CMDS]);
 		head++;
 	}
+
+	kfree(async_cmd);
 }
 
 static ssize_t devx_async_cmd_event_read(struct file *filp, char __user *buf,
-- 
2.39.5



