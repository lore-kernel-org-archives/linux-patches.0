Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D934198845;
	Thu,  6 Jun 2024 14:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683034; cv=none; b=ZG2yUxpzZZs0cmKnsnmLPDgGwQDeyTRUXXjA3pA++tetr3Gc9hL5CYh9glc0jtWsk38Tjy2xkrWQiWenvzOVKaAoJ60Pv9PlwiwDaS5AnuY5np3vYvaPwHWZypm7C9jwY6z5XQo8CJOe6+aXogF9UxI1G2zKMDhgucTIUgOFVTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683034; c=relaxed/simple;
	bh=sh4dLZfuk1G9xvlqRFH4UwRfoftDnIgUaR2R4uffrwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ii0WzdPimWd+t5OM2cp0kwTMtkVIDuVFesX+prEnft28mpJ5vhJIjoABlswfrBmk1TB8VPCKncP8juPHZsGEA+/RuZnrJ40zS7A8Hz0CFmRkjpvLsu06Lk67S8NKtQO841Dgh+7AiW35LFIVOAdgXaR2EqjyHfw2NUxC2tf9W9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r/x4a0iJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r/x4a0iJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C8D0C4AF15;
	Thu,  6 Jun 2024 14:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683034;
	bh=sh4dLZfuk1G9xvlqRFH4UwRfoftDnIgUaR2R4uffrwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r/x4a0iJjjsgKyXR2CLD5CHY4/f4SAFgB8EnmOnDiFDKsuthuKbUVIF0tDIcTqttX
	 htKCtF3e6iKzmVqZE8rijiMObZ56tNLpXFcyOhaAhIONf9RTiaWMPTRcvqdjW+CGYF
	 uaxgNXsc6Lafz8/+tKFRszzeoMl1ZcWDw8X7h1VY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 260/374] virtio: delete vq in vp_find_vqs_msix() when request_irq() fails
Date: Thu,  6 Jun 2024 16:03:59 +0200
Message-ID: <20240606131700.593230432@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 89875151fccdd024d571aa884ea97a0128b968b6 ]

When request_irq() fails, error path calls vp_del_vqs(). There, as vq is
present in the list, free_irq() is called for the same vector. That
causes following splat:

[    0.414355] Trying to free already-free IRQ 27
[    0.414403] WARNING: CPU: 1 PID: 1 at kernel/irq/manage.c:1899 free_irq+0x1a1/0x2d0
[    0.414510] Modules linked in:
[    0.414540] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.9.0-rc4+ #27
[    0.414540] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-1.fc39 04/01/2014
[    0.414540] RIP: 0010:free_irq+0x1a1/0x2d0
[    0.414540] Code: 1e 00 48 83 c4 08 48 89 e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 90 8b 74 24 04 48 c7 c7 98 80 6c b1 e8 00 c9 f7 ff 90 <0f> 0b 90 90 48 89 ee 4c 89 ef e8 e0 20 b8 00 49 8b 47 40 48 8b 40
[    0.414540] RSP: 0000:ffffb71480013ae0 EFLAGS: 00010086
[    0.414540] RAX: 0000000000000000 RBX: ffffa099c2722000 RCX: 0000000000000000
[    0.414540] RDX: 0000000000000000 RSI: ffffb71480013998 RDI: 0000000000000001
[    0.414540] RBP: 0000000000000246 R08: 00000000ffffdfff R09: 0000000000000001
[    0.414540] R10: 00000000ffffdfff R11: ffffffffb18729c0 R12: ffffa099c1c91760
[    0.414540] R13: ffffa099c1c916a4 R14: ffffa099c1d2f200 R15: ffffa099c1c91600
[    0.414540] FS:  0000000000000000(0000) GS:ffffa099fec40000(0000) knlGS:0000000000000000
[    0.414540] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.414540] CR2: 0000000000000000 CR3: 0000000008e3e001 CR4: 0000000000370ef0
[    0.414540] Call Trace:
[    0.414540]  <TASK>
[    0.414540]  ? __warn+0x80/0x120
[    0.414540]  ? free_irq+0x1a1/0x2d0
[    0.414540]  ? report_bug+0x164/0x190
[    0.414540]  ? handle_bug+0x3b/0x70
[    0.414540]  ? exc_invalid_op+0x17/0x70
[    0.414540]  ? asm_exc_invalid_op+0x1a/0x20
[    0.414540]  ? free_irq+0x1a1/0x2d0
[    0.414540]  vp_del_vqs+0xc1/0x220
[    0.414540]  vp_find_vqs_msix+0x305/0x470
[    0.414540]  vp_find_vqs+0x3e/0x1a0
[    0.414540]  vp_modern_find_vqs+0x1b/0x70
[    0.414540]  init_vqs+0x387/0x600
[    0.414540]  virtnet_probe+0x50a/0xc80
[    0.414540]  virtio_dev_probe+0x1e0/0x2b0
[    0.414540]  really_probe+0xc0/0x2c0
[    0.414540]  ? __pfx___driver_attach+0x10/0x10
[    0.414540]  __driver_probe_device+0x73/0x120
[    0.414540]  driver_probe_device+0x1f/0xe0
[    0.414540]  __driver_attach+0x88/0x180
[    0.414540]  bus_for_each_dev+0x85/0xd0
[    0.414540]  bus_add_driver+0xec/0x1f0
[    0.414540]  driver_register+0x59/0x100
[    0.414540]  ? __pfx_virtio_net_driver_init+0x10/0x10
[    0.414540]  virtio_net_driver_init+0x90/0xb0
[    0.414540]  do_one_initcall+0x58/0x230
[    0.414540]  kernel_init_freeable+0x1a3/0x2d0
[    0.414540]  ? __pfx_kernel_init+0x10/0x10
[    0.414540]  kernel_init+0x1a/0x1c0
[    0.414540]  ret_from_fork+0x31/0x50
[    0.414540]  ? __pfx_kernel_init+0x10/0x10
[    0.414540]  ret_from_fork_asm+0x1a/0x30
[    0.414540]  </TASK>

Fix this by calling deleting the current vq when request_irq() fails.

Fixes: 0b0f9dc52ed0 ("Revert "virtio_pci: use shared interrupts for virtqueues"")
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Message-Id: <20240426150845.3999481-1-jiri@resnulli.us>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_pci_common.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
index b655fccaf7733..584af7816532b 100644
--- a/drivers/virtio/virtio_pci_common.c
+++ b/drivers/virtio/virtio_pci_common.c
@@ -348,8 +348,10 @@ static int vp_find_vqs_msix(struct virtio_device *vdev, unsigned int nvqs,
 				  vring_interrupt, 0,
 				  vp_dev->msix_names[msix_vec],
 				  vqs[i]);
-		if (err)
+		if (err) {
+			vp_del_vq(vqs[i]);
 			goto error_find;
+		}
 	}
 	return 0;
 
-- 
2.43.0



