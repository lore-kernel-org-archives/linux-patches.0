Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59CEB11710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF94C433C8;
	Mon, 11 Sep 2023 15:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446013;
	bh=euOleWHP4tyxkpaQeHtMdUSZcU7mI5yk2NhQidjmmd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxGNq+QD9xq9th2Tad9+cfzayG7SRgk2/wtSHZqxJXW9H9ocaOFs2wr6+t51Iaf/X
	 QfmklH8zXZ+Vy/DNT4pj7Yx9akQ7N/oDFUPDE9u6BHpt+aD7CaHOyOZAzKIslu0lwd
	 3Q2mHcgide0n1IwyAypLgg3vi+4hfGuiMkC0Iad0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dexuan Cui <decui@microsoft.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	sathyanarayanan.kuppuswamy@linux.intel.com,
	Michael Kelley <mikelley@microsoft.com>
Subject: [PATCH 6.1 552/600] PCI: hv: Fix a crash in hv_pci_restore_msi_msg() during hibernation
Date: Mon, 11 Sep 2023 15:49:45 +0200
Message-ID: <20230911134649.911422324@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit 04bbe863241a9be7d57fb4cf217ee4a72f480e70 upstream.

When a Linux VM with an assigned PCI device runs on Hyper-V, if the PCI
device driver is not loaded yet (i.e. MSI-X/MSI is not enabled on the
device yet), doing a VM hibernation triggers a panic in
hv_pci_restore_msi_msg() -> msi_lock_descs(&pdev->dev), because
pdev->dev.msi.data is still NULL.

Avoid the panic by checking if MSI-X/MSI is enabled.

Link: https://lore.kernel.org/r/20230816175939.21566-1-decui@microsoft.com
Fixes: dc2b453290c4 ("PCI: hv: Rework MSI handling")
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: sathyanarayanan.kuppuswamy@linux.intel.com
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pci-hyperv.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -3930,6 +3930,9 @@ static int hv_pci_restore_msi_msg(struct
 	struct msi_desc *entry;
 	int ret = 0;
 
+	if (!pdev->msi_enabled && !pdev->msix_enabled)
+		return 0;
+
 	msi_lock_descs(&pdev->dev);
 	msi_for_each_desc(entry, &pdev->dev, MSI_DESC_ASSOCIATED) {
 		irq_data = irq_get_irq_data(entry->irq);


