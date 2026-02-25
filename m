Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7121E2834;
	Wed, 25 Feb 2026 01:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983173; cv=none; b=PweLd7Yq7IJnYe+sdGGPlzHcC9mnCfpfX/U4s9J8O5WeiqTRXEsuiByZxbdQkAdI1IZrzWKFWrS4KirGHNJ1oT6UGjKqdR0Kf12Z+Rh+yIyM+WJTJdCadAqczOpQH4hWVFI6gt5Qlq0296iSoNFoI23XOJICnFYAUS2QIIKNk/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983173; c=relaxed/simple;
	bh=1DxQ7irKyMCX6tEJ2Ktr56LscaLPYRNLryp7gJPfedw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i1U0amKwwGsW5XbRValCWxkLvCcE6WueyA6jpa2NF7hTXp3CjT5/FzEiFQhN0RJp0s5rZgDqIR+gG0al4phME8G1OB/Dw70N+n6ppvCv33TfxulpqoHhqdzharSY3Bi1nKDh5vKz9Yr6zW7+c15e5qUFsejYGLP+2gUDU8a+XdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lTkRMQhf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lTkRMQhf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C75C116D0;
	Wed, 25 Feb 2026 01:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983173;
	bh=1DxQ7irKyMCX6tEJ2Ktr56LscaLPYRNLryp7gJPfedw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lTkRMQhfK9komie+k6GtYytNDRjJ5mh168lwUHxeSW1fS++frfF7kBFmmQVxdA7/t
	 5aC6ZnPJcny6xHih8K8dSIbZDX4E2GyjtHbsOlVfINRJlfiSQCw3Y1rakix6cMdMjD
	 HzdSIRbj4kzTQLDg6G107Q6rjMik+Bgt74Mna6nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 325/781] PCI/P2PDMA: Fix p2pmem_alloc_mmap() warning condition
Date: Tue, 24 Feb 2026 17:17:14 -0800
Message-ID: <20260225012407.678293215@linuxfoundation.org>
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
index 218c1f5252b66..dd64ec830fdd4 100644
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



