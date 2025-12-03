Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E82F34CFD0;
	Wed,  3 Dec 2025 16:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778796; cv=none; b=ldk76J76b2fap7jU4/CpF1NBzt/NvyUlBee7cKE1yNZrj/4P0A+mVTto83V+NgTHLA2k1lzEjYdwEG+O3sRW+92lknqnQKNiqyGBnLEbBCI/eziTLDmqYW1WIy/F5nfW9pGCU3aT0408sDSzipcb2TeJr6w6X8IgZggPEXoQ/O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778796; c=relaxed/simple;
	bh=46xZpzCovNSWZ9rz0NJ5Dv5mMMtkpZuOD63il9ZoGBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVgwvFZb9BaOZuH4AQgcFUuMGUQHq/tHsst3clObHUJPDPwrf3knz5+12ctbjRSCHLoxlpwKlLbp9f/sIWBjiWlftRnTNoKGsmZy7CYgcE5Kki5U7j8BiSYKZiCLzf1G8mI1YK7bltdv9RbK0IodMBrk2bhJpSdgAtrjTkhOSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GS4mcmyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GS4mcmyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A946C4CEF5;
	Wed,  3 Dec 2025 16:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778795;
	bh=46xZpzCovNSWZ9rz0NJ5Dv5mMMtkpZuOD63il9ZoGBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GS4mcmyHBxAjs5mcCioMK3ssCMciAiYWq1FaARNIULnZFbtmzXn70VTWl7YpsRcbx
	 IDHZFIAzCMbJf5etLYK24jBJQr9R+NHiGsw5hxViGuYMs1at50vH2CsyNmefu8uqKf
	 Q3Ahyc7DKrTyXcXeM4P1vEULfc1/sG06RyUDPtyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vger.kernnel.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/568] s390/pci: Restore IRQ unconditionally for the zPCI device
Date: Wed,  3 Dec 2025 16:21:02 +0100
Message-ID: <20251203152442.896269001@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit b45873c3f09153d1ad9b3a7bf9e5c0b0387fd2ea ]

Commit c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()"),
introduced the zpci_set_irq() and zpci_clear_irq(), to be used while
resetting a zPCI device.

Commit da995d538d3a ("s390/pci: implement reset_slot for hotplug
slot"), mentions zpci_clear_irq() being called in the path for
zpci_hot_reset_device().  But that is not the case anymore and these
functions are not called outside of this file. Instead
zpci_hot_reset_device() relies on zpci_disable_device() also clearing
the IRQs, but misses to reset the zdev->irqs_registered flag.

However after a CLP disable/enable reset, the device's IRQ are
unregistered, but the flag zdev->irq_registered does not get cleared. It
creates an inconsistent state and so arch_restore_msi_irqs() doesn't
correctly restore the device's IRQ. This becomes a problem when a PCI
driver tries to restore the state of the device through
pci_restore_state(). Restore IRQ unconditionally for the device and remove
the irq_registered flag as its redundant.

Fixes: c1e18c17bda6 ("s390/pci: add zpci_set_irq()/zpci_clear_irq()")
Cc: stable@vger.kernnel.org
Reviewed-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
[ adjusted bitfield context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci.h |    1 -
 arch/s390/pci/pci_irq.c     |    9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -136,7 +136,6 @@ struct zpci_dev {
 	u8		has_resources	: 1;
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
-	u8		irqs_registered	: 1;
 	u8		reserved	: 2;
 	unsigned int	devfn;		/* DEVFN part of the RID*/
 
--- a/arch/s390/pci/pci_irq.c
+++ b/arch/s390/pci/pci_irq.c
@@ -107,9 +107,6 @@ static int zpci_set_irq(struct zpci_dev
 	else
 		rc = zpci_set_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 1;
-
 	return rc;
 }
 
@@ -123,9 +120,6 @@ static int zpci_clear_irq(struct zpci_de
 	else
 		rc = zpci_clear_airq(zdev);
 
-	if (!rc)
-		zdev->irqs_registered = 0;
-
 	return rc;
 }
 
@@ -427,8 +421,7 @@ bool arch_restore_msi_irqs(struct pci_de
 {
 	struct zpci_dev *zdev = to_zpci(pdev);
 
-	if (!zdev->irqs_registered)
-		zpci_set_irq(zdev);
+	zpci_set_irq(zdev);
 	return true;
 }
 


