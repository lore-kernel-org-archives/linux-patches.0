Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841BD36494B;
	Wed, 20 May 2026 16:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294530; cv=none; b=IaMYsoRTn3dZIQehwWLvCcM7jfOLIBJvaUIsXiSToknFy8T0BxnQSc4OwavUW/B8tJPG0JiYT3y8kIxInwLOCDaUNCbp1G7ntuc7rV5IrkMYUr9xMM/zDfHtOcRRPGKxPfgoqjUvLZr5vLfx3nGhDQEu4FitwXr5ojid5ieizz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294530; c=relaxed/simple;
	bh=5ruxJZNlLWNhbeKiERSbII2S9PRxDqFJcvU+pFlUrbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DBTJ80q69BY2NJwxch2fJbXBgd9xFmfDdL5usNhjqA+BRId8fsUzMDuD9zetns2iNL4hLIBIsGEYECPq2tOOx4DwnumJ9VPEOY3JgEdSDslTarHr+kdSuex6PEVZ1XTvph2TKGe0uL4Nr7TJJkfbCr5xioUs6DwIDefA6/V/CdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=01rTLCQQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01rTLCQQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798401F000E9;
	Wed, 20 May 2026 16:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294527;
	bh=IPaq1Mx/Duka+WnuRx4gNxaFpb6upoakUbIQGvWM3ac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=01rTLCQQ6bzLaoaZEOQRWXjhaW9+7YSXST2xJJJi+ztFbRn2VjXvh1Rmx+DvZCp28
	 3ReFSDZ3DZ+YL+JiDAcCgxloGFdOUZXy3MOR2ZC77+O+eVif1rDb9VP4SDhbl3Kx7M
	 DOXuxUgPUtKtfQ6LoCLU4uV7PHS2jxCh7/cOFsSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Duoming Zhou <duoming@zju.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0072/1146] wifi: rtlwifi: pci: fix possible use-after-free caused by unfinished irq_prepare_bcn_tasklet
Date: Wed, 20 May 2026 18:05:22 +0200
Message-ID: <20260520162149.987582685@linuxfoundation.org>
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



