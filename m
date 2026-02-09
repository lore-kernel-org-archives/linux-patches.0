Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9452C22301;
	Mon,  9 Feb 2026 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648298; cv=none; b=ZPW0/nixB/ZN7d5ZSyDJXsbNjxiP0jvrjlY6YdDLfeK9IC+YLQ/yCssy64SwIKrsM9ePKrFVhxIay4YiKnMfe9sJDBaqMgmLsNTynrY7CkpXcPf7a+jcUgb5iUPDwncRGNakH9wl82XZGZEm7T+Wehdp3JzXpcNze0jpfMRYOX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648298; c=relaxed/simple;
	bh=BIG8sZnZYpQBN8KLtk8TYUsJysYVJIcz7XdWRyIFVHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J+GXHv2yTlC/2/fAGLVSPzt2nD1NeRUL4QAb8+N7jGZYbofRsZvYQYIywYj6NUekmHUeEs58nuJUzsfb7l/az3WRJ274s//l5qWBhG/i5vTCUkb4OZNH0lT1rOHuU7CEG7PrMVEiSksEgMQaoyLc9bzrnnqCjQ99B49XAJC4tzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wSdEMEGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wSdEMEGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15FC9C19422;
	Mon,  9 Feb 2026 14:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648298;
	bh=BIG8sZnZYpQBN8KLtk8TYUsJysYVJIcz7XdWRyIFVHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wSdEMEGhbaGDBZcCdfrGpGGl68Q7k02ds8Gexh9K9Bck0jXxgpvqMPg5bh87fcf12
	 7n8B2Qrxo0VxVuesfAA00GnLY1aUqmy2NElDcrDg0fuf+ncZ6bkC1brEStBXs3JTdY
	 9N8H6OStSsdhdQCQkJUwIaNnq13uOsSO2BJjyL0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Justin Tee <justin.tee@broadcom.com>,
	Chaitanya Kulkarni <ckulkarnilinux@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/69] nvme-fc: release admin tagset if init fails
Date: Mon,  9 Feb 2026 15:24:06 +0100
Message-ID: <20260209142303.296273241@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.913348974@linuxfoundation.org>
References: <20260209142301.913348974@linuxfoundation.org>
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

From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>

[ Upstream commit d1877cc7270302081a315a81a0ee8331f19f95c8 ]

nvme_fabrics creates an NVMe/FC controller in following path:

    nvmf_dev_write()
      -> nvmf_create_ctrl()
        -> nvme_fc_create_ctrl()
          -> nvme_fc_init_ctrl()

nvme_fc_init_ctrl() allocates the admin blk-mq resources right after
nvme_add_ctrl() succeeds.  If any of the subsequent steps fail (changing
the controller state, scheduling connect work, etc.), we jump to the
fail_ctrl path, which tears down the controller references but never
frees the admin queue/tag set.  The leaked blk-mq allocations match the
kmemleak report seen during blktests nvme/fc.

Check ctrl->ctrl.admin_tagset in the fail_ctrl path and call
nvme_remove_admin_tag_set() when it is set so that all admin queue
allocations are reclaimed whenever controller setup aborts.

Reported-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index dc84cade703db..63bef22095b41 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3563,6 +3563,8 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 
 	ctrl->ctrl.opts = NULL;
 
+	if (ctrl->ctrl.admin_tagset)
+		nvme_remove_admin_tag_set(&ctrl->ctrl);
 	/* initiate nvme ctrl ref counting teardown */
 	nvme_uninit_ctrl(&ctrl->ctrl);
 
-- 
2.51.0



