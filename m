Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB67346E6C
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302115; cv=none; b=gmTRspdxp+G56VnsTLpD2wYQybl5YR3PW4QkRq8rO+8tWBn0SWKn74svu7SMSNCLh31mUl5DEAYU72ypAdLuPO9D62DONH4rI7stnfXEmj2C2uHDjcR3kZuqMvEKjTpCYJvW2Vci5MVIAr5XdxJyXh/IgJDq9/gTZjQIhGIWfOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302115; c=relaxed/simple;
	bh=52ultd3Dq9klQuUydyd/vPvGLUfgEvdiFHtD/3pyqf0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c8DHMdtus3t/W/ZXeUt7afZY5JAExs1VtYYdZZgdj3sNXG1i385+bj1Omi2qMVz2tSwN7Sdkda25B62FNbvXhRYSeJx6yDRXGxP0mzQ+Q/cbFcLQXocyX2gULfiE9kgpSaZ8bPi4DXSVJ4XyU5b4KWPY3nRUDhkO8MM8SGfb+iY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WIHtCEFo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WIHtCEFo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C268C2BC87;
	Sat, 28 Feb 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302115;
	bh=52ultd3Dq9klQuUydyd/vPvGLUfgEvdiFHtD/3pyqf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WIHtCEFoh9b/3zP3DRnJqY9a0oZ1Y09ZFlhdqCLtW2J5zGsr9O81xCpeOp7Xp9Sp4
	 cR6jM6uAiYmzfcn6JTyxrSJ+3EAERJ2NPPsPFr36gBAOiLRYhJrbfPmzY0Tx7DUAJY
	 8Lua1QfrLwks0B4D6/94nIWOK4JjtteR+muFH3qV3lK4bZpb1XtomWA6OtO3KLpYnt
	 CNwV/F1Jay0Un5QwkV3mV7W/8aYCOLMd60noW/EiwhmYe5RybD1B2mnRHtLECaxg6Y
	 4e6jfUhUdXuhNdPDObe+HFrrQc9cUu2mdMtYFqvgaTNLW2RGyOWx54XEh8KW+gT0ov
	 U32hbnygi9Dhg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/283] PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails
Date: Sat, 28 Feb 2026 13:04:06 -0500
Message-ID: <20260228180709.1583486-104-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 0f1e431bbfc20..f97ac18a8dc8f 100644
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

