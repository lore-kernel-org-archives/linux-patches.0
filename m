Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD48613D51E;
	Thu, 17 Sep 2026 17:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666017; cv=none; b=ApQUJyvblonzliH0knxLImoi3ZJsvolpJPJXl18Cc8HEnBpGTA9xb6FHcyy/ytdgl9X+575akxrg+EgERi8F+nke24Keo0bdVYJPI+ChlswH+u3cdp9aKSLqRPbY2fYjinkcEMCbxDfm+8RMkVX7fV4OW0Q1FPxkCbtzALGY+mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666017; c=relaxed/simple;
	bh=fO8bXhynMhbvSjssUWQkY8v81s6HkfaXgyq4e4NReA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KDrglDqVb1VnL1JB0zVlC40JLLHKitw+hkaVpELmCnTzZ/nT7IViRb62F6AMfittMJIMTY27AR/7FFpDpRJ4HhuBYXsThc+VxZIuCWJ/x9Tn+cABGVeHGIFyAvGI+SpbM2zI5us+07ZqSaigU3/cBmiSIAnlB/R63fiObZwezqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vChowzsW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vChowzsW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25251F00893;
	Thu, 17 Sep 2026 17:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666016;
	bh=kbxd1chCL2qKKVoaf1dGW9e2pYLwdszLMcARE4EBBoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vChowzsWuozepVMC+MLBFgCwhXlMfkICNmjjXLxjE3uhFweY+Q+4LvU2Ya64JI8YM
	 DLIcArlrCBDoO9LjoUjBqCaLgD0u6YYSdsGhZLbv3t6glMO66L2gktLzdIXJ84uhcX
	 +ZaUErevlmHFLN8lTQYlujlTjeHUfVze9Kt3McJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0859/1250] virtio-pci: return IRQ_HANDLED after non-zero ISR
Date: Thu, 17 Sep 2026 16:10:54 +0100
Message-ID: <20260917151615.251127844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Stellman <astellman@stellman-greene.com>

[ Upstream commit 93fa09455fb1a9624b73d42ac1f83771f4818e80 ]

vp_interrupt() reads the ISR before dispatching config-change and
vring handling. Reading the ISR also clears it, so once the read
returns non-zero the interrupt was from this device and has already
been consumed.

Currently vp_interrupt() returns the result of vp_vring_interrupt().
For a config-change interrupt with no vring work, that can return
IRQ_NONE even though the ISR was non-zero and the interrupt was
handled.

Call vp_vring_interrupt() for any queue work, but once the ISR is
non-zero return IRQ_HANDLED.

Tested with QEMU virtio-blk-pci forced to INTx using vectors=0 and
pci=nomsi. On an idle device, 200 config-change interrupts were
generated using QMP block_resize.

Before this change, irq_handler_exit reported ret=unhandled and
/proc/irq/11/spurious increased from 0 to 200 unhandled interrupts.
After this change, irq_handler_exit reported ret=handled and the
unhandled count remained at 0.

The issue was found during an LLM-assisted Quality Playbook review.

Fixes: 77cf524654a8 ("virtio_pci: split up vp_interrupt")
Suggested-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: LLM
Signed-off-by: Andrew Stellman <astellman@stellman-greene.com>
Message-ID: <20260904141318.30278-1-astellman@stellman-greene.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index ef87e7584756e..64806d042dbb2 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -120,7 +120,9 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
 	if (isr & VIRTIO_PCI_ISR_CONFIG)
 		vp_config_changed(irq, opaque);
 
-	return vp_vring_interrupt(irq, opaque);
+	vp_vring_interrupt(irq, opaque);
+
+	return IRQ_HANDLED;
 }
 
 static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
-- 
2.53.0



