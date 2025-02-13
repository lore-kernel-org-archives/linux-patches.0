Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E8415DBBA;
	Thu, 13 Feb 2025 15:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458913; cv=none; b=FJIfn5Cx40EPfmEKk0ychNeJbu/hNbHVO8ST7iz40PHX2IAtIpik6IASk5SvppQYOG+MdB/2bvZ2N5EJeRS7xZfcdLwQkuGXgRpGzYOWJciIWjcnW+pDhz6hXsCJ3jWOSyuWC9u6Pi9wJDDbh2GWPJ1g9fSEnhoELgq/1H57QRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458913; c=relaxed/simple;
	bh=7og+cwnnJFT8oPAT7Sj8C04N+PkjXh7X1CihiHJMjPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMHxkKvuXiKww7Ala93LsomiWZaVnqUw+i846J1jI0vt5pWLOMwKY5Tp7GZQGy6AtcukrMUHgdxiuCYbSCmoCxjOYilIvlKGgB6G7mFSmNaUzzGlP5nha6pOVclpz7NTJJ+b8Cd1Ww8RbGjsG/gxTiQKnxjyj0xhZEjcl7qaKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F5wu3hIm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F5wu3hIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3107DC4CEE5;
	Thu, 13 Feb 2025 15:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458912;
	bh=7og+cwnnJFT8oPAT7Sj8C04N+PkjXh7X1CihiHJMjPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F5wu3hImD8aCGYgM8KX1YMt2RU62qwLNU5pf9Tbgd1xjXPHiPuwqsXO50BASbzQpT
	 lQdi1c+KBBIf/3lCQv1KWimvl4lE4DYJhHhv1frnb5lnNLEsEucpQjR9JaagR3fBfs
	 XFfKkQQLOzpJ7Xoslbjf9I8+E7UAzUNz+dlawxY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <wagi@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 114/443] nvme-fc: use ctrl state getter
Date: Thu, 13 Feb 2025 15:24:39 +0100
Message-ID: <20250213142445.012129000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index b81af7919e94c..682234da2fabe 100644
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



