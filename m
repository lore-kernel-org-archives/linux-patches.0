Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92314F121;
	Thu, 13 Feb 2025 15:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460414; cv=none; b=l4WIehnHUQJlgYhyi7xjlGXsdN0rzeochVOFE3ySxf+3HNMMLFbtFjfXGZRgrmpWurL3mh7c7zOj3StMXC3lUH0BkN2wAaYhmAFFFZSekODgIz6edDRbAAsYhtCk1buOw+gsX5sxyh4yJrUY5ovUUKT7fxY1TYi0/xRfEyOqvgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460414; c=relaxed/simple;
	bh=Ck+rA0qkslfTMh8qOlGZu1ED2ZCmlmVSFAgL9JBLDHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q1BInSe86+1Fw3hGEzAm/jlxHuxMHEcq6PhouMks9FU5qbsmxoBMJP9W0TDYfmjouWx+Fm3qSdF0d9WRzkXxTZNHH1DhnjEzM5EzKCesh9C0DLNZK9MLF+sl5kFGkISOLav8Jjlv6sPas2ncKiZIpVEMomz9910FV58fmciym6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1Rp96TA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1Rp96TA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4C7DC4CED1;
	Thu, 13 Feb 2025 15:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460414;
	bh=Ck+rA0qkslfTMh8qOlGZu1ED2ZCmlmVSFAgL9JBLDHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1Rp96TA2WqzHWKI8KGLYtYVUMc1x8AOLV2rtxSQn/OR+W22W2ug1wZmTxh9rBtSn
	 nRzRtx9UO/GjSg0T15u4EqHp2i6F+r8Sfoq6cy72dyXdYT2qFKVn0IWkqwVLzLlGcW
	 fmHofWJA+iFmomvrIcgEhM0VCYkhnf85lwUhBwic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/273] nvme-fc: use ctrl state getter
Date: Thu, 13 Feb 2025 15:27:16 +0100
Message-ID: <20250213142409.884812786@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit c8ed6cb5d37bc09c7e25e49a670e9fd1a3bd1dfa ]

Do not access the state variable directly, instead use proper
synchronization so not stale data is read.

Fixes: e6e7f7ac03e4 ("nvme: ensure reset state check ordering")
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index cdb1e706f855e..91324791a5b66 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -2080,7 +2080,8 @@ nvme_fc_fcpio_done(struct nvmefc_fcp_req *req)
 		nvme_fc_complete_rq(rq);
 
 check_error:
-	if (terminate_assoc && ctrl->ctrl.state != NVME_CTRL_RESETTING)
+	if (terminate_assoc &&
+	    nvme_ctrl_state(&ctrl->ctrl) != NVME_CTRL_RESETTING)
 		queue_work(nvme_reset_wq, &ctrl->ioerr_work);
 }
 
@@ -2534,6 +2535,8 @@ __nvme_fc_abort_outstanding_ios(struct nvme_fc_ctrl *ctrl, bool start_queues)
 static void
 nvme_fc_error_recovery(struct nvme_fc_ctrl *ctrl, char *errmsg)
 {
+	enum nvme_ctrl_state state = nvme_ctrl_state(&ctrl->ctrl);
+
 	/*
 	 * if an error (io timeout, etc) while (re)connecting, the remote
 	 * port requested terminating of the association (disconnect_ls)
@@ -2541,7 +2544,7 @@ nvme_fc_error_recovery(struct nvme_fc_ctrl *ctrl, char *errmsg)
 	 * the controller.  Abort any ios on the association and let the
 	 * create_association error path resolve things.
 	 */
-	if (ctrl->ctrl.state == NVME_CTRL_CONNECTING) {
+	if (state == NVME_CTRL_CONNECTING) {
 		__nvme_fc_abort_outstanding_ios(ctrl, true);
 		set_bit(ASSOC_FAILED, &ctrl->flags);
 		dev_warn(ctrl->ctrl.device,
@@ -2551,7 +2554,7 @@ nvme_fc_error_recovery(struct nvme_fc_ctrl *ctrl, char *errmsg)
 	}
 
 	/* Otherwise, only proceed if in LIVE state - e.g. on first error */
-	if (ctrl->ctrl.state != NVME_CTRL_LIVE)
+	if (state != NVME_CTRL_LIVE)
 		return;
 
 	dev_warn(ctrl->ctrl.device,
-- 
2.39.5



