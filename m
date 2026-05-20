Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C55E35C1A0;
	Wed, 20 May 2026 17:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297499; cv=none; b=tB7BsiyxVUyHl3yuDlIttQ6uOC7ngNC8KAuxbgpgMNg/CzeKo2erwFiDdYxNqMvIgl30wZ0poE2+METIqut52BIPz5SRKFJBPkutdOMJUn24YCOCfyPO2lBkFNgYc02sNkPJzkJwXfvdC3APwbGleQVZvj12jkd0aDQM9uAufNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297499; c=relaxed/simple;
	bh=E94hPZJF3suVGIrEcU5bluhNgtqssSe50PzG1kg3a/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C79rkWTL1Og9P2CrI9whrUJkXDLHztGUKMIt3OjApRdORmTH19ItB9VvCDKW9DdyK9QCuSkHLjM8tlJVZo9NqqXs41P6lQSfuJg2P/OKWVyoiq2qv/U9b2ijS1Ai/97CMzVCwkAPT2PeeCc0Wtbfd7jLqdn7AKvEFuSM/s1p2ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdSoU7lL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdSoU7lL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF41C1F000E9;
	Wed, 20 May 2026 17:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297497;
	bh=g8cE+ozKX+0zEmtmMh3fPYa6ooaJtJy5ZG7DC5gOF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdSoU7lLfW/xFWtl4f/w3rfUSgilGX4H7A4ffj3K3jKN3GTgj6W4mC5lVNm9A9j3+
	 v3Epx15J728sRnQr0hhbm1i8M8Exr/YN6O4HVhQ47JJ14cznhOqTlU+8IXYamPsaZV
	 uAXew/hCC/5ppAdOAKr6vNqIpBgHal4UCQOlCeKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 055/957] wifi: rtlwifi: pci: fix possible use-after-free caused by unfinished irq_prepare_bcn_tasklet
Date: Wed, 20 May 2026 18:08:58 +0200
Message-ID: <20260520162135.752144120@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index d080469264cf8..f0010336e78c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1674,6 +1674,7 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
+	tasklet_kill(&rtlpriv->works.irq_prepare_bcn_tasklet);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 }
 
-- 
2.53.0



