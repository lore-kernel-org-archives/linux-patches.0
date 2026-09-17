Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12F24E77FF;
	Thu, 17 Sep 2026 15:41:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659724; cv=none; b=CV6o+IJSQ384UTPOqVQrgtTfwvuOUZTMpb7mN5u/aVj7mZ40Im/sHmMB5GE+Ba3+V+4oFInj9Ax+rNkj/ietBdRJNdfmIR/ZotEMgb5LMc84pDrPJBbiX5Gp4Kv7HupcucVHlt6/5AQBBBhZSVz265uky50S3GuX0gbF5jy/41c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659724; c=relaxed/simple;
	bh=z6vOf1YeyFgvkYj1yXXUS/3IwPf1k5+XK4OIOyQl4ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FmefRtSQLt+2D9TwBDgRAni7EUQt0oe8HrkljPzeTy6ogwyp46p348Q0g/BMA5f5j3CM8JygXsbv3WVlTkgksFqyyt9k/qmXwJkKAw1gJb2VAzTYxij/2oRZw3kV1nxOtL0M09+LDO40qm7Qyu+C2Z+JNoElV8GXQUCS7e7HzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XdtJGMcp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XdtJGMcp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05DB31F00893;
	Thu, 17 Sep 2026 15:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659714;
	bh=aJpklFrE6M79BnX5F25M3E+INT5Or2RjJKH8FA3WtxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XdtJGMcpg0AzRZWBbrqDfAqQzrxBDvnW04scwrtJa2dLve8/3AHqHQBz+Hcl3y2r8
	 z16D6mnzYHI9guZnpp9RG2jRGenAA/kx524CeJiWCs+O43vJd75iahVw4r7azdpuoG
	 ih4g/Bqj1kRABcLVXUizvnVYWf/0orFA2DNSfjCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 349/733] virtio-pci: return IRQ_HANDLED after non-zero ISR
Date: Thu, 17 Sep 2026 16:10:57 +0100
Message-ID: <20260917151400.266881868@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 10371ecbc054c..b90c174450b20 100644
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



