Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6F51303A1E;
	Sat, 25 Oct 2025 16:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409555; cv=none; b=XBKZaQMjC3G5rlv0mEjzNmsahdABjr1VRIFm9UiCQ7VHC0QpB8dk5/VHy+DHrMihIzB/kej8+NXlcYueIlxloBWH1xbxjAHgTUVUljMP7CYTPRmbGXUNNM47XjUFfRHofdcb/oDnL8FhWAlLbRPV6ms+Jg3/cMYbWMwGdGG7/14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409555; c=relaxed/simple;
	bh=CKo2WsZ+wTgGk/i5OdedRgcgAJo8XtXMgrnGzM6TyTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MPLL1xSRzGGimXyjHCa4csiI0vdGBDJnUT0t4lhVzHcu6oq58AreP7rsA7RbQ/OiLjf/9mWIKG4SwV9AoGb9YeqeZY0eHkmp0uFAh/3w60TEf6GFAQyB9xMdRIoyoUCCY5Ydr1RNlWWNtWF7PCNnXAzILhts3+A910ToR2HhTyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FjkR5T1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FjkR5T1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 760A8C4CEFF;
	Sat, 25 Oct 2025 16:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409554;
	bh=CKo2WsZ+wTgGk/i5OdedRgcgAJo8XtXMgrnGzM6TyTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjkR5T1bfX1d4D9ALnjRJqu/ieAKuUvcYCqg//4QNFRpXtREuMDbBdSRXorv34rk/
	 QRyuRJVPUi+IH4d3K+chabMjf/A1k9WzLxK2AuF80YLI9aAasPH71ic+5ZHbuDoJRo
	 YP8W/5amqAdxEj+KXJTmCFgsuLtGvDez8I8r6BIJkJv+RxDLTSjOmZXaba25jR4hm8
	 cvqJk1US7V+E+IRUsW4QnygKQG5xhmVgiv2c0YVKhnbttcU3Avg3O4IM/BK1CL+xDq
	 g8r6F55KebR7n9kgyFpCp5sTqFwESgRPJPEEvjMFUMEs2qIPzq4FkHWHfQPbWBCcL9
	 HsOz2L43DtyKQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Timothy Pearson <tpearson@raptorengineering.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	alex@shazbot.org,
	kevin.tian@intel.com,
	bhelgaas@google.com,
	pstanner@redhat.com,
	seanjc@google.com,
	zhao.xichao@vivo.com,
	alexandre.f.demers@gmail.com
Subject: [PATCH AUTOSEL 6.17-6.12] vfio/pci: Fix INTx handling on legacy non-PCI 2.3 devices
Date: Sat, 25 Oct 2025 11:59:53 -0400
Message-ID: <20251025160905.3857885-362-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Timothy Pearson <tpearson@raptorengineering.com>

[ Upstream commit 8b9f128947dd72e0fcf256088a673abac9b720bf ]

PCI devices prior to PCI 2.3 both use level interrupts and do not support
interrupt masking, leading to a failure when passed through to a KVM guest on
at least the ppc64 platform. This failure manifests as receiving and
acknowledging a single interrupt in the guest, while the device continues to
assert the level interrupt indicating a need for further servicing.

When lazy IRQ masking is used on DisINTx- (non-PCI 2.3) hardware, the following
sequence occurs:

 * Level IRQ assertion on device
 * IRQ marked disabled in kernel
 * Host interrupt handler exits without clearing the interrupt on the device
 * Eventfd is delivered to userspace
 * Guest processes IRQ and clears device interrupt
 * Device de-asserts INTx, then re-asserts INTx while the interrupt is masked
 * Newly asserted interrupt acknowledged by kernel VMM without being handled
 * Software mask removed by VFIO driver
 * Device INTx still asserted, host controller does not see new edge after EOI

The behavior is now platform-dependent.  Some platforms (amd64) will continue
to spew IRQs for as long as the INTX line remains asserted, therefore the IRQ
will be handled by the host as soon as the mask is dropped.  Others (ppc64) will
only send the one request, and if it is not handled no further interrupts will
be sent.  The former behavior theoretically leaves the system vulnerable to
interrupt storm, and the latter will result in the device stalling after
receiving exactly one interrupt in the guest.

Work around this by disabling lazy IRQ masking for DisINTx- INTx devices.

Signed-off-by: Timothy Pearson <tpearson@raptorengineering.com>
Link: https://lore.kernel.org/r/333803015.1744464.1758647073336.JavaMail.zimbra@raptorengineeringinc.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES – the change makes VFIO’s INTx masking work correctly on legacy
devices that lack PCI 2.3 masking support, eliminating a real guest-
visible interrupt loss.

- The handler already relies on `disable_irq_nosync()` when `pci_2_3` is
  false (`drivers/vfio/pci/vfio_pci_intrs.c:232-235`), but without this
  patch the disable stays “lazy,” so a level-triggered device that
  reasserts while masked never generates another host interrupt on
  platforms such as ppc64. The new call to `irq_set_status_flags(...,
  IRQ_DISABLE_UNLAZY)` for those devices
  (`drivers/vfio/pci/vfio_pci_intrs.c:307-309`) forces the core to
  perform an immediate hardware disable, exactly as recommended in the
  IRQ core (`kernel/irq/chip.c:380-408`), preventing the lost-interrupt
  stall described in the commit message.
- Cleanup paths clear the flag both on request failure and normal
  teardown (`drivers/vfio/pci/vfio_pci_intrs.c:312-314` and
  `drivers/vfio/pci/vfio_pci_intrs.c:360-361`), so the change is tightly
  contained and doesn’t leak settings after the device is released.
- The fix is small, self-contained, and only touches the legacy INTx
  path, leaving MSI/MSI-X and modern PCI 2.3 devices untouched. It uses
  long-standing IRQ APIs with no new dependencies.

Given the user-visible failure (guest stops receiving interrupts or
risks storms) and the minimal, well-scoped fix, this is a good candidate
for stable backporting. Suggested next step: backport to supported
stable branches that ship the current VFIO INTx logic.

 drivers/vfio/pci/vfio_pci_intrs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci_intrs.c b/drivers/vfio/pci/vfio_pci_intrs.c
index 123298a4dc8f5..61d29f6b3730c 100644
--- a/drivers/vfio/pci/vfio_pci_intrs.c
+++ b/drivers/vfio/pci/vfio_pci_intrs.c
@@ -304,9 +304,14 @@ static int vfio_intx_enable(struct vfio_pci_core_device *vdev,
 
 	vdev->irq_type = VFIO_PCI_INTX_IRQ_INDEX;
 
+	if (!vdev->pci_2_3)
+		irq_set_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
+
 	ret = request_irq(pdev->irq, vfio_intx_handler,
 			  irqflags, ctx->name, ctx);
 	if (ret) {
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		vdev->irq_type = VFIO_PCI_NUM_IRQS;
 		kfree(name);
 		vfio_irq_ctx_free(vdev, ctx, 0);
@@ -352,6 +357,8 @@ static void vfio_intx_disable(struct vfio_pci_core_device *vdev)
 		vfio_virqfd_disable(&ctx->unmask);
 		vfio_virqfd_disable(&ctx->mask);
 		free_irq(pdev->irq, ctx);
+		if (!vdev->pci_2_3)
+			irq_clear_status_flags(pdev->irq, IRQ_DISABLE_UNLAZY);
 		if (ctx->trigger)
 			eventfd_ctx_put(ctx->trigger);
 		kfree(ctx->name);
-- 
2.51.0

