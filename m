Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9171BDFB;
	Wed,  3 Jan 2024 17:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLF0zeAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3604BC433C8;
	Wed,  3 Jan 2024 17:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302092;
	bh=eRARaMgP7Hzt0mo3dy6y0gpdVoA5bZaKlaRmqV2m1wY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLF0zeAs/s8fHW1nN5wxUiHuK5jERsMY3VCCbqPH+v5YGgUalwOXo7hurVf1af2td
	 PQ4BvbCLRP6y3QjH4d9Sc+9nMBrfzWFiNVYR3qnwOS1rctxVMbFJaHgY5RQANG4pPs
	 a8wSltoq5Vf2mPNrHjAZ6akEsY8rF/maahgwcaMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Michael Liang <mliang@purestorage.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 43/49] Revert "nvme-fc: fix race between error recovery and creating association"
Date: Wed,  3 Jan 2024 17:56:03 +0100
Message-ID: <20240103164841.656694656@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Keith Busch <kbusch@kernel.org>

commit d3e8b1858734bf46cda495be4165787b9a3981a6 upstream.

The commit was identified to might sleep in invalid context and is
blocking regression testing.

This reverts commit ee6fdc5055e916b1dd497f11260d4901c4c1e55e.

Link: https://lore.kernel.org/linux-nvme/hkhl56n665uvc6t5d6h3wtx7utkcorw4xlwi7d2t2bnonavhe6@xaan6pu43ap6/
Link: https://lists.infradead.org/pipermail/linux-nvme/2023-December/043756.html
Reported-by: Daniel Wagner <dwagner@suse.de>
Reported-by: Maurizio Lombardi <mlombard@redhat.com>
Cc: Michael Liang <mliang@purestorage.com>
Tested-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/fc.c |   21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2548,24 +2548,17 @@ nvme_fc_error_recovery(struct nvme_fc_ct
 	 * the controller.  Abort any ios on the association and let the
 	 * create_association error path resolve things.
 	 */
-	enum nvme_ctrl_state state;
-	unsigned long flags;
-
-	spin_lock_irqsave(&ctrl->lock, flags);
-	state = ctrl->ctrl.state;
-	if (state == NVME_CTRL_CONNECTING) {
-		set_bit(ASSOC_FAILED, &ctrl->flags);
-		spin_unlock_irqrestore(&ctrl->lock, flags);
+	if (ctrl->ctrl.state == NVME_CTRL_CONNECTING) {
 		__nvme_fc_abort_outstanding_ios(ctrl, true);
+		set_bit(ASSOC_FAILED, &ctrl->flags);
 		dev_warn(ctrl->ctrl.device,
 			"NVME-FC{%d}: transport error during (re)connect\n",
 			ctrl->cnum);
 		return;
 	}
-	spin_unlock_irqrestore(&ctrl->lock, flags);
 
 	/* Otherwise, only proceed if in LIVE state - e.g. on first error */
-	if (state != NVME_CTRL_LIVE)
+	if (ctrl->ctrl.state != NVME_CTRL_LIVE)
 		return;
 
 	dev_warn(ctrl->ctrl.device,
@@ -3179,16 +3172,12 @@ nvme_fc_create_association(struct nvme_f
 		else
 			ret = nvme_fc_recreate_io_queues(ctrl);
 	}
-
-	spin_lock_irqsave(&ctrl->lock, flags);
 	if (!ret && test_bit(ASSOC_FAILED, &ctrl->flags))
 		ret = -EIO;
-	if (ret) {
-		spin_unlock_irqrestore(&ctrl->lock, flags);
+	if (ret)
 		goto out_term_aen_ops;
-	}
+
 	changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE);
-	spin_unlock_irqrestore(&ctrl->lock, flags);
 
 	ctrl->ctrl.nr_reconnects = 0;
 


