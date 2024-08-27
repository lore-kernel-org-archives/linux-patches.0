Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D9DDC1;
	Tue, 27 Aug 2024 14:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770171; cv=none; b=F+dsBT1YLHDs8NtDzP0BQdYKEVvwo6ItfIl2YXDyVA7mMEKCthlgUbxla2IUSSX88jeu1/GLqFI6Qu5KwOV6clAFoEYcN4i6Id2csPLfamsNhbk8g/l90mJfejJ8rTzJK/VxhJSB38Sh2wI2DqStnpSeUufobLYtn0TGrcyt0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770171; c=relaxed/simple;
	bh=ZQoLHFM1FLCs96k/ApHvE/P6rKTeNpbL4IKZ47Ntmds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a756OgdtTRpExjhRIsZkyneUoAcH45dUMGtxK5L4T9vLk0mEAw2agATpsFiVrUQOF8PNLxsywAxEbpufQkzWykSTKlwFXho4redGCg1HPNeIbucSew0oxjtB5/wsi/IkcXHrIfuZhsW+E4E455IcHf23XrwoIqJemGhkwEjn+E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxGu/sxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxGu/sxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9458C4AF18;
	Tue, 27 Aug 2024 14:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770171;
	bh=ZQoLHFM1FLCs96k/ApHvE/P6rKTeNpbL4IKZ47Ntmds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxGu/sxK1IDWz8EjHUYdDNeMppg0hI3qGB1rbbnI59DqWNAsKLhEFoXi5qFa4nI4c
	 MQE5VK7SDEaH0ZYbH/Ki4oXkyBBQVU8KFMkfUw4pDxhkkj9tbrXQDtpv+FEUNefVX2
	 Prc+UXCPt0UUQMb5q/Wu+7kJjzvlmqtvgMB1J380=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 147/341] ionic: no fw read when PCI reset failed
Date: Tue, 27 Aug 2024 16:36:18 +0200
Message-ID: <20240827143849.014629759@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit 219e183272b4a566650a37264aff90a8c613d9b5 ]

If there was a failed attempt to reset the PCI connection,
don't later try to read from PCI as the space is unmapped
and will cause a paging request crash.  When clearing the PCI
setup we can clear the dev_info register pointer, and check
it before using it in the fw_running test.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/pensando/ionic/ionic_bus_pci.c   |  5 ++++
 .../net/ethernet/pensando/ionic/ionic_dev.c   | 23 +++++++++++++++----
 2 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
index f0a7fde8f7fff..a5fa49fd21390 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_bus_pci.c
@@ -215,6 +215,11 @@ static int ionic_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 static void ionic_clear_pci(struct ionic *ionic)
 {
+	ionic->idev.dev_info_regs = NULL;
+	ionic->idev.dev_cmd_regs = NULL;
+	ionic->idev.intr_status = NULL;
+	ionic->idev.intr_ctrl = NULL;
+
 	ionic_unmap_bars(ionic);
 	pci_release_regions(ionic->pdev);
 
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index 22ab0a44fa8c7..b4e0fb25b96d7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -165,9 +165,19 @@ void ionic_dev_teardown(struct ionic *ionic)
 }
 
 /* Devcmd Interface */
-bool ionic_is_fw_running(struct ionic_dev *idev)
+static bool __ionic_is_fw_running(struct ionic_dev *idev, u8 *status_ptr)
 {
-	u8 fw_status = ioread8(&idev->dev_info_regs->fw_status);
+	u8 fw_status;
+
+	if (!idev->dev_info_regs) {
+		if (status_ptr)
+			*status_ptr = 0xff;
+		return false;
+	}
+
+	fw_status = ioread8(&idev->dev_info_regs->fw_status);
+	if (status_ptr)
+		*status_ptr = fw_status;
 
 	/* firmware is useful only if the running bit is set and
 	 * fw_status != 0xff (bad PCI read)
@@ -175,6 +185,11 @@ bool ionic_is_fw_running(struct ionic_dev *idev)
 	return (fw_status != 0xff) && (fw_status & IONIC_FW_STS_F_RUNNING);
 }
 
+bool ionic_is_fw_running(struct ionic_dev *idev)
+{
+	return __ionic_is_fw_running(idev, NULL);
+}
+
 int ionic_heartbeat_check(struct ionic *ionic)
 {
 	unsigned long check_time, last_check_time;
@@ -199,10 +214,8 @@ int ionic_heartbeat_check(struct ionic *ionic)
 		goto do_check_time;
 	}
 
-	fw_status = ioread8(&idev->dev_info_regs->fw_status);
-
 	/* If fw_status is not ready don't bother with the generation */
-	if (!ionic_is_fw_running(idev)) {
+	if (!__ionic_is_fw_running(idev, &fw_status)) {
 		fw_status_ready = false;
 	} else {
 		fw_generation = fw_status & IONIC_FW_STS_F_GENERATION;
-- 
2.43.0



