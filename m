Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714B843DA4B;
	Thu, 30 Jul 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422568; cv=none; b=inl2t6IbD49PO5isrzNMwlVjdsWn4gbtt729I8IX4rsXI0SklWB6vU8uLV8oenycsswoM2kUY1WYAOw5D+g68qBlLuzmk7B1AAnDbfpfn75R70dChlDUdrM4hHH5H0Qf2dWjSwnVypfuZNcMZQYGHIJLQcLVH4zgZk2oYuPERbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422568; c=relaxed/simple;
	bh=nTo9Ca8EwTfomcJ3FJEPOpAYsmGtS36X5lf+47+Fwvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ5D50GDc+OSczWKGnjawVtzlfDdaKriOS0HKs4Hb8AlsMQVdHmOG2qE2f+GFsxPne4sqh7eyN37u9ErClhymWvk0FiCLYCdAnVvRmmCNZ9M0o0NW/CdR5ckoGYVqHQZZl1AkHs1QqB5ErL/gxYK9z9bIBLAtT/sJ/BU20c52FQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DKrgD0Nh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DKrgD0Nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C27231F000E9;
	Thu, 30 Jul 2026 14:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422567;
	bh=geM7HRJfNUxKZ6NjARRTB+1JCwFWx4C2xXq8bF1m8Fc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DKrgD0NhAEmXEsSXkMPBjLRDssCrquRAi1kviKEPmkKw+8Cci3alNZoglYtHRzK3j
	 4ferRyRllXFgT5F9+4isVw/Dd+yQX/LFNARZbKrs3VBNkL3kqMATHydsigJVeHsS1I
	 HZxmAgF9HAyxb80FoCD/I2lbLv9elUCyXJ6Z3res=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.1 483/744] media: cx23885: add ioremap return check and cleanup
Date: Thu, 30 Jul 2026 16:12:36 +0200
Message-ID: <20260730141454.562373066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1002,8 +1002,12 @@ static int cx23885_dev_setup(struct cx23
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
 
@@ -1109,6 +1113,12 @@ static int cx23885_dev_setup(struct cx23
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


