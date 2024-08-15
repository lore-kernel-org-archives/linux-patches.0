Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3226D1A4F16;
	Thu, 15 Aug 2024 14:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733031; cv=none; b=iOVj2jneSqbAIUR5rr6hejqkluQNOmEdv+y2iigvnq5OyO47H5q9asU34Sj+c11Bq52MIaTSF2QiJC3/8EMqe7ItAUvcenxUZEIrsYlobVD+BAK5PWTS/k6UzQGxIlLONsTlhdnTHqw6OrGaA5ivBT3FIl5DWrtL8g8Hd2BnoMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733031; c=relaxed/simple;
	bh=k4Hmoj9Dr50Er92X5HHf5V9pTcKF5UDTZMLLlsawNGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHFngmEFtSiTBgQqarmfctb4uaqxiqkvgohjdlgECegKx/L8ZtFrQuakDx41kMZkv70N7+geKTMvFqXa1iN+/EpwIcGUIzr+Hse3ENoYoqKO+LQhszJe89Dr/8eYShk84AlDM8X+34cxPptEUAupyeQKbXwPCcwzNX1yIwb89Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8ZN9Tih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8ZN9Tih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9305AC32786;
	Thu, 15 Aug 2024 14:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723733031;
	bh=k4Hmoj9Dr50Er92X5HHf5V9pTcKF5UDTZMLLlsawNGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8ZN9TihTPKO6uxorh0+QWC1MEACPibGtaoudH2o+hAePuohs2XCva2zK2ZTraAL1
	 XDcgiACxHE/Rbx8uMar1cD4on3YIgyM8ylPVJq3vQPm+eackqjIbHOWp/j0BND4W+o
	 Lw6ttq1r8IM3PvS68VqZM+rYqDkmEK60mEdnryDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/352] vhost-vdpa: switch to use vmf_insert_pfn() in the fault handler
Date: Thu, 15 Aug 2024 15:26:56 +0200
Message-ID: <20240815131932.997766985@linuxfoundation.org>
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

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 0823dc64586ba5ea13a7d200a5d33e4c5fa45950 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vdpa.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index f48047a1027a2..c9f585db1553c 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -959,13 +959,7 @@ static vm_fault_t vhost_vdpa_fault(struct vm_fault *vmf)
 
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
-- 
2.43.0



