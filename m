Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99CC28EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355FFC433EF;
	Mon, 30 Jan 2023 14:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087667;
	bh=brB7bgfLoakBLH/oGDpWQsl69DTnzmDQyIWgGBlFcjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CBsd4xfcb0bX1XinwpKyLH4xx2Q0J+fDEX5zE4OtCb/n3ctnUy5poa4yua2Wr/1tn
	 6HgVWQeS5Fb+LsCQaWurEDel2lhnBHLHXO7iqxZmX9Y1GvrPjucwTaUuRzKbm27/Ik
	 yrm2+I+LyDWjaIQGaQgMSgG+qXe/n95tJ2gpJSDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 284/313] nvme: fix passthrough csi check
Date: Mon, 30 Jan 2023 14:51:59 +0100
Message-Id: <20230130134349.949679108@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 85eee6341abb81ac6a35062ffd5c3029eb53be6b ]

The namespace head saves the Command Set Indicator enum, so use that
instead of the Command Set Selected. The two values are not the same.

Fixes: 831ed60c2aca2d ("nvme: also return I/O command effects from nvme_command_effects")
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 9e9ad91618ab..25ade4ce8e0a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1088,7 +1088,7 @@ u32 nvme_command_effects(struct nvme_ctrl *ctrl, struct nvme_ns *ns, u8 opcode)
 	if (ns) {
 		if (ns->head->effects)
 			effects = le32_to_cpu(ns->head->effects->iocs[opcode]);
-		if (ns->head->ids.csi == NVME_CAP_CSS_NVM)
+		if (ns->head->ids.csi == NVME_CSI_NVM)
 			effects |= nvme_known_nvm_effects(opcode);
 		if (effects & ~(NVME_CMD_EFFECTS_CSUPP | NVME_CMD_EFFECTS_LBCC))
 			dev_warn_once(ctrl->device,
-- 
2.39.0



