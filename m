Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350FE429000;
	Sat, 12 Sep 2026 13:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218091; cv=none; b=VRocRpI1c5vIULsbqKXA/yZjZNjn9ChkuUDiTERSGVcQUAK467DBUZ0fH0KEyLAzClNmwXJG2nwLlC15m+KNmYin9wWGthhQgNbzVWQOx+fMjAoLC9lEciIAfAEqOxzl9CciQZJlpCJ9d92ocM7oliMqJ/gJNLL1PPP2mRJc6xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218091; c=relaxed/simple;
	bh=B/tncWTKybFPtjU1kTz0TMPtgemjn1kqngIwf/uyOFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV/pek21nV7wCDCWACLk2Lw1dfuS18lLNn3q+QhUVSLP4htPSMSrVDSTY6gUouHSM4gWzOZTp35f0fZnxIkAdoLxo9NC61I5zD2NpIgMmxzPLbr6WmPr1kMCTmpbpgqOXjKKNnKJCUxh/PwlsWzXNCC/ktX2YD0IVR10lMoIvHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KivF84N3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KivF84N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958941F000FF;
	Sat, 12 Sep 2026 13:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218088;
	bh=hdwjcDxFz02Yv0yjH+zVeZpy334vKYdd1gsgOSFOlGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KivF84N3maVCFzTWBCOpTSOqHGkrRjbo1lGVOUFLySOF/cdUgaWSVwfzMcZvl23rW
	 pKwq2yF7MBac9p+yRb+3v85DWqunF0mqVXofTBDb66fMl5Yd9ov4CfS0oNmkDnblNA
	 ZzPwT2Qrx6qj9BrdEpXY2l6vj3iyaE46JqHWAs0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fan Wu <fanwu01@zju.edu.cn>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1074/1376] RDMA/cxgb4: Free debugfs on registration failure
Date: Sat, 12 Sep 2026 08:58:20 +0200
Message-ID: <20260912065631.497441034@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



