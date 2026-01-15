Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E29D3D1CBB;
	Thu, 15 Jan 2026 17:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499374; cv=none; b=psj1EPVYZJoq3ZfJDROxORptRTxHS+FciLgYYHq2rRtWcPvbs/H8oIrYzojMvPn4+kWEWhOeHmq0CTACGY3xVa1J29prWqJo0mv7BiuDjNNDYhaHdllm5wmNdfOGwNaNbbgx1Zqd0TwgUsaI+gW+HbqL017F1gjpsFOzmeJg2ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499374; c=relaxed/simple;
	bh=Lh+sKoTuig0d0hQ4tlCekGpGH0LjKjy+AOqpi0wQVHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bpq8vFQIzg9eQhb3ruYC1rKY8uv9e3dCaq+YQUkIywh8WkgpG+7Fo/jKI/9S850iNL60TEcBAmYeFOJMCVLOy8+pOLJ3XQUeaFQwb/Lcb/5l8wB4VcyFFcPqWAWZZhO/OGClaU59vxoNsx7PSDedtH+LY+EJXvES1fopLt/9bcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8WIMvc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8WIMvc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2022C2BCAF;
	Thu, 15 Jan 2026 17:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499374;
	bh=Lh+sKoTuig0d0hQ4tlCekGpGH0LjKjy+AOqpi0wQVHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l8WIMvc/xm0aAX53C22wszafB9qTVak7EjiFdgMOBpQ2b57s/5CFlIkWG6UNnNPpg
	 r+YQ+GQieVuSgGvtnCcvZLq63W8VxdEFkLj6/8WUMyPow1eluBnD1pr4agxAvcaqtq
	 BVbD0DuGb2CkQEjvksNRtMU6O7VKuHnPyPzxejxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/451] firmware: imx: scu-irq: Init workqueue before request mbox channel
Date: Thu, 15 Jan 2026 17:46:46 +0100
Message-ID: <20260115164238.316830827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



