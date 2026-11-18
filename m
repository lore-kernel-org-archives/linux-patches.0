Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054418;
	b=3CSAww1YE8rg2st3ogboLK/xvk94qh9OVih1Hjvo4kYCrQeSv01KxH2tB6BUppyB1tTX
	 +k3+FVoaKvmJRLzfuXricTDSb4ahEdnawOZ4sWkCRuw5h0bb18XyxUwUl2ma/zwuRkmgu
	 HfiZmAz/aRThkoqObqzKRen5vHGOMJhO1PR/Os9wg5PJcbKyDIUGHp0zgfiStKI/RlfoA
	 vZT9LHT1K2UjBjtLTCkdjYRXvlKJCkfG8aTNQwmJNbqY6NUT4zkNFOYnfGfxH3zEpQ3t0
	 Yfm2y4LvYWP9StUPbLn/xRfWKAk/hmsOpyp/xys0t6RUb7vjv0nS2GDn0Vrowraxmlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054418;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4WvIpjJlLpOle5tVY82RYkri1uBggxadlhL2YuYB7mo=;
	b=m+DdKigSz0yelEGs2Q2Hn1egDc0FaAGr2HhogU+zTbARCRBqn5wXoZFYGRiAzppwXYtD
	 vyF9i3s8sIDNdPXCR1UzJdGIFpnw2X1OZnwzieTHKr2Wznx+89OSp8qVmCJioVTRDZIoC
	 WiJ1ZVqZevOh6OWK2pSy/kN5RuxVe5WQQJf++hS0clwLuUM4hf2+Bc47WfMRitcRJoifa
	 6MSIBhG89FlEgiCTNGe4c6QsZgl0UlDy9QD0dH0VrCYXSYyqb7W9OaEGzjcmEwEDideDo
	 7ZNdPxXHsjuArlRbAF4xGIg3JCkmTLjEWN6f6SBRR55TezdkSe1xnz3PryHunMA/+2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nC50R0ju;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E926606A320;
	Thu, 19 Nov 2026 02:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nC50R0ju
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8851F000C4;
	Thu, 19 Nov 2026 02:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054418;
	bh=4WvIpjJlLpOle5tVY82RYkri1uBggxadlhL2YuYB7mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nC50R0juq8kLjT/3UArYrMT48Puaj35lPO7V6ymttKAB3DsDZsrBkTZu6IwTTV0An
	 Kdt6MO7SPNHoS2JhhYyiXSpzB2ern1EpkqtItE+olpJF6ihe2WeUKiRGt91DnBsgWk
	 AlRdTX2eoWhnugGIsuJh/tTbCAl74PScnY4JzFK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1267/2214] fbdev: kyro: Use devm_ioremap() for mmio registers
Date: Wed, 18 Nov 2026 15:49:03 +0100
Message-ID: <20261118150102.303853772@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>

[ Upstream commit e0bf12a43243e6afc5a03fc55c58ec48aba48088 ]

Replace the manual ioremap() call for the MMIO registers with the
device-managed devm_ioremap() variant.

This simplifies the driver's resource management by ensuring the memory is
automatically unmapped when the driver detaches from the device.

Signed-off-by: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: d3bc005a6294 ("fbdev: kyro: Release WC setup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 4979339dbc008..7441d48faea77 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -713,13 +713,14 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	kyro_fix.mmio_len   = pci_resource_len(pdev, 1);
 
 	currentpar->regbase = deviceInfo.pSTGReg =
-		ioremap(kyro_fix.mmio_start, kyro_fix.mmio_len);
+		devm_ioremap(&pdev->dev, kyro_fix.mmio_start,
+			     kyro_fix.mmio_len);
 	if (!currentpar->regbase)
 		goto out_free_fb;
 
 	info->screen_base = pci_ioremap_wc_bar(pdev, 0);
 	if (!info->screen_base)
-		goto out_unmap_regs;
+		goto out_free_fb;
 
 	if (!nomtrr)
 		currentpar->wc_cookie = arch_phys_wc_add(kyro_fix.smem_start,
@@ -768,8 +769,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 out_unmap:
 	iounmap(info->screen_base);
-out_unmap_regs:
-	iounmap(currentpar->regbase);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -792,7 +791,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulOverlayOffset = 0;
 
 	iounmap(info->screen_base);
-	iounmap(par->regbase);
 
 	arch_phys_wc_del(par->wc_cookie);
 
-- 
2.53.0



