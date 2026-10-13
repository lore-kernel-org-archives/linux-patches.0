Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1B34FD290;
	Tue, 13 Oct 2026 12:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893229; cv=none; b=JTuwaOjZANCmB8EYQJnzEoxibdAXScxJeYX3bTgNbtgi7Hae8/G+XsPkWKGMB7qpcQD7IVnLbXfDdelBb4T4wSzl23I2T9nhpEWGSTNSCx5qvnkpTrfWCfbO9mtUggZdloy32bHmJ17QFVqNsdC5zVKeOgVrZYRz3Rh6VuHtju4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893229; c=relaxed/simple;
	bh=N/EFyZpWLSVJeNNntO2oLWIZBI1o6zlpS4xJ2+k9agI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2DFJpqYIIvz/D3jkyda+MBSvJdGgl8az+QgrADy6dxCuoeX6/DUPZglWbiiwxsKSEFkiLWsXYjGXMhYFbplWLtAcZswpZgQbFuLxRCrbEZt9yKSKjAyVYAOdh87KFGqBdbRxcLVNJmfbGFnXBp6uGEl8fXJ99u4qXdF0svOWbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fwjdg4zh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fwjdg4zh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF111F000FF;
	Tue, 13 Oct 2026 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893228;
	bh=QESofUzkiWoaAYBRvDiv6W+yPUfFRGF+sFfMvrcxr3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fwjdg4zh5pKtorMhEqzg0h5DeC6Hkzc6rVXsic6DRdHGrlWrrli79Y3DNCrxH+QFG
	 ZsArPPIe6zkbFjT7Op5RxyL/JeEgDHk9rY1KbANQVgnY8CFfHVR/SbcN2g75WIm9oV
	 e00Nj5hUwETzkpzEgsMZdAlJZ8UNntwxk0xZpj90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 154/621] PCI: endpoint: Add missing NULL check for alloc_workqueue()
Date: Tue, 13 Oct 2026 13:32:29 +0200
Message-ID: <20261013112924.509183708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 03f336a869b3a3f119d3ae52ac9723739c7fb7b6 ]

alloc_workqueue() can return NULL on memory allocation failure. Without
proper error checking, this may lead to a NULL pointer dereference when
queue_work() is later called with the NULL workqueue pointer in
epf_ntb_epc_init().

Add a NULL check immediately after alloc_workqueue() and return -ENOMEM on
failure to prevent the driver from loading with an invalid workqueue
pointer.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Fixes: 8b821cf76150 ("PCI: endpoint: Add EP function driver to provide NTB functionality")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251110040446.2065-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-ntb.c  | 5 +++++
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-ntb.c b/drivers/pci/endpoint/functions/pci-epf-ntb.c
index 33cafce06e633..5314aca2188a0 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -2075,6 +2075,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb",
 				    WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU, 0);
+	if (!kpcintb_workqueue) {
+		pr_err("Failed to allocate kpcintb workqueue\n");
+		return -ENOMEM;
+	}
+
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index fadebe86417b6..68110855ea1c7 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1515,6 +1515,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb",
 				    WQ_MEM_RECLAIM | WQ_HIGHPRI | WQ_PERCPU, 0);
+	if (!kpcintb_workqueue) {
+		pr_err("Failed to allocate kpcintb workqueue\n");
+		return -ENOMEM;
+	}
+
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
-- 
2.53.0



