Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB492F2909;
	Mon, 22 Sep 2025 19:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570138; cv=none; b=SXZ4jCldG8QdmNnDA8m3fNNbSkHl8JqXFKcbh7JuLlSJfLHLYCq9IQEFCHTN+JDHTymKrd/bJXoSEsgtRrQussxg2ZFTd9FIu0LTsXduem7CnM7JOVxqoUe41LM0PJoQrUuDBMTqq7FPUWq2IcMc+ieGQ7YJ4hmhYZVJo82K6lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570138; c=relaxed/simple;
	bh=8ZeLbHhSoCRk2S9s+Fhlq8DbfEZyrz2ObiP1XInpAPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xfoguc+3h37uN97aRfzsKbEJ/UYQIJgPSFI46cTEWrfsBE8Egq1UirSfyskZGBC/TwVCF4UBUw45xs4kufWHHsTPVhTgrXGJtlS3Mtl2nx1nzE0RQSicYEDVaq5lek8F76CfOmKE35YusMeDqVxurwUvrbzqYNo1eMoriswpQUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/NBza+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/NBza+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 154CBC4CEF0;
	Mon, 22 Sep 2025 19:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570138;
	bh=8ZeLbHhSoCRk2S9s+Fhlq8DbfEZyrz2ObiP1XInpAPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/NBza+VmsiVFeiZMFURtRjayrDDnMNOMH3UNNQBbFNhQ53Zmsaa1lJvCBdcJ3fp4
	 rV4OjnwILiQ0L1MFRmCyYvCOgfg/sqyL6OYqCYsIypZ5MTwwUZU20UVhY44I+GYLe6
	 NLPRjEkbX38DYWqxVdaQ2zeeYwDvmoWDZPq90W8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 033/149] ixgbe: destroy aci.lock later within ixgbe_remove path
Date: Mon, 22 Sep 2025 21:28:53 +0200
Message-ID: <20250922192413.700944706@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jedrzej Jagielski <jedrzej.jagielski@intel.com>

[ Upstream commit 316ba68175b04a9f6f75295764789ea94e31d48c ]

There's another issue with aci.lock and previous patch uncovers it.
aci.lock is being destroyed during removing ixgbe while some of the
ixgbe closing routines are still ongoing. These routines use Admin
Command Interface which require taking aci.lock which has been already
destroyed what leads to call trace.

[  +0.000004] DEBUG_LOCKS_WARN_ON(lock->magic != lock)
[  +0.000007] WARNING: CPU: 12 PID: 10277 at kernel/locking/mutex.c:155 mutex_lock+0x5f/0x70
[  +0.000002] Call Trace:
[  +0.000003]  <TASK>
[  +0.000006]  ixgbe_aci_send_cmd+0xc8/0x220 [ixgbe]
[  +0.000049]  ? try_to_wake_up+0x29d/0x5d0
[  +0.000009]  ixgbe_disable_rx_e610+0xc4/0x110 [ixgbe]
[  +0.000032]  ixgbe_disable_rx+0x3d/0x200 [ixgbe]
[  +0.000027]  ixgbe_down+0x102/0x3b0 [ixgbe]
[  +0.000031]  ixgbe_close_suspend+0x28/0x90 [ixgbe]
[  +0.000028]  ixgbe_close+0xfb/0x100 [ixgbe]
[  +0.000025]  __dev_close_many+0xae/0x220
[  +0.000005]  dev_close_many+0xc2/0x1a0
[  +0.000004]  ? kernfs_should_drain_open_files+0x2a/0x40
[  +0.000005]  unregister_netdevice_many_notify+0x204/0xb00
[  +0.000006]  ? __kernfs_remove.part.0+0x109/0x210
[  +0.000006]  ? kobj_kset_leave+0x4b/0x70
[  +0.000008]  unregister_netdevice_queue+0xf6/0x130
[  +0.000006]  unregister_netdev+0x1c/0x40
[  +0.000005]  ixgbe_remove+0x216/0x290 [ixgbe]
[  +0.000021]  pci_device_remove+0x42/0xb0
[  +0.000007]  device_release_driver_internal+0x19c/0x200
[  +0.000008]  driver_detach+0x48/0x90
[  +0.000003]  bus_remove_driver+0x6d/0xf0
[  +0.000006]  pci_unregister_driver+0x2e/0xb0
[  +0.000005]  ixgbe_exit_module+0x1c/0xc80 [ixgbe]

Same as for the previous commit, the issue has been highlighted by the
commit 337369f8ce9e ("locking/mutex: Add MUTEX_WARN_ON() into fast path").

Move destroying aci.lock to the end of ixgbe_remove(), as this
simply fixes the issue.

Fixes: 4600cdf9f5ac ("ixgbe: Enable link management in E610 device")
Signed-off-by: Jedrzej Jagielski <jedrzej.jagielski@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 2a857037dd102..d5c421451f319 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -11892,10 +11892,8 @@ static void ixgbe_remove(struct pci_dev *pdev)
 	set_bit(__IXGBE_REMOVING, &adapter->state);
 	cancel_work_sync(&adapter->service_task);
 
-	if (adapter->hw.mac.type == ixgbe_mac_e610) {
+	if (adapter->hw.mac.type == ixgbe_mac_e610)
 		ixgbe_disable_link_status_events(adapter);
-		mutex_destroy(&adapter->hw.aci.lock);
-	}
 
 	if (adapter->mii_bus)
 		mdiobus_unregister(adapter->mii_bus);
@@ -11955,6 +11953,9 @@ static void ixgbe_remove(struct pci_dev *pdev)
 	disable_dev = !test_and_set_bit(__IXGBE_DISABLED, &adapter->state);
 	free_netdev(netdev);
 
+	if (adapter->hw.mac.type == ixgbe_mac_e610)
+		mutex_destroy(&adapter->hw.aci.lock);
+
 	if (disable_dev)
 		pci_disable_device(pdev);
 }
-- 
2.51.0



