Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631B53438A8;
	Thu, 17 Sep 2026 16:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660993; cv=none; b=Si1KJRhG3op/l7hnsgeKcaCvGTtTaWPTTMQROjkPvbYsne+BqKFRf4CIiy6wwEBrr0gvchCNiZuFWowNIMWpfof+r9O1faIODJk3+SvPNk3uuJ7pfPCg7i/KCszzwIAg0M0Vkma0vqqFbb6J5Op7HWXr/AafqxyQGoYHOVE9LvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660993; c=relaxed/simple;
	bh=pEyMvqGb6pbUHFA/30A+LSQlj3vAxbPN+DyhNPePG2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUO8Y6WPv+TAveubfY1qbB+mVVbiaOp/CtwiDKWP0BL/AqMiztCNq9AG8X5t+NmMjXOxMcx6YQ1dXtuVczYzlSvYnJdGLaRPadZlXxNHf2cDB6pmWOG3iUrm82LefUPudPg4VsA1etKtvF1yUo6UrJ3O0KLGc8pQk3raTvf3Q+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nIp0X5w3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nIp0X5w3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD481F000FF;
	Thu, 17 Sep 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660992;
	bh=zj5cUPEgdnclXcSRSgIhl649tXj9u7tUNan/STOe2ZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIp0X5w3M/Ul4nGgyuCZmXiBLI+rU/b3hW4WV6W+MgY92+z4M19G7btGq0Scp7n3M
	 fjE7JJKVE1nVjf6uuynZzYdat8kQzmkqR+Av8EjKI7zq3SBk7F+9uQpfz7koC05PoA
	 uEyWm9KeY2HRbn6h8k7He8k1vI1hl5h8oQjgYOdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0047/1250] media: chips-media: wave5: Release m2m_ctx after Instance Removed from List
Date: Thu, 17 Sep 2026 15:57:22 +0100
Message-ID: <20260917151553.214773327@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brandon Brnich <b-brnich@ti.com>

[ Upstream commit 7cdbd7bb21949a8fda10c7104a2b12ee363cbf5c ]

Possible use after free if IRQ thread manages to obtain spinlock between
m2m_ctx release and wave5_release function removing stream instance from
list of active instances. The IRQ thread looks for the m2m_ctx which is
freed so null pointer dereference occurs.

Signed-off-by: Brandon Brnich <b-brnich@ti.com>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Tested-by: Jackson Lee <jackson.lee@chipsnmedia.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/chips-media/wave5/wave5-helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-helper.c b/drivers/media/platform/chips-media/wave5/wave5-helper.c
index 53a0ac068c2e2..c3d34be833ff0 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-helper.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-helper.c
@@ -68,7 +68,6 @@ int wave5_vpu_release_device(struct file *filp,
 	int ret = 0;
 	unsigned long flags;
 
-	v4l2_m2m_ctx_release(inst->v4l2_fh.m2m_ctx);
 	/*
 	 * To prevent Null reference exception, the existing irq handler were
 	 * separated to two modules.
@@ -89,6 +88,9 @@ int wave5_vpu_release_device(struct file *filp,
 	list_del_init(&inst->list);
 	spin_unlock_irqrestore(&inst->dev->irq_spinlock, flags);
 	mutex_unlock(&inst->dev->irq_lock);
+
+	v4l2_m2m_ctx_release(inst->v4l2_fh.m2m_ctx);
+
 	if (inst->state != VPU_INST_STATE_NONE) {
 		u32 fail_res;
 
-- 
2.53.0



