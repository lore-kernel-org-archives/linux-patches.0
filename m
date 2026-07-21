Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBEA6425863;
	Tue, 21 Jul 2026 19:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662431; cv=none; b=JjyCA2EMKLwoXrvQi7lC52FNJZFeSXVZ0k79iG2WdSR7MjlSRJvlKXKSUX9AXjxosXAVqJ7KuEnk7JM/SwZhGfvtnHsAOMgePS19e572ak/fFV6TOw/w0ANM26qzaAQ4cDmBEbK1p4imnSCutm3K5dlhtqKgyJSdI71yPWQGJjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662431; c=relaxed/simple;
	bh=G6rIHKqkBWLFuF/WUJN4dyT6t8/NVmjK1yepu+bR2YE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WZ1CFkNfXPphGWuki+NDY2E56V1fPtDMijkd42wssvDIx/FdmpXqRooNbkMEUirACveBtB2hcjx8EnJiBjjM0WLxWStEwFs3RWhNlms29RRTC+q5ZAI+fJ5eYXkZFHqG8TQXuEM6I5k9NpddwOX+RgKrZ79NfSdeREm/Qmr5Fg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lx/Rx539; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lx/Rx539"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38AC41F000E9;
	Tue, 21 Jul 2026 19:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662430;
	bh=gm5en09o9kmiTt4mq2imauKGEtp7ZeaI7jiuopMSx94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lx/Rx539F3TSvWzcRQLXpk64K22QI9DZijovr/ZSPOIGgklKJjwfz3l0NM5UHdhxx
	 MZcVETwwA6tlaXNghy1qF2ztNJ+fSJg3CuxMOjryleeI5mMMQSG8dgzLJDHKpy9qlV
	 czTFXDO3i59ajMAylKZbuMQO3mtV1Ur6m60Dttno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0442/1276] PCI: qcom: Disable ASPM L0s for SA8775P
Date: Tue, 21 Jul 2026 17:14:45 +0200
Message-ID: <20260721152455.992549035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Shawn Guo <shengchao.guo@oss.qualcomm.com>

[ Upstream commit 29f692985819f4089f02a86e151a72f6d4cdd90d ]

Due to a hardware issue, L0s is not properly supported by the PCIe
controller on the SA8775p SoC. If enabled, the L0s to L0 transition
triggers below correctable AER errors and may also affect link stability:

  pcieport 0000:00:00.0: PME: Signaling with IRQ 332
  pcieport 0000:00:00.0: AER: enabled with IRQ 332
  pcieport 0000:00:00.0: AER: Correctable error message received from 0000:01:00.0
  pci 0000:01:00.0: PCIe Bus Error: severity=Correctable, type=Data Link Layer, (Transmitter ID)
  pci 0000:01:00.0:   device [17cb:1103] error status/mask=00001000/0000e000
  pci 0000:01:00.0:    [12] Timeout
  pcieport 0000:00:00.0: AER: Multiple Correctable error message received from 0000:01:00.0
  pcieport 0000:00:00.0: PCIe Bus Error: severity=Correctable, type=Data Link Layer, (Transmitter ID)
  pcieport 0000:00:00.0:   device [17cb:0115] error status/mask=00001000/0000e000
  pcieport 0000:00:00.0:    [12] Timeout

Hence, disable L0s for the SA8775p SoC to allow it to properly function
by sacrificing a little bit of power saving.

Fixes: 58d0d3e032b3 ("PCI: qcom-ep: Add support for SA8775P SOC")
Assisted-by: Claude:claude-4-6-sonnet
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
[mani: commit log, corrected fixes tag]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Link: https://patch.msgid.link/20260419093934.1223027-1-shengchao.guo@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pcie-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 533782940f2e21..81ba04cedc72ab 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1385,6 +1385,7 @@ static const struct qcom_pcie_cfg cfg_1_9_0 = {
 static const struct qcom_pcie_cfg cfg_1_34_0 = {
 	.ops = &ops_1_9_0,
 	.override_no_snoop = true,
+	.no_l0s = true,
 };
 
 static const struct qcom_pcie_cfg cfg_2_1_0 = {
-- 
2.53.0



