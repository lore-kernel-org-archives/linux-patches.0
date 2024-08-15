Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EACF63D5;
	Thu, 15 Aug 2024 14:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732999; cv=none; b=bBEun0XtCnYEo1okaK7UZ84G8WWzyNJk/lHbSl7U8VMOOw0BktxyJWqwjK+AHZa/szkQzsmMglkrlkjhcOxX+Ky9neNapAH80kDdD+A8Wd0xRYUCqrWF3IaLtxoaBvv5DqW2iTjqJZNsuAOahplKAivOdG22v0OcDY4EST7gxdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732999; c=relaxed/simple;
	bh=JLwakQpsa70ZRlBZgWuK2iG59JsqEDVpXXiUnHoixLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu9MG92/J2xSNSaCktvyPLGcxt8cm4PjiFMW1S3igee4BTBQD22rbHUylEbcb7H/AdjSd8GBwgeAdAO0EW9zrjHu1CaGAKukewP1UV2lv7eOGhJ8en75GxV992FvXPZ1UkuGDbj1Tu7qsL3/JK7nN/3xlWthpVNM5vW00f7B/fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NErK3UNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NErK3UNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C03AC32786;
	Thu, 15 Aug 2024 14:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732998;
	bh=JLwakQpsa70ZRlBZgWuK2iG59JsqEDVpXXiUnHoixLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NErK3UNXqZY3CP/a+nufRzf+QCJntxlAszy3Y9alzCzephMFekKXhHZFGaH2fCuwr
	 3GdsIVWr5zClr0gogrKtdP/8xBbniQBEfPunW7lR71hdN3HInQrHXSm3I6Jdt7QAW+
	 jFM28CDfdh8Y5pnsfoTKXH2vfsIvFwfwNzUDaU2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cai Huoqing <caihuoqing@baidu.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/352] vdpa: Make use of PFN_PHYS/PFN_UP/PFN_DOWN helper macro
Date: Thu, 15 Aug 2024 15:26:55 +0200
Message-ID: <20240815131932.959536675@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cai Huoqing <caihuoqing@baidu.com>

[ Upstream commit 729ce5a5bd6fda5eb2322a39db2287f1f26f92f3 ]

it's a nice refactor to make use of
PFN_PHYS/PFN_UP/PFN_DOWN helper macro

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
Link: https://lore.kernel.org/r/20210802013717.851-1-caihuoqing@baidu.com
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Stable-dep-of: 0823dc64586b ("vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 04578aa87e4da..f48047a1027a2 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -519,15 +519,15 @@ static void vhost_vdpa_iotlb_unmap(struct vhost_vdpa *v, u64 start, u64 last)
 	unsigned long pfn, pinned;
 
 	while ((map = vhost_iotlb_itree_first(iotlb, start, last)) != NULL) {
-		pinned = map->size >> PAGE_SHIFT;
-		for (pfn = map->addr >> PAGE_SHIFT;
+		pinned = PFN_DOWN(map->size);
+		for (pfn = PFN_DOWN(map->addr);
 		     pinned > 0; pfn++, pinned--) {
 			page = pfn_to_page(pfn);
 			if (map->perm & VHOST_ACCESS_WO)
 				set_page_dirty_lock(page);
 			unpin_user_page(page);
 		}
-		atomic64_sub(map->size >> PAGE_SHIFT, &dev->mm->pinned_vm);
+		atomic64_sub(PFN_DOWN(map->size), &dev->mm->pinned_vm);
 		vhost_iotlb_map_free(iotlb, map);
 	}
 }
@@ -589,7 +589,7 @@ static int vhost_vdpa_map(struct vhost_vdpa *v,
 	if (r)
 		vhost_iotlb_del_range(dev->iotlb, iova, iova + size - 1);
 	else
-		atomic64_add(size >> PAGE_SHIFT, &dev->mm->pinned_vm);
+		atomic64_add(PFN_DOWN(size), &dev->mm->pinned_vm);
 
 	return r;
 }
@@ -643,7 +643,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 	if (msg->perm & VHOST_ACCESS_WO)
 		gup_flags |= FOLL_WRITE;
 
-	npages = PAGE_ALIGN(msg->size + (iova & ~PAGE_MASK)) >> PAGE_SHIFT;
+	npages = PFN_UP(msg->size + (iova & ~PAGE_MASK));
 	if (!npages) {
 		ret = -EINVAL;
 		goto free;
@@ -651,7 +651,7 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 	mmap_read_lock(dev->mm);
 
-	lock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
+	lock_limit = PFN_DOWN(rlimit(RLIMIT_MEMLOCK));
 	if (npages + atomic64_read(&dev->mm->pinned_vm) > lock_limit) {
 		ret = -ENOMEM;
 		goto unlock;
@@ -685,9 +685,9 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 
 			if (last_pfn && (this_pfn != last_pfn + 1)) {
 				/* Pin a contiguous chunk of memory */
-				csize = (last_pfn - map_pfn + 1) << PAGE_SHIFT;
+				csize = PFN_PHYS(last_pfn - map_pfn + 1);
 				ret = vhost_vdpa_map(v, iova, csize,
-						     map_pfn << PAGE_SHIFT,
+						     PFN_PHYS(map_pfn),
 						     msg->perm);
 				if (ret) {
 					/*
@@ -711,13 +711,13 @@ static int vhost_vdpa_process_iotlb_update(struct vhost_vdpa *v,
 			last_pfn = this_pfn;
 		}
 
-		cur_base += pinned << PAGE_SHIFT;
+		cur_base += PFN_PHYS(pinned);
 		npages -= pinned;
 	}
 
 	/* Pin the rest chunk */
-	ret = vhost_vdpa_map(v, iova, (last_pfn - map_pfn + 1) << PAGE_SHIFT,
-			     map_pfn << PAGE_SHIFT, msg->perm);
+	ret = vhost_vdpa_map(v, iova, PFN_PHYS(last_pfn - map_pfn + 1),
+			     PFN_PHYS(map_pfn), msg->perm);
 out:
 	if (ret) {
 		if (nchunks) {
@@ -961,7 +961,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
 
 	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
 	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
-			    notify.addr >> PAGE_SHIFT, PAGE_SIZE,
+			    PFN_DOWN(notify.addr), PAGE_SIZE,
 			    vma->vm_page_prot))
 		return VM_FAULT_SIGBUS;
 
-- 
2.43.0



