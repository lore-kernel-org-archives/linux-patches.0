Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D715511197;
	Wed, 30 Sep 2026 16:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784586; cv=none; b=F+E3eYJeVWJ9YfYw9qeB7on24KyT5vA8AHYP1qqMGSnC3R/kdRrWaKCuthIAle6E511iZHKnx0OA6Al3fPbCBCYHpgFfWLpsX6fTrOo67RBlax0o2GB4Nq2O416OmPypgklIuun0jBxZsWE80GgHlxKgj+54To8ZzlcYcI8mKmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784586; c=relaxed/simple;
	bh=qX0U6it7LZuNyBbVR9W+BBzmirK0Eg14ziouXpRhgpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0uHJPwvJ6jlpU1nSjsEA8n+rVT78ZKkasWVxa5Smq+y6cvelzQs9CcsgdA96sqS5Ze7UNY9TFLRxvRcq6YhaaTQLCD6EgBGQH4Vj4xN0MSGrUfd9SfzTLxfxPt6AbuiHLwBKnMWHe7lPyLBZxO9KMiZbV6ufhp6nmhq+09xD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbaJEknz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbaJEknz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8611F000FF;
	Wed, 30 Sep 2026 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784581;
	bh=/F9KYpgPhGoPkcx7hvOCISrMNP5thHFh+9vmLCAmaa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbaJEknzbSfKODoSKLYPU3YzB/3daWO9KrcIQoVK0j2iQi2wkn6j+SMj2cAdG+qQv
	 yg97+ypuwwdKK41+Hdsb6kxLRXv07561JtdIBsmFyale8fgbzMF9Tj88YwPQkj2grX
	 EqKT0GIFWyaAztmpdZmRpPfMSAtnha/KSGzAsE54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiajia Liu <liujiajia@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 170/982] wifi: mt76: transform aspm_conf for pci_disable_link_state
Date: Wed, 30 Sep 2026 17:15:06 +0200
Message-ID: <20260930152420.466914565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



