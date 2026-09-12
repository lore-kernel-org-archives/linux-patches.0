Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1DF369990;
	Sat, 12 Sep 2026 08:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203242; cv=none; b=nkBCEo4Vn0k4Bbu3UIEydrPr/jDn/nEsltW2NsCfcSAu+IJp5Jmh9LJc6L2M40iRPS0GT6xP6zkMcQYoaDW28lBagtr0MWF0uT99dmdhSmQn5gMlr64VCKqiwaKULJpwZUUmXrxs7yOn/b1GDi2plZ/jADkODa8U870u8dfRKeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203242; c=relaxed/simple;
	bh=YZYCoTDUQ2eOg095rew2+yPAvjKx/SycODzNjK2wG98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MWj5qcliLiYdGu/8eJP1t0yKLnhfVWOAWOb7uf7rU+VXqhOnwPCRkdhLoKgLQ+upkM+h1dw7Qs6xe6GdcCWtvgXJsvZT2I2/Ko84gPkWtJGDaZQnU7jHeoMoRtA1jTK+qIs16ANDuuhHPOO/qAKTGHKN9ZqWbhjW291XIIg/1NQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b3apBcQg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b3apBcQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042DD1F000FF;
	Sat, 12 Sep 2026 08:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203240;
	bh=wbF4dPpKH08Zgj6lrAviV5a/HdFQN1fdPSyUI4801rQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b3apBcQgOKjjendVZbqoceJHwVoDnnfRv41kGCtkwKI1nLnNOMUNZ7E2mBQEAWUk3
	 cjo54tDt57nYgmX4zXrkGjlJqZl/XTZybthvR61+Qr/BEsv6A9zoIaX9lbtm1aKQee
	 xc1GSigWV2Kc3++ihbUoPA4tFtyG0aQLGBUbxWws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1366/1815] RDMA/cxgb4: Free debugfs on registration failure
Date: Sat, 12 Sep 2026 08:51:56 +0200
Message-ID: <20260912065721.098459713@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index c1815972aecff..24ac9871ce67c 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -933,6 +933,7 @@ static void c4iw_rdev_close(struct c4iw_rdev *rdev)
 
 void c4iw_dealloc(struct uld_ctx *ctx)
 {
+	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_rdev_close(&ctx->dev->rdev);
 	WARN_ON(!xa_empty(&ctx->dev->cqs));
 	WARN_ON(!xa_empty(&ctx->dev->qps));
@@ -957,7 +958,6 @@ static void c4iw_remove(struct uld_ctx *ctx)
 	if (!ctx->dev)
 		return;
 
-	debugfs_remove_recursive(ctx->dev->debugfs_root);
 	c4iw_unregister_device(ctx->dev);
 	c4iw_dealloc(ctx);
 }
-- 
2.53.0



