Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040FD18DB2A;
	Wed, 25 Feb 2026 01:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983168; cv=none; b=NoSS9Ft5C24/aQvLW1IV1OkmNCEs/3ZbyU7ZkiEtrsMZ0To/CuqQrqqwjBnWSihbBPOmGtrsAxb29FBYlk8vK/15eYnIkBUiVjduHi+T44yqXdA0yGwGPdojy9KXALaCvfat1BqemmwD0kRzb6357F0hqnsZvgqevyfp8rLHDOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983168; c=relaxed/simple;
	bh=OPFCtROldQArhvKaVx4dlJWtzG6d8CnWnymoakqZkS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIYovi3us/EBbBPLoaZ7VejoAy/YVKQprKGoh8ZnvmaKORqMT58tvft++1vG0NTOmmeol1lXqlUqbYmoZ8ptPEwIH4j+TDSrgXoiQ76tgnWfOqu3EpBPGgoNsNwnsIPRr8yiu40FTShRIbu6JWTkopWFKTrosQbCBxSt8CEwKtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AIPGEE3j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AIPGEE3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4188C116D0;
	Wed, 25 Feb 2026 01:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983167;
	bh=OPFCtROldQArhvKaVx4dlJWtzG6d8CnWnymoakqZkS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AIPGEE3jNtGxRaVvJKH04ESqOLQFVBt8/h5ngHRPJI7ZPEVa2EI70ZXNt9/VJ8QMj
	 xlt+fjD+D/6mov8x21KLXo5sFSwa05OL25Jvd31B++sUH75ON7/vLViv5TBDK6HxA8
	 9+f6eEREAjvSmNwQIbIJKDJgtdiJTwYMcUdzYSQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 320/781] PCI: endpoint: Add missing NULL check for alloc_workqueue()
Date: Tue, 24 Feb 2026 17:17:09 -0800
Message-ID: <20260225012407.548836861@linuxfoundation.org>
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
index 9ea8b57d69d79..a3a588e522e71 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -2126,6 +2126,11 @@ static int __init epf_ntb_init(void)
 
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
index a098727f784bd..20a400e834392 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1653,6 +1653,11 @@ static int __init epf_ntb_init(void)
 
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
2.51.0



