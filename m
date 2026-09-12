Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD31431F9B4;
	Sat, 12 Sep 2026 15:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228614; cv=none; b=DSPx6ZVGCsJdf7FRAuCiGx1HAIsEeVrsjQkzYiL8wSgJKtgshQ/34bHnY8/qZpNslne/xh5QoRTk17nFa7fjlZz1xTPsgg1l2xwOKKeV0/Ot4+iNhjoOZ2Yi2/tR8Jja04oUmTSxDn5CEIKkAEkPmX387SQY3IW30qzwTPPfV4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228614; c=relaxed/simple;
	bh=q14qO8V5iEU75UKTMzl9v1tOwTsuhAT4wUDOiiFSk50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsLpxjDnexJ7iN2gNhuio0jBN8HktZD4O+ogiRL9D9Gfi0xV0TbDlinUYOWK/IMkhYB9z6vsbsr2Q3SPPzvnx1rU9mgOh+9bMmlAu4GxG/03AxaYt0MIFm1sFFyQZs9DS8UM8EXtgXfasUVYPEUvbetfJde/MDTO423gnmnWeSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=baZURT1w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="baZURT1w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54EBF1F000FF;
	Sat, 12 Sep 2026 15:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228613;
	bh=OjhewEMFqS4WlP/QVqgJ1T+Dl+OGNONnlqpWzo6EtTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=baZURT1woZ4TRXd33QRJDc9LzddBFFFlR8nUbJzVtExdE2go0hivboawP6Lh432sv
	 ZwgefSl5DiTS0rxQozenWVoTOLVDpD/+JHcFZZmAKxSOHyYeUgGYTV78y2aqDvyMaj
	 ghqUgUyUUk1snQNT3DWAsrgIl6hyYPcmTxG2aKcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0379/1191] media: saa7164: fix cleanup on resource allocation failure
Date: Sat, 12 Sep 2026 08:51:47 +0200
Message-ID: <20260912065556.748037532@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -880,6 +880,9 @@ static int get_resources(struct saa7164_
 		if (request_mem_region(pci_resource_start(dev->pci, 2),
 			pci_resource_len(dev->pci, 2), dev->name))
 			return 0;
+
+		release_mem_region(pci_resource_start(dev->pci, 0),
+				   pci_resource_len(dev->pci, 0));
 	}
 
 	printk(KERN_ERR "%s: can't get MMIO memory @ 0x%llx or 0x%llx\n",
@@ -1002,8 +1005,7 @@ static int saa7164_dev_setup(struct saa7
 		       dev->name, dev->pci->subsystem_vendor,
 		       dev->pci->subsystem_device);
 
-		saa7164_devcount--;
-		return -ENODEV;
+		goto err_devlist;
 	}
 
 	/* PCI/e allocations */
@@ -1041,7 +1043,7 @@ err_ioremap_bar2:
 	iounmap(dev->lmmio);
 err_ioremap_bar0:
 	release_resources(dev);
-
+err_devlist:
 	scoped_guard(mutex, &devlist) {
 		list_del(&dev->devlist);
 	}


