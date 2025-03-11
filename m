Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA1425E809;
	Tue, 11 Mar 2025 15:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705370; cv=none; b=n+PHwJX+TFxcZTOhnCRsJR6SycYotztTjEr5GI90hlJqqf3orsZ3Ded5JERiqwGZQJeyXwuFcKyyir3nqP7AASWPOs+qWSJCZrg51b7AyhMbBFKp2Cn2NNLBQAi4NgqlZcx5RxQokK0bdAE7t/lOYLJahWsQq3U86bmQGr+k4iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705370; c=relaxed/simple;
	bh=nydeS/rP917DgOtl52GYL74JJw6KSqnDu0tUyjQ5koE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHBlwZ7dpqJmWTUVq9FEEdDgbBjKfqKNmk76hlMLUL1qqynfr0sv4hUjaOpKCw8FwC/L/qRAHSbQ2QX6ZCi/8V7DocAdVJRHcF26/X0ZVPTnHOoCwSrAYbKiLBP50HIifi+VM1Jk7062TGPvcBflyohT66X1O1zcmXLZqQrLTq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfqW/4Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfqW/4Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B92C4CEE9;
	Tue, 11 Mar 2025 15:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705369;
	bh=nydeS/rP917DgOtl52GYL74JJw6KSqnDu0tUyjQ5koE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfqW/4OcfZTdTt4Igj5wzeaD+aKK71kcBnhfh/c7R6PGaXmBtZDrfxeaiqxK2ssfj
	 Q4K3R+urgSaQXwf/pfjmgab/sFR8y8iuDT/6EiFUUVuNsxJpF03Q56NEIxWp+p2Awl
	 kvhirUWagrWAoYXtyiA2gEUKC8t55YyS8M+LXBRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/328] wifi: rtlwifi: do not complete firmware loading needlessly
Date: Tue, 11 Mar 2025 15:56:22 +0100
Message-ID: <20250311145715.366678781@linuxfoundation.org>
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

[ Upstream commit e73e11d303940119e41850a0452a0deda2cc4eb5 ]

The only code waiting for completion is driver removal, which will not be
called when probe returns a failure. So this completion is unnecessary.

Fixes: b0302aba812b ("rtlwifi: Convert to asynchronous firmware load")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241107133322.855112-2-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 1 -
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 1c77b3b2173c8..a31d013d8815a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -2282,7 +2282,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 
 	pci_release_regions(pdev);
-	complete(&rtlpriv->firmware_loading_complete);
 
 fail1:
 	if (hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index fc1548ad434f6..b5b95ec1231e0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -1083,7 +1083,6 @@ int rtl_usb_probe(struct usb_interface *intf,
 error_out2:
 	_rtl_usb_io_handler_release(hw);
 	usb_put_dev(udev);
-	complete(&rtlpriv->firmware_loading_complete);
 	kfree(rtlpriv->usb_data);
 	return -ENODEV;
 }
-- 
2.39.5



