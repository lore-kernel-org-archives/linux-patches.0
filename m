Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA601A2548;
	Thu,  6 Jun 2024 14:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683740; cv=none; b=prgklyC4Va7lDGZ/EMqew9UD6R83Tq8Xsx3DKwU7xxtsFeIEASkJwbfODC+j8s2udvzxZx4jdJdCHWIbir/Vq2lWjaWCprP+mwRrLniqhZ5c+z1nxQ4nn17/xsqvyFQmG7WxC72BtR05HmSOB/WwNw0SLKrEsCEAOFKgmJYbmwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683740; c=relaxed/simple;
	bh=iRfYlwyjDYddCJKnUrY+wSjzX1bdaHeoXJ7gz1niGt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXD1gWQXU0JiN79TLwuYs2U9ooF9D2llwKnVeD132VJ4GBcMmAP6MUmmEdxP2Hrjd842mtgD9XPLW9gaDgF3k2wc6yHgafmq9fGVVP4+/IqjkwQDbVJmeQddNnM8Ptiumb1/XzuKJh2Lxz26RxfaO1fuMYqDfjt0Z+ZGXdn+wZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ceEjjKSi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ceEjjKSi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3FFC2BD10;
	Thu,  6 Jun 2024 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683739;
	bh=iRfYlwyjDYddCJKnUrY+wSjzX1bdaHeoXJ7gz1niGt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ceEjjKSip8arYHTrKBEIHbr8lNQiIonAZYatzX9Ira1vew8injX+5qEaBXXdgin60
	 ACSLG9YpCxs1efYusHfHXrwOOokoKG14v+GKtTKAY4svNfFRbJg44MJDII79pnh+RF
	 aUQTBwgPYnfDzapM0TJijxrpA+ckdDYnzpTcoZN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 658/744] i3c: master: svc: return actual transfer data len
Date: Thu,  6 Jun 2024 16:05:30 +0200
Message-ID: <20240606131753.566483839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 6d1a19d34e2cc07ca9cdad8892da94e716e9d15f ]

I3C allow devices early terminate data transfer. So set "actual_len" to
indicate how much data get by i3c_priv_xfer.

Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20231201222532.2431484-6-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 7f3d633b460b ("i3c: master: svc: change ENXIO to EAGAIN when IBI occurs during start frame")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index d8d817858e000..3966924d10668 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -135,6 +135,7 @@ struct svc_i3c_cmd {
 	const void *out;
 	unsigned int len;
 	unsigned int actual_len;
+	struct i3c_priv_xfer *xfer;
 	bool continued;
 };
 
@@ -1047,6 +1048,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 
 	if (readl(master->regs + SVC_I3C_MERRWARN) & SVC_I3C_MERRWARN_NACK) {
 		ret = -ENXIO;
+		*actual_len = 0;
 		goto emit_stop;
 	}
 
@@ -1064,6 +1066,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 	 */
 	if (SVC_I3C_MSTATUS_IBIWON(reg)) {
 		ret = -ENXIO;
+		*actual_len = 0;
 		goto emit_stop;
 	}
 
@@ -1159,6 +1162,10 @@ static void svc_i3c_master_start_xfer_locked(struct svc_i3c_master *master)
 					  cmd->addr, cmd->in, cmd->out,
 					  cmd->len, &cmd->actual_len,
 					  cmd->continued);
+		/* cmd->xfer is NULL if I2C or CCC transfer */
+		if (cmd->xfer)
+			cmd->xfer->actual_len = cmd->actual_len;
+
 		if (ret)
 			break;
 	}
@@ -1346,6 +1353,7 @@ static int svc_i3c_master_priv_xfers(struct i3c_dev_desc *dev,
 	for (i = 0; i < nxfers; i++) {
 		struct svc_i3c_cmd *cmd = &xfer->cmds[i];
 
+		cmd->xfer = &xfers[i];
 		cmd->addr = master->addrs[data->index];
 		cmd->rnw = xfers[i].rnw;
 		cmd->in = xfers[i].rnw ? xfers[i].data.in : NULL;
-- 
2.43.0



