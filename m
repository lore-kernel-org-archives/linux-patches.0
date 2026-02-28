Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDEB34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301770; cv=none; b=jr4H+9/ViRHuShfPUg1RuwQoWjyA/Ybu7aQFLwZL9wp9C5MP09fsc+scOGt+8vUFgSzFJlBPWxZpyfLzfNBrnLA+lIzrveTXYDWVggflleSC+2C2s2SLsmU0ad/Jqd3wHZdfuekAHjRCYcfPBrlmkm7St5yIyAtNpNv0q/4cN8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301770; c=relaxed/simple;
	bh=dA9RqxmqyJs2gc1SKW2oGI4cByhxr1HEDdA5Y2MVUXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaaVguIMiEq2FWUaQmQTxOq4x4PJenCtmNzt0hiIc6GLVrAV1icmEKIEl9WxL91jL39KkWdq3dQPxznEaSNBoLcEYZrdiuCSWLxsPz6dqspITWfSVeBze6svwaynjJZEi9lqlRsZTJjJ7ECNp+dQ6u6JHWvaVbw1RI2VNHjNp4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTTFFjVQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTTFFjVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56C35C19423;
	Sat, 28 Feb 2026 18:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301770;
	bh=dA9RqxmqyJs2gc1SKW2oGI4cByhxr1HEDdA5Y2MVUXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PTTFFjVQr7aifAD9RjxFFAZRcYIsgKU8A0x24fSXgoGiFH+Luygmt8MBGdVQg6K9X
	 HlvS7hmIrtAK0xZHXhvIiSDKrFwvmVv/nvawUkNmFZ4rnBakCSjLoy1tg49yS32LEB
	 CQGnZWWX4Xrbyidt/Dswk2HBDDulHnjn2cjRk3R9DIlf7tvsXFQhMK31fSDph8q3AV
	 ihe3OhWd2dc1M6NoHiSb7scGaft47pI7NXrVRLk5GqRoZCoHmY/6rlGiCEoZfTAaX3
	 dmbRjOwOePyylX2pbapupO4SYUk/rF0+ZSaTY814TOlzLmT8Bjqfa61ZhKG4NcII12
	 YNO1MRqWuCLFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/385] PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails
Date: Sat, 28 Feb 2026 12:56:39 -0500
Message-ID: <20260228180011.1568201-177-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 52e1564eadd0b..ec53b2b0d57fe 100644
--- a/drivers/pci/p2pdma.c
+++ b/drivers/pci/p2pdma.c
@@ -143,6 +143,7 @@ static int p2pmem_alloc_mmap(struct file *filp, struct kobject *kobj,
 		ret = vm_insert_page(vma, vaddr, virt_to_page(kaddr));
 		if (ret) {
 			gen_pool_free(p2pdma->pool, (uintptr_t)kaddr, len);
+			percpu_ref_put(ref);
 			return ret;
 		}
 		percpu_ref_get(ref);
-- 
2.51.0

