Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA3D183CA6;
	Mon, 12 Aug 2024 16:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478996; cv=none; b=NG6vwcPv3pimT7QXUgd+1rpqct9kMiTX6H+fw0b1sLWBGTR942f+OjvETMRr0EnrwqIToMvv3H3t4oLZGObaYwaBa/v6zIdJ4yOka/Zf9L8e2LcdyELfkzPJftzFhVDnYX5ZFWFHVpO3MxrbfZMmu3MlNCe3X4wSnUT7JXpcWgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478996; c=relaxed/simple;
	bh=3Fqc7hRy4IjGtn4KWZmnNi+ec0BxMcjxpXfjT/Lxqh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RsIaW9VBr4JK+04DqlqgUZkxc3f96XeGyjpOLnevvYzynHYgLGmjh0GSbEPBcjrvDKgXDy7O/1GVoHWAuKoXNl2ZAFSDWpL1tyu/8oRatuu9dqdwWYu8wm8hsnxQv2qBCAXIE+Vvb0BMaa+GP51M01I3zDg7En0MQiZx6p0gnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ntBPStma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ntBPStma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953A7C32782;
	Mon, 12 Aug 2024 16:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478996;
	bh=3Fqc7hRy4IjGtn4KWZmnNi+ec0BxMcjxpXfjT/Lxqh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ntBPStmaEIs/zRjTMmO+NAAPtLgVwC3Pgo3DK1tb6nf4830f5NVSZyLLtclwCIm1x
	 ycc+S8CvB50KkmsLmlqU9oo1GiZehqppX3THF/uo5Gv/dpDTSv24ZzU1QWP2ZPULXi
	 UpZlfemj6wJir5isqwvyfkOW2og44WZZ2EmF8cy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH 6.1 101/150] vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler
Date: Mon, 12 Aug 2024 18:03:02 +0200
Message-ID: <20240812160129.058915362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1294,13 +1294,7 @@ static vm_fault_t vhost_vdpa_fault(struc
 
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


