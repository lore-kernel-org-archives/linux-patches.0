Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F3433065C;
	Sat, 12 Sep 2026 14:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221834; cv=none; b=ewyxGP3tNjwwkcpXBGRdwVeOsQ227bLGqFbhJ+DmONYLlSQ9LVHIOgZ7hM6v+yw7AAmbdUtXqssdNfAJ9O2pvxYSgZ7gnaxI+mT/dlbDb4W1tImN68oMxz8Mrc4SltxprJsfvh3PWAUaY00g5RaI90dbffiS2g3PqAis9YdoMB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221834; c=relaxed/simple;
	bh=nJQWMzeZNEcVdBScnOcoGXGYaM5bud5U0P8ssF3jHvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7kffmDVlHVFvzeWR6OovGZW5t1RNgCFlPFIwdl7VKD8E6yNXcREyr1JTXjWEDtMU9eOVX/rJcpd3hLB8wgATPyLH7tq/tw1rDlrB+1QQTh3JrolcEkxXwZ4dP6woxIwcMBGXMZTVOHDT8o9OwZfUXnQlOKVj19j7dyLgmgj1OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TOrJJZkh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TOrJJZkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDDC11F000FF;
	Sat, 12 Sep 2026 14:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221831;
	bh=B3UDycBWdSBDUx9DQPnLVzmqMyCXATc4ya6RRGofZlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TOrJJZkhUQmL3sQtAsveLYSztssd1xJjhI158TSFEMK6fVTwjCD54IS2et/1U1ctP
	 8zsrOYBCivLpi7AVnGn+81clIz04ElR8Hql0eSYgk8D0OHsV0Q+QZalAOGMDz0SYad
	 a/b8QjxRI0l6nsVUfzrPKulrs/IVtqLYM76cdqlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 0463/1424] media: saa7164: fix cleanup on resource allocation failure
Date: Sat, 12 Sep 2026 08:48:15 +0200
Message-ID: <20260912065617.655218176@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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


