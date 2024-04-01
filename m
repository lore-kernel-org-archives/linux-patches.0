Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AA940876;
	Mon,  1 Apr 2024 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990078; cv=none; b=i9s+J9s24oXGOfkJdYjqSwnJ86vQVZHStBTwcBwqBloRnnPQ1/zbMAvBzlotzpAaWvmI2UTa7R7n5ozovZpLt5ZUOGnPZe2sSzsQpN5rTTu5N4Olg7quYz76MuRZLwimk3wLYp58Oe51WRvch2YvLNYsZbebXpLgGqn69MkEy0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990078; c=relaxed/simple;
	bh=A2kqNJBgZftFhnfKiHQiUNajmG3duAa0ukg9Kw0gd1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vGdsb4T7FDiPYIpH4vW2qHFZZOEyp/BdzencOZiZaLHKLUGcepnAEdZd4+MbCM5FkTyZSD5OJsEW5MpS4v+Be7fG+fDITFqyMAWy4L1PLmftZ5APcgHj6qDx8uAEAtV1EJ+Ghazg6q+A7E8C63NvYnUt2hK89AMGZcQWyXWIesY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xV0x1u/1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xV0x1u/1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6470EC433F1;
	Mon,  1 Apr 2024 16:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990077;
	bh=A2kqNJBgZftFhnfKiHQiUNajmG3duAa0ukg9Kw0gd1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xV0x1u/16/62ziY74C4TNDkghxscZvsLAUS/Wot3tDLyI5rTM0R10RvClyJ1jZDlf
	 /Eo3zF5VKJQq8W5PqZX1lSreS+SPhAMbP6rhUlvrdAR0k77tl/k5UGFONekdpnAGbt
	 bS1lKGD2BmbcfW6bES+HwZ1QFRsGjra2a1J8X8K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edmund Raile <edmund.raile@proton.me>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>
Subject: [PATCH 6.6 212/396] firewire: ohci: prevent leak of left-over IRQ on unbind
Date: Mon,  1 Apr 2024 17:44:21 +0200
Message-ID: <20240401152554.246577183@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edmund Raile <edmund.raile@proton.me>

commit 575801663c7dc38f826212b39e3b91a4a8661c33 upstream.

Commit 5a95f1ded28691e6 ("firewire: ohci: use devres for requested IRQ")
also removed the call to free_irq() in pci_remove(), leading to a
leftover irq of devm_request_irq() at pci_disable_msi() in pci_remove()
when unbinding the driver from the device

remove_proc_entry: removing non-empty directory 'irq/136', leaking at
least 'firewire_ohci'
Call Trace:
 ? remove_proc_entry+0x19c/0x1c0
 ? __warn+0x81/0x130
 ? remove_proc_entry+0x19c/0x1c0
 ? report_bug+0x171/0x1a0
 ? console_unlock+0x78/0x120
 ? handle_bug+0x3c/0x80
 ? exc_invalid_op+0x17/0x70
 ? asm_exc_invalid_op+0x1a/0x20
 ? remove_proc_entry+0x19c/0x1c0
 unregister_irq_proc+0xf4/0x120
 free_desc+0x3d/0xe0
 ? kfree+0x29f/0x2f0
 irq_free_descs+0x47/0x70
 msi_domain_free_locked.part.0+0x19d/0x1d0
 msi_domain_free_irqs_all_locked+0x81/0xc0
 pci_free_msi_irqs+0x12/0x40
 pci_disable_msi+0x4c/0x60
 pci_remove+0x9d/0xc0 [firewire_ohci
     01b483699bebf9cb07a3d69df0aa2bee71db1b26]
 pci_device_remove+0x37/0xa0
 device_release_driver_internal+0x19f/0x200
 unbind_store+0xa1/0xb0

remove irq with devm_free_irq() before pci_disable_msi()
also remove it in fail_msi: of pci_probe() as this would lead to
an identical leak

Cc: stable@vger.kernel.org
Fixes: 5a95f1ded28691e6 ("firewire: ohci: use devres for requested IRQ")
Signed-off-by: Edmund Raile <edmund.raile@proton.me>
Link: https://lore.kernel.org/r/20240229144723.13047-2-edmund.raile@proton.me
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firewire/ohci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -3773,6 +3773,7 @@ static int pci_probe(struct pci_dev *dev
 	return 0;
 
  fail_msi:
+	devm_free_irq(&dev->dev, dev->irq, ohci);
 	pci_disable_msi(dev);
 
 	return err;
@@ -3800,6 +3801,7 @@ static void pci_remove(struct pci_dev *d
 
 	software_reset(ohci);
 
+	devm_free_irq(&dev->dev, dev->irq, ohci);
 	pci_disable_msi(dev);
 
 	dev_notice(&dev->dev, "removing fw-ohci device\n");


