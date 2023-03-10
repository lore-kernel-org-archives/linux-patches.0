Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A238481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B19C4339B;
	Fri, 10 Mar 2023 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457357;
	bh=GnFaU6znMvVjgYZwqXmjwHHmNCtVX80BE4HkEbnvA3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUnuv/9IOTIEi3niU52qTib1Yi+zkXGg3r8rH+WLvrHqU+c+oyZbYX634y39duSMy
	 67sgF5OvLoB/eIydkgnmb1RIJkn0HmcIECBhCOnHoks7YLr7RLXCMPeL2bofPwgbL2
	 XMkmjV2NR94tOklwzpdC0NltIfnC1WzjVlyWuNfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wagner <dwagner@suse.de>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/200] nvme-fabrics: show well known discovery name
Date: Fri, 10 Mar 2023 14:38:37 +0100
Message-Id: <20230310133720.473690247@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daniel Wagner <dwagner@suse.de>

[ Upstream commit 26a57cb35548ae67c14871cccbf50da3edb01ea4 ]

The kernel always logs the unique subsystem name for a discovery
controller, even in the case user space asked for the well known.

This has lead to confusion as the logs of nvme-cli and the kernel
logs didn't match.

First, nvme-cli connects to the well known discovery controller to
figure out if it supports TP8013. If so then nvme-cli disconnects and
connects to the unique discovery controller. Currently, the kernel show
that user space connected twice to the unique one.

To avoid further confusion, show the well known discovery controller if
user space asked for it:

  $ nvme connect-all -v -t tcp -a 192.168.0.1
  nvme0: nqn.2014-08.org.nvmexpress.discovery connected
  nvme0: nqn.2014-08.org.nvmexpress.discovery disconnected
  nvme0: nqn.discovery connected

  kernel log:
  nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 192.168.0.1:8009
  nvme nvme0: Removing ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery"
  nvme nvme0: new ctrl: NQN "nqn.discovery", addr 192.168.0.1:8009

Fixes: e5ea42faa773 ("nvme: display correct subsystem NQN")
Signed-off-by: Daniel Wagner <dwagner@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fabrics.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/fabrics.h b/drivers/nvme/host/fabrics.h
index a6e22116e1396..dcac3df8a5f76 100644
--- a/drivers/nvme/host/fabrics.h
+++ b/drivers/nvme/host/fabrics.h
@@ -189,7 +189,8 @@ nvmf_ctlr_matches_baseopts(struct nvme_ctrl *ctrl,
 
 static inline char *nvmf_ctrl_subsysnqn(struct nvme_ctrl *ctrl)
 {
-	if (!ctrl->subsys)
+	if (!ctrl->subsys ||
+	    !strcmp(ctrl->opts->subsysnqn, NVME_DISC_SUBSYS_NAME))
 		return ctrl->opts->subsysnqn;
 	return ctrl->subsys->subnqn;
 }
-- 
2.39.2



