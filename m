Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211331FE45D;
	Wed, 25 Feb 2026 01:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983994; cv=none; b=BF4pR9YNKBExwu/WyPRmGyTQ25GxWCL5fksYzr8exRDzWTmOWHWFa8iA5PEAEdBt+wrAVI2e8GkWSsIbZ/ck1sDszcvhmKRtcUi5vVWDNCg4N/bpj/1/PLPJ5y9IEaf89VMDWp8bD/9nNgk3UoF8XybgN0LpXlz7H/oBq4aI7+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983994; c=relaxed/simple;
	bh=FrSdb+lW6M4NEvHh3D6vj9zhthtQQiBKoSMy5kffpC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qU7eSvu/B+7Q99Fb+X6yd/v8wq7oEJmO/v4z5dCspywNJGrOwQ3unZc/b8ZpXoV8sORypcwyxAlLETg2x1aHulvCG6yEP7F/lk/Mbntp59fOqx7nE73lXNLZlBcImXs6OomrNvO5uh3pNwTSPY8ZltXUGilnOM38e3nKbgKreSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUOLuHbM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUOLuHbM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0EEC116D0;
	Wed, 25 Feb 2026 01:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983994;
	bh=FrSdb+lW6M4NEvHh3D6vj9zhthtQQiBKoSMy5kffpC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUOLuHbMsZZLkwq4Un/DxFXvmZdFRw23BKIrQ0Fqg9yJiSO3YfvG6Hzb1YtpQiMqP
	 XcVq3EGhQus2fbeS9nfD80jErvsidvB2PyE60sPaBFg0lR4o4dWNgW11zrRS93hLxW
	 ZqkKzg03V5Qqt75aENyLU9lyMPfsbduOP49Wp7vE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alistair Popple <apopple@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/641] PCI/P2PDMA: Reset page reference count when page mapping fails
Date: Tue, 24 Feb 2026 17:19:34 -0800
Message-ID: <20260225012354.864455538@linuxfoundation.org>
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
index 12c69bb2b2326..49e395eb013d3 100644
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



