Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955FA33A6F1;
	Wed, 30 Sep 2026 18:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794493; cv=none; b=rY65iPkSnwEnn0utiMRpccK0ztVIB2ore1gj0Tiqkbvg17v8qnK0wd/NZguMvtCjSO5l1iiy/jAFSWdEq4aTsuupSPetuCO5FQhgmSs1rH7wJIAPG/jzem3vs8aM15L8LGzEKtDhcKYqfLsFaSHtpfIvnCIVzYBn9qyWfXmavU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794493; c=relaxed/simple;
	bh=WyADdJAhTF1ynloTn2X9cCDHNdg52e5uBs1G6gB94no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIjzsdPglLNGlZQme+fEhO05OO3RQOiDn4lVBS+qGXniDZarCMiSgx8CM+RUSqHPSwcmEmItCAPLze6uaEjUBI97HRXs+4/cNIF+wUC+awo1sFXXIQWepiYpQgDNznpL6waL4bnsTRP3toYbFudqL+GAYZdEw04VpYncFLrEAao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duetKZw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duetKZw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D73071F000FF;
	Wed, 30 Sep 2026 18:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794492;
	bh=3chXhHMJoSjQcd5y3R7kI6ZNmZO/6zcw1OXXsu3F7yg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=duetKZw4fg7Iyz5J97RJUmsGoFJBRwdrvK/lstbiX4dWgrhMSZouyuj1XbiGtqWGX
	 RND0EKFNau5b0Ase72qV7YbRsxOwAtGTbe+GRQ2o6sRoGJypMTxEJkhx+BvLaUERnC
	 ClIPVn7XFiqbyCBtcb3hqPN8wrW9Phxs82X5BiOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0196/1193] wifi: mt76: transform aspm_conf for pci_disable_link_state
Date: Wed, 30 Sep 2026 17:14:40 +0200
Message-ID: <20260930152438.557139652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



