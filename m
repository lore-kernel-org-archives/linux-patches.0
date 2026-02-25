Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 319B3242D9B;
	Wed, 25 Feb 2026 01:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983172; cv=none; b=Q0iqDpgucQ/Jd1OVQr6cZH/L16j3g0veA0MwcwAxBE/RlW51j0mUA9miiF1u61xRIZd62z4x0QTAKVItgpeUIistPvZWAL9uwCM4h3f4UTSnL5aNluUxSvYy09SIfHaRnW/z3jY9I+s7c+uwY8+L1Ne8FD6yuPpNJLcqkkLIOf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983172; c=relaxed/simple;
	bh=JxmPFASYiiHSWr/4j1JT8k9obwcqDnvaDZ/beV3DIHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jjel9/P559m3Ck7yLYh2BOln+zc5dK3n3NCHSTcAIzTclUYQC2PPp2wC2xCGxQG+khI6sgSyRwhpfxRWSiwxDw5zGiKaplckXUM4WppcS+/wC9JNZc3Mu4CFYHXYNgkQgpIXCupnIM5i27k62d1Z3vfDiJkvT4OZny95cePZiFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3tOakYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3tOakYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFCDEC116D0;
	Wed, 25 Feb 2026 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983172;
	bh=JxmPFASYiiHSWr/4j1JT8k9obwcqDnvaDZ/beV3DIHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3tOakYcP47DNQ3o9ae1j16m0fKRAhYac5klMH+ee9G1PeIiAnvm3p57txGXAvrZ1
	 uuXSfT5vJcFwdkV+i9sNjtX1OCeToG5lvgkp0Met4hp6ALy/fJVt40BFVfDPP2Cfze
	 T7PDgWjC4t5LeTute+uXTvFRMr4Y11XSXE1E4J8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Tao <houtao1@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Alistair Popple <apopple@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 324/781] PCI/P2PDMA: Release per-CPU pgmap ref when vm_insert_page() fails
Date: Tue, 24 Feb 2026 17:17:13 -0800
Message-ID: <20260225012407.653116462@linuxfoundation.org>
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
index 4a2fc7ab42c34..218c1f5252b66 100644
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



