Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9690372ECE;
	Sat, 12 Sep 2026 20:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243210; cv=none; b=lcpn6/Xz2x0jwBLKI6yw4hTnmLdaU2ilkTAUXNpZamXWVF/HMgknfQuQzg8Ihc2lkCfJA8nZdh3d7zGZGymB5f6qXpPHlvS/1GlfEM7VyyxtMOg2lbCez0Z/5FyOydnW0Pnd8PJnH9/NSzXDEWpOOqqhTfXVcIQ1rxCtlEbb4wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243210; c=relaxed/simple;
	bh=wbmJCu10ojcaSDUJzFVWuYhSXPR0NyCYlxnN5zFZU6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBWm5+IJR8N8IVcLj1qaSh6rPN8Yj4EscM0sKbeYJ1jNELEvW9K2VoziS6/JKe+282WxpyuUtdnOLbWNh2GQfA6kp1YnBgPIFiFCX2AfdNt8fPIvzKDWpTcwlc5iQZ1CU6VgKqmXUZ/h+t3ksVZBsCSw+CwpHQaOYl2IHwtDr0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yvjjbm24; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yvjjbm24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422801F000FF;
	Sat, 12 Sep 2026 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243208;
	bh=FTPcSpePu6aVOGyJKmecW0+KK14KeSjb/pMMhA9dX5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yvjjbm24URXwVBRCQpxuco2Pj6UsXHK0PHvK4VlhQqNiMiJEIi2YxHZLBPDrEFTBt
	 qZMNV9zu90xqDaER4aAIftrRBTMgGeFSJxef/DCsl3c+uS3LcebUbld53p4CGl46Rs
	 rzOEaGKVal/7Q4VviPsBKqWbVpwz6jnYvNfFW1UQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 675/798] RDMA/cxgb4: Free debugfs on registration failure
Date: Sat, 12 Sep 2026 09:05:03 +0200
Message-ID: <20260912065532.572723306@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit fe5c16bb6252dea6025b748257ddc3b2665495b0 ]

c4iw_alloc() creates the per-device debugfs tree (dev->debugfs_root via
setup_debugfs()), but it is removed only in c4iw_remove(), not in
c4iw_dealloc().  When RDMA device registration fails, the registration
worker's err_dealloc_ctx path calls c4iw_dealloc() directly, bypassing
c4iw_remove(), so the debugfs dentries leak and outlive the freed
c4iw_dev.

Move debugfs_remove_recursive() into c4iw_dealloc() so every path that
frees ctx->dev also removes its debugfs tree.

Fixes: 49ea0c036ede ("RDMA/iw_cxgb4: cleanup device debugfs entries on ULD remove")
Link: https://patch.msgid.link/r/20260806130128.465460-2-fanwu01@zju.edu.cn
Assisted-by: Codex:gpt-5.6
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
index 94d8fdc44ff41..8cfe2ee349d15 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -935,6 +935,7 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 
 void c4iw_dealloc(struct uld_ctx *ctx)
 {
+	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_rdev_close(&ctx->dev->rdev);
 	WARN_ON(!xa_empty(&ctx->dev->cqs));
 	WARN_ON(!xa_empty(&ctx->dev->qps));
@@ -959,7 +960,6 @@ static void c4iw_remove(struct uld_ctx *ctx)
 	if (!ctx->dev)
 		return;
 
-	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);
 }
-- 
2.53.0



