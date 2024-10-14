Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E3F1C82F4;
	Mon, 14 Oct 2024 15:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919794; cv=none; b=O0WEqBowVZPhz0IhfCCCad0OpNaDPBv+sisE5NB9soZd/8wwneF4OZTT9PCZkoCpeuu43g+BVm0/ux3RrmSM7fTXm4X3ShN6DC2BXF9PRzXp57kJrNe7JTZpVizO6r3eBlaBg2XWQwopW46jD5Z/MC0Ud5uOekBa0l08SxQKqYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919794; c=relaxed/simple;
	bh=E8zL575Y17abfJsL1+1urThZuqI4J3eylNEYp53BSN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xr1PLrC/kT3c98Gs+/Lhnk7gRibxvDfUVc7YIwWHnYlc4jCG09vu1yLdshkkyV4EAlVOHLGguYBq4hvLGQe+cMlN3cf4ssdyB4+fG72sGpVZ4JM2LmlORjb/TFUGEwRFaAmEUK7R4k01iHGlTFIkaDjyvfsl+dHy4+OEuz1qftA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O9tCF4bb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O9tCF4bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E68BC4CEC3;
	Mon, 14 Oct 2024 15:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919793;
	bh=E8zL575Y17abfJsL1+1urThZuqI4J3eylNEYp53BSN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O9tCF4bbU+5biL02ziZEz7GSzqBOyX9wG2UNpCFtmJ5epLGUPAd6/viUXaS8yWYI4
	 hf34ihccJ0k5jsc/xI52hmzqUGtejkowXMikViu+JTzmPULUJtcnZRSZP+pEM2y4eB
	 8Dc/84iS8mqbLUHfpaQF9bkYvGgY7KH3VEieIMN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iuliana Prodan <iuliana.prodan@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 709/798] remoteproc: imx_rproc: Use imx specific hook for find_loaded_rsc_table
Date: Mon, 14 Oct 2024 16:21:03 +0200
Message-ID: <20241014141245.922676951@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 00a0c8f4a2200..bbaba453383dd 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -537,6 +537,17 @@ static struct resource_table *imx_rproc_get_loaded_rsc_table(struct rproc *rproc
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
@@ -546,7 +557,7 @@ static const struct rproc_ops imx_rproc_ops = {
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



