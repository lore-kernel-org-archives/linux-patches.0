Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A413C198A;
	Thu, 15 Jan 2026 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497942; cv=none; b=fmPFJpnfqWkoAY94+Q+RaGdgzGphsCrbDx6zxn2qcIqcjLL4mvhnYO1QsFOuckZRS7HKK1Gp0q+fnOFE4Wcw1llpnsIFB7aG/PxJTIcoLCBOwO2XA4If9CzGb3MUzylVM2AHMqOulLd7yc7GghawJJF4Q4pisZlIajRfFUrRp6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497942; c=relaxed/simple;
	bh=s8SW+bu5a8Y9HGT764MIzixPIHpwyLi0MA0AWKgirn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRRX36ZztooFs4WVvz4j1d3U3Hbpnxs6CcLwMQZSSXeH03vHP+WpE95LgyFP6kwdPEUo2LTFtn8I1oo1apAlg3gvLsMjuKlZBquugu6k2af9hZR2PYnpDZWh/OsowQFNPAizz+fBKVoPdBnBSlPF08Aw5nJWBZWCaI+yRlJq1cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCKMNXut; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCKMNXut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CE21C19423;
	Thu, 15 Jan 2026 17:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497941;
	bh=s8SW+bu5a8Y9HGT764MIzixPIHpwyLi0MA0AWKgirn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCKMNXut04qfD3VbhHvN/Yihw/Y83ZYG/gJvVAEChMjT/MwkGIUsgo+hN47pQBhGE
	 C0Sxr74I1mQLMU/nKoL30dZsY6mgeS31jalFcZvH0P+MrJxWtAXPVNvcPXHAczA3l1
	 yLOLKp0J6EWxfAWbopaK5m0sLpF2d7imshNI60WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 258/554] firmware: imx: scu-irq: Init workqueue before request mbox channel
Date: Thu, 15 Jan 2026 17:45:24 +0100
Message-ID: <20260115164255.572388865@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 32b1ca4e1050..06c49a61a079 100644
--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -148,6 +148,8 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 	cl->dev = dev;
 	cl->rx_callback = imx_scu_irq_callback;
 
+	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
+
 	/* SCU general IRQ uses general interrupt channel 3 */
 	ch = mbox_request_channel_byname(cl, "gip3");
 	if (IS_ERR(ch)) {
@@ -157,8 +159,6 @@ int imx_scu_enable_general_irq_channel(struct device *dev)
 		return ret;
 	}
 
-	INIT_WORK(&imx_sc_irq_work, imx_scu_irq_work_handler);
-
 	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
 				       "#mbox-cells", 0, &spec)) {
 		i = of_alias_get_id(spec.np, "mu");
-- 
2.51.0



