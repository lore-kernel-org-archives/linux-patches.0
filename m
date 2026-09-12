Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B6239768F;
	Sat, 12 Sep 2026 08:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203050; cv=none; b=q/bbsuFql1Msmkdxjhs8cWE92ACXYrKgNdNgALWNfQYG0iEPj8qp6qyRL6MJTxBJjbacPqgvfNM4TaKgrRbKQwlXV5A2I+4szQOml+eOAnGsXzpzujRz+pEELMFeeZJTrmC2r1WZqRLqrZcUjoWpGK+awD3Xfsz8gB3iOGEE2Dc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203050; c=relaxed/simple;
	bh=ZstOe2kRKTdoMK0jIR4qO14YupCtBNwfmUJdQ6gYIYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h++BJOA9FWgKtcjUub/3zBsWTr1lYow3SVnlEfuXgo9Qil5+7acMmDvaagA8nrTEvt2qwqJ21VL3KE6Jl4ct3sbWTSkGd1LXgwSRFxKdc4PYqbOE++Rom5vyqoNDAhqbq6gjHpcyEfzyeGpi2JvjbvShrsseiiulbbjg/fdpXuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8tpg5ks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8tpg5ks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CB661F000FF;
	Sat, 12 Sep 2026 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203049;
	bh=Cia/89uBaojigJXPH2t8XguV2cRiRS9WUFNMbo17ZXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x8tpg5ksyrkEn6IntPEm3Wc4c6dTsuMGpCv3R32DcHbfthjiOvni+gF1Iw3sF3I2c
	 JfE4UKaAsIDkYY95J5zlnhRXM4smiT5bqDaJuphtnBbB8VJ+zrAElUDsxKqYkbfAfU
	 jfJ/k+f51B8Id9Kgeb9Kjqc0eg5Bu6hbd2zAENvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1286/1815] fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()
Date: Sat, 12 Sep 2026 08:50:36 +0200
Message-ID: <20260912065719.203779721@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Myeonghun Pak <mhun512@gmail.com>

[ Upstream commit 95a627143a696f70e17be5ed3b1e733bb6724b46 ]

tdfxfb_probe() enables the PCI device with pci_enable_device(), but
several failure paths after that point return without disabling it. The
framebuffer_alloc() failure path returns -ENOMEM directly, and the later
shared out_err path releases the framebuffer and returns -ENXIO without
balancing the PCI enable state.

The successful probe path has the same imbalance because tdfxfb_remove()
releases the framebuffer, mappings and regions, but never calls
pci_disable_device().

Use pcim_enable_device() so the PCI device is disabled automatically on
probe failure and driver detach.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/tdfxfb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/tdfxfb.c b/drivers/video/fbdev/tdfxfb.c
index cc6a074f3165b..9a06cef756994 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1385,7 +1385,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
-- 
2.53.0



