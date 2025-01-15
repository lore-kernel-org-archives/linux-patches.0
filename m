Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E77248BA1;
	Wed, 15 Jan 2025 10:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938350; cv=none; b=u4QWvG4JRrXM5HJCHMOqKelNx2fa2wKavQIknUepm8dmGYYzE0d2RFTn7Fxx35caLTLlArptJ5+XGDfPJZxzZPW//qvkZATTqKNOyyn4aqVgDgdkAJCNojAtAFxTDce9F6TtxdSUdCzmlNAgdugGJKvlZE1ZlENhT0sRwN5a74s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938350; c=relaxed/simple;
	bh=hL338cH60dz5bbYB9CTs3nb1e1wBO3FmswVWYXxXAuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDOj6SjqDkYjZFhxgAEF1o3e9rL/tb9h3PLA5FFgHC9N0c4uZaey2VGk+ROd9qY0FC4tLuOUjovzeklbSoPDqs+pXARSwTJ0OFxEOxOcJs/rbwo7wwe+oJrwSqyn91NZp7NBY7KNVXuv/DJrpTwTWtf1jtvTLj3Rk+fIAb1pR4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYv2bpry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYv2bpry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F15EC4CEDF;
	Wed, 15 Jan 2025 10:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938350;
	bh=hL338cH60dz5bbYB9CTs3nb1e1wBO3FmswVWYXxXAuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYv2bpryrHSzIsyRmeLAPO+ts5mCePO2DJa+jIYb8Jk8AfrReWRp2UiglWnqKyKvh
	 40VyaxdIUv9Ave8u8UKP2mBK1owC2GXlFFH6cHk3aVHGzslipXQYaKX2KUXfYTrW3o
	 Q75X+hhdsGwzfjh8n+YzhA8nFSqhgr01mddtkq6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Xu Yang <xu.yang_2@nxp.com>
Subject: [PATCH 6.12 155/189] usb: host: xhci-plat: set skip_phy_initialization if software node has XHCI_SKIP_PHY_INIT property
Date: Wed, 15 Jan 2025 11:37:31 +0100
Message-ID: <20250115103612.593047839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit e19852d0bfecbc80976b1423cf2af87ca514a58c upstream.

The source of quirk XHCI_SKIP_PHY_INIT comes from xhci_plat_priv.quirks or
software node property. This will set skip_phy_initialization if software
node also has XHCI_SKIP_PHY_INIT property.

Fixes: a6cd2b3fa894 ("usb: host: xhci-plat: Parse xhci-missing_cas_quirk and apply quirk")
Cc: stable <stable@kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://lore.kernel.org/r/20241209111423.4085548-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-plat.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-plat.c
index e6c9006bd568..db109b570c5c 100644
--- a/drivers/usb/host/xhci-plat.c
+++ b/drivers/usb/host/xhci-plat.c
@@ -290,7 +290,8 @@ int xhci_plat_probe(struct platform_device *pdev, struct device *sysdev, const s
 
 	hcd->tpl_support = of_usb_host_tpl_support(sysdev->of_node);
 
-	if (priv && (priv->quirks & XHCI_SKIP_PHY_INIT))
+	if ((priv && (priv->quirks & XHCI_SKIP_PHY_INIT)) ||
+	    (xhci->quirks & XHCI_SKIP_PHY_INIT))
 		hcd->skip_phy_initialization = 1;
 
 	if (priv && (priv->quirks & XHCI_SG_TRB_CACHE_SIZE_QUIRK))
-- 
2.48.0



