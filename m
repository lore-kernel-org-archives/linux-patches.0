Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BFB30E847;
	Sat, 30 May 2026 17:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161780; cv=none; b=MJXHR1a0rD3OQp34tDu+rG6Dwi0W4U8wz1Kqw025rjFW7OnKwJnO06+t3y5UHVJaRF/Z0BFarX8vhCaaIeDuVtZuCtauJYyPuWmXdxWdUtCGxcNzgxl3BfUA4WcLG8X2wbPOjMKLFN5l18x6eRDkZqJ++JpxzayiSEAVUQnqSt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161780; c=relaxed/simple;
	bh=qOuzr4i5PEAU7V3rFBGnq+xJ2cFB3R/bMZcitoZTVcI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sjs9XyI9DHBDLo8InKxPJcKnLvWq0gHwjo6h7BBJeuCB95V7BikAinbV7UIo1ucFA40aHGjy13ii3fm4AHZ0RRS6E95yjSPm7UctrDd5StGLh1GMz0e01vXs3s2MNrt6vkbIG2674DQPxz3kyepKuVNyZFxGThscPg/PfiT97jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sv8RYcgJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sv8RYcgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73251F00893;
	Sat, 30 May 2026 17:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161779;
	bh=5uL3QV4R8HDFWRh63zFd/XSb5aX6TgSRizlwtS/4ji8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sv8RYcgJYnFrIW6aA7Xy9hcL91FxjdliR2M1IjxbqHZbvsekevB8t2iZC04op7MmV
	 nDysYwPrJJZa5KJcqcv7oP+1QOfIcgR/EeYiHk4O8RePX8zYW6tS4hT7jybMc5erQX
	 QMDotJT/OkoW8e46Z4gWCkCG8oSOBHF8GlT9V5bE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Taegyu Kim <tmk5904@psu.edu>,
	Yuho Choi <dbgh9129@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 724/969] fbdev: offb: fix PCI device reference leak on probe failure
Date: Sat, 30 May 2026 18:04:08 +0200
Message-ID: <20260530160320.531613113@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 869b93ba04088713596e68453c1146f52f713290 ]

offb_init_nodriver() gets a referenced PCI device with pci_get_device().
If pci_enable_device() fails, the function returns without dropping that
reference.

Release the PCI device reference before returning from the
pci_enable_device() failure path.

Fixes: 5bda8f7b5468 ("video: fbdev: offb: Call pci_enable_device() before using the PCI VGA device")
Co-developed-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Co-developed-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/offb.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/offb.c b/drivers/video/fbdev/offb.c
index ea232395e226f..e151b0d7b53c2 100644
--- a/drivers/video/fbdev/offb.c
+++ b/drivers/video/fbdev/offb.c
@@ -646,8 +646,13 @@ static void offb_init_nodriver(struct platform_device *parent, struct device_nod
 			vid = be32_to_cpup(vidp);
 			did = be32_to_cpup(didp);
 			pdev = pci_get_device(vid, did, NULL);
-			if (!pdev || pci_enable_device(pdev))
+			if (!pdev)
 				return;
+
+			if (pci_enable_device(pdev)) {
+				pci_dev_put(pdev);
+				return;
+			}
 		}
 #endif
 		/* kludge for valkyrie */
-- 
2.53.0



