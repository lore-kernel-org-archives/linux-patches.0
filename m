Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6F63A9D8F;
	Sat, 17 Oct 2026 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253600; cv=none; b=GViK4CWNAxOD7kCHsRK0K0Rh76cOFiAvTzpYCzV6z4wIgUWdeFZyMDvxuxjlUKiiP1dHygYjhhoKGkqjguGZsBpPwcR9SMsEk417xgl8JCRdLauRwqdbNeIYxIiaWcxcz9qYurypDgIZ8ijSYTQezu/nOHPejMjHehLD74AH76o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253600; c=relaxed/simple;
	bh=CPVUQyZLO8P21gOntBSY8szoVjoGnN7vvBsr69Ckspg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5zRbHdI7SghOhIyeY31z+466PZOhMaiYcHl93J44UyJ0jVJndeDHrhka0XCnFFcXgGw2unvnFKirgEBwpFzNrL8qBXvXn8uLcjd5hUiidLjIKdC6B2MVJ32KnDFTuAY1xtaduKAM9u+qbpmtBRubwrD/Z4Ij/83u2aruc3lHkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN9m1eS8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN9m1eS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92FD31F000C5;
	Sat, 17 Oct 2026 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253598;
	bh=kaWAo62f2p/W9Si/Ewf5/N5PbOzT1zdOWNFzWxR1wwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CN9m1eS8RHFMctEut6KdyKOWuBg9HHxn15uQoAuPUEcEe79dc+62b4zp1hzilIzr3
	 WSxY6Rs1DsCdqG27BhPo/z8msK/EQbTeYiCozWTd4GnDq7JIaabt6JIs0mgK9nbYyM
	 foiEAdt3Z6fztEMoZs609OClC2DExvc1Xl7vpsz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 172/869] PCI: endpoint: Add missing NULL check for alloc_workqueue()
Date: Sat, 17 Oct 2026 17:50:13 +0200
Message-ID: <20261017160041.462529500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d12cf226f3282..040c32e438be0 100644
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
index f9786637d21c4..963a1a1f983db 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1418,6 +1418,11 @@ static int __init epf_ntb_init(void)
 
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



