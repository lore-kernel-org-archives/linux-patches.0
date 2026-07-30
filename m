Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6245433438F;
	Thu, 30 Jul 2026 15:41:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426119; cv=none; b=ll4hVPuQM2hrHqMuMkofTqKkqAzyp1QHJ17tkjeM2VUQ/r0Z7eqD7OwNOvpT6+lWWU1dIfyp2ppymFg5Shc6DJ7jZxZJ6LKVhNMTLFKjOS0i7f0cx1iu0REFBSLprXU2jrjhVsIkLndgIb3RqU+vhH9DHRL28WmlpMpYk9A6RIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426119; c=relaxed/simple;
	bh=19in0nUSnM9coU1+HRlrtbrriQTFMSzBFeqgb5ISC3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5JEbjpitihL4wA5L+lkILOUOFewaXlgNC0XCJZI2KeJMvcABKraLwSfi/tC8qeFd20WdjpW3P+uG+gpSYd6w8QCkY/5yEWEzFUiQmGmoCq+SPCjat9sweFeCyJyQR4QXn+ibOUpn+strL6L1tKkfhOOSuIKF2nLmfGpVTsZZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gpWwNR2N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gpWwNR2N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAB111F000E9;
	Thu, 30 Jul 2026 15:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426118;
	bh=RGc42Zmlweu60y0mdZeD+RpEPZ9YO0e5YJ3pQbQ4Ixc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gpWwNR2NSwfkAcyoj5W/j/Y4ITQqM9lUgXmxUq26InvTD4PtMQ0p5/st2hLPJEUOc
	 4EDcTuUUpwHjzcg7f3CR1cJo8Nr4mQ6KvMF0vHCIM8DWa2wR5loSE+yP2RqHZ3gEye
	 y8CFAZrdzjxkUGM2EqmbgkF0LjuCj/ASuNFCp/44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Jun <1742789905@qq.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 307/602] media: cx23885: add ioremap return check and cleanup
Date: Thu, 30 Jul 2026 16:11:39 +0200
Message-ID: <20260730141442.419131684@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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


