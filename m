Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25213DF00B;
	Sat, 17 Oct 2026 16:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255381; cv=none; b=ZgFHXfgzQU9S6hghMYX6Q+ogDvWrveroSjkArSy7isKoybhXw0nd6Adc9wvQedxms+9ZSsBSvKU14sCn6sfVl+C8B7B0YEW/0X4vveaiMfOCB6DnG+ZjQZ9u6yMfuli3bvuATwycY+dbScXkntmHrVnhWsbF81zPjtsVjG+Jdco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255381; c=relaxed/simple;
	bh=xTKonb7UMwFoYflpHp/eXPT7vMnobcANVcU9XlxCJog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjx/1xUksHYw1Nc59ezwb2ixMJgXEt2gBKP7jwFYFtCZWKekWgAv2x76ncEDimQtjpTViIEl101MpBJyKbgR+952bZ+AoMG+0gzFrf9HfsfZ5KGyN9HlakZvbbcSwsEYaEJ3bp+Bwfw0o5h0pPPKqrAkCQ3WmgplLw1vzougEdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0FyLv2Gc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0FyLv2Gc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CFF1F000C4;
	Sat, 17 Oct 2026 16:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255380;
	bh=pyO7yHoW5SWOwVNscIfQMhQseF9c8RFWYbk+TI0+H50=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0FyLv2Gc6dqgQg8rNKgCJs6aBbOe9vzxo0oIfvMwAIfhhhDBes9lXtU9rUDHizJMI
	 gflBwLVBREiiZb/A8kNip2dC3AIMuKcw9DLBwF+Rq8++rCb9tlTsAo7zn11Jn5Kd89
	 MHx/DZlfhScIyMkWc60P+T4VSIIiGY0oU3fsv3gI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brandon Brnich <b-brnich@ti.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Jackson Lee <jackson.lee@chipsnmedia.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 758/869] media: chips-media: wave5: Release m2m_ctx after Instance Removed from List
Date: Sat, 17 Oct 2026 17:59:59 +0200
Message-ID: <20261017160056.363442949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
index 56914c749c045..f5deae9480923 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-helper.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-helper.c
@@ -67,7 +67,6 @@ int wave5_vpu_release_device(struct file *filp,
 	int ret = 0;
 	unsigned long flags;
 
-	v4l2_m2m_ctx_release(inst->v4l2_fh.m2m_ctx);
 	/*
 	 * To prevent Null reference exception, the existing irq handler were
 	 * separated to two modules.
@@ -88,6 +87,9 @@ int wave5_vpu_release_device(struct file *filp,
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



