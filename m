Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 869F3392831;
	Thu, 30 Jul 2026 15:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424470; cv=none; b=YZoSSBU+O8sdJYNTqm4MM9XgRpzjfgnsbPm5yzKoATFFvWLumEfYNSYzVPM0DWN71KySZA1IZn1y4B6IOjXLyvMpaqOdoCizrtlB5YeqbLfsMPVNR7faHBkYd1hkfhOVxTOuri1JlQaG9NcMoN1RSAO2p9biQUu/Lb4lDwZkc5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424470; c=relaxed/simple;
	bh=5/35sIskdGPfDF8K4yolokUy/DNl7MJ7IwJeViA3i6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zs8IuHFlqD9GB2+uY/t4PEPKNUt+3YXtfmoDp1jHXDQ5I8wyrgKxy4nn79xZcKBNHp/vgDAImpXDJttAm6gN7swpJuVQYnoaJ9ntjDatVwJpAkcX67Ev81aQJ5KC/XHuQNNAkGK622DUBBPYVM49U6CBokt7dKGIPIJNyZnzBaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ak7l3pOk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ak7l3pOk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C151F000E9;
	Thu, 30 Jul 2026 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424469;
	bh=9URwU8GE1UJSFtb+s0Qt1ZpypkgQCDQYyK4w3ocjAA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ak7l3pOkfrAFrVoMx6FKyvL+QQIAb/948WHoJi/DOR42uxZzGP59mE1Bz8kyokSvw
	 fnsyF/85+X75Aak7A4ItUiH58Z8Snq4u7ycPtST7akjZKQqdE1qZJaT4HHwPuXpMDA
	 QQeoOafPSxB/sosNO20i5AQbUQNvqpob5UE5DJvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 403/675] media: cx23885: add ioremap return check and cleanup
Date: Thu, 30 Jul 2026 16:12:13 +0200
Message-ID: <20260730141453.700895832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Wang Jun <1742789905@qq.com>

commit a0701e387b46e2481c05b47f1235b954bfc2af3e upstream.

Add a check for the return value of pci_ioremap_bar()
in cx23885_dev_setup().
If ioremap for BAR0 fails, release the already allocated
PCI memory region,
decrement the device count, and return -ENODEV.

This prevents a potential null pointer dereference and
ensures proper cleanup
on memory mapping failure.

Fixes: d19770e5178a ("V4L/DVB (6150): Add CX23885/CX23887 PCIe bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wang Jun <1742789905@qq.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cx23885-core.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -990,8 +990,12 @@ static int cx23885_dev_setup(struct cx23
 	}
 
 	/* PCIe stuff */
-	dev->lmmio = ioremap(pci_resource_start(dev->pci, 0),
-			     pci_resource_len(dev->pci, 0));
+	dev->lmmio = pci_ioremap_bar(dev->pci, 0);
+	if (!dev->lmmio) {
+		dev_err(&dev->pci->dev, "CORE %s: can't ioremap MMIO memory\n",
+			dev->name);
+		goto err_release_region;
+	}
 
 	dev->bmmio = (u8 __iomem *)dev->lmmio;
 
@@ -1096,6 +1100,12 @@ static int cx23885_dev_setup(struct cx23
 	}
 
 	return 0;
+
+err_release_region:
+	release_mem_region(pci_resource_start(dev->pci, 0),
+			   pci_resource_len(dev->pci, 0));
+	cx23885_devcount--;
+	return -ENODEV;
 }
 
 static void cx23885_dev_unregister(struct cx23885_dev *dev)


