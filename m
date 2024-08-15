Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E798519E7F6;
	Thu, 15 Aug 2024 14:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730503; cv=none; b=VkwHWcyp+ux+Omexo+ihAFpkllORziaUvhj3kAtxFyYHCxqg27Uqqz+rThN40Wm7GrXA4eqRNC3BQ9xL40FiuZSdF/KzauBLmGu3M9H3A1UOjN2nF9+voIy06GEN9z2q/v7RtrWdLsu2kZhByxPCfWY4HwnCeVqhxNS3J2QDo9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730503; c=relaxed/simple;
	bh=HXyuVhTnkZzdxySFoctGQeEZm1GaskpMf11ubx2p5Bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NvPmregZhqLS7Of8QsBTfvn+qdiyHxCe6weXcE+HDGsSB3GXV6sOuQayAGOmuENsjLwkVF0YdGorDvpKcj44qRuthOczHYnefOy/nGbX6hBMM1XyK0DUojxIxJB9tMgpcVuue4I9SSFTRVHQ4yg6LAZoaopC1jlvLTYjVpWnLH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QLcIjxJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QLcIjxJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C2EC32786;
	Thu, 15 Aug 2024 14:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730502;
	bh=HXyuVhTnkZzdxySFoctGQeEZm1GaskpMf11ubx2p5Bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QLcIjxJO1mU8jzD3k0jrweGL0Udzy0ba8se/5mS5uVZN4AstfMXUshNCsgZSdYKR/
	 JpYi72xaE3kpJLBPSOR2MSRBa9S95Fv8iMwXS/19QJ6WdTY/q2+YkhGDmyPzevzb0e
	 ExpQfjCXegslk2+j60vMwwpMKXOaEpYjBO9n2G9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>
Subject: [PATCH 5.15 427/484] vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler
Date: Thu, 15 Aug 2024 15:24:45 +0200
Message-ID: <20240815131957.949725598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1059,13 +1059,7 @@ static vm_fault_t vhost_vdpa_fault(struc
 
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


