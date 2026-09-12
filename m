Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC7412269;
	Sat, 12 Sep 2026 11:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213866; cv=none; b=r0t5vhar2Vr9clFZLoZz0g5atX2Lf/L2WWF52iwxqH3mvXKz5Jx+t4WZcV48FcAS1M/TCu0074ACHQxdPWqX3Y9B0ieyr+ggk+Tij22oEbpbjG+dF0YQzeko3FjSjes62ovKn/FwJ/XZhbRxh+HjHazJ0efLmvc3fSsmE20OgQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213866; c=relaxed/simple;
	bh=2l6SEZbzShNJKIpc/EA7lHbuA61zbGlzQdbX6ukW62s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD+u5PxJZftFOx/kH2EEPfqcIcFwuKzIS07vLygnlMjJPxBLf0ulnBktf9Fn5Y4zOhYM6UOT3IqNOcIQ5fAGQO1xnP+Sm5UgyH5NGUJcZx0HQaQlgnthpyZLcNVzoXAqQPHAwNG5c/FJw5PCnJ19d+aRfAweNEYprqYK+mKEbEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsaxYu1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsaxYu1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87A41F000FF;
	Sat, 12 Sep 2026 11:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213865;
	bh=eVp6xj+htt6QUyBZ12p9NPi/n3zwNhNCmNSPO7CwnPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BsaxYu1gqku4cpvf4Sh7sgIxUYdSgVsCdcqrlBsZb/EU5hUt+rsArXunDMZ9ZqWDU
	 sEDNx/P7/9H6PSCfBGmLlXMpsFITOW/e14hj2eX3tcxMaS2tRcsVdoO1/fyyBg/aRT
	 2DGy1sG3aZWoniDOmupXFpQTeb/ElQXAfrYCvlhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 0209/1376] media: saa7164: fix cleanup on resource allocation failure
Date: Sat, 12 Sep 2026 08:43:55 +0200
Message-ID: <20260912065612.207262774@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

commit 28e84c6e2e6753ed238ea097b2842a32a6a6879b upstream.

saa7164_dev_setup() adds the device to the global saa7164_devlist before
requesting the PCI BAR memory regions.

If get_resources() fails, saa7164_dev_setup() decrements the device count
and returns an error, but leaves the device on saa7164_devlist. The probe
error path then frees the device, leaving a dangling entry on the global
list.

Reuse the existing MMIO mapping error path to remove the device from
saa7164_devlist and decrement the device count before returning.

Also release BAR0 if it was successfully requested but the BAR2 request
fails.

Fixes: 443c1228d505 ("V4L/DVB (12923): SAA7164: Add support for the NXP SAA7164 silicon")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/saa7164/saa7164-core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -878,6 +878,9 @@ static int get_resources(struct saa7164_
 		if (request_mem_region(pci_resource_start(dev->pci, 2),
 			pci_resource_len(dev->pci, 2), dev->name))
 			return 0;
+
+		release_mem_region(pci_resource_start(dev->pci, 0),
+				   pci_resource_len(dev->pci, 0));
 	}
 
 	printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx or 0x%llx\n",
@@ -1000,8 +1003,7 @@ static int saa7164_dev_setup(struct saa7
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
-		saa7164_devcount--;
-		return -ENODEV;
+		goto err_devlist;
 	}
 
 	/* PCI/e allocations */
@@ -1039,7 +1041,7 @@ err_ioremap_bar2:
 	iounmap(dev->lmmio);
 err_ioremap_bar0:
 	release_resources(dev);
-
+err_devlist:
 	scoped_guard(mutex, &devlist) {
 		list_del(&dev->devlist);
 	}


