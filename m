Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40CA25E818;
	Tue, 11 Mar 2025 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706369; cv=none; b=TJLEsgsbYCzjJJ5SqkhYpTQm9RYTV1cj2mrHbRMm1wm0E7e/BYGscvX1e36ZH4sMVVbnFdQbNoX/ih+nCqUS+UzUzPRpB0CHtl3aeW7k9f0GTOotDsY/6NdHiDPf2zb4vvCQX0P4hr2aKdBhtU7wMcbICRoHdhiUMegN8RYDC20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706369; c=relaxed/simple;
	bh=McUkSPoLjTGCBOz0mEgIWlKHctwEC4d30QwWfm38JFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHxy5UMSPzmqAOZ8hqdGvbV+JkYZNjfrygE+iV9tLXldYPPISzafD3VD1sQRKDNV6xBx0PkuAyz6A4n7cOjR8axofuED9Bl29sw+ZQel41uyBYzj0K3uccmXUejxUzfIQ2xDlu/huFzQxrPXs2bG6lffya+w5IBESPhqAit7RQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cE8hv113; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE8hv113"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08317C4CEE9;
	Tue, 11 Mar 2025 15:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706368;
	bh=McUkSPoLjTGCBOz0mEgIWlKHctwEC4d30QwWfm38JFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE8hv113zF1Yq4/j9fWfTM6/i+3Vj/0KNB1MogNlYbW7JV0GNuYduWoYdaxOKKWNA
	 ti7pBDYjCfGEd5gmh3UcA8VCP23yaLIUa6lvYDsKajq91/uWgFTNLn6rEqt4guH2Y9
	 Ahcxus0eeAwolnK8HRhKhm9mKfppPyPxLt69UJ60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/462] wifi: rtlwifi: fix memory leaks and invalid access at probe error path
Date: Tue, 11 Mar 2025 15:54:51 +0100
Message-ID: <20250311145759.347927322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 84f2669f201ab..5b0a5a22d06d2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2167,7 +2167,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	if (rtlpriv->cfg->ops->init_sw_vars(hw)) {
 		pr_err("Can't init_sw_vars\n");
 		err = -ENODEV;
-		goto fail3;
+		goto fail2;
 	}
 	rtlpriv->cfg->ops->init_sw_leds(hw);
 
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



