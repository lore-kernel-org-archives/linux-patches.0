Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984DF392829;
	Sat, 17 Oct 2026 17:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258333; cv=none; b=h+3Tc5tAdfu8zJiM/DlxSWFLwr6aCy0snNzY8YSB5C24ytguADtbvA/orJrRRlpKuk1IwinrSbuabL706J23/GMMTzWXuCEMZzhGsx6Fc6s5MbDU7HfnmNkmlqm9YUpMte9tVWSkHEtqzHCKTvzkj1KGDKydG2IAlA020wItiD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258333; c=relaxed/simple;
	bh=ZzDWj6g8TkbH5CDO1X9EROqV514grbdPGwqSZbATNV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzKF+1bOKLFPI+c5E1pQrhbm5tG/zIuMOYjaa7OXa1W/Ua1R595drhfIV+f6nABvVnhDlGp5TdxVmrALRK+LnBMq/3jxhpUAIqjylRZCt6n6gmx7CZNNKPec3CWbYzjcoZXoIEkinMZ/ZFQ2nzZXFbAZsElsBQnX8pDWlfk5cuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y5D5/qZS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y5D5/qZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E582E1F000C4;
	Sat, 17 Oct 2026 17:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258332;
	bh=ZQzEmG05scogtXG97rrh6Xe9hYjm5nN4Z7zb9+c/LAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y5D5/qZSR4LRVwkzkV3z/sB7J9Dw2nc9T8tPUfgJnvG1fxOVXJD+OGbvmgfyvR9oT
	 RfIBS4x7tAy86WeU/wKASL8C4FP43/rbR72D4S0XxI1Bvg/7ksCC2zCsbfJOoP+TEv
	 I4oMAhZQJNETG8GbWLe4BJdQHAsYpbrnYaJ1004g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0850/1674] PCI: endpoint: Add missing NULL check for alloc_workqueue()
Date: Sat, 17 Oct 2026 17:52:02 +0200
Message-ID: <20261017160452.945812473@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cba6bab067b61..ee3ce8a02529a 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -2075,6 +2075,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
 					    WQ_HIGHPRI, 0);
+	if (!kpcintb_workqueue) {
+		pr_err("Failed to allocate kpcintb workqueue\n");
+		return -ENOMEM;
+	}
+
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 0ebd37e7ecd0f..22364ebd73ed7 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1432,6 +1432,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
 					    WQ_HIGHPRI, 0);
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



