Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB281DF24A;
	Wed,  6 Nov 2024 12:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895555; cv=none; b=ZXMnwaz8yaoT9kRD/DbK0/gfaTCCe5TyI3LzphbfIeyQlAtUB7x4cRKmTLB3GVLzGhJ0cGnw4GsMpI/n20gOGufQHngYgaScIgkYnH3MQ2COai5kE3VkF6vh1U5hEjcn4z9Nlogx+yLBD3WEcGdg2vQ4CKiB1iNAvdf4j5xas30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895555; c=relaxed/simple;
	bh=ui3y6GPmiiqLKCaC1mYk+SnkYU7YVMt7wMIJNtrIlp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QR7/Pzx8k1kSabplIMPvqpienj0RT7CYODICOVvzBE3cy3cS/xaG5ATSF8Tqh8Q3Kh03zGbjskGpFxC1/2QFQCT4cEFw9QKALMdrrxvQFBs9u0kYWWlJR+eWMWv/LDzlFuKeIlHc1U5twmspfrx+u+r79fcjr/0eyV2ehlF6cXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SEJUU2KQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SEJUU2KQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3100CC4CECD;
	Wed,  6 Nov 2024 12:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895555;
	bh=ui3y6GPmiiqLKCaC1mYk+SnkYU7YVMt7wMIJNtrIlp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SEJUU2KQAOvhCJEwpDdiFnIjHeBkm1TuqI18H95bN16p8r/xSlGdn6TNZc0PI9cc6
	 Qurlore4pH5sqnyuAZhiMBtx5QX5yWCVgwUB2Gf1YESoQLAcYSAUnwxuZ4MZQt+WLL
	 AmBxlZZq5Asw1rDLAwZ0DL/geAUXteZUF7X3V+2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamed Khalfella <mkhalfella@purestorage.com>,
	Yuanyuan Zhong <yzhong@purestorage.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com>
Subject: [PATCH 4.19 258/350] igb: Do not bring the device up after non-fatal error
Date: Wed,  6 Nov 2024 13:03:06 +0100
Message-ID: <20241106120327.283027836@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamed Khalfella <mkhalfella@purestorage.com>

[ Upstream commit 330a699ecbfc9c26ec92c6310686da1230b4e7eb ]

Commit 004d25060c78 ("igb: Fix igb_down hung on surprise removal")
changed igb_io_error_detected() to ignore non-fatal pcie errors in order
to avoid hung task that can happen when igb_down() is called multiple
times. This caused an issue when processing transient non-fatal errors.
igb_io_resume(), which is called after igb_io_error_detected(), assumes
that device is brought down by igb_io_error_detected() if the interface
is up. This resulted in panic with stacktrace below.

[ T3256] igb 0000:09:00.0 haeth0: igb: haeth0 NIC Link is Down
[  T292] pcieport 0000:00:1c.5: AER: Uncorrected (Non-Fatal) error received: 0000:09:00.0
[  T292] igb 0000:09:00.0: PCIe Bus Error: severity=Uncorrected (Non-Fatal), type=Transaction Layer, (Requester ID)
[  T292] igb 0000:09:00.0:   device [8086:1537] error status/mask=00004000/00000000
[  T292] igb 0000:09:00.0:    [14] CmpltTO [  200.105524,009][  T292] igb 0000:09:00.0: AER:   TLP Header: 00000000 00000000 00000000 00000000
[  T292] pcieport 0000:00:1c.5: AER: broadcast error_detected message
[  T292] igb 0000:09:00.0: Non-correctable non-fatal error reported.
[  T292] pcieport 0000:00:1c.5: AER: broadcast mmio_enabled message
[  T292] pcieport 0000:00:1c.5: AER: broadcast resume message
[  T292] ------------[ cut here ]------------
[  T292] kernel BUG at net/core/dev.c:6539!
[  T292] invalid opcode: 0000 [#1] PREEMPT SMP
[  T292] RIP: 0010:napi_enable+0x37/0x40
[  T292] Call Trace:
[  T292]  <TASK>
[  T292]  ? die+0x33/0x90
[  T292]  ? do_trap+0xdc/0x110
[  T292]  ? napi_enable+0x37/0x40
[  T292]  ? do_error_trap+0x70/0xb0
[  T292]  ? napi_enable+0x37/0x40
[  T292]  ? napi_enable+0x37/0x40
[  T292]  ? exc_invalid_op+0x4e/0x70
[  T292]  ? napi_enable+0x37/0x40
[  T292]  ? asm_exc_invalid_op+0x16/0x20
[  T292]  ? napi_enable+0x37/0x40
[  T292]  igb_up+0x41/0x150
[  T292]  igb_io_resume+0x25/0x70
[  T292]  report_resume+0x54/0x70
[  T292]  ? report_frozen_detected+0x20/0x20
[  T292]  pci_walk_bus+0x6c/0x90
[  T292]  ? aer_print_port_info+0xa0/0xa0
[  T292]  pcie_do_recovery+0x22f/0x380
[  T292]  aer_process_err_devices+0x110/0x160
[  T292]  aer_isr+0x1c1/0x1e0
[  T292]  ? disable_irq_nosync+0x10/0x10
[  T292]  irq_thread_fn+0x1a/0x60
[  T292]  irq_thread+0xe3/0x1a0
[  T292]  ? irq_set_affinity_notifier+0x120/0x120
[  T292]  ? irq_affinity_notify+0x100/0x100
[  T292]  kthread+0xe2/0x110
[  T292]  ? kthread_complete_and_exit+0x20/0x20
[  T292]  ret_from_fork+0x2d/0x50
[  T292]  ? kthread_complete_and_exit+0x20/0x20
[  T292]  ret_from_fork_asm+0x11/0x20
[  T292]  </TASK>

To fix this issue igb_io_resume() checks if the interface is running and
the device is not down this means igb_io_error_detected() did not bring
the device down and there is no need to bring it up.

Signed-off-by: Mohamed Khalfella <mkhalfella@purestorage.com>
Reviewed-by: Yuanyuan Zhong <yzhong@purestorage.com>
Fixes: 004d25060c78 ("igb: Fix igb_down hung on surprise removal")
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 01138fc93ea10..3a65dccc08ba8 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9151,6 +9151,10 @@ static void igb_io_resume(struct pci_dev *pdev)
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
 	if (netif_running(netdev)) {
+		if (!test_bit(__IGB_DOWN, &adapter->state)) {
+			dev_dbg(&pdev->dev, "Resuming from non-fatal error, do nothing.\n");
+			return;
+		}
 		if (igb_up(adapter)) {
 			dev_err(&pdev->dev, "igb_up failed after reset\n");
 			return;
-- 
2.43.0



