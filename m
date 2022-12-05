Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6FD15C82
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA9CC433C1;
	Mon,  5 Dec 2022 19:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268156;
	bh=f26FviH9Ojc5377JhuCtrhXPgrQ2thV8/WZHICpc4LU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeooNdo6XMZ5rqbRHtBC8qQqqmsIM4pELKgOrxD+KGKg28TFwYtlNk1zUeyaa/7UZ
	 EQsmwuHnl0s1+HCfyNTzZ3VVRHKsoXfySrnqd3/ohl3VDOKlGCz/ErOu4l9nmvapyd
	 EbtHxDKtLHPsjHY4gdkxNOKvQOKhb8N8PzZdgY7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiongfeng Wang <wangxiongfeng2@huawei.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/105] iommu/vt-d: Fix PCI device refcount leak in dmar_dev_scope_init()
Date: Mon,  5 Dec 2022 20:10:05 +0100
Message-Id: <20221205190806.267044352@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.124472741@linuxfoundation.org>
References: <20221205190803.124472741@linuxfoundation.org>
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

[ Upstream commit 4bedbbd782ebbe7287231fea862c158d4f08a9e3 ]

for_each_pci_dev() is implemented by pci_get_device(). The comment of
pci_get_device() says that it will increase the reference count for the
returned pci_dev and also decrease the reference count for the input
pci_dev @from if it is not NULL.

If we break for_each_pci_dev() loop with pdev not NULL, we need to call
pci_dev_put() to decrease the reference count. Add the missing
pci_dev_put() for the error path to avoid reference count leak.

Fixes: 2e4552893038 ("iommu/vt-d: Unify the way to process DMAR device scope array")
Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Link: https://lore.kernel.org/r/20221121113649.190393-3-wangxiongfeng2@huawei.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/dmar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 017786d62f47..3ea851583724 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -804,6 +804,7 @@ int __init dmar_dev_scope_init(void)
 			info = dmar_alloc_pci_notify_info(dev,
 					BUS_NOTIFY_ADD_DEVICE);
 			if (!info) {
+				pci_dev_put(dev);
 				return dmar_dev_scope_status;
 			} else {
 				dmar_pci_bus_add_dev(info);
-- 
2.35.1



