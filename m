Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7DE934CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383C3C433D2;
	Wed,  7 Jun 2023 20:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686170624;
	bh=wNda3bZlc2vfyvi7DQgqvTCZhG0Vfg3T2a4I9OeFoXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sWdSouo6eVlDWjxZXB0+2cAHKC619v4cUHyE/B1+vR5WBMLrRYuNd1JuSTJ/DbnpB
	 DcSzGOVafxXSVYUCOTiWEeHdrhOpBQ1l5y9NeJN5qyVNEquNtxJe1xfdBar/Xj6S7I
	 dNgYIpTIOGygRGS4BtSushuKoBKBWp4k22H0c6vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/225] nvme: do not let the user delete a ctrl before a complete initialization
Date: Wed,  7 Jun 2023 22:15:18 +0200
Message-ID: <20230607200918.469938415@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
References: <20230607200913.334991024@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 2eb94dd56a4a4e3fe286def3e2ba207804a37345 ]

If a userspace application performes a "delete_controller" command
early during the ctrl initialization, the delete operation
may race against the init code and the kernel will crash.

nvme nvme5: Connect command failed: host path error
nvme nvme5: failed to connect queue: 0 ret=880
PF: supervisor write access in kernel mode
PF: error_code(0x0002) - not-present page
 blk_mq_quiesce_queue+0x18/0x90
 nvme_tcp_delete_ctrl+0x24/0x40 [nvme_tcp]
 nvme_do_delete_ctrl+0x7f/0x8b [nvme_core]
 nvme_sysfs_delete.cold+0x8/0xd [nvme_core]
 kernfs_fop_write_iter+0x124/0x1b0
 new_sync_write+0xff/0x190
 vfs_write+0x1ef/0x280

Fix the crash by checking the NVME_CTRL_STARTED_ONCE bit;
if it's not set it means that the nvme controller is still
in the process of getting initialized and the kernel
will return an -EBUSY error to userspace.
Set the NVME_CTRL_STARTED_ONCE later in the nvme_start_ctrl()
function, after the controller start operation is completed.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index f502e032e7e46..2e22c78991ccf 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3540,6 +3540,9 @@ static ssize_t nvme_sysfs_delete(struct device *dev,
 {
 	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
 
+	if (!test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags))
+		return -EBUSY;
+
 	if (device_remove_file_self(dev, attr))
 		nvme_delete_ctrl_sync(ctrl);
 	return count;
@@ -4980,7 +4983,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	 * that were missed. We identify persistent discovery controllers by
 	 * checking that they started once before, hence are reconnecting back.
 	 */
-	if (test_and_set_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
+	if (test_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags) &&
 	    nvme_discovery_ctrl(ctrl))
 		nvme_change_uevent(ctrl, "NVME_EVENT=rediscover");
 
@@ -4991,6 +4994,7 @@ void nvme_start_ctrl(struct nvme_ctrl *ctrl)
 	}
 
 	nvme_change_uevent(ctrl, "NVME_EVENT=connected");
+	set_bit(NVME_CTRL_STARTED_ONCE, &ctrl->flags);
 }
 EXPORT_SYMBOL_GPL(nvme_start_ctrl);
 
-- 
2.39.2



