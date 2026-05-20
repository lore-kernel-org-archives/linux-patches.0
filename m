Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDC73F20F9;
	Wed, 20 May 2026 17:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299512; cv=none; b=KqCCF5mVMQBPldhII5ZpoG2SaM6kYiRXeg/ZlbH+9K9gsUbRuY5dviS2BWCwzTtDcm0IHq2BSq0WPjQv3st2Eyqidz497MbqIXo9TXe0Xxly9sSkqyXmkE8NUa58qSf9YqB22mkR6mFxqsSrRTTCWr+smgIxIXqdNF+c0rx7C9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299512; c=relaxed/simple;
	bh=bTyF2UEYgbalQIGuqIWSmnbX4PooXmkds2vuoeWg2kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8Rgum+9bVhGoxFFLQ2gTfFx4Orf1H07O+54rZ6jWSyoQ22J6HmIme6QsNlHethf4/az+Y2sCKykm2Sn26hm7l41Gk3IDAYVB8z5QfmWnmscKk/cfvvvCw+RlG2+3R4J4VoHvsIlP5dyxXazKnTwsOzeqoL559fSWzshOg6UP/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqdzz60v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqdzz60v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A08C1F00893;
	Wed, 20 May 2026 17:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299511;
	bh=xLIXmDOIkCon/ZwSl29HCtPNbCmuEXAJESD2vG5rh4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqdzz60vTAv7TDiQ6f2Wwe8wL+/WFdxXTMgohxrIuKpFyr2D45dL742YtndVeJ1K2
	 RzIZBS8MMEpxO0u0OaVmAKgS3TiHc1NVQxeuOgSJCEj9B8hp7yEKCcWDvCbAltUH3B
	 5bDPODWi4LOAZ4mAN/AupwzMBGRX5/QtIMdkdTYM=
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
Subject: [PATCH 6.18 758/957] drm/sysfb: ofdrm: fix PCI device reference leaks
Date: Wed, 20 May 2026 18:20:41 +0200
Message-ID: <20260520162151.003842052@linuxfoundation.org>
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
 drivers/gpu/drm/sysfb/ofdrm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdrm.c
index 8d8ab39c5f363..f94fddea897a5 100644
--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -349,6 +349,7 @@ static void ofdrm_pci_release(void *data)
 	struct pci_dev *pcidev = data;
 
 	pci_disable_device(pcidev);
+	pci_dev_put(pcidev);
 }
 
 static int ofdrm_device_init_pci(struct ofdrm_device *odev)
@@ -374,6 +375,7 @@ static int ofdrm_device_init_pci(struct ofdrm_device *odev)
 	if (ret) {
 		drm_err(dev, "pci_enable_device(%s) failed: %d\n",
 			dev_name(&pcidev->dev), ret);
+		pci_dev_put(pcidev);
 		return ret;
 	}
 	ret = devm_add_action_or_reset(&pdev->dev, ofdrm_pci_release, pcidev);
-- 
2.53.0



