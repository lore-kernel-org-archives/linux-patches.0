Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC831AB507;
	Mon, 14 Oct 2024 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917007; cv=none; b=fu7gBtwcvpwLJwHkU3peusBpE5navTIv+JYvuaCDDpaC7G4wrKJol8+nSM0qWPYPqOBc4xVJI+OZDua65dg7a8B9JOXP/TcxH6yRCpaH/6NkPyrdvp1dHAThQsg4G7e40Kw0rvlJ4sKgsIUDTsH6soZZCJxLqSjZt2oBkzvYrPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917007; c=relaxed/simple;
	bh=UdJ7rtvO1X86t3UAlrBtL62rNY0XREjjmOa3cDDac1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O9ak+DAHSUfro27Ofk5FIHGumcNXGuo7NDsNbMo/YlvE35pzFm4zzfZdrpzy5k9cv1J/mIzMoRZZX5aBOhqHxqtJaiabj2R5OJ9K7w9Sxr3pg3jLcdrcBIEQMIDtqS0RVRppmWwdK5J7Q9X9yw5swshl74xsnqItU46qvVL26aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=khLnvRJl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="khLnvRJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C7D1C4CEC3;
	Mon, 14 Oct 2024 14:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917007;
	bh=UdJ7rtvO1X86t3UAlrBtL62rNY0XREjjmOa3cDDac1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=khLnvRJln5MCF61x6fYTczl8ceGZKGKzxQwvlwh54W6mtK+RPQmFUOZ3Vu6TgCcDV
	 6KJXrL3r0EsynfJVynXuy8TB+Vfd/ZfHyDcfN3S7RQkXjk5Uq/GvFurVl3PtrY6JND
	 1+fcZLE87F0uuRM8Pu6OGLJrCEJL8yKvooQK08ck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/213] thermal: intel: int340x: processor: Fix warning during module unload
Date: Mon, 14 Oct 2024 16:20:31 +0200
Message-ID: <20241014141047.851332361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 99ca0b57e49fb73624eede1c4396d9e3d10ccf14 ]

The processor_thermal driver uses pcim_device_enable() to enable a PCI
device, which means the device will be automatically disabled on driver
detach.  Thus there is no need to call pci_disable_device() again on it.

With recent PCI device resource management improvements, e.g. commit
f748a07a0b64 ("PCI: Remove legacy pcim_release()"), this problem is
exposed and triggers the warining below.

 [  224.010735] proc_thermal_pci 0000:00:04.0: disabling already-disabled device
 [  224.010747] WARNING: CPU: 8 PID: 4442 at drivers/pci/pci.c:2250 pci_disable_device+0xe5/0x100
 ...
 [  224.010844] Call Trace:
 [  224.010845]  <TASK>
 [  224.010847]  ? show_regs+0x6d/0x80
 [  224.010851]  ? __warn+0x8c/0x140
 [  224.010854]  ? pci_disable_device+0xe5/0x100
 [  224.010856]  ? report_bug+0x1c9/0x1e0
 [  224.010859]  ? handle_bug+0x46/0x80
 [  224.010862]  ? exc_invalid_op+0x1d/0x80
 [  224.010863]  ? asm_exc_invalid_op+0x1f/0x30
 [  224.010867]  ? pci_disable_device+0xe5/0x100
 [  224.010869]  ? pci_disable_device+0xe5/0x100
 [  224.010871]  ? kfree+0x21a/0x2b0
 [  224.010873]  pcim_disable_device+0x20/0x30
 [  224.010875]  devm_action_release+0x16/0x20
 [  224.010878]  release_nodes+0x47/0xc0
 [  224.010880]  devres_release_all+0x9f/0xe0
 [  224.010883]  device_unbind_cleanup+0x12/0x80
 [  224.010885]  device_release_driver_internal+0x1ca/0x210
 [  224.010887]  driver_detach+0x4e/0xa0
 [  224.010889]  bus_remove_driver+0x6f/0xf0
 [  224.010890]  driver_unregister+0x35/0x60
 [  224.010892]  pci_unregister_driver+0x44/0x90
 [  224.010894]  proc_thermal_pci_driver_exit+0x14/0x5f0 [processor_thermal_device_pci]
 ...
 [  224.010921] ---[ end trace 0000000000000000 ]---

Remove the excess pci_disable_device() calls.

Fixes: acd65d5d1cf4 ("thermal/drivers/int340x/processor_thermal: Add PCI MMIO based thermal driver")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20240930081801.28502-3-rui.zhang@intel.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_device_pci.c        | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
index e7a0f17cdbe4b..24eaec5d095c1 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device_pci.c
@@ -280,7 +280,6 @@ static int proc_thermal_pci_probe(struct pci_dev *pdev, const struct pci_device_
 	if (!pci_info->no_legacy)
 		proc_thermal_remove(proc_priv);
 	proc_thermal_mmio_remove(pdev, proc_priv);
-	pci_disable_device(pdev);
 
 	return ret;
 }
@@ -302,7 +301,6 @@ static void proc_thermal_pci_remove(struct pci_dev *pdev)
 	proc_thermal_mmio_remove(pdev, pci_info->proc_priv);
 	if (!pci_info->no_legacy)
 		proc_thermal_remove(proc_priv);
-	pci_disable_device(pdev);
 }
 
 #ifdef CONFIG_PM_SLEEP
-- 
2.43.0



