Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45ACA4E430E;
	Wed, 30 Sep 2026 16:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784181; cv=none; b=GR8WWZ4CVLlT4Iul/j9CEDYkjihK/2VGtrwRu3A65kYRszz0ZSypyn0A4lMO4FPFvE5wAF8iP/nxxC/+CoXUqPVZASFtqd6PAsrDjn/fzzzzeTliVJpcBw2gnLkZXjlpDp6qNx6aVz8Ag+hTEsGptfxiS986n0ANJ5Otsrbz6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784181; c=relaxed/simple;
	bh=YyC7XPv7OcDY0Q7zkFJZJfsy31N7rKtX88/63LZFq/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BqSwTGyT2qdwir3dtOLkwgjOOabIZ95OGQaYYTGZ4nPJ6AxAMa5HF6KAzVY5hXFSIqg3RKWfpasomgqbsq+JlH6DPG1eg66Tzqei2PjSAp7VMl5hkBOf14XAoRFG851BgO+frMrXVhW2PAp6Yf2gQPzvwbV7ykuGRAgO2NbqggM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YSdoL9ID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YSdoL9ID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A175F1F000FF;
	Wed, 30 Sep 2026 16:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784176;
	bh=3wRmPWIMiD0R0vX7eucgni8/V8rTwiRxIKubC1AMTcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSdoL9ID6G42n/dB8rY1WbSSqcfnr1XXWN6/OkmySX8vIBdzCz4o8Gia+wdBiX5BZ
	 fhyvzdoV0mit0+MzsRmboFaLpzPRcPeO4/1MFDoPXZizqLtl26G349dJMnnVtWMaxr
	 CdwfvEPPn+CzupqtRBvpWCRe+K/DOdY3UqRYGhyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Daniel Wagner <dwagner@suse.de>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/982] nvme-core: align fabrics_q teardown with admin_q in nvme_free_ctrl
Date: Wed, 30 Sep 2026 17:13:17 +0200
Message-ID: <20260930152418.106980578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit f702badaf7d31dc3dea6c66da92b5f35fadd89dc ]

Currently, the final reference for the fabrics admin queue (fabrics_q)
is dropped inside nvme_remove_admin_tag_set(). However, the primary admin
queue (admin_q) defers dropping its final reference until
nvme_free_ctrl().

Move the blk_put_queue() call for fabrics_q from
nvme_remove_admin_tag_set() to nvme_free_ctrl(). This aligns the
lifecycle management of both admin queues, ensuring they are freed
symmetrically when the controller is finally torn down.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f7695aba66cc4..66600341bd6aa 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -5050,10 +5050,8 @@ EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
 void nvme_remove_admin_tag_set(struct nvme_ctrl *ctrl)
 {
 	blk_mq_destroy_queue(ctrl->admin_q);
-	if (ctrl->ops->flags & NVME_F_FABRICS) {
+	if (ctrl->fabrics_q)
 		blk_mq_destroy_queue(ctrl->fabrics_q);
-		blk_put_queue(ctrl->fabrics_q);
-	}
 	blk_mq_free_tag_set(ctrl->admin_tagset);
 }
 EXPORT_SYMBOL_GPL(nvme_remove_admin_tag_set);
@@ -5194,6 +5192,8 @@ static void nvme_free_ctrl(struct device *dev)
 
 	if (ctrl->admin_q)
 		blk_put_queue(ctrl->admin_q);
+	if (ctrl->fabrics_q)
+		blk_put_queue(ctrl->fabrics_q);
 	if (!subsys || ctrl->instance != subsys->instance)
 		ida_free(&nvme_instance_ida, ctrl->instance);
 
-- 
2.53.0



