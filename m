Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12A19049B;
	Mon, 23 Jun 2025 21:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715477; cv=none; b=W8RM/yeZAq58J7xSSPyEzsiCCQY27Vm2D4fXNvR4ITE68grtd0G7KP2G6H62fFB5NDMhyWuSWidI0rbMLjWDRYbe+Wi78+9sc4gajkoi2IlVXy6xeJwodyyWiLvThI9eNXPQBsI90poIiGPxW0mP9zeMG2BNa1KkvLWDmBVFOEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715477; c=relaxed/simple;
	bh=XhIrbpUoksmRlnWo5tsAoscKSh2Mqw9a+w0LsweCK9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHDD1yxxgEi/IdK5zwwFc/xYplET22yoFY9FLhRUV2r300x4QKGOwWQ2j2gmCTyl+6Swy5RebFnLjeGi18sm2dU9ELv2mge4ysh7vMqNTXxXNdS7LS69NSi3l4aORsJZ6gAUSCzV4KnT2tEFT7SYXeZIcBi5AmdoO2cGgCbJa7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amZkpWs/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amZkpWs/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8016C4CEEA;
	Mon, 23 Jun 2025 21:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715477;
	bh=XhIrbpUoksmRlnWo5tsAoscKSh2Mqw9a+w0LsweCK9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amZkpWs/CIqh3BsrNVPcGCko2RUvOml1EmIajAhamATDi6Vm/amJdoiojf7yZ6gDt
	 zZzgizwbACfV7kQyIKO120fHSfiR33RY8dUGuuqkIV+JlM1/xGzgszpRb47faP08Uy
	 bUuJb/+mSRL5RMaCkye1bI7SZmUEobBISJXYQW+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/508] nvmet-fcloop: access fcpreq only when holding reqlock
Date: Mon, 23 Jun 2025 15:05:08 +0200
Message-ID: <20250623130651.717531128@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit 47a827cd7929d0550c3496d70b417fcb5649b27b ]

The abort handling logic expects that the state and the fcpreq are only
accessed when holding the reqlock lock.

While at it, only handle the aborts in the abort handler.

Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fcloop.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
index 787dfb3859a0d..74fffcab88155 100644
--- a/drivers/nvme/target/fcloop.c
+++ b/drivers/nvme/target/fcloop.c
@@ -613,12 +613,13 @@ fcloop_fcp_recv_work(struct work_struct *work)
 {
 	struct fcloop_fcpreq *tfcp_req =
 		container_of(work, struct fcloop_fcpreq, fcp_rcv_work);
-	struct nvmefc_fcp_req *fcpreq = tfcp_req->fcpreq;
+	struct nvmefc_fcp_req *fcpreq;
 	unsigned long flags;
 	int ret = 0;
 	bool aborted = false;
 
 	spin_lock_irqsave(&tfcp_req->reqlock, flags);
+	fcpreq = tfcp_req->fcpreq;
 	switch (tfcp_req->inistate) {
 	case INI_IO_START:
 		tfcp_req->inistate = INI_IO_ACTIVE;
@@ -633,16 +634,19 @@ fcloop_fcp_recv_work(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&tfcp_req->reqlock, flags);
 
-	if (unlikely(aborted))
-		ret = -ECANCELED;
-	else {
-		if (likely(!check_for_drop(tfcp_req)))
-			ret = nvmet_fc_rcv_fcp_req(tfcp_req->tport->targetport,
-				&tfcp_req->tgt_fcp_req,
-				fcpreq->cmdaddr, fcpreq->cmdlen);
-		else
-			pr_info("%s: dropped command ********\n", __func__);
+	if (unlikely(aborted)) {
+		/* the abort handler will call fcloop_call_host_done */
+		return;
+	}
+
+	if (unlikely(check_for_drop(tfcp_req))) {
+		pr_info("%s: dropped command ********\n", __func__);
+		return;
 	}
+
+	ret = nvmet_fc_rcv_fcp_req(tfcp_req->tport->targetport,
+				   &tfcp_req->tgt_fcp_req,
+				   fcpreq->cmdaddr, fcpreq->cmdlen);
 	if (ret)
 		fcloop_call_host_done(fcpreq, tfcp_req, ret);
 
@@ -659,9 +663,10 @@ fcloop_fcp_abort_recv_work(struct work_struct *work)
 	unsigned long flags;
 
 	spin_lock_irqsave(&tfcp_req->reqlock, flags);
-	fcpreq = tfcp_req->fcpreq;
 	switch (tfcp_req->inistate) {
 	case INI_IO_ABORTED:
+		fcpreq = tfcp_req->fcpreq;
+		tfcp_req->fcpreq = NULL;
 		break;
 	case INI_IO_COMPLETED:
 		completed = true;
@@ -683,10 +688,6 @@ fcloop_fcp_abort_recv_work(struct work_struct *work)
 		nvmet_fc_rcv_fcp_abort(tfcp_req->tport->targetport,
 					&tfcp_req->tgt_fcp_req);
 
-	spin_lock_irqsave(&tfcp_req->reqlock, flags);
-	tfcp_req->fcpreq = NULL;
-	spin_unlock_irqrestore(&tfcp_req->reqlock, flags);
-
 	fcloop_call_host_done(fcpreq, tfcp_req, -ECANCELED);
 	/* call_host_done releases reference for abort downcall */
 }
-- 
2.39.5



