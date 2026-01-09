Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766171946C8;
	Fri,  9 Jan 2026 12:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960394; cv=none; b=OqZ6BZOOf1xmCmIjwWIYu69THsKULbdFbGP+S73j0dOfwvS9bKGsGGd9hhPkPhZX/fCrgy9JDEmu7guaMEPioIiFlribtJaiHLOnzww972mcYQdaHccBxAtyKjhWtm5LCdInFAjSFBZJ1NsL94dTgaPFsOqobByq9BxHI7j7PnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960394; c=relaxed/simple;
	bh=li2WSKYBpdRLipsnj9Hk51wb4VA3vsXWU+VRXT4S/A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XxodUarwaHGo3YshXnXIPMEMopFtGkbsvLVF6AcnmvT6cUG8eFZtovpTC8BmbMfNN24IrgK+eufGHpgaAkmbcmTTXczYjmrAjzNSRTgyoQekk89oiGeT3b0Gcz4FXTJcpEIhNjVGlmJyxuxUvc6WoS4dqiuCkI8qYLIPzlnxh0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSVCUKRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSVCUKRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C8EC4CEF1;
	Fri,  9 Jan 2026 12:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960394;
	bh=li2WSKYBpdRLipsnj9Hk51wb4VA3vsXWU+VRXT4S/A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSVCUKRP0wcY5ssw+Z+rEIV7hbyeKXqWt9a1xKdjSnGE40HnF96RXWr0Pgbj7Esp0
	 KrHhZx9WTrvj0l5NkK1Ch5iHvfpGkyhzjbrTEtOhugIpavFic+JSIVaL5F35ohye4D
	 YAZ0i1Fd4tH/V1odVDHZr44Jmwp4clwD+jpJB9OY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 387/737] firmware: imx: scu-irq: Init workqueue before request mbox channel
Date: Fri,  9 Jan 2026 12:38:46 +0100
Message-ID: <20260109112148.558674016@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 81fb53feb66a3aefbf6fcab73bb8d06f5b0c54ad ]

With mailbox channel requested, there is possibility that interrupts may
come in, so need to make sure the workqueue is initialized before
the queue is scheduled by mailbox rx callback.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu-irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-scu-irq.c b/drivers/firmware/imx/imx-scu-irq.c
index f2b902e95b73..b9f6128d56f7 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -214,6 +214,8 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 	cl->dev = dev;
 	cl->rx_callback = imx_scu_irq_callback;
 
+	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
+
 	/* SCU general IRQ uses general interrupt channel 3 */
 	ch = mbox_request_channel_byname(cl, "gip3");
 	if (IS_ERR(ch)) {
@@ -223,8 +225,6 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 		return ret;
 	}
 
-	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
-
 	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
 				       "#mbox-cells", 0, &spec)) {
 		i = of_alias_get_id(spec.np, "mu");
-- 
2.51.0



