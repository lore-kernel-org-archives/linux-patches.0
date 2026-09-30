Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7BC50B42C;
	Wed, 30 Sep 2026 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782683; cv=none; b=g9r8+Wa/85O0BF0yEt60fw+PoxAUQYsUiH8rk1YjgnthzPJbODL6ISMB/pFZ9W26/pm0mtsgaCR4+602djtXYG2IKlp4XBgTHyYe1rFcgkWnqMC6/O1lsqd3mXzaNMRfZE+6lsTp4rgz9DhdQTJO9kesKHC/X416/CA2TksV/4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782683; c=relaxed/simple;
	bh=zGEcqsENYwfsF1ikY6ya1OtyZ7D1azJ/OYqwCDVrpDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+U6t0T7B0vMTIKdLQdzz2Mn0avEfIXJ+njEXWOzzFPsHVBI9PjmTxukTNSIhLTce7iru4BXSpdAixZuzxtXQ9Duho5BqvLBU+26B4YrnuSYC2UMZxNfPxtCCkxcop9nL1MOVQR8QkfSU2xNo9a18qEhTmD6p2T+W/liTKpNWyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vl6loTr+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vl6loTr+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F471F00899;
	Wed, 30 Sep 2026 15:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782675;
	bh=rL2nhz7ZZvjykgPXZKW8Q8o4rqU+pl8Ex2g3K4FS6Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vl6loTr+7cII55qTkRTSSlda6/pc+NKwm+CQ+nBKPl3XypbYqf3LvvPrQviQoKVau
	 wJokCb4QnrfX4d2Xnrl1XxS9Hi0BeGRA/C78OAVagq1qPv63ruT6H1lHn5Bvw0V4xG
	 q4ChP8qZKpmf1v68ww6fgGhjbOseU3Efe+vN43eA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/595] wifi: mt76: transform aspm_conf for pci_disable_link_state
Date: Wed, 30 Sep 2026 17:20:06 +0200
Message-ID: <20260930152350.168076406@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

From: Jiajia Liu <liujiajia@kylinos.cn>

[ Upstream commit 2dd78856223484895306351df1f903a4b75d213f ]

commit b478e162f227 ("PCI/ASPM: Consolidate link state defines") changed
PCIE_LINK_STATE_L0S (1) to (BIT(0) | BIT(1)). PCI_EXP_LNKCTL_ASPM_L0S (1)
and PCI_EXP_LNKCTL_ASPM_L1 (2) are no longer matched with
PCIE_LINK_STATE_L0S (3) and PCIE_LINK_STATE_L1 (4).

On the platform enabling ASPM L0s and L1, mt76_pci_disable_aspm is not able
to disable L1. Fix this by transforming aspm_conf to pcie link state.

Signed-off-by: Jiajia Liu <liujiajia@kylinos.cn>
Link: https://patch.msgid.link/20260602054349.42429-1-liujia6264@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/pci.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/pci.c b/drivers/net/wireless/mediatek/mt76/pci.c
index 4c1c159fbb62f..36dba6e03e8b4 100644
--- a/drivers/net/wireless/mediatek/mt76/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/pci.c
@@ -30,8 +30,14 @@ void mt76_pci_disable_aspm(struct pci_dev *pdev)
 
 	if (IS_ENABLED(CONFIG_PCIEASPM)) {
 		int err;
+		int state = 0;
 
-		err = pci_disable_link_state(pdev, aspm_conf);
+		if (aspm_conf & PCI_EXP_LNKCTL_ASPM_L0S)
+			state |= PCIE_LINK_STATE_L0S;
+		if (aspm_conf & PCI_EXP_LNKCTL_ASPM_L1)
+			state |= PCIE_LINK_STATE_L1;
+
+		err = pci_disable_link_state(pdev, state);
 		if (!err)
 			return;
 	}
-- 
2.53.0



