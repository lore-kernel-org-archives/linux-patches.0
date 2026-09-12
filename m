Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC29383C88;
	Sat, 12 Sep 2026 19:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240006; cv=none; b=W5gwqxDGNcBBd3iPiEtyTDKX6aW/ixge2Av/HCTg9JSVBzLWKRnth90bfJnoaQ9mugd0x11Vu4gITB8pT4Rf6YOPctsKrtr8Zksx84Rb9evCBREADlrmy49R5pkc3H6Xo2jimKwWgU8u7qZBoFE0M61sjKrxJFZReWRfiZAK/EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240006; c=relaxed/simple;
	bh=feQe9L275BFZgNbyI7QH+4NWzL9FG5n5YoFkYbDdwGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F2T1tFEcclOPFW/00Yr2C7nSileGEKszXuiUkl6XOWTxJ8wL875U6kVn7C/ioooH4plma66OP7AtuPC2PbMUTMCsz1NXhutQXy7feF//yY0JA1qD8zL0UDzFal43UksCxqmheOnUWAJYiw8Jn0UWOJnBCiR+L9k42w9apGYcrBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFAD2cam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFAD2cam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01AD41F000FF;
	Sat, 12 Sep 2026 19:06:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240005;
	bh=kblUxIQ7GvnyZFmhAeWtcwj+fvczlIqP2nsUAmqu484=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFAD2camJtFSWZ3Is5dRhgpqhpBgf3qwt6lHnQtdQa9nXzqT1mZn2rRxEtLlcQ5ZJ
	 v0VFNZ0Afyn/G05mBtVyntiaOM9T5uWV+KazJ+UVb7AGx9VjNmkaqnQEYdeBOavY36
	 Xc/baxU//yueCK8wdLI/f0h+6YOetBLIlaV8H6e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 781/935] RDMA/cxgb4: Free debugfs on registration failure
Date: Sat, 12 Sep 2026 09:03:31 +0200
Message-ID: <20260912065544.741181424@linuxfoundation.org>
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



