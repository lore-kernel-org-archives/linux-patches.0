Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A2A15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CF9C433C1;
	Mon,  5 Dec 2022 19:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268459;
	bh=VzJDjgQa9jnJieCfe2b7Yj/gCQymZ1keEbTKJMD8wBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhWVKtS+p6QvQ6L6CcTHp8ftiC+Z4zNnEP0CXjH/ogaCXWawHi6aoOvo+XqG3lAvW
	 DLFHc40rR17cxjk0aYHIkq5vgGkBB8UnkwzXfCIVLFiX8pnRTHgpw0vH8X7AWfzagt
	 H28cPRYQC4M/uwGNnFEJlMo8PrrVfdswXlodkuT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 109/124] iommu/vt-d: Fix PCI device refcount leak in has_external_pci()
Date: Mon,  5 Dec 2022 20:10:15 +0100
Message-Id: <20221205190811.539122503@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiongfeng Wang <wangxiongfeng2@huawei.com>

[ Upstream commit afca9e19cc720bfafc75dc5ce429c185ca93f31d ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() before 'return true' to avoid reference count leak.

Fixes: 89a6079df791 ("iommu/vt-d: Force IOMMU on for platform opt in hint")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221121113649.190393-2-wangxiongfeng2@huawei.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index e47700674978..412b106d2a39 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -3844,8 +3844,10 @@ static inline bool has_external_pci(void)
 	struct pci_dev *pdev = NULL;
 
 	for_each_pci_dev(pdev)
-		if (pdev->external_facing)
+		if (pdev->external_facing) {
+			pci_dev_put(pdev);
 			return true;
+		}
 
 	return false;
 }
-- 
2.35.1



