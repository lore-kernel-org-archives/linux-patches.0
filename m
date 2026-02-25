Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBBD1D5ABA;
	Wed, 25 Feb 2026 01:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983183; cv=none; b=auRYp/9LDOz315M9h5KVOdTJeRM/KF2gynhURon6hTjppReX7KfiuD+ZUWRBQYcaLLHk5iy0njxqY2FLTpbceU6bxqRMeyznValo3+AQbQZMSlb4CwoloIw7RsGw2GgDoCvHnewAK2DlH93NdEVlgqcgkXdqUINzPcsA5oUZuw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983183; c=relaxed/simple;
	bh=4Tgz0M5YHOvR+MYmEaZhP3i66pi2ylL9vT8R6kBCNsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dus446i+NqLngk0Yzkcvvn9S4R3dZbWMYT39qhI+VjWVCDfhOFwrpYnTO/NIKeUpH8uapGKdA5gR7bz5CL79prIRPJSATYRH4vbEikId74x16zCGJBMJCsi+gF21pfQ/YKY9bS3EA11xLmWjudrxGc7KcmTJYWpUu+iEP2CFRxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A315IfLS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A315IfLS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9127C116D0;
	Wed, 25 Feb 2026 01:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983182;
	bh=4Tgz0M5YHOvR+MYmEaZhP3i66pi2ylL9vT8R6kBCNsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A315IfLSccuefZ6V5PTEgD1YYM++Y98uxLknsA2W/GNUq3l3ziaJMRMLqPyYJNyrO
	 RCYvfG0CER2dHl26n8QEuqyJs13F8fKuJsr7ratAAPJ3HDtS0VXJieUOjvH6npIvB6
	 9Reb1MCIm8TzhrV1VejtI5K9wWIZ7nB1CDD2ak/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 333/781] PCI/P2PDMA: Reset page reference count when page mapping fails
Date: Tue, 24 Feb 2026 17:17:22 -0800
Message-ID: <20260225012407.867996865@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alistair Popple <apopple@nvidia.com>

[ Upstream commit 83014d82a1100abc89f7712ad67c3e5accaddc43 ]

When mapping a p2pdma page the page reference count is initialised to 1
prior to calling vm_insert_page(). This is to avoid vm_insert_page()
warning if the page refcount is zero. Prior to setting the page count there
is a check to ensure the page is currently free (ie. has a zero reference
count).

However vm_insert_page() can fail. In this case the pages are freed back to
the genalloc pool, but that does not reset the page refcount.  So a future
allocation of the same page will see the elevated page refcount from the
previous set_page_count() call triggering the VM_WARN_ON_ONCE_PAGE checking
that the page is free.

Fix this by resetting the page refcount to zero using set_page_count().
Note that put_page() is not used because that would result in freeing the
page twice due to implicitly calling p2pdma_folio_free().

Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
Signed-off-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Link: https://patch.msgid.link/20260112005440.998543-1-apopple@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index dd64ec830fdd4..79a414fd6623b 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -152,6 +152,13 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
+
+			/*
+			 * Reset the page count. We don't use put_page()
+			 * because we don't want to trigger the
+			 * p2pdma_folio_free() path.
+			 */
+			set_page_count(page, 0);
 			percpu_ref_put(ref);
 			return ret;
 		}
-- 
2.51.0



