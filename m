Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3450126C18;
	Wed,  5 Feb 2025 13:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763459; cv=none; b=s1H2adIYzaZBI8w4kKDwAPGcHcnRKyrEYz+BaRRn7KUThAVnxHwxoC4QMSUNenK/3NIH253E9eyipJ2MOlFl3wCqT8WpYa1NpSeRJ5kYY3Qi6+KlKS28Wuj2xTor4/SPN7XIJfmIqiZbpUhMfwkvncigbgkvcQ1ieIa+eBtsOVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763459; c=relaxed/simple;
	bh=sbxa5APIuigSbsSB2SwqjwEtO+QHcq/lyMMFDggDhLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ALdFk/gqblno3FY7fQBEeODRWFpWkqhMTxtwxgAgEgaIGSkbGvUs4fy//pe/LsT9Z7nvHZOPaBQN1z3JQwQg9g/bXkEvgfILr/bqpnaCwLH9L98eFOSEAZWQ9Ho9mpQR4xwOfUNfBnxe52QaJKGUABZO0cH4MnwEHKgEeh82hLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrgYHEbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrgYHEbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF587C4CED6;
	Wed,  5 Feb 2025 13:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763459;
	bh=sbxa5APIuigSbsSB2SwqjwEtO+QHcq/lyMMFDggDhLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrgYHEbNN/LqGCBE+dKBL9ZEkQAv4RsZngVY/W5oAoXOb2e0g/Bwn8KfzAQOVI6xm
	 dySlyZWCB/S0QP4Tokokn0Rh46dXAqouFj+NekDAZxNIYXH0DkUOpSuSz+ChCaNpFw
	 eTfCKgVBPAUndRR0thOVEJRKjleEfhtZy8JaIS2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/393] wifi: rtlwifi: fix memory leaks and invalid access at probe error path
Date: Wed,  5 Feb 2025 14:39:47 +0100
Message-ID: <20250205134422.896450712@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 67004ce2f6d9c..711f75ce7690a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2167,7 +2167,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
 		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
-		goto fail3;
+		goto fail2;
 	}
 	rtl_init_sw_leds(hw);
 
@@ -2185,14 +2185,14 @@ int rtl_pci_probe(struct pci_dev *pdev,
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
 
@@ -2215,9 +2215,12 @@ int rtl_pci_probe(struct pci_dev *pdev,
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



