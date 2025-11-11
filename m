Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C9F4C97;
	Tue, 11 Nov 2025 00:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822274; cv=none; b=UtwLdq57qLzX3KbxGth4nqefgcbSNnMT4Rcn9M+wA/uNpc1zpKRHTBShkVHJbhvYhFCr1/bhC2Ic7ESCTzx6BgRHZdWOrFJ8MjbqH9GY99rAQYMa0tK0LTusLgIhOqV8jwrG2p0/eILuWJZPJ8TacdWc/cC/JlzXOWn0H976oPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822274; c=relaxed/simple;
	bh=bVYw2gKJOhk2FoXHKCtYxEAfZaViFnOK2aLOxnn5Wlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeXzNlp50MeqQCVgKJk1r9rFyvbsx/0ux06JLuf8fCO6knlsc4AKYf062Y2hllcHKZbso1XYNI34k9PosBY0x/O84m0i1Up8f0zazMxYIpRAE4nHVjVcsE0In/YEqcSG0dnCfjkMVxkuHc2HyKnn43M/QW5tIiB/OSGDTrbVjg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ASC7Dwt+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ASC7Dwt+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5E2C19421;
	Tue, 11 Nov 2025 00:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822273;
	bh=bVYw2gKJOhk2FoXHKCtYxEAfZaViFnOK2aLOxnn5Wlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ASC7Dwt+IRC6FzTRKsj3cXpu/IlyDGKhOnqxmXOBnuO0SE28UtRgJjo2rp3an7+Ml
	 w0nDxpo7RfRGtR9IxoxEu7Z6YyNigFQ3KQf5rM4toM/x0nXztmUTFLYJuFidzdvyCo
	 rBtnytDbFd5zcfYWrayyh3zvzJ9h3MnnLK8rcXK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vger.kernnel.org,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 6.12 016/565] s390/pci: Restore IRQ unconditionally for the zPCI device
Date: Tue, 11 Nov 2025 09:37:52 +0900
Message-ID: <20251111004527.233806157@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

From: Farhan Ali <alifm@linux.ibm.com>

commit b45873c3f09153d1ad9b3a7bf9e5c0b0387fd2ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/include/asm/pci.h |    1 -
 arch/s390/pci/pci_irq.c     |    9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

--- a/arch/s390/include/asm/pci.h
+++ b/arch/s390/include/asm/pci.h
@@ -141,7 +141,6 @@ struct zpci_dev {
 	u8		has_resources	: 1;
 	u8		is_physfn	: 1;
 	u8		util_str_avail	: 1;
-	u8		irqs_registered	: 1;
 	u8		tid_avail	: 1;
 	u8		reserved	: 1;
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
 


