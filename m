Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F18B415198D;
	Wed,  5 Feb 2025 14:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764170; cv=none; b=QUa4ARlj45mOYs0uTGQXmZNLkaWYcyKa9iy+LSJiQui1gDc2DcIrRLsNLR96f0GmVzyXxzd9i8CWpo1nwwFKPascqqlKy55gYmKsDH56xDr+d99lEcZ+ogJaeV8qxEtGEOZkTAwwgSXRugxiUr5jygnqrA8f9oh/Hpkvoy3Ce6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764170; c=relaxed/simple;
	bh=C4hut6YpNaVdWjqa1mgsgJVkCdSXTAA0QkAXp3gq5hk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7M4JRCOFkWg7lA49rtHpOqvFHUSjIIP7PcctKnybHeMQPAeZ8zQmOuxzThi/UQP4btQbHe563LgbZJDGorkGE7vk6nN19W7DNCSO4vv93COEvAi8dPcR+vii564k3kdOABHI+rm4PCoUqc6Qh4E0rpMqM+PEr3kxn9NLSwHuBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l+/jaQvo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l+/jaQvo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380AC4CED6;
	Wed,  5 Feb 2025 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764169;
	bh=C4hut6YpNaVdWjqa1mgsgJVkCdSXTAA0QkAXp3gq5hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l+/jaQvoAq7CAUDfXw+7/EdfQntBFdZpS/i4DDZJe+8+BKV/sPfaXyp+TVwLgpX/j
	 cUvk5Ca5KF/zRED/+TlxOMSR/IyKfSelyhZuQiW6V39AgSgb436AqqzN9bKizb4nXp
	 YoE7rRyNAUoElNDlqt4WRHJ8cz/r5vrPcRN0Tuxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/590] wifi: rtlwifi: fix memory leaks and invalid access at probe error path
Date: Wed,  5 Feb 2025 14:37:30 +0100
Message-ID: <20250205134458.891286658@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit e7ceefbfd8d447abc8aca8ab993a942803522c06 ]

Deinitialize at reverse order when probe fails.

When init_sw_vars fails, rtl_deinit_core should not be called, specially
now that it destroys the rtl_wq workqueue.

And call rtl_pci_deinit and deinit_sw_vars, otherwise, memory will be
leaked.

Remove pci_set_drvdata call as it will already be cleaned up by the core
driver code and could lead to memory leaks too. cf. commit 8d450935ae7f
("wireless: rtlwifi: remove unnecessary pci_set_drvdata()") and
commit 3d86b93064c7 ("rtlwifi: Fix PCI probe error path orphaned memory").

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241206173713.3222187-4-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index e60ac910e750b..a870117cf12af 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2165,7 +2165,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
 		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
-		goto fail3;
+		goto fail2;
 	}
 	rtl_init_sw_leds(hw);
 
@@ -2183,14 +2183,14 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	err = rtl_pci_init(hw, pdev);
 	if (err) {
 		pr_err("Failed to init PCI\n");
-		goto fail3;
+		goto fail4;
 	}
 
 	err = ieee80211_register_hw(hw);
 	if (err) {
 		pr_err("Can't register mac80211 hw.\n");
 		err = -ENODEV;
-		goto fail3;
+		goto fail5;
 	}
 	rtlpriv->mac80211.mac80211_registered = 1;
 
@@ -2213,9 +2213,12 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	set_bit(RTL_STATUS_INTERFACE_START, &rtlpriv->status);
 	return 0;
 
-fail3:
-	pci_set_drvdata(pdev, NULL);
+fail5:
+	rtl_pci_deinit(hw);
+fail4:
 	rtl_deinit_core(hw);
+fail3:
+	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
 fail2:
 	if (rtlpriv->io.pci_mem_start != 0)
-- 
2.39.5



