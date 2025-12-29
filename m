Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D249F33066A;
	Mon, 29 Dec 2025 16:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025109; cv=none; b=iO9d8ztI13SBRRdliAAS0DB7ZCffIDEqNyTI3ikijP2zDdvklk5vvT2v2ZXgsNTJY4biVod2En49V2KD4VbPYq+PQSSSrJviCquFTvJdAa/WlZK8xZfgC3Ya2hRlpxo65+Q2zaFUs6nRXRV5TwQ7xQd4Tr5LhnUPifPSFLmdVno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025109; c=relaxed/simple;
	bh=tsLwUdn7JWuTcIZIs8ic6NC3BCDNXzS6ntZdl4DGhyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smj0F+DpVMFmDrm7Co1VXBkHBz3r0o4poPT9gbNdj3zqgoKvqZv9pmUtqDbl9fEfUjsPiA3JC8OAfLdSmEVf3Nc6Pe1opEMbfRyd2+uPOC7MB+LR31p/nqmjJuCrFopLpYKQTEe7Tju0zvSiboF+MpnAWK9tSl64lEVxK4ZqgnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqZjcYsK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqZjcYsK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572DDC4CEF7;
	Mon, 29 Dec 2025 16:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025109;
	bh=tsLwUdn7JWuTcIZIs8ic6NC3BCDNXzS6ntZdl4DGhyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqZjcYsKZnuu9zPJ3JTef3g5c6hgbdOBp4C4D+up2rq6o0yue1KrMe+A4RXenNvTE
	 ibcfHfLDOiKnwYzDQxDiUSLzZ/ZTmoRx7xXNXFstHDwHRsIhtB3PRyimoBGBVqFW4C
	 cvYuFdtd4HEdE15HHI12zrapmKslWvDjC0pk/dVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gerd Bayer <gbayer@linux.ibm.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/430] net/mlx5: Fix double unregister of HCA_PORTS component
Date: Mon, 29 Dec 2025 17:07:47 +0100
Message-ID: <20251229160726.757624181@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Gerd Bayer <gbayer@linux.ibm.com>

[ Upstream commit 6a107cfe9c99a079e578a4c5eb70038101a3599f ]

Clear hca_devcom_comp in device's private data after unregistering it in
LAG teardown. Otherwise a slightly lagging second pass through
mlx5_unload_one() might try to unregister it again and trip over
use-after-free.

On s390 almost all PCI level recovery events trigger two passes through
mxl5_unload_one() - one through the poll_health() method and one through
mlx5_pci_err_detected() as callback from generic PCI error recovery.
While testing PCI error recovery paths with more kernel debug features
enabled, this issue reproducibly led to kernel panics with the following
call chain:

 Unable to handle kernel pointer dereference in virtual kernel address space
 Failing address: 6b6b6b6b6b6b6000 TEID: 6b6b6b6b6b6b6803 ESOP-2 FSI
 Fault in home space mode while using kernel ASCE.
 AS:00000000705c4007 R3:0000000000000024
 Oops: 0038 ilc:3 [#1]SMP

 CPU: 14 UID: 0 PID: 156 Comm: kmcheck Kdump: loaded Not tainted
      6.18.0-20251130.rc7.git0.16131a59cab1.300.fc43.s390x+debug #1 PREEMPT

 Krnl PSW : 0404e00180000000 0000020fc86aa1dc (__lock_acquire+0x5c/0x15f0)
            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:2 PM:0 RI:0 EA:3
 Krnl GPRS: 0000000000000000 0000020f00000001 6b6b6b6b6b6b6c33 0000000000000000
            0000000000000000 0000000000000000 0000000000000001 0000000000000000
            0000000000000000 0000020fca28b820 0000000000000000 0000010a1ced8100
            0000010a1ced8100 0000020fc9775068 0000018fce14f8b8 0000018fce14f7f8
 Krnl Code: 0000020fc86aa1cc: e3b003400004        lg      %r11,832
            0000020fc86aa1d2: a7840211           brc     8,0000020fc86aa5f4
           *0000020fc86aa1d6: c09000df0b25       larl    %r9,0000020fca28b820
           >0000020fc86aa1dc: d50790002000       clc     0(8,%r9),0(%r2)
            0000020fc86aa1e2: a7840209           brc     8,0000020fc86aa5f4
            0000020fc86aa1e6: c0e001100401       larl    %r14,0000020fca8aa9e8
            0000020fc86aa1ec: c01000e25a00       larl    %r1,0000020fca2f55ec
            0000020fc86aa1f2: a7eb00e8           aghi    %r14,232

 Call Trace:
  __lock_acquire+0x5c/0x15f0
  lock_acquire.part.0+0xf8/0x270
  lock_acquire+0xb0/0x1b0
  down_write+0x5a/0x250
  mlx5_detach_device+0x42/0x110 [mlx5_core]
  mlx5_unload_one_devl_locked+0x50/0xc0 [mlx5_core]
  mlx5_unload_one+0x42/0x60 [mlx5_core]
  mlx5_pci_err_detected+0x94/0x150 [mlx5_core]
  zpci_event_attempt_error_recovery+0xcc/0x388

Fixes: 5a977b5833b7 ("net/mlx5: Lag, move devcom registration to LAG layer")
Signed-off-by: Gerd Bayer <gbayer@linux.ibm.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Acked-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20251202-fix_lag-v1-1-59e8177ffce0@linux.ibm.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 3db0387bf6dcb..8ec04a5f434dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -1413,6 +1413,7 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 static void mlx5_lag_unregister_hca_devcom_comp(struct mlx5_core_dev *dev)
 {
 	mlx5_devcom_unregister_component(dev->priv.hca_devcom_comp);
+	dev->priv.hca_devcom_comp = NULL;
 }
 
 static int mlx5_lag_register_hca_devcom_comp(struct mlx5_core_dev *dev)
-- 
2.51.0



