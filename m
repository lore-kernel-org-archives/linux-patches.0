Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AE7395ADB;
	Thu, 30 Jul 2026 16:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427636; cv=none; b=HQjrBkuTa0ClP4xGnwqt3In7suFRr8OQ4YWpYxl3XxsKskr5c3yngtgZw5vy206mys4DMg/xHb1vg0nH2busZWvJSuHOiMs0rj4Qqt8ErBaYfpQi3oIIE2m6v+ld/+Fj0zOCACSF1PaTO4slrwkccakOyFyi2qK+2YswsjVHH1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427636; c=relaxed/simple;
	bh=ts9m1MbDb8cRhajDC0ikRAzDy0KsB367OR0V6Pg8RpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqNY2PT7iYCYX9r7XfBxHVR2kuuAgcltDcNUrNmhaoK1nflsaIB5UIPCSfBtfra3np4Bp7rNZKZI2JUPHiiVMe3DgTpxSxAtt2D2brMFQwVOP4vWvj16DZ/7BadP8Bp0fUMTAFU0Z3nQOFCIznVYhku+jqg9p0faVeEGlI0OU/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AHdnM2nn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AHdnM2nn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373CC1F000E9;
	Thu, 30 Jul 2026 16:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427635;
	bh=NdxqgFZUUaD+0kw9ZBzaiW81Fu333sat/EVEW90YMfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AHdnM2nnwUci4xF9QkesQR1MvqIiqorpQe3qE7orsh5E4SrDfPPe73gFoR0km5Xg7
	 UF6iz+IS/Pcc9Ple6MZwgtbDAVWaCAgoQrW/x7AcFJmA2/FnK1TTXpZK6yaQOR0dVY
	 QDZip4kPYG6//FLvaMz6IAVyr94ccmzrlt7vi/h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 241/484] media: cx23885: add ioremap return check and cleanup
Date: Thu, 30 Jul 2026 16:12:18 +0200
Message-ID: <20260730141428.715833416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


