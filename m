Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A3B18B49E;
	Tue, 10 Sep 2024 10:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963685; cv=none; b=VuT18cPAW4ordSjc6y49ciKhq+w2Y59Sx041qHUxWF3DB+x2SLSR6Z/k9R+dKrGBx1B5NHnOd038pWovOLMZbB0ckxpuKvP9Z84TbhUXRSBanSKf6jWz0F/g+TPhEVCbXpJmg3sK/wpJENnD7pJ/SSBEL27dpXYBVzs2bgdmohw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963685; c=relaxed/simple;
	bh=NRKThZkn4oz6dI5jFTJLIihBs4PwpUV6j1qxMg601Eo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ho6tzSTtJ4WpSD1dcZS+tmO/BgbVH39OvjmeTtPlUAvz6t9P1oPWDDMTG+ePAkka9A6sVA+PNIjS90dCyYnuPXPVZIwcI9tb7XCqH6Ii8HK3fESlG+UQGW+nNmuc+Zt21xHEtXXWfcLOUOv03lX3bxX2PlTT27jgQQs+a3VkKIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c15NPh+N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c15NPh+N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEB7C4CEC3;
	Tue, 10 Sep 2024 10:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963685;
	bh=NRKThZkn4oz6dI5jFTJLIihBs4PwpUV6j1qxMg601Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c15NPh+NDMDHm/wCQx+gErnYIOxtY7rt/cig/gS062pPRn858HhvFSFBNZjwKopIj
	 805Gw+57MV0zbYDRxPuDE1WsbjkGGL50FW9PCkHl6InBkqT/p8x6UwbepgBQgjEzw0
	 JXKSv6UDFj36IJ4VSKQiA28NhXRnrsVklzHCobKU=
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
Subject: [PATCH 5.15 141/214] pci/hotplug/pnv_php: Fix hotplug driver crash on Powernv
Date: Tue, 10 Sep 2024 11:32:43 +0200
Message-ID: <20240910092604.514502134@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f4c2e6e01be0..e233f8402e8c 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -38,7 +38,6 @@ static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
 				bool disable_device)
 {
 	struct pci_dev *pdev = php_slot->pdev;
-	int irq = php_slot->irq;
 	u16 ctrl;
 
 	if (php_slot->irq > 0) {
@@ -57,7 +56,7 @@ static void pnv_php_disable_irq(struct pnv_php_slot *php_slot,
 		php_slot->wq = NULL;
 	}
 
-	if (disable_device || irq > 0) {
+	if (disable_device) {
 		if (pdev->msix_enabled)
 			pci_disable_msix(pdev);
 		else if (pdev->msi_enabled)
-- 
2.43.0



