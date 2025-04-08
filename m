Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17EA826869D;
	Tue,  8 Apr 2025 12:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113791; cv=none; b=JrDoDi2BUAUTIqLd/qd6DLbTOXGfpelaoZuuPb2qgQTRhUztGWi7IKwzw0IF2QS/kGFjFUeh7tjsl5lYjTtw4lBQoYGjPifo4WNfzcGgaZzDB/TxwLmkTJFo4l7HHaAxNVti+0XHOcmziAdzXGbXXbyy41drqOt6n3O9uOUxhsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113791; c=relaxed/simple;
	bh=6cDrRPRemTCw2vTcZOLy063WBlViY9W2tJYi6fb7KHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ly/v7o654JsaMjXZ4S3CiOtVayhlLhkhby0dAfDRKBoOIytFlexz6jWDSI+X9TsJeBv6BsE3KL4nFkBuOhyBQO+KoCBb4TGXxKg07OAbuo16lwtlFhyHg6UPeZiLs5O8+HBGxeek0TEXSQmnpFp+/1YYupzXmjWMdaV+llIwBk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MYlqMI/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MYlqMI/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D13FC4CEE5;
	Tue,  8 Apr 2025 12:03:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113791;
	bh=6cDrRPRemTCw2vTcZOLy063WBlViY9W2tJYi6fb7KHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MYlqMI/3XR4XFnN3QGYWYumhwGcYcvJfniJdXBjNs9Ii2CntO9qwqR8L3mAofn0Tz
	 kZYpzKWHcgs5MxMN6JG5XLgpvlQC63C2qLzjjqmrU0ljVp22YVci5rmYkx1WMHFp+H
	 qUKngYbxm8KKi6nVGldzDyOLRuH3u3zy7pVajdGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Daniel Wagner <wagi@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/154] nvme-fc: go straight to connecting state when initializing
Date: Tue,  8 Apr 2025 12:49:22 +0200
Message-ID: <20250408104815.957484845@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Wagner <wagi@kernel.org>

[ Upstream commit d3d380eded7ee5fc2fc53b3b0e72365ded025c4a ]

The initial controller initialization mimiks the reconnect loop
behavior by switching from NEW to RESETTING and then to CONNECTING.

The transition from NEW to CONNECTING is a valid transition, so there is
no point entering the RESETTING state. TCP and RDMA also transition
directly to CONNECTING state.

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Daniel Wagner <wagi@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/fc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
index 0d2c22cf12a08..f3c0bff714eba 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3164,8 +3164,7 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
 	list_add_tail(&ctrl->ctrl_list, &rport->ctrl_list);
 	spin_unlock_irqrestore(&rport->lock, flags);
 
-	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_RESETTING) ||
-	    !nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
+	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
 		dev_err(ctrl->ctrl.device,
 			"NVME-FC{%d}: failed to init ctrl state\n", ctrl->cnum);
 		goto fail_ctrl;
-- 
2.39.5



