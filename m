Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E7F25E835;
	Tue, 11 Mar 2025 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705454; cv=none; b=iA89cyvHkQsh7+8nAlli/K3+yfHAckw0weJtSKaP4Dj+GR7L8h66/pVjBBXV6JM9YTEpgoHLuBDxsuImcW2nqTfb/V1cp5ONpLkwawa6ZjBVM5cqdzJZ91kY++a/dXIqHbVvQfqg8vGqRuBCfv/jLQrDZZp1qWxBt1Yq/BLZdt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705454; c=relaxed/simple;
	bh=GuzqsrqFX0JsHOMUX1coIbBabqUfXL8kGYR83wyflvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZGkmr5/gLodqtDZY/dPBaCmY8QoD1oL+nY5v7C/zhBITr3oQIYvP27PS6X6hEv0xVmNAEqB9kzfO168skKHtutVgJ3ugkp90WHnFw/wv3hyCjf0xyde+BTuxzKqvm/YCW6KqRoy3SR7eTSYb3AZkm8XtZW1lQm3OmRKPAXOL0i4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/RRMYkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/RRMYkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0F56C4CEE9;
	Tue, 11 Mar 2025 15:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705454;
	bh=GuzqsrqFX0JsHOMUX1coIbBabqUfXL8kGYR83wyflvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/RRMYkvD0YBTZ6bvuSYJitW5IvlMb6aX7HKv7Zybx+iqceau6lg+UURuLXrTTGAw
	 2+pPpJslg6NVObQKU58htSeUgNRtS07MfuyNGh04eDk2pqgT6QRht91YitPTo2oMje
	 6MSuGpSo4sONmcKwByZ2NGVFWyNGhxpD14FV6M7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/328] wifi: rtlwifi: pci: wait for firmware loading before releasing memory
Date: Tue, 11 Mar 2025 15:56:32 +0100
Message-ID: <20250311145715.771273709@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit b59b86c5d08be7d761c04affcbcec8184738c200 ]

At probe error path, the firmware loading work may have already been
queued. In such a case, it will try to access memory allocated by the probe
function, which is about to be released. In such paths, wait for the
firmware worker to finish before releasing memory.

Fixes: 3d86b93064c7 ("rtlwifi: Fix PCI probe error path orphaned memory")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241206173713.3222187-5-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 4d01996c9df5e..b16b1f1fb1e05 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2230,6 +2230,7 @@ int rtl_pci_probe(struct pci_dev *pdev,
 fail4:
 	rtl_deinit_core(hw);
 fail3:
+	wait_for_completion(&rtlpriv->firmware_loading_complete);
 	rtlpriv->cfg->ops->deinit_sw_vars(hw);
 
 fail2:
-- 
2.39.5



