Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51E6304964;
	Tue, 30 Sep 2025 15:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244699; cv=none; b=IhHVVqz072LUo8hV495vc6F805+yU8OiEJD9r+wlbnAIVAC+Cj0HbiGw/KW/LCWXet/h1LlgOlWn86yjBUcNc4oml40uVLPY8tQNzbJNowSHJblA6fTTbw1bPiCv8vAkQVdnATQQtlZ1CeTn7gxtytMRQ7hgvLIbDF0OUnsguak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244699; c=relaxed/simple;
	bh=OxSepol2nO7gkJbnV0onDbe1tHKv6GmVJs177wCz62M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ucJCfcXueR4Fq30rNngCvFfZApNfKNCgGXAiUU1OSE0sBwa3SjMrgb6LRnp1cSqSlUJW/olDFwXA0RQvCJ7UOGGKAVx29/BCP+sGsDvC/OuDfRBAOFSHrx/RFBCWT+ArtjWtuG5OBO8BVPAAxncdtOgUB++4WuXfqVZIOeqOmBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iZhTQuvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iZhTQuvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3EBC4CEF0;
	Tue, 30 Sep 2025 15:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244699;
	bh=OxSepol2nO7gkJbnV0onDbe1tHKv6GmVJs177wCz62M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iZhTQuvb+kIH1lXMSnitBThNR+wc5akOPdNhWRYl4AU7z+0oHLO9UXC6N3PXeMSGS
	 UUGURRJLgDE5nltyn/DDUoJc8J5S8/yCJOHGxUGAy5QDzn5cgZ2Ga/e6g4kBTLktjv
	 nw7/1ih1vNER+jJxDNclyYVbgrWcGxwqwH/dyDiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zabelin Nikita <n.zabelin@mt-integration.ru>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 086/143] drm/gma500: Fix null dereference in hdmi teardown
Date: Tue, 30 Sep 2025 16:46:50 +0200
Message-ID: <20250930143834.658640574@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 1cf3943691277..c0feca58511df 100644
--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -726,8 +726,8 @@ void oaktrail_hdmi_teardown(struct drm_device *dev)
 
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



