Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14991D6188;
	Tue, 30 Sep 2025 15:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245324; cv=none; b=Z1MOKFEbjAsz7zE2cHb5Lboqdug3mLcAKC4o6/KtRhj9RDo2MZ5rZXO3aq+UYIcJLGUTJ2b4VRb1lLTTkpK+fVB6yRu8tnR4g8+g3NCLzEq2St59rVbxIqKmaifeiNLRc3Iv66E4+6losIwp4KA/NbmbOY/sdj73yR3feM6XRnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245324; c=relaxed/simple;
	bh=Br1Q8qsFJGDXqzNRBi+L2COm7O6h30gmulb758vYhBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSRouiTs/NUShKKYmVCPMmMqZAVgWeReFF6UcKwnr48AgJSDX7iVVPQbFVnOwLRNwK+2SwsjwvTXazmSuhQQJ+WWbsO/agvE08WV3PEL9BTJChyHA8kbENbvNMkY/Q+r5S9nkrqt5q6iK9884A1ikGPNgWFbm9pnahiO8uDDARY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI26JCG2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI26JCG2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F129CC113D0;
	Tue, 30 Sep 2025 15:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245323;
	bh=Br1Q8qsFJGDXqzNRBi+L2COm7O6h30gmulb758vYhBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EI26JCG2p8V/QE7nIz7jqJbLSUz0g18s0XB2P9+Fc92OI1l4StNwtDVV2yxOJe/JT
	 vGPo5+4JkzcIpq/PcBrkzKjv4s5Oy59AdEZISeGVbh4jMidFRLRS5eLRa5x1ghxn/L
	 7TsJuGRxYnMW46Q0zJc1A+z1zlL0E6esnnhy3U+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zabelin Nikita <n.zabelin@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/151] drm/gma500: Fix null dereference in hdmi teardown
Date: Tue, 30 Sep 2025 16:47:45 +0200
Message-ID: <20250930143832.977045227@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zabelin Nikita <n.zabelin@mt-integration.ru>

[ Upstream commit 352e66900cde63f3dadb142364d3c35170bbaaff ]

pci_set_drvdata sets the value of pdev->driver_data to NULL,
after which the driver_data obtained from the same dev is
dereferenced in oaktrail_hdmi_i2c_exit, and the i2c_dev is
extracted from it. To prevent this, swap these calls.

Found by Linux Verification Center (linuxtesting.org) with Svacer.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Signed-off-by: Zabelin Nikita <n.zabelin@mt-integration.ru>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://lore.kernel.org/r/20250918150703.2562604-1-n.zabelin@mt-integration.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/gma500/oaktrail_hdmi.c b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
index a097a59a9eaec..08e83b7513197 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -724,8 +724,8 @@ void oaktrail_hdmi_teardown(struct drm_device *dev)
 
 	if (hdmi_dev) {
 		pdev = hdmi_dev->dev;
-		pci_set_drvdata(pdev, NULL);
 		oaktrail_hdmi_i2c_exit(pdev);
+		pci_set_drvdata(pdev, NULL);
 		iounmap(hdmi_dev->regs);
 		kfree(hdmi_dev);
 		pci_dev_put(pdev);
-- 
2.51.0



