Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E11D3C3F56;
	Wed, 30 Sep 2026 19:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795357; cv=none; b=Ka1Kn0zoPoUklUi1AL/EWumcHEsIAzqZrxtwjzHV2ZggVDazJIk62Mf2hdM+n0r4K6N0r1z1CCkqjxilZ/vUwRHEVltpW98sgxpdK+JZiDc2HpQw7Xw4uNhYInI4ykgTPq5BcZ5F7z3qulq4Udm8Q78x/QMo2+QLwrHFtE8n03o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795357; c=relaxed/simple;
	bh=HZAzHgYgHCKdSMjCNuRrJ+ps1CPWyc7BSD4Y5K8IsCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WBxVQUEWzobX94EG7f5npYG0gQOQBWU2JcQO3rHDxfVO5SkDEAgaO2nzGR4ouvsERQQKaLf3ulxjQUZIqHk4bBhs9Rturzt+/dIeo4FV5Pf8Af+a7O4MuEMRtzZ+vra5y5mDFGvJbuPYekCYUA2c+lBaDL5NlOtqGSXTVcgXOHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUPPX0Zv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUPPX0Zv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79AF41F000FF;
	Wed, 30 Sep 2026 19:09:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795356;
	bh=UHmb7pLdWfWhcG+QBNqxkWdkhboVo8l/pDJsrzuzi9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BUPPX0Zv8aXvCm5oUBEpYxXHhk9XuPmlbw5WVrrI4vp+rQoswHxJavVRdiWKXfdAV
	 KMOeQ/VI9r0y2WJ2Y0zHNoTHoiQhN5Z06/Yo3P4Tio81+oGwgA9Dx2iZNGmR7l05sB
	 Qw8niBknzg84JazLjxfPTraRyTq9kTqxEZbyqezQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Andrew Stellman <astellman@stellman-greene.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0534/1193] virtio-pci: return IRQ_HANDLED after non-zero ISR
Date: Wed, 30 Sep 2026 17:20:18 +0200
Message-ID: <20260930152446.075442463@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 64dfa54d702f1..48fa07ef59222 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -96,7 +96,9 @@ static irqreturn_t vp_interrupt(int irq, void *opaque)
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



