Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC4647D922;
	Sat, 12 Sep 2026 13:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218051; cv=none; b=lGjR2wjGxywrv6sZwZ2wP0JJE6LbyiGBKaQO3Mn/CQkNBcH3Kt5svLSlVEbMPpYso7iTQdZET37XoZlF/W9N6kpK9SxigdfcLSpsNa5cTsdKeL6tOQ/s4FpzneTvkhmavQOleHOBwwWuKv5F/l6r4Z5mYUkugWjFZrxijNi0tD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218051; c=relaxed/simple;
	bh=zY9mX9VGV2sW5PwqNe1FsQavmyp2E1eBBfiHuWjQu9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bny3zKtkyih8q0n64Wu8rv18pBYWdAuX83y8weFkv4Soob2hOUzU6LIb7cySQv+AtoV5cMnLVH6gcux81T31MNVjOPoodW5vBF8jjHWVgyj1tWVqmQFsmPmE2Oz8f5xpwvYwgghU5YVUUCbFWSmXmtxQyvpus6kk9dorIFHV1QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dMLO0ILO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dMLO0ILO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D951F000FF;
	Sat, 12 Sep 2026 13:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218050;
	bh=5MqOYn7Lx3vGFyr3waZDrKzdwUeasKTDAdMWkhrCDog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dMLO0ILOOlyr6PD1GFliy6r+E6Cj3F3l+XBDd6mOFN/rMAvW3Ll3xVW+PaweaglIY
	 WF/o6dAKqROBMLlUHf4J6TA18i68Ic/0Gr43b/X5qdzIR3CHo+XRcxWgo7Fgi4As9c
	 FD9ycgUAQotLk/zW9Jj4alfGbaGIe8YGEfLxBONA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1022/1376] fbdev: tdfxfb: fix PCI enable cleanup with pcim_enable_device()
Date: Sat, 12 Sep 2026 08:57:28 +0200
Message-ID: <20260912065630.340395305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index c5095358209e1..eb8f33ae94e77 100644
--- a/drivers/video/fbdev/tdfxfb.c
+++ b/drivers/video/fbdev/tdfxfb.c
@@ -1383,7 +1383,7 @@ static int tdfxfb_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		return err;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		printk(KERN_ERR "tdfxfb: Can't enable pdev: %d\n", err);
 		return err;
-- 
2.53.0



