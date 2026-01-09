Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A821C35BDC5;
	Fri,  9 Jan 2026 12:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963127; cv=none; b=OeNhLCcg0oxSKFoXq3aYnISSSMQeCqJ4YNRHcMvB8CmdfrmWdcLn1RHpDumxk7+IRUoh3vAzw6+TPN3kYQMzt6yzgYxvF8SK1uuB5FvmlTaZoxbXes7rFx3Z+p3v+IZxsvlT4IegZASbMhSGo+flg/3lQwwUWy+YDos2c9vyJU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963127; c=relaxed/simple;
	bh=8zo6kgnm+u+8Bg0CZJTFqn/Z7+YmJ8GBf19OI6AhFhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HLvu9/zxXfRQGZ13N9a6GUhJUjW9A3jPr+FsbQotj2bt73Bq5qy+OmddG4QEyb9owaEQI6lMaTuAJbL2ArkJ+nvZgTNhUeMAVTw/aT8skGQ6UgHWMGRWbLeo6+npGPVL2rsIWHxBPsE9yk4qpo1GTLzR5DPGih/dbFr8O3wjqSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EM7TS0TH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EM7TS0TH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35BC6C4CEF1;
	Fri,  9 Jan 2026 12:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963127;
	bh=8zo6kgnm+u+8Bg0CZJTFqn/Z7+YmJ8GBf19OI6AhFhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EM7TS0THSQtbCO1hoTwqJRi5/EYpEKUuuOG6FOE3wc0ZXaHTtzGoY2mwLZaM9Qehd
	 Rjgs6ffXatHuRA32Lm4Hk560w60lnNW0xlkMK0In8BNv6Cg1TszBNPj8hBXq+gs5LV
	 wUd1dvIzW1SMmoVmV7RPmfHEZgaaOZ+Ilp8mqgLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Sun <yi.sun@intel.com>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Bin Lan <lanbincn@139.com>
Subject: [PATCH 6.1 607/634] dmaengine: idxd: Remove improper idxd_free
Date: Fri,  9 Jan 2026 12:44:45 +0100
Message-ID: <20260109112140.469719921@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Sun <yi.sun@intel.com>

[ Upstream commit f41c538881eec4dcf5961a242097d447f848cda6 ]

The call to idxd_free() introduces a duplicate put_device() leading to a
reference count underflow:
refcount_t: underflow; use-after-free.
WARNING: CPU: 15 PID: 4428 at lib/refcount.c:28 refcount_warn_saturate+0xbe/0x110
...
Call Trace:
 <TASK>
  idxd_remove+0xe4/0x120 [idxd]
  pci_device_remove+0x3f/0xb0
  device_release_driver_internal+0x197/0x200
  driver_detach+0x48/0x90
  bus_remove_driver+0x74/0xf0
  pci_unregister_driver+0x2e/0xb0
  idxd_exit_module+0x34/0x7a0 [idxd]
  __do_sys_delete_module.constprop.0+0x183/0x280
  do_syscall_64+0x54/0xd70
  entry_SYSCALL_64_after_hwframe+0x76/0x7e

The idxd_unregister_devices() which is invoked at the very beginning of
idxd_remove(), already takes care of the necessary put_device() through the
following call path:
idxd_unregister_devices() -> device_unregister() -> put_device()

In addition, when CONFIG_DEBUG_KOBJECT_RELEASE is enabled, put_device() may
trigger asynchronous cleanup via schedule_delayed_work(). If idxd_free() is
called immediately after, it can result in a use-after-free.

Remove the improper idxd_free() to avoid both the refcount underflow and
potential memory corruption during module unload.

Fixes: d5449ff1b04d ("dmaengine: idxd: Add missing idxd cleanup to fix memory leak in remove call")
Signed-off-by: Yi Sun <yi.sun@intel.com>
Tested-by: Shuai Xue <xueshuai@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>

Link: https://lore.kernel.org/r/20250729150313.1934101-2-yi.sun@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
[ Slightly adjust the context. ]
Signed-off-by: Bin Lan <lanbincn@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Without this patch, this issue can be reproduced in Linux-6.1.y 
when the idxd module is removed.
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/init.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -816,7 +816,6 @@ static void idxd_remove(struct pci_dev *
 	destroy_workqueue(idxd->wq);
 	perfmon_pmu_remove(idxd);
 	put_device(idxd_confdev(idxd));
-	idxd_free(idxd);
 }
 
 static struct pci_driver idxd_pci_driver = {


