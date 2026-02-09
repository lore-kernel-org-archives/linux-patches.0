Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D88125B2;
	Mon,  9 Feb 2026 14:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647580; cv=none; b=X9KQmTAqv88o8GzrDoLnqC5nCOijJT9yjJolbD2vGzAnTPeh6zparwVsy2P4dMWjrvYIinh0cpuZBz0OVPUovgYzf7ANNzUGg0PNtY5onnQL6Fyx17HJMFUPHbK+6JmbnT3jOR6dOniN2jC/P9D4kursBl7v4FrklZl0tX7kUGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647580; c=relaxed/simple;
	bh=v6hdiEfCKYeRmnVa0kRvSXzMc5siFMYDnPu0dJYP1TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvWZEZOdRhPiGNWfE/sP52SucRBLhZkSeoBOa7tGYGtSZT5fH2/pAuluMxTiU+JD1y0pa4X8IuWE7oqwjJtXby/9TQNJ+ufEyPTHUZGQBIf6jQAoUboZ1HWHC+4CCsyiQ81+dln1nZv0qZymLRN6KZJZZziRXuUAk9WXmMuhHz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ekwStY+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ekwStY+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6017C116C6;
	Mon,  9 Feb 2026 14:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647580;
	bh=v6hdiEfCKYeRmnVa0kRvSXzMc5siFMYDnPu0dJYP1TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ekwStY+kMQwAevrMGUDsFvkNB+MDMtRUomIHP2dajFl38scRAArdZrxEFZlRQqmwx
	 QUQXKS7xIXjRVhjY+okhT6/g5xjLAyLDbz1MhbXOlYOPc5loeh8/radQt26fnl7W4R
	 yv3LyDAmfhwbo39+MKgkpur75kS6z62z8Ue1ZM58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuhao Jiang <danisjiang@gmail.com>,
	Junrui Luo <moonafterrain@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 125/175] dpaa2-switch: add bounds check for if_id in IRQ handler
Date: Mon,  9 Feb 2026 15:23:18 +0100
Message-ID: <20260209142325.008498985@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junrui Luo <moonafterrain@outlook.com>

[ Upstream commit 31a7a0bbeb006bac2d9c81a2874825025214b6d8 ]

The IRQ handler extracts if_id from the upper 16 bits of the hardware
status register and uses it to index into ethsw->ports[] without
validation. Since if_id can be any 16-bit value (0-65535) but the ports
array is only allocated with sw_attr.num_ifs elements, this can lead to
an out-of-bounds read potentially.

Add a bounds check before accessing the array, consistent with the
existing validation in dpaa2_switch_rx().

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Reported-by: Junrui Luo <moonafterrain@outlook.com>
Fixes: 24ab724f8a46 ("dpaa2-switch: use the port index in the IRQ handler")
Signed-off-by: Junrui Luo <moonafterrain@outlook.com>
Link: https://patch.msgid.link/SYBPR01MB7881D420AB43FF1A227B84AFAF91A@SYBPR01MB7881.ausprd01.prod.outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 0ff234f6a3ed9..66240c340492c 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -1531,6 +1531,10 @@ static irqreturn_t dpaa2_switch_irq0_handler_thread(int irq_num, void *arg)
 	}
 
 	if_id = (status & 0xFFFF0000) >> 16;
+	if (if_id >= ethsw->sw_attr.num_ifs) {
+		dev_err(dev, "Invalid if_id %d in IRQ status\n", if_id);
+		goto out;
+	}
 	port_priv = ethsw->ports[if_id];
 
 	if (status & DPSW_IRQ_EVENT_LINK_CHANGED)
-- 
2.51.0



