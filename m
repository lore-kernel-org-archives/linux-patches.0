Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27EDB1CAA60;
	Wed, 19 Mar 2025 14:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395209; cv=none; b=UbvzkJsAuix6XFXG+v3jB6iRZuOdFnrHGXUR1vKKIeywNzrz/A+WPbZ7KwpyRFXWOlGsjylF9ecFn68xn/x/sAewnttPG5iyIv13FJqCQ1p5ZXO/Z5B/fHKo569EA5XaZ5aPUaA3vGnNUcaFH6r0ltoWua/lEtqYaVnnEzb7XnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395209; c=relaxed/simple;
	bh=QUbAHPUYuccFgqe66U7UkVwrOKVVuIjtGknNh7g0akQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buAUr3X2BJyHN049IF7wVG/B9SUqY05Cm0RMO9UPfpZIxtG0XN+3lDdZQvad+kkFWsQJF3kh4NunKwQXAhVzoC2JQIBRtKhMr4numZ8CLPS1vf8nZzZdxp+W14d4YAXRU2vXWX+hisJ2WEniuNbRWcz1sZ2KD51wZculLvYI49A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TueMxVYe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TueMxVYe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0373C4CEE4;
	Wed, 19 Mar 2025 14:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395209;
	bh=QUbAHPUYuccFgqe66U7UkVwrOKVVuIjtGknNh7g0akQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TueMxVYeXTLco6tYVdPOTQhWE+42rrOURzMb40Dw0fnpOq9K8AMros0Up4USdaQpX
	 h4B033V9qAFqPDDZ9uF1u3YDSZt1hhWrNcUGM3AMsNbs6GBXJoh/69d7F3nSTOSY4v
	 EcdP9FH0hWbguGeOvfUmiGootnSdI26Ug7rJhgsM=
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
Subject: [PATCH 6.6 036/166] nvme-fc: go straight to connecting state when initializing
Date: Wed, 19 Mar 2025 07:30:07 -0700
Message-ID: <20250319143020.968234016@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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
index 91324791a5b66..0641050f590f3 100644
--- a/drivers/nvme/host/fc.c
+++ b/drivers/nvme/host/fc.c
@@ -3553,8 +3553,7 @@ nvme_fc_init_ctrl(struct device *dev, struct nvmf_ctrl_options *opts,
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



