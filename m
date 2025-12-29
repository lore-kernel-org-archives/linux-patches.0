Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76A89460;
	Mon, 29 Dec 2025 16:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025338; cv=none; b=ALNleKuwoF0yP9CukzLDhSP1/0GiRMn4DFW/QMpTqEWfJQJ1v14YLa3y51/arUPFphgZlm/hcydkiN6Dbe0uySIdrpMRuPyhBu72w0C3hIaAjbRnGgT2djrVLlUDgynbxzdXLCF8uw8WjivLD1c5cGEOT6IEL3E99Y67+xFnJao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025338; c=relaxed/simple;
	bh=9GFb3rVuTgh3Jmj9if29SRqaCYlCMzR5Kn0fa8hzDM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQUwb06PTOKxwf9XQaz4emlzMkz2SKU5DaWopzbN7wyQQ5U65RzL4dlTF4QNbYeSgRgh9ZNi1sm40nxzRVjxMgF3tZI71znTgTNma+TEpY4sMM/y9zk+Vm6xNpG+cknui+1tGm3qVvY0v1M2FoGPkIQxzYBD/mgGRN0iCRGYTPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KsnclN8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KsnclN8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC096C4CEF7;
	Mon, 29 Dec 2025 16:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025338;
	bh=9GFb3rVuTgh3Jmj9if29SRqaCYlCMzR5Kn0fa8hzDM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KsnclN8ABSVf0mHi3NhLU2u5OD+7HBzba+5xV9kOqDqfzsBHhPrtldmgvJ9AkJLyT
	 Vp2XRzF8M9LDojWt3fTmQ6OYSeJ2hU8Tco9VEDCAjJeBodu8R8bSP0w3ZtROd/jnPx
	 OT1yHjjkkchV25skzxEw7uXEhWBB0tyi2BwRKG2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 179/430] firmware: imx: scu-irq: Init workqueue before request mbox channel
Date: Mon, 29 Dec 2025 17:09:41 +0100
Message-ID: <20251229160730.946656399@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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



