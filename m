Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49D11922E5;
	Tue, 10 Sep 2024 10:02:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962558; cv=none; b=PuBmSwx1Qsr1CrFhAqJ3uJsiGJ8MNb9vn2MlmNhSdIiCe5suR9t2CVK/Lf4CPsAjgC11fGYZwQkmsBTqF7YzjEdJdXW4OfRBgfM9ZzfwEVJ3aLBBMtPCmW6+SEb+Z0boTCu/hN8Ryg+3OFiY/MsCWZHx1Y1CXtVHH0CIxcKi+6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962558; c=relaxed/simple;
	bh=oCtLPbTX1iyRK9g5P7ap8hV+34XngdgYjTCIdLL2ItI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crZPWGqMtTa6eJ/17mN4NwEGJN66ujPqAr0h4z6aSp4OyWyTFoP/FV8uX74kmk98pHNDTV8MfCggPRlNqYoqNW0ta8vkS3aHRvnDnDynZjuulgNnLxrVgdAFSxJ7/fhPE81MIESxOHL9tyMPmZ+t1I8vhQ6kvtH+rcbZ0WumVXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okE56HgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okE56HgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38501C4CEC3;
	Tue, 10 Sep 2024 10:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962558;
	bh=oCtLPbTX1iyRK9g5P7ap8hV+34XngdgYjTCIdLL2ItI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okE56HgFOxyE0URRizlCuVYNuQYdQUZSob7VdkZG39TC23CcMuVilIaUIBHGYiYPU
	 exglrYL/zIvLKHYM6fuP/mGx943G1Z6NShMgJjeAldKGrktHhFUTCEPp+pa/IHWU6i
	 Uzxh6ustXnZkFAd31oP8fFqvP8AVoLcQKnbQcfLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Timothy Pearson <tpearson@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shawn Anastasio <sanastasio@raptorengineering.com>,
	Krishna Kumar <krishnak@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 075/121] pci/hotplug/pnv_php: Fix hotplug driver crash on Powernv
Date: Tue, 10 Sep 2024 11:32:30 +0200
Message-ID: <20240910092549.461045060@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krishna Kumar <krishnak@linux.ibm.com>

[ Upstream commit 335e35b748527f0c06ded9eebb65387f60647fda ]

The hotplug driver for powerpc (pci/hotplug/pnv_php.c) causes a kernel
crash when we try to hot-unplug/disable the PCIe switch/bridge from
the PHB.

The crash occurs because although the MSI data structure has been
released during disable/hot-unplug path and it has been assigned
with NULL, still during unregistration the code was again trying to
explicitly disable the MSI which causes the NULL pointer dereference and
kernel crash.

The patch fixes the check during unregistration path to prevent invoking
pci_disable_msi/msix() since its data structure is already freed.

Reported-by: Timothy Pearson <tpearson@raptorengineering.com>
Closes: https://lore.kernel.org/all/1981605666.2142272.1703742465927.JavaMail.zimbra@raptorengineeringinc.com/
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Shawn Anastasio <sanastasio@raptorengineering.com>
Signed-off-by: Krishna Kumar <krishnak@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240701074513.94873-2-krishnak@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index d7b2b47bc33e..382494261830 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -35,7 +35,6 @@ static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
 				bool disable_device)
 {
 	struct pci_dev *pdev = php_slot->pdev;
-	int irq = php_slot->irq;
 	u16 ctrl;
 
 	if (php_slot->irq > 0) {
@@ -54,7 +53,7 @@ static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
 		php_slot->wq = NULL;
 	}
 
-	if (disable_device || irq > 0) {
+	if (disable_device) {
 		if (pdev->msix_enabled)
 			pci_disable_msix(pdev);
 		else if (pdev->msi_enabled)
-- 
2.43.0



