Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32F4A26FA60;
	Wed, 25 Feb 2026 01:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771984039; cv=none; b=W2/nu1gZoqJbINLo5OJ8OCACgx21canVOpAZ5U0ElHEeObvWC3YG+rsA9NeRYJV6Ekeno044EBHG/AQhva+YAHR3MZuSxopQ4g2PdjQKF9w2PclZLUJDAi1Yy5bG7ewP5u0jhthG8WnUDLduuI00m6mGx0C5+IWX5nUgCw+w5Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771984039; c=relaxed/simple;
	bh=OQ8KfNjiw+qcAtG8lj/ZnoLx+Di9bwW1B3Xd6kjV/Tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODpATw8bYgBctLiMNaUr1KosCiksxzNKz45JR4H+fl+TF6wd6BSPTE71K2KZ+tNWsbDc8rF0J2+uK6Ufo73LwSyIVtRW6F/iH9s+F+3XTuAeaTmYu2Crh6g+5TL4svbEIpBgbTKJpKMr4nsF2kOK14Z0G1FPAElcQzthFa67MTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt0OG5fY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt0OG5fY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EEDC116D0;
	Wed, 25 Feb 2026 01:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771984039;
	bh=OQ8KfNjiw+qcAtG8lj/ZnoLx+Di9bwW1B3Xd6kjV/Tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rt0OG5fYgIt8lgVBMokqq+nZw2kSPKVmqc9xuBIxM7BEraoy39VrG+mfKcRmL3OV6
	 j7ikOipsiFgt7lqkXuPYz/azoa4+YLBIXoaZ714kfJA0xV5bOuxEIqIc2qsQ31/O8A
	 KPxt2eXCNGZjQGWfa9Z+IoUkVM41iH/OeQI8Q6GU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 240/641] PCI/P2PDMA: Fix p2pmem_alloc_mmap() warning condition
Date: Tue, 24 Feb 2026 17:19:26 -0800
Message-ID: <20260225012354.690759101@linuxfoundation.org>
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

[ Upstream commit cb500023a75246f60b79af9f7321d6e75330c5b5 ]

Commit b7e282378773 has already changed the initial page refcount of
p2pdma page from one to zero, however, in p2pmem_alloc_mmap() it uses
"VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))" to assert the initial page
refcount should not be zero and the following will be reported when
CONFIG_DEBUG_VM is enabled:

  page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x380400000
  flags: 0x20000000002000(reserved|node=0|zone=4)
  raw: 0020000000002000 ff1100015e3ab440 0000000000000000 0000000000000000
  raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
  page dumped because: VM_WARN_ON_ONCE_PAGE(!page_ref_count(page))
  ------------[ cut here ]------------
  WARNING: CPU: 5 PID: 449 at drivers/pci/p2pdma.c:240 p2pmem_alloc_mmap+0x83a/0xa60

Fix by using "page_ref_count(page)" as the assertion condition.

Fixes: b7e282378773 ("mm/mm_init: move p2pdma page refcount initialisation to p2pdma")
Signed-off-by: Hou Tao <houtao1@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Link: https://patch.msgid.link/20251220040446.274991-3-houtao@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/p2pdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/p2pdma.c b/drivers/pci/p2pdma.c
index 5497ce0be7c5c..12c69bb2b2326 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -147,7 +147,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		 * we have just allocated the page no one else should be
 		 * using it.
 		 */
-		VM_WARN_ON_ONCE_PAGE(!page_ref_count(page), page);
+		VM_WARN_ON_ONCE_PAGE(page_ref_count(page), page);
 		set_page_count(page, 1);
 		ret = vm_insert_page(vma, vaddr, page);
 		if (ret) {
-- 
2.51.0



