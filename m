Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FA1EFFA6;
	Mon, 23 Jun 2025 21:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714084; cv=none; b=EAQWXmVVU2A3bfzaZmtArMaZBW15FuKlwSKlURaLsKrscZ13K2SuNXaYf0cXjqIBHiHjkZXhTkb8rZrNPQPeLPwl17xG8qlibfTUvqZa8MOHWeoTT1XFRuMAc/UJxUmyZcMgNvcMdSZx332mtdbfNE2wbQd6kX8ruATZtOKtxeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714084; c=relaxed/simple;
	bh=eQqqWwWBfKFqEqKAzpAWMwCvER7a6pXVDgfuQDKKRSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jcf27LmEaD2f4EZvELFdcWCKsO3McLCfJmtRlTy7482GxDVOiB6dDwrdCELJdRAp7WvF2No/bHD03AfHmlmw1mQpzKPR+ILrKitkaaZRpSkXJywfY70+dEFYYCUa0kewo1rOSpffH2J7Ek9f/teJ3gEpktpb9TYhz8wIuCXjjFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hveF6Zsf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hveF6Zsf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1698C4CEEA;
	Mon, 23 Jun 2025 21:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714084;
	bh=eQqqWwWBfKFqEqKAzpAWMwCvER7a6pXVDgfuQDKKRSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hveF6ZsfSQ6vMY+7+lagmkwl8jD6Duu8PYIDFL+aGh7Axd2wPOsvmxppdVgie4rwH
	 kGsBLuiGKrJWEm938ArXHxd2vZhg5f9YJCSIbtrQ2cGNv8umnPPOxPu30xcBb7Tpje
	 7iRia/0XcGy6FSkRzAKSbTQ9RRhBTA3iVGJfWFM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 164/411] nvmet-fcloop: access fcpreq only when holding reqlock
Date: Mon, 23 Jun 2025 15:05:08 +0200
Message-ID: <20250623130637.818382764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



