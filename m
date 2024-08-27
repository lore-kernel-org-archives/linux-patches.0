Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3311BC9E3;
	Tue, 27 Aug 2024 14:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770406; cv=none; b=dGDfiJgeOlfi7Hp2ISKVNWCJBtWe2CuCicvUg3i/vfa1+1M3/S3cPEukSHnRreBMcAulNgsO88EweuoI/Ulk5GHOImmS48UA0NDKtFpZzAe7wRsj2hoq1cm1HEvhvXuh+EEgpHIWT8z8aLBUbEvIkM7DcDNxO0Bo80qyXTC7m/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770406; c=relaxed/simple;
	bh=Mde3a2+hda2qfamTRSBMcD4tEtNeL4SbcHDE8jBiNoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzFhxUTfOtYwaxshxOaJ6ugyQAzBNj1XVjI2c8TchWOM+Hts8ib0codshU/vP2vbTSRscMEC0JmFBmxcEv7h1WL2DjhwalgWbc27zPhbVNytIBL+2tNOI+K5/zplyARUMC3o8bbeJhOyItTCDvL7S4+v4ADw53MXX2pbhEth/3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZxFYC9H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZxFYC9H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4DBC6107C;
	Tue, 27 Aug 2024 14:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770406;
	bh=Mde3a2+hda2qfamTRSBMcD4tEtNeL4SbcHDE8jBiNoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZxFYC9HYmZMMdppkaHtYLMO2tPM49XcmJon/XN+wKQYlFak0Nqoc7n/FNxcCH1Qs
	 BbNlJVYPW6QLj1DXzGX9jVC83voedIQEZ3snGgH89qi0HDKoj4/9Tx6UWGuAw8KV45
	 KCxj3wjMVYx4aZdpYAmnrdVtn1QqRIaZBul9jvU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brett Creeley <brett.creeley@amd.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/341] ionic: check cmd_regs before copying in or out
Date: Tue, 27 Aug 2024 16:37:29 +0200
Message-ID: <20240827143851.707567584@linuxfoundation.org>
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

[ Upstream commit 7662fad348ac54120e9e6443cb0bbe4f3b582219 ]

Since we now have potential cases of NULL cmd_regs and info_regs
during a reset recovery, and left NULL if a reset recovery has
failed, we need to check that they exist before we use them.
Most of the cases were covered in the original patch where we
verify before doing the ioreadb() for health or cmd status.
However, we need to protect a few uses of io mem that could
be hit in error recovery or asynchronous threads calls as well
(e.g. ethtool or devlink handlers).

Fixes: 219e183272b4 ("ionic: no fw read when PCI reset failed")
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.c     | 10 ++++++++++
 drivers/net/ethernet/pensando/ionic/ionic_ethtool.c |  7 ++++++-
 drivers/net/ethernet/pensando/ionic/ionic_fw.c      |  5 +++++
 drivers/net/ethernet/pensando/ionic/ionic_main.c    |  3 +++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.c b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
index b4e0fb25b96d7..e242166f0afe7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.c
@@ -319,22 +319,32 @@ int ionic_heartbeat_check(struct ionic *ionic)
 
 u8 ionic_dev_cmd_status(struct ionic_dev *idev)
 {
+	if (!idev->dev_cmd_regs)
+		return (u8)PCI_ERROR_RESPONSE;
 	return ioread8(&idev->dev_cmd_regs->comp.comp.status);
 }
 
 bool ionic_dev_cmd_done(struct ionic_dev *idev)
 {
+	if (!idev->dev_cmd_regs)
+		return false;
 	return ioread32(&idev->dev_cmd_regs->done) & IONIC_DEV_CMD_DONE;
 }
 
 void ionic_dev_cmd_comp(struct ionic_dev *idev, union ionic_dev_cmd_comp *comp)
 {
+	if (!idev->dev_cmd_regs)
+		return;
 	memcpy_fromio(comp, &idev->dev_cmd_regs->comp, sizeof(*comp));
 }
 
 void ionic_dev_cmd_go(struct ionic_dev *idev, union ionic_dev_cmd *cmd)
 {
 	idev->opcode = cmd->cmd.opcode;
+
+	if (!idev->dev_cmd_regs)
+		return;
+
 	memcpy_toio(&idev->dev_cmd_regs->cmd, cmd, sizeof(*cmd));
 	iowrite32(0, &idev->dev_cmd_regs->done);
 	iowrite32(1, &idev->dev_cmd_regs->doorbell);
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
index 3a6b0a9bc2414..35829a2851fa7 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_ethtool.c
@@ -90,18 +90,23 @@ static void ionic_get_regs(struct net_device *netdev, struct ethtool_regs *regs,
 			   void *p)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
+	struct ionic_dev *idev;
 	unsigned int offset;
 	unsigned int size;
 
 	regs->version = IONIC_DEV_CMD_REG_VERSION;
 
+	idev = &lif->ionic->idev;
+	if (!idev->dev_info_regs)
+		return;
+
 	offset = 0;
 	size = IONIC_DEV_INFO_REG_COUNT * sizeof(u32);
 	memcpy_fromio(p + offset, lif->ionic->idev.dev_info_regs->words, size);
 
 	offset += size;
 	size = IONIC_DEV_CMD_REG_COUNT * sizeof(u32);
-	memcpy_fromio(p + offset, lif->ionic->idev.dev_cmd_regs->words, size);
+	memcpy_fromio(p + offset, idev->dev_cmd_regs->words, size);
 }
 
 static void ionic_get_link_ext_stats(struct net_device *netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_fw.c b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
index 5f40324cd243f..3c209c1a23373 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_fw.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_fw.c
@@ -109,6 +109,11 @@ int ionic_firmware_update(struct ionic_lif *lif, const struct firmware *fw,
 	dl = priv_to_devlink(ionic);
 	devlink_flash_update_status_notify(dl, "Preparing to flash", NULL, 0, 0);
 
+	if (!idev->dev_cmd_regs) {
+		err = -ENXIO;
+		goto err_out;
+	}
+
 	buf_sz = sizeof(idev->dev_cmd_regs->data);
 
 	netdev_dbg(netdev,
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_main.c b/drivers/net/ethernet/pensando/ionic/ionic_main.c
index f019277fec572..3ca6893d1bf26 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_main.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_main.c
@@ -438,6 +438,9 @@ static void ionic_dev_cmd_clean(struct ionic *ionic)
 {
 	struct ionic_dev *idev = &ionic->idev;
 
+	if (!idev->dev_cmd_regs)
+		return;
+
 	iowrite32(0, &idev->dev_cmd_regs->doorbell);
 	memset_io(&idev->dev_cmd_regs->cmd, 0, sizeof(idev->dev_cmd_regs->cmd));
 }
-- 
2.43.0



