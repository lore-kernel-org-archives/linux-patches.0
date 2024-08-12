Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24401186E38;
	Mon, 12 Aug 2024 16:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479706; cv=none; b=hOp2f205FPtGepyG0CB+TDuRwCj2vmC7yjaDN41WIR2g01eCYzaTTbAaMJ61tL5Vakn/IDI33h+sUgzIWBkGL5j6KS7tmU7Ly9ULCFealHFwIZHb8nyTVWUhog543Hl+252CKEUq2On69owKIUDT+MQ7Kx1MBrndGtPL6qMvFrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479706; c=relaxed/simple;
	bh=aZuVy3a8NV4/qqTUSgq+LXBrR/lFbppjb5GHejy7+EY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZT2xBrHQPufPu+NqN5+m6UgF/AZ2HnRpuiqf7LQpVV7crt2EUDelD7WeU/YoAM4vJ2QEpGPsp6/liL0Snr85XY5/4vj3IKcfmExTB2nv8/YxRnh2j7C8c79sCgb2OMfim5SEZsU8zK1NdzQflAuryXsU9lpuML4/OWVbe4cjbhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UnT7mIwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UnT7mIwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF92C4AF0C;
	Mon, 12 Aug 2024 16:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479706;
	bh=aZuVy3a8NV4/qqTUSgq+LXBrR/lFbppjb5GHejy7+EY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnT7mIwI7Gt5ZuUdRcciKya6OI5srXSi3oL7mNezb7sWv/EJEwRQ/pzsmr5k8zQMN
	 Wg9/NSnGTDxVwQQoU9xSFK7JEWefAopXuf8gcUIa6L9sQfa3+dBG4p3XKo0F0DQuz4
	 +jJxg6AklBavlGKGpfVkfZwTNRYYzC2AMtHfs8AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH 6.6 127/189] vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler
Date: Mon, 12 Aug 2024 18:03:03 +0200
Message-ID: <20240812160137.033807951@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 0823dc64586ba5ea13a7d200a5d33e4c5fa45950 upstream.

remap_pfn_page() should not be called in the fault handler as it may
change the vma->flags which may trigger lockdep warning since the vma
write lock is not held. Actually there's no need to modify the
vma->flags as it has been set in the mmap(). So this patch switches to
use vmf_insert_pfn() instead.

Reported-by: Dragos Tatulea <dtatulea@nvidia.com>
Tested-by: Dragos Tatulea <dtatulea@nvidia.com>
Fixes: ddd89d0a059d ("vhost_vdpa: support doorbell mapping via mmap")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
Message-Id: <20240701033159.18133-1-jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/vdpa.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -1378,13 +1378,7 @@ static vm_fault_t vhost_vdpa_fault(struc
 
 	notify = ops->get_vq_notification(vdpa, index);
 
-	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-	if (remap_pfn_range(vma, vmf->address & PAGE_MASK,
-			    PFN_DOWN(notify.addr), PAGE_SIZE,
-			    vma->vm_page_prot))
-		return VM_FAULT_SIGBUS;
-
-	return VM_FAULT_NOPAGE;
+	return vmf_insert_pfn(vma, vmf->address & PAGE_MASK, PFN_DOWN(notify.addr));
 }
 
 static const struct vm_operations_struct vhost_vdpa_vm_ops = {


