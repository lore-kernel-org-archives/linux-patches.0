Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2D24342CBA;
	Sat, 17 Oct 2026 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254707; cv=none; b=WDbPXpOk0Qw8Yvk0um9VF/ruBza4JinvGLVZV9MlCsbc8NtedKfjk7e/X+pSJHKszWx5gv1qiGqD0rX5HcoLyvxq5OQQ90aNsOqvGIwDNkE/PpOz0ESLZNQcdvGx+i3hntDKZZeCsYDlvyvWpWFtmKwAO5AcyMptstO9m35cfN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254707; c=relaxed/simple;
	bh=Mcv1Vjrwc92diqd3KFyUfdjp8YHPEIzOQOGALQ1gJ8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEBMkHGKw2YnDCC/5jRRk7uHxoLD1J1/MCrv/NwiTQeq1Rs24SzZTr398s1Hl3+ES8Z76TzQOCUKASoLymfAo9boL82QNmgXLP26rryObl8M28t0r+/Nt6pLq6duDlCt1hx/X85FndyFjonr7PHtE240ISvHwmqRXdaE68Pz0Qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/z27wP8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/z27wP8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F09AD1F000C5;
	Sat, 17 Oct 2026 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254706;
	bh=JRT+kvqagVgq0JIu7DMb27Kyq6kCnWxVNGlLU1+a+dQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/z27wP84MRcDPWJoI+2Bk2QNapX5HLeywcLkZi1IeOLmetXZhlmch2ef7Z25rNDK
	 sT7SZfLdts1R9GTcO+Qfjkwywe6mgli1YRWl8JFjZrDrLwzh1x11ddPE2Q6i3NdLzH
	 wIyCdHbztul+Xt2hD6Ug+mTa6puuB135BjUdhhBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 535/869] EDAC/igen6: Initialize edac_op_state according to the configuration data
Date: Sat, 17 Oct 2026 17:56:16 +0200
Message-ID: <20261017160050.819024928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qiuxu Zhuo <qiuxu.zhuo@intel.com>

[ Upstream commit 1d512b1aa5a88f93170b0b9360de4fff7a2f8a0a ]

Currently, igen6_edac sets edac_op_state to EDAC_OPSTATE_NMI, while the
driver also supports memory errors reported from Machine Check. Initialize
edac_op_state to the correct value according to the configuration data
that the driver probed.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/20241106114024.941659-2-orange@aiven.io
Stable-dep-of: ab1f9d466c7d ("EDAC/igen6: Fix call trace due to missing release()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/igen6_edac.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/edac/igen6_edac.c b/drivers/edac/igen6_edac.c
index 63a61932e67fd..003db3d9f1913 100644
--- a/drivers/edac/igen6_edac.c
+++ b/drivers/edac/igen6_edac.c
@@ -1357,6 +1357,15 @@ static void unregister_err_handler(void)
 	unregister_nmi_handler(NMI_SERR, IGEN6_NMI_NAME);
 }
 
+static void opstate_set(struct res_config *cfg)
+{
+	/* Set the mode according to the configuration data. */
+	if (cfg->machine_check)
+		edac_op_state = EDAC_OPSTATE_INT;
+	else
+		edac_op_state = EDAC_OPSTATE_NMI;
+}
+
 static int igen6_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	u64 mchbar;
@@ -1374,6 +1383,8 @@ static int igen6_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		goto fail;
 
+	opstate_set(res_cfg);
+
 	for (i = 0; i < res_cfg->num_imc; i++) {
 		rc = igen6_register_mci(i, mchbar, pdev);
 		if (rc)
@@ -1457,8 +1468,6 @@ static int __init igen6_init(void)
 	if (owner && strncmp(owner, EDAC_MOD_STR, sizeof(EDAC_MOD_STR)))
 		return -EBUSY;
 
-	edac_op_state = EDAC_OPSTATE_NMI;
-
 	rc = pci_register_driver(&igen6_driver);
 	if (rc)
 		return rc;
-- 
2.53.0



