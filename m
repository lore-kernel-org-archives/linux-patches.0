Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73525A355;
	Tue, 21 Oct 2025 20:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077342; cv=none; b=j8iy7UhzRateFFRtFnWkGnM/oqxZCPiL+o/bX2GaVQgg1clvo32p0XnXucj+aVEDgDdnQDB8kMPb8HP8J6otqtA8PmLMeYM7nHVCW1n1ZOjV0OBnoBIm4xsgwmdPU2puVaO3tOeHwmAj3Ie2oWUdMy/Axwc2FPIzjPVcJ4eseDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077342; c=relaxed/simple;
	bh=Rwj+4aCa3BEc3Z1EysMvoL6YXwqBwGAI+3h/uaWEmRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fgv0ZJzYPmNGpPU8lqyCXMDlit0fxrEsc4o+ehDkG3rlUL7D6JXVWy9DZfIVIrAAMRoGIL/0sc6u2tzDEa/0tlnVC8lgZgZBO2vSTxfeH5ks3uESrSJyKWLHXaS5b2CC4RRn+Jilt1kQ36fbfy0WIuF58aBKKOxZ1bcVkqvdhHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Abp9/gqf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Abp9/gqf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC68FC4CEF1;
	Tue, 21 Oct 2025 20:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077342;
	bh=Rwj+4aCa3BEc3Z1EysMvoL6YXwqBwGAI+3h/uaWEmRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Abp9/gqf3uQWbEgdHRpGa+EOlfC7Vg0atfmBLvcs/Y8TwKGSW/aaR3oNimMfeuXG+
	 iRVbsU0CCovPt+Yx0yBc6LOwGCzdhiOLVo2bL5Vu9eJ4y66P5t5uhmZmPHUpvH1XNn
	 hetvt349fsBRvBM/q5fQKxHxqDGhvMZn0/CeBDFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Rinitha S <sx.rinitha@intel.com>,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/159] ixgbe: fix too early devlink_free() in ixgbe_remove()
Date: Tue, 21 Oct 2025 21:50:51 +0200
Message-ID: <20251021195044.980187571@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 5feef67b646d8f5064bac288e22204ffba2b9a4a ]

Since ixgbe_adapter is embedded in devlink, calling devlink_free()
prematurely in the ixgbe_remove() path can lead to UAF. Move devlink_free()
to the end.

KASAN report:

 BUG: KASAN: use-after-free in ixgbe_reset_interrupt_capability+0x140/0x180 [ixgbe]
 Read of size 8 at addr ffff0000adf813e0 by task bash/2095
 CPU: 1 UID: 0 PID: 2095 Comm: bash Tainted: G S  6.17.0-rc2-tnguy.net-queue+ #1 PREEMPT(full)
 [...]
 Call trace:
  show_stack+0x30/0x90 (C)
  dump_stack_lvl+0x9c/0xd0
  print_address_description.constprop.0+0x90/0x310
  print_report+0x104/0x1f0
  kasan_report+0x88/0x180
  __asan_report_load8_noabort+0x20/0x30
  ixgbe_reset_interrupt_capability+0x140/0x180 [ixgbe]
  ixgbe_clear_interrupt_scheme+0xf8/0x130 [ixgbe]
  ixgbe_remove+0x2d0/0x8c0 [ixgbe]
  pci_device_remove+0xa0/0x220
  device_remove+0xb8/0x170
  device_release_driver_internal+0x318/0x490
  device_driver_detach+0x40/0x68
  unbind_store+0xec/0x118
  drv_attr_store+0x64/0xb8
  sysfs_kf_write+0xcc/0x138
  kernfs_fop_write_iter+0x294/0x440
  new_sync_write+0x1fc/0x588
  vfs_write+0x480/0x6a0
  ksys_write+0xf0/0x1e0
  __arm64_sys_write+0x70/0xc0
  invoke_syscall.constprop.0+0xcc/0x280
  el0_svc_common.constprop.0+0xa8/0x248
  do_el0_svc+0x44/0x68
  el0_svc+0x54/0x160
  el0t_64_sync_handler+0xa0/0xe8
  el0t_64_sync+0x1b0/0x1b8

Fixes: a0285236ab93 ("ixgbe: add initial devlink support")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Tested-by: Rinitha S <sx.rinitha@intel.com>
Reviewed-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20251009-jk-iwl-net-2025-10-01-v3-6-ef32a425b92a@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 6218bdb7f941f..86b9caece1042 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -12091,7 +12091,6 @@ static void ixgbe_remove(struct pci_dev *pdev)
 
 	devl_port_unregister(&adapter->devlink_port);
 	devl_unlock(adapter->devlink);
-	devlink_free(adapter->devlink);
 
 	ixgbe_stop_ipsec_offload(adapter);
 	ixgbe_clear_interrupt_scheme(adapter);
@@ -12127,6 +12126,8 @@ static void ixgbe_remove(struct pci_dev *pdev)
 
 	if (disable_dev)
 		pci_disable_device(pdev);
+
+	devlink_free(adapter->devlink);
 }
 
 /**
-- 
2.51.0



