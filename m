Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA6533D1CC6;
	Wed, 20 May 2026 18:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301799; cv=none; b=Z56tyJp/Xg6vRYI1ZbyirY20gOxkEOp44EJGLG0kEyf+Q14GPyYuAJ67jEqallY+H1A8yYP47O+xZHGR9xxMhX+0g41luwh8qWrRfECkvhLVdS72Fm3MhewCHR0IozG/msyIJfAnKP0rR+LRCtlM/6CaH4xOIxfHl+VyHaypaOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301799; c=relaxed/simple;
	bh=zf1SpcqoQCX0c4Bl6vPmQb3eIaNogy+P9qaY1Umtvgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVPtoI4Uii98qNLXeOJWqhpwYG4LgOSTQ50UtgLWae9qAcQv77CnSCvAOvbak2NpATyJ2k/dVCphrhb15Gz7PGIg1jnj76W47dAvmneh3+jfecwUb/n6c0//J15wkEO8nBSza2PNPjtjNzrSiktebLxEf9Fe1C+Du1djt2hY20s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wCqGD5Iz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCqGD5Iz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4571F000E9;
	Wed, 20 May 2026 18:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301797;
	bh=UpInOkIM80u3SkqttUuVW8iCPXotPPp6FmwqK55VqcI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wCqGD5IzIyHbP2RZdDXtbQowp2KC4aM3hgWTOMuUOAnD8SwdRqLSiWIoEM8LUNyaX
	 e9QFPIZQ2c/3eYPpd9eOr3LIW1egUbnFy8YbFqDRmKPli3UlW28tWi2vef8QAT2vWo
	 T2yHBNSPVL2r9JWednrjE+CRkR1g4s2hMsr30qag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 024/508] wifi: rtlwifi: pci: fix possible use-after-free caused by unfinished irq_prepare_bcn_tasklet
Date: Wed, 20 May 2026 18:17:27 +0200
Message-ID: <20260520162059.114752990@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Duoming Zhou <duoming@zju.edu.cn>

[ Upstream commit 039cd522dc70151da13329a5e3ae19b1736f468a ]

The irq_prepare_bcn_tasklet is initialized in rtl_pci_init() and
scheduled when RTL_IMR_BCNINT interrupt is triggered by hardware.
But it is never killed in rtl_pci_deinit(). When the rtlwifi card
probe fails or is being detached, the ieee80211_hw is deallocated.
However, irq_prepare_bcn_tasklet may still be running or pending,
leading to use-after-free when the freed ieee80211_hw is accessed
in _rtl_pci_prepare_bcn_tasklet().

Similar to irq_tasklet, add tasklet_kill() in rtl_pci_deinit() to
ensure that irq_prepare_bcn_tasklet is properly terminated before
the ieee80211_hw is released.

The issue was identified through static analysis.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260223045522.48377-1-duoming@zju.edu.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 40112b2c37775..b978d31e47ca9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1675,6 +1675,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
+	tasklet_kill(&rtlpriv->works.irq_prepare_bcn_tasklet);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 }
 
-- 
2.53.0



