Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E19CC3FD14C;
	Wed, 20 May 2026 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301478; cv=none; b=bsSLaVhTVE5kiM6sqTG7cajKn1yaxBk9HN1qIozl2oR9281Wei2JvKwdJMuTt3DdJVGBYnA0GNgvwYLLpFiwVOrIj82mrfpfdPxgQVi4xqUXchlDYTktg1mb4D7jzlNtysc7dN9tqP2M8KQaA2BJKbCXo2TiwLx+edyDRxEcIiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301478; c=relaxed/simple;
	bh=+qnbKOW8jP17FDNnKm0L09LR6yQjDsVcoatReAPK49g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qyr1H4HQ9XamBbFRakHUvFucXegHmDWJQzmpUCfUjJPgDEtflYAI5l/pslsM9divnKQj19nUC5qD54sLHlvfwwzLMgV5aikbTHBvhbc5FfpERQEB2cpNhH0sqBAUWi8Gwy27rEW1VOt34kHPeEEXk4J5nWHdtRt7JEYPSaGz3hg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vp9cIBoL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vp9cIBoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135651F000E9;
	Wed, 20 May 2026 18:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301475;
	bh=34fias831304GMDm130DejGozLjjZ7XLWsUiK6EWBVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vp9cIBoLAhoQfqg1PCZTBoLykaxkoSRIN11/nBCUYGXNduINXkKFP+gaGNglO2i0P
	 o74cu71hGXLsOWpl4CoNxCdly4O8goMSzqch/8IUT5yO+kg6xmIGzEpM6rm5CfMVqo
	 R6w2x32Z76ehS8/tQrCkktvCUi73AXhARZtIbTBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Taegyu Kim <tmk5904@psu.edu>,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/666] drm/sysfb: ofdrm: fix PCI device reference leaks
Date: Wed, 20 May 2026 18:22:18 +0200
Message-ID: <20260520162122.692395081@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4aa8110000b0d215deef8eed283565dd0c1def88 ]

display_get_pci_dev_of() gets a referenced PCI device via
pci_get_device(). Drop that reference when pci_enable_device() fails and
release it during the managed teardown path after pci_disable_device().

Without that, ofdrm leaks the pci_dev reference on both the error path
and the normal cleanup path.

Fixes: c8a17756c425 ("drm/ofdrm: Add ofdrm for Open Firmware framebuffers")
Co-developed-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Co-developed-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260420002513.216-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/ofdrm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/tiny/ofdrm.c b/drivers/gpu/drm/tiny/ofdrm.c
index 35996f7eedac0..cc90e0035d034 100644
--- a/drivers/gpu/drm/tiny/ofdrm.c
+++ b/drivers/gpu/drm/tiny/ofdrm.c
@@ -350,6 +350,7 @@ static void ofdrm_pci_release(void *data)
 	struct pci_dev *pcidev = data;
 
 	pci_disable_device(pcidev);
+	pci_dev_put(pcidev);
 }
 
 static int ofdrm_device_init_pci(struct ofdrm_device *odev)
@@ -375,6 +376,7 @@ static int ofdrm_device_init_pci(struct ofdrm_device *odev)
 	if (ret) {
 		drm_err(dev, "pci_enable_device(%s) failed: %d\n",
 			dev_name(&pcidev->dev), ret);
+		pci_dev_put(pcidev);
 		return ret;
 	}
 	ret = devm_add_action_or_reset(&pdev->dev, ofdrm_pci_release, pcidev);
-- 
2.53.0



