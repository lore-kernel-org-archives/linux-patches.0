Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A56579837;
	Wed,  9 Sep 2026 14:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964114; cv=none; b=EOmmH9iVOPxsxyyO7JHjfC5ooTZ7aL1MRoOFFIjPWwVoHRtkQngLStZwoI2ltOnP/bnDPfZGpkaCNFyNzCU+MjTpDl1T4SLfJ0oFSObdrbu5zKLYhNlAkqGn7WLbRnAyFPTj1nNQcXdURdxAtb2shZNIPmjqb6UVNpXP/aNPkGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964114; c=relaxed/simple;
	bh=CxO0Fm1jVf3RQ7oMXX9dDXW/1tZ71DLyKkDCJRTiy28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pt+jug1301zHlfONHRqar9hYzvkeSGWEtlanvZUIcOE5VW+kMIqzJ5aFK0u337yO9bQI08VNWsXVp95Wfh8wB5cuWUVEaWRp0UC6my7z3fd/MLLrBYf3LiRmgCAdPM2eXAjrGss0D/aiR5wx6DcGoKYUHFJVn6FpFyuOvxgfzig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4XQAJHQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4XQAJHQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E4E1F00A3A;
	Wed,  9 Sep 2026 14:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964113;
	bh=RxtuRidUTZ6vWlpv3GaWoe74lzC8v4itYhSGNKpuoD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a4XQAJHQs+mnLz+ow2imKqp7tTzEMJhzVNdlZIwMw5dSVVNnNxqLThDipkK3u8R2I
	 ixMXQgcIrCxWRNPbVXdO/8uSHKGSgfTK7AAkunLWSaUa6kZiz1Z8Ynha64psXORble
	 R2byYheLylN8UGjiqW0t4+wmJF+2xlI+ea81PP5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 309/583] media: saa7164: fix cleanup on resource allocation failure
Date: Wed,  9 Sep 2026 15:39:54 +0200
Message-ID: <20260909134248.717181565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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


