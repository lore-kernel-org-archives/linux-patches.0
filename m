Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77289471254;
	Tue, 21 Jul 2026 18:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657048; cv=none; b=AlMbTcOeE1F7i4JpoQak++eKuTdOOVjD3kf6ivhAsJ+vNUvWiKv5cllSj0ac8dkj8q/wzT5RakDMEO3NM8ttL6Pyc5UpvXVrFVD2mrF4dAM0ykl7rsrFdqrnsNDN1+ojRaLfwY69BCIvm+2O2setaCVbzRdKcMbRLOr4UOzIECA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657048; c=relaxed/simple;
	bh=ge93vOn0UO3C8wja2Lb8wm4V0cHgoG3uHUQU0pGM28A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7x9D1sfK1VQ6F5R2rodR/Ms86R4FuoTqViPi2KABzvGVl+T3TIpM6BjCvL751I2PhM8fKdAx+lLVo4Ji7bcHNB1Q8lFU0na3J9UIz+Kk3x89iS693FNNMXZkNVGppxL+9YFMrhNUYXSrGNRLb0DPxEXKKhVcRBB1EThB4/UYbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPBBiFhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPBBiFhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC8981F000E9;
	Tue, 21 Jul 2026 18:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657047;
	bh=9yefy2hewo8nJCMt8E1QSL/LoS4jxhPVagbdjD+/KNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPBBiFhewNdlYs7ZbrbfC1oYbDHv7kPJuusONz1v322B6ppfWqEeI7KV4k3kL403X
	 LjmHvnF94JoD8qirhS7bQD55fuRfO4raBI2qjTNupeQbGIZeOHLTXxitSZw2D1efSS
	 IDXxDpa4rwlxZ5q2AVGfZH6OXsE34lNESorRj4Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0618/1611] PCI: qcom: Disable ASPM L0s for SA8775P
Date: Tue, 21 Jul 2026 17:12:14 +0200
Message-ID: <20260721152529.286706572@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index a70911a9567535..fbdb5a92647851 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1438,6 +1438,7 @@ static const struct qcom_pcie_cfg cfg_1_9_0 = {
 static const struct qcom_pcie_cfg cfg_1_34_0 = {
 	.ops = &ops_1_9_0,
 	.override_no_snoop = true,
+	.no_l0s = true,
 };
 
 static const struct qcom_pcie_cfg cfg_2_1_0 = {
-- 
2.53.0



