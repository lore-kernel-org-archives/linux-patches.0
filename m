Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054421;
	b=B1yHion2QC58GNZ/32rc59d55y3gjG2jFWnDbGNM626RlPIhfNJhIQLBnHlwp5njOGbM
	 dsXg+k/TuQRnVZ8+Lua8lnNmc4BBf25n7ZL50wXhzzy6rlFOTmEKNxvIw0oZ0cLIYf+ao
	 aGO8gYyj+iXeTfXde8eIW4viGGHBbTt8Q6tcPVV4UtPIs0XUn1ShFbQM68w3RQXreimrq
	 SWKansnl1JIPhbN0JqlJeV/ww9j6RPKTu6jbBPMbOfvd31nAOGwgbYeuZUXLbnm+Z90WY
	 j5sFhaPJLhacalwTVTbdWW9Mci0VYVnjcY+wsZLEihaLhkNdemVRNXmZv3rOySpvqew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054421;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bxHVJFalepBvBU2xVx9uqY8Kims0hsJM9aSBczNCqh4=;
	b=UyIGZE9m1EWVOqBLtiBK1JqgdaOQd14tOYZ7X3J7j0ssLK9QG4md72nAON+G2Z351kbL
	 C/E8xK36BwhCrUMMjXCVzJfISdaeChRSsu3HIzyNghF22HzcmFxcj2ioEvyTRRVPb7gFB
	 jzSd74goR31VDp9FtN8BDSE69sIVH870yKT6AY3v2+dGeCE+38TVmImk5cEYtJ1ZYsaK/
	 2TI4sp44sbjffbpKkPwH9u2zuLWBk8+HwA1b/pO7mb6SMjvzofV/IOSfJMJIbr3V/delz
	 KFsNgpHn+uG/kkvkbwydenlwsgObbvSsa/TZieaqhWAcx5CJStDSGV2BAG3bWD94hlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6K8GUW1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20031606A32A;
	Thu, 19 Nov 2026 02:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G6K8GUW1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E48D1F000C4;
	Thu, 19 Nov 2026 02:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054421;
	bh=bxHVJFalepBvBU2xVx9uqY8Kims0hsJM9aSBczNCqh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6K8GUW12MKc/jkyBlYornZttBnI7ILGkAb648YGH350xfRUrUj2vHfPqSgntk+wa
	 ASoLVq8XYDJrnZsDjyCxBpnj78zasM6KDvC8vQ4IfHszzk7ShvX3IdiRZ2nhJFqkXf
	 rgVCISGQlAQp/RJFXcvndaOIZu8LgMTdcBwB61g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1268/2214] fbdev: kyro: Use devm_ioremap_wc() for screen mem
Date: Wed, 18 Nov 2026 15:49:04 +0100
Message-ID: <20261118150102.340673998@linuxfoundation.org>
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

[ Upstream commit 32dfb6112ea3ca143636832cd34234f2be4830bb ]

Replace the manual pci_ioremap_wc() call for mapping screen memory with the
device-managed devm_ioremap_wc() variant.

This simplifies the driver's resource management by ensuring the memory is
automatically unmapped when the driver detaches from the device.

Signed-off-by: Giovanni Di Santi <giovanni.disanti.lkl@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Stable-dep-of: d3bc005a6294 ("fbdev: kyro: Release WC setup on registration failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/kyro/fbdev.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/video/fbdev/kyro/fbdev.c b/drivers/video/fbdev/kyro/fbdev.c
index 7441d48faea77..b298e9a1b4510 100644
--- a/drivers/video/fbdev/kyro/fbdev.c
+++ b/drivers/video/fbdev/kyro/fbdev.c
@@ -718,7 +718,8 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (!currentpar->regbase)
 		goto out_free_fb;
 
-	info->screen_base = pci_ioremap_wc_bar(pdev, 0);
+	info->screen_base = devm_ioremap_wc(&pdev->dev, kyro_fix.smem_start,
+					    kyro_fix.smem_len);
 	if (!info->screen_base)
 		goto out_free_fb;
 
@@ -756,7 +757,7 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	fb_memset(info->screen_base, 0, size);
 
 	if (register_framebuffer(info) < 0)
-		goto out_unmap;
+		goto out_free_fb;
 
 	fb_info(info, "%s frame buffer device, at %dx%d@%d using %ldk/%ldk of VRAM\n",
 		info->fix.id,
@@ -767,8 +768,6 @@ static int kyrofb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_unmap:
-	iounmap(info->screen_base);
 out_free_fb:
 	framebuffer_release(info);
 
@@ -790,8 +789,6 @@ static void kyrofb_remove(struct pci_dev *pdev)
 	deviceInfo.ulNextFreeVidMem = 0;
 	deviceInfo.ulOverlayOffset = 0;
 
-	iounmap(info->screen_base);
-
 	arch_phys_wc_del(par->wc_cookie);
 
 	unregister_framebuffer(info);
-- 
2.53.0



