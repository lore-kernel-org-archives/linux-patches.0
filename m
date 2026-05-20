Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67CB1228CB0;
	Wed, 20 May 2026 16:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294838; cv=none; b=avzSyVLARqTgqtfB2Ic1/CHU141R3LJ2b5sKHGFAB4J/KUKGn4m3ShWqJmvjeZzaiXITodCYeUJpWUC+gOov9Z+7kycN1XRzAEN608vYrpduXBjHT8L2FBUgox5MM2UHjt5gGjzZjZfHFR0E3tAYLrtmSyjlmO6iwov7/0/Ox7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294838; c=relaxed/simple;
	bh=VhpRDSaLniwQAmdV2E3q3S0O6MIQ4ZN8Z96M9hhoJxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zur2SVBXYgGGqFl8dI5tVLG69Wv8mU2Idotgmn6fGZ47wNkkVeiqQ/7/8i0yrI7Ka/pL9VJj58qqvgGtxVaORAKJUWIdyKR2Bewvwlrczvl2e62nwzGEewqubHD2N1hP4VTGvvBhrAjVVlP10mDaviI8EsBe/PXJAd5zsN2RYiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZUfYcmG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZUfYcmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52F71F000E9;
	Wed, 20 May 2026 16:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294837;
	bh=cTyZx2ZDl8B1oROxK8lXj/1K8cT6gEL65BV9XgOpTbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZUfYcmGbnuARTw8Zae49QF4yo0dbJlEylwXJODYlApWsfmtltca1JoQ+4bAWGnQS
	 vajFAcKcYSbBI3+uOMqDUE6okwDEoiCwllx8Oi3RK6+RztgaZ+CNLZ/xiEcDH26T77
	 Pfs5pVQZZNBxUMm16kv0xZG9Jc6jNaeyvD+kfK10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erni Sri Satya Vennela <ernis@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0191/1146] net: mana: Use pci_name() for debugfs directory naming
Date: Wed, 20 May 2026 18:07:21 +0200
Message-ID: <20260520162152.601143099@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>

[ Upstream commit c116f07ab9d22bb6f355f3cf9e44c1e6a47fe559 ]

Use pci_name(pdev) for the per-device debugfs directory instead of
hardcoded "0" for PFs and pci_slot_name(pdev->slot) for VFs. The
previous approach had two issues:

1. pci_slot_name() dereferences pdev->slot, which can be NULL for VFs
   in environments like generic VFIO passthrough or nested KVM,
   causing a NULL pointer dereference.

2. Multiple PFs would all use "0", and VFs across different PCI
   domains or buses could share the same slot name, leading to
   -EEXIST errors from debugfs_create_dir().

pci_name(pdev) returns the unique BDF address, is always valid, and is
unique across the system.

Fixes: 6607c17c6c5e ("net: mana: Enable debugfs files for MANA device")
Signed-off-by: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260408081224.302308-2-ernis@linux.microsoft.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/gdma_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/ethernet/microsoft/mana/gdma_main.c
index 786186c9a115f..c2e855ff3ca9a 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -2007,11 +2007,8 @@ static int mana_gd_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	gc->dev = &pdev->dev;
 	xa_init(&gc->irq_contexts);
 
-	if (gc->is_pf)
-		gc->mana_pci_debugfs = debugfs_create_dir("0", mana_debugfs_root);
-	else
-		gc->mana_pci_debugfs = debugfs_create_dir(pci_slot_name(pdev->slot),
-							  mana_debugfs_root);
+	gc->mana_pci_debugfs = debugfs_create_dir(pci_name(pdev),
+						  mana_debugfs_root);
 
 	err = mana_gd_setup(pdev);
 	if (err)
-- 
2.53.0



