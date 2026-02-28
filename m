Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AA3375AC8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301745; cv=none; b=HZlgafzWKfxfCg0Onz584w6pATWo1c0liVYsN9qvb3pgISwVU8Aa4MqM0iJzM8xYFlH+elA3uOsxwBwbtJMIJBa4jzW2WamohmjMHV5BNGXe1C3jqof/SSAiSPJkeJkJaaMUPJoDNE9Zl1lmv4bkRyZmkERCK5FGHpQRtbgFKgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301745; c=relaxed/simple;
	bh=8wrK/bGXHQuqF9g+P/uxHCg98NE+Scj77BwNyhDbJSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qL/i+EzUQv0vYbyMhtHnv2K9VAl7rzE4+n//x7TJUn4bTjST9rMMUb17eRQtEGy20uOKQ54P6kY2OEZOOlBJGFew7fOUbqnPmAQmngXIuUkpFCT/K/+mCVyE90vX+nmLZmMyRNWav3vfHjLUM6zUpy/v1gODJo42+WIQg902Cd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=az3FB/N3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="az3FB/N3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42341C116D0;
	Sat, 28 Feb 2026 18:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301744;
	bh=8wrK/bGXHQuqF9g+P/uxHCg98NE+Scj77BwNyhDbJSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=az3FB/N3BB1V9tlNd6EONFOmst6T/Bj99yC6mX2TLlu0OvN+N79ROOdkmNlixAPt9
	 99x17IGLKCcrWwQnoFnSESAd/E7BAL4EHwYXQDCRie0SnrtSrpSShabSC4iaGYcXzy
	 phXi8BWNcScolwq0hMG2MLG+19hS8DSMDF3jDWhx8Wfaa33CyOV5ZHj0JVaQRGOJ30
	 2roW8TfuFyFdCQzgHQK4M7aqnYb4DfR1HyTXKINtCLSlH3oBzPRz5jZuZJDxeGItB5
	 okePCBl2Qjp7KEqfslccQABf4Xqe53yfso3V+HSzSZsabUcIn/yXf/uy9QXxH6Lak0
	 u7vJzsl5I2FUQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Zilin Guan <zilin@seu.edu.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 147/385] media: chips-media: wave5: Fix memory leak on codec_info allocation failure
Date: Sat, 28 Feb 2026 12:56:09 -0500
Message-ID: <20260228180011.1568201-147-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit a519e21e32398459ba357e67b541402f7295ee1b ]

In wave5_vpu_open_enc() and wave5_vpu_open_dec(), a vpu instance is
allocated via kzalloc(). If the subsequent allocation for inst->codec_info
fails, the functions return -ENOMEM without freeing the previously
allocated instance, causing a memory leak.

Fix this by calling kfree() on the instance in this error path to ensure
it is properly released.

Fixes: 9707a6254a8a6 ("media: chips-media: wave5: Add the v4l2 layer")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c | 4 +++-
 drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c | 4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
index e238447c88bbf..8f7154932d24c 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-dec.c
@@ -1835,8 +1835,10 @@ static int wave5_vpu_open_dec(struct file *filp)
 	spin_lock_init(&inst->state_spinlock);
 
 	inst->codec_info = kzalloc(sizeof(*inst->codec_info), GFP_KERNEL);
-	if (!inst->codec_info)
+	if (!inst->codec_info) {
+		kfree(inst);
 		return -ENOMEM;
+	}
 
 	v4l2_fh_init(&inst->v4l2_fh, vdev);
 	filp->private_data = &inst->v4l2_fh;
diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
index 3e35a05c2d8df..a1330c54b17e6 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpu-enc.c
@@ -1546,8 +1546,10 @@ static int wave5_vpu_open_enc(struct file *filp)
 	inst->ops = &wave5_vpu_enc_inst_ops;
 
 	inst->codec_info = kzalloc(sizeof(*inst->codec_info), GFP_KERNEL);
-	if (!inst->codec_info)
+	if (!inst->codec_info) {
+		kfree(inst);
 		return -ENOMEM;
+	}
 
 	v4l2_fh_init(&inst->v4l2_fh, vdev);
 	filp->private_data = &inst->v4l2_fh;
-- 
2.51.0

