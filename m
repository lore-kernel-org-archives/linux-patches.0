Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3705D1E2834;
	Wed, 25 Feb 2026 01:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984030; cv=none; b=HnQ53u+12HCqqmgvGthqEmWR7GrSBBm0FVPDDHFThrG8GpWi3f7tmh/nB6FK0Xqkqrz3KiwTVysz168GKamvAOaY4/xkYHwy+Eibij1jkPVrDD3FoFLbG3CEivQ420Cp4DzPN948dzSS8JAN0UYcw8NhUSdILvtIlKgRG+mcKgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984030; c=relaxed/simple;
	bh=E6x6+osREuYqVyf701JH1DmhdZZ7qIgc4wPgLBnML1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFFgfnOXHtLT2hoJdDdjHT/wKC9GLgSOsCFYN1w70XnhIhP0NUshyOEDP9aJ6NKGjQxtyRhDBDRXyutZGcrFsjipc7cD823IBac1VveVb4Aw3vrIXeDU1WV17DOGZFjoqaAcClyMSKmmDohPZv3oLSqI6k2Kq6oNVpOUpE4nSR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCln1Vfs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCln1Vfs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E916DC116D0;
	Wed, 25 Feb 2026 01:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984030;
	bh=E6x6+osREuYqVyf701JH1DmhdZZ7qIgc4wPgLBnML1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCln1VfsYZT2ZnI/7jSlOTn/EJwtk+XxFI8f/abhxElz2fv1VlK1oXzyQdC5NFAu9
	 Y+K3CSRgNz0RnxecRXdgF7Bak70871oKml0U6OwU7TEDNv6M/N1nhBmMSAKJ9/J6jK
	 fs2qBzkfOX+nuOlzgeeWXdEGR40aEk0o6/StNlWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/641] PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails
Date: Tue, 24 Feb 2026 17:19:25 -0800
Message-ID: <20260225012354.669655984@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Hou Tao <houtao1@huawei.com>

[ Upstream commit 6220694c52a5a04102b48109e4f24e958b559bd3 ]

When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
doesn't invoke percpu_ref_put() to free the per-CPU ref of pgmap acquired
after gen_pool_alloc_owner(), and memunmap_pages() will hang forever when
trying to remove the PCI device.

Fix it by adding the missed percpu_ref_put().

Fixes: 7e9c7ef83d78 ("PCI/P2PDMA: Allow userspace VMA allocations through sysfs")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Link: https://patch.msgid.link/20251220040446.274991-2-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 78e108e47254a..5497ce0be7c5c 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -152,6 +152,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
+			percpu_ref_put(ref);
 			return ret;
 		}
 		percpu_ref_get(ref);
-- 
2.51.0



