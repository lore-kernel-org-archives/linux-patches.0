Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D746B309EEB;
	Sat, 12 Sep 2026 15:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225332; cv=none; b=qtIRZzuoG4d29HWwuw+oHS9l6leQk/mwOVEtyLi/ItOQZPSeIpjhHpiWLimLK/LcMtXSx5S6O24khTPyYtuQxx3Y/zUfzYkGHW/oghLeED1pRPwgJu7TDRtUYR+/9XEcyMWAzOoPkqWxT7MD5LNze8xhpdCnkusbJ1uofQA7AZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225332; c=relaxed/simple;
	bh=O0NG4PWTWSe+UxoswAiKktq9yawhxYFZeBBnml0kuYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wlx1EUldyZkIe2lfOpovMLeavUpWEPeD1WUHcCu8xbAA03YF++PFUNkShETFQ+TwEzhxdA49Irr1my3o9qGBAdM5QlDKxNL17BfmeEoyOBG0E7n3hkTGGdVUFQHZuQQfITQzzqacaZKq1aHx8plmtlu5/s6qkoHYxCvc6sYgkp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3y5PHd/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3y5PHd/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC501F000FF;
	Sat, 12 Sep 2026 15:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225330;
	bh=9PKlJjgk60MFL3Nx3RyQh+g8RDQ8KFVBh0mOx52hdtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3y5PHd/o2j4JfaIdI3mMP30zQY9+d/8SX03ofnzmIOFzgIot3kqxEWA7GS4lie4t
	 2xeyF+Nxw5YPJKdVwPo4oYE4xPUlvq4EACfwVFUilD93PdCJpW6fpcxLVS0Hl6uZzO
	 1okhXOnmKKj4+2ZKaDR3zbEcxAVx3CnZLwHq2EPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1174/1424] RDMA/cxgb4: Free debugfs on registration failure
Date: Sat, 12 Sep 2026 09:00:06 +0200
Message-ID: <20260912065633.583990395@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index ac86a77c712e9..d5101cabbd4b6 100644
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



