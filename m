Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01DA01F8931;
	Tue, 15 Oct 2024 12:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994127; cv=none; b=eFNFcg7I4h5jHb7uiDzgBK8/yytS1QpaMqR5varY8dcQFd5DcaMhc9zw3thy+jv07JnGcxuJnH02bfZRPotwgwms8mbrC8f9UocYca+Ion1GbsQl5Sankuy1r2CLvVvta4F/6SeA+qNOZxHIED11wk7aecoiZIvV3DK6O8qD0iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994127; c=relaxed/simple;
	bh=VSRA035oOeXDfqZIf3LGPHIzD6yl3MjwgP9LNwaRYyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvhlTyl1lqnI3VFs/ZVLff0/vdvR3H2M3kq+/UfLso32wdUfLY6CPCYSwuSWw5T8N8cfGPUAYO6cEG5xg0YATcngiRW4L+E0gtJLJxuGxgnIsGVD39SsfymKaEWgBRMuR+/u/ObOMMwSZogYGbNtDmc71M9khwSM3TnmTrKkwY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dBZ01dzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dBZ01dzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77892C4CEC6;
	Tue, 15 Oct 2024 12:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994126;
	bh=VSRA035oOeXDfqZIf3LGPHIzD6yl3MjwgP9LNwaRYyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dBZ01dzvMShoZ+4nyn4xSZyefubHCSKdwCTmXgw0EhCGcEQ6stNCEN+PrDB686IJa
	 +Wc3jTGWBnFzlzrgIOhFRdaU6McVG0GI5pe2GSCHs7hRqBmKiGHPMW2bqr6/ymuojL
	 9kN4Eep3OvkGI/CJNewIaek3x/RLWU1HdkdeN/JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 613/691] remoteproc: imx_rproc: Use imx specific hook for find_loaded_rsc_table
Date: Tue, 15 Oct 2024 13:29:21 +0200
Message-ID: <20241015112504.665750251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit e954a1bd16102abc800629f9900715d8ec4c3130 ]

If there is a resource table device tree node, use the address as
the resource table address, otherwise use the address(where
.resource_table section loaded) inside the Cortex-M elf file.

And there is an update in NXP SDK that Resource Domain Control(RDC)
enabled to protect TCM, linux not able to write the TCM space when
updating resource table status and cause kernel dump. So use the address
from device tree could avoid kernel dump.

Note: NXP M4 SDK not check resource table update, so it does not matter
use whether resource table address specified in elf file or in device
tree. But to reflect the fact that if people specific resource table
address in device tree, it means people are aware and going to use it,
not the address specified in elf file.

Reviewed-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://lore.kernel.org/r/20240719-imx_rproc-v2-2-10d0268c7eb1@nxp.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index c45c87a94d62a..107da44ab3b76 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -529,6 +529,17 @@ static struct resource_table *imx_rproc_get_loaded_rsc_table(struct rproc *rproc
 	return (struct resource_table *)priv->rsc_table;
 }
 
+static struct resource_table *
+imx_rproc_elf_find_loaded_rsc_table(struct rproc *rproc, const struct firmware *fw)
+{
+	struct imx_rproc *priv = rproc->priv;
+
+	if (priv->rsc_table)
+		return (struct resource_table *)priv->rsc_table;
+
+	return rproc_elf_find_loaded_rsc_table(rproc, fw);
+}
+
 static const struct rproc_ops imx_rproc_ops = {
 	.prepare	= imx_rproc_prepare,
 	.attach		= imx_rproc_attach,
@@ -538,7 +549,7 @@ static const struct rproc_ops imx_rproc_ops = {
 	.da_to_va       = imx_rproc_da_to_va,
 	.load		= rproc_elf_load_segments,
 	.parse_fw	= imx_rproc_parse_fw,
-	.find_loaded_rsc_table = rproc_elf_find_loaded_rsc_table,
+	.find_loaded_rsc_table = imx_rproc_elf_find_loaded_rsc_table,
 	.get_loaded_rsc_table = imx_rproc_get_loaded_rsc_table,
 	.sanity_check	= rproc_elf_sanity_check,
 	.get_boot_addr	= rproc_elf_get_boot_addr,
-- 
2.43.0



