Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1963644BE;
	Sat, 12 Sep 2026 07:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198625; cv=none; b=mhDBnsE966BIxGD5o9UxfnSu5NPOBlKjvVciJY4lQdsdq8YETGL0iwJhku2xiOBgTAf7Tg5grC54/Zu0pSoIeOhQcN/TnOFZyR/gwju+EXU6NTj8qRAwJ/qn4DyxfO/iRftVHKy8FNHLdm0g97OGkcwIxpYBYOq6WYknCh4uEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198625; c=relaxed/simple;
	bh=qcidhxG8etaC494AbK6/Fr8hITjlY7P9p1xE9HGxEg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzeoypNv7vy0oW+On+9t8NIZMYNOq1wsyxzE/lGCklpNg+SprYuHhL7gaZ2e9TfIARti5j8ayNm+d6Sc6EryHOnSg8PsbrSxGzn1vMlQ94yNPG9PSbvGSr4/0GFVJSZ3dsjBxqnLlGDRrr9D9v4G9QaNKq7BL0mEZPOLLtrqsVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UapixO3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UapixO3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC5F1F000FF;
	Sat, 12 Sep 2026 07:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198622;
	bh=5Kdkh2AZCXoRgSHqujMlgXvjWdshMVz3rdVAorn+1zU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UapixO3c8Cv0vOcp38sHB6ymwltxS3fF/MxNTZq5nhlkMj+ioMqLQlFmGlE8JJOpi
	 YIeAk+IWAKgPQFCpXXgXVp7UEr44msyHaazbGvxdN5IPRd/P26KC6VZ9EcpJbvgc1G
	 dhb4dnq38hs/q6g0l2oLMXZvF98BaXHfA9DJx3Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <john@groves.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0420/1815] dax/fsdev: use __va(phys) for kaddr in direct_access
Date: Sat, 12 Sep 2026 08:36:10 +0200
Message-ID: <20260912065658.755233227@linuxfoundation.org>
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

From: John Groves <John@Groves.net>

[ Upstream commit ff7c73fca793bd5c29a15ba735b0886f62f3a840 ]

Use __va(phys) instead of virt_addr + linear_offset for the kaddr
return in __fsdev_dax_direct_access(). The previous code added a
device-linear byte offset to virt_addr (which is __va of ranges[0]),
but for multi-range devices with physical gaps between ranges, this
linear arithmetic crosses the gap and produces a wrong kernel virtual
address. Using __va(phys) where phys comes from dax_pgoff_to_phys()
is correct for any range layout because the direct map translates
each physical address independently.

This leaves dev_dax->virt_addr write-only, so remove the field
(suggested by Dave Jiang).

Fixes: 759455848df0b ("dax: Save the kva from memremap")

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: John Groves <john@groves.net>
Link: https://patch.msgid.link/0100019ecc096de8-8bc254a7-d2cc-44b6-82b1-1394fda8bb41-000000@email.amazonses.com
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dax/dax-private.h | 2 --
 drivers/dax/fsdev.c       | 8 ++------
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c1..607a53a91f58b 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -69,7 +69,6 @@ struct dev_dax_range {
  * data while the device is activated in the driver.
  * @region: parent region
  * @dax_dev: core dax functionality
- * @virt_addr: kva from memremap; used by fsdev_dax
  * @cached_size: size of daxdev cached by fsdev_dax
  * @align: alignment of this instance
  * @target_node: effective numa node if dev_dax memory range is onlined
@@ -85,7 +84,6 @@ struct dev_dax_range {
 struct dev_dax {
 	struct dax_region *region;
 	struct dax_device *dax_dev;
-	void *virt_addr;
 	u64 cached_size;
 	unsigned int align;
 	int target_node;
diff --git a/drivers/dax/fsdev.c b/drivers/dax/fsdev.c
index 68a4369562f70..57c589e19b539 100644
--- a/drivers/dax/fsdev.c
+++ b/drivers/dax/fsdev.c
@@ -51,9 +51,7 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	struct dev_dax *dev_dax = dax_get_private(dax_dev);
 	size_t size = nr_pages << PAGE_SHIFT;
 	size_t offset = pgoff << PAGE_SHIFT;
-	void *virt_addr = dev_dax->virt_addr + offset;
 	phys_addr_t phys;
-	unsigned long local_pfn;
 
 	phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
 	if (phys == -1) {
@@ -63,11 +61,10 @@ static long __fsdev_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
 	}
 
 	if (kaddr)
-		*kaddr = virt_addr;
+		*kaddr = __va(phys);
 
-	local_pfn = PHYS_PFN(phys);
 	if (pfn)
-		*pfn = local_pfn;
+		*pfn = PHYS_PFN(phys);
 
 	/*
 	 * Use cached_size which was computed at probe time. The size cannot
@@ -351,7 +348,6 @@ static int fsdev_dax_probe(struct dev_dax *dev_dax)
 		pr_debug("%s: offset detected phys=%llx pgmap_phys=%llx offset=%llx\n",
 		       __func__, phys, pgmap_phys, data_offset);
 	}
-	dev_dax->virt_addr = addr + data_offset;
 
 	inode = dax_inode(dax_dev);
 	cdev = inode->i_cdev;
-- 
2.53.0



