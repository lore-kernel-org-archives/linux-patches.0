Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20EE92D0C9F;
	Tue, 12 Aug 2025 19:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026789; cv=none; b=vGn5PagMNOZsMl745bqs0lav++/ooPaAorGshV4e+FdiSbzUqiuNsiABKeSXN5lv2e00MOcf+40q7KcVa+0+A95kV69jwL04TYILlMK4FHsrrX4T78npz+EqDswwPtDah63FqGhnrux+Bq6cotMyfBc1IWTE2B7wLjSdzwRg0cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026789; c=relaxed/simple;
	bh=13RbbqSyf8PirpozC8YL8tMrY/q8+raGUsJIImKHhmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSRmA3DmCPET4qPmLKhywOBa2KmV/EQ1tDrDjmp8gffeOz5oucD3EK/tG8vZaWFzJ9u4pYBdFOIm4qQtcJngNEO34wN1ymUKYjyVVAb9E//NCxP98tF4l6McqCb4DAjBtDtOOC7I3xvpaLxTUV1/zaI/Rjhz1pJ0dXGWWIt33jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pL4YjIKF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pL4YjIKF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8860CC4CEF0;
	Tue, 12 Aug 2025 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026787;
	bh=13RbbqSyf8PirpozC8YL8tMrY/q8+raGUsJIImKHhmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pL4YjIKFGtDmI20Bvg4ZpYxE2RhanLNiQZt1lsN4plumAVr9IvsPOPSd9OqIs+apG
	 DhKu8W+fi8x7MBn5ER9egD62AHTuTk0vxG8T92tmmA3yptpIqIgn70AJ7+fkpkSVcZ
	 vEkbWgR28XQMbJ01VmxR4aVIGAj158GiUyBz3Rz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 408/480] benet: fix BUG when creating VFs
Date: Tue, 12 Aug 2025 19:50:16 +0200
Message-ID: <20250812174414.260641508@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 5a40f8af2ba1b9bdf46e2db10e8c9710538fbc63 ]

benet crashes as soon as SRIOV VFs are created:

 kernel BUG at mm/vmalloc.c:3457!
 Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
 CPU: 4 UID: 0 PID: 7408 Comm: test.sh Kdump: loaded Not tainted 6.16.0+ #1 PREEMPT(voluntary)
 [...]
 RIP: 0010:vunmap+0x5f/0x70
 [...]
 Call Trace:
  <TASK>
  __iommu_dma_free+0xe8/0x1c0
  be_cmd_set_mac_list+0x3fe/0x640 [be2net]
  be_cmd_set_mac+0xaf/0x110 [be2net]
  be_vf_eth_addr_config+0x19f/0x330 [be2net]
  be_vf_setup+0x4f7/0x990 [be2net]
  be_pci_sriov_configure+0x3a1/0x470 [be2net]
  sriov_numvfs_store+0x20b/0x380
  kernfs_fop_write_iter+0x354/0x530
  vfs_write+0x9b9/0xf60
  ksys_write+0xf3/0x1d0
  do_syscall_64+0x8c/0x3d0

be_cmd_set_mac_list() calls dma_free_coherent() under a spin_lock_bh.
Fix it by freeing only after the lock has been released.

Fixes: 1a82d19ca2d6 ("be2net: fix sleeping while atomic bugs in be_ndo_bridge_getlink")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250801101338.72502-1-mschmidt@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_cmds.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_cmds.c b/drivers/net/ethernet/emulex/benet/be_cmds.c
index a89aa4ac0a06..779f1324bb5f 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -3852,8 +3852,8 @@ int be_cmd_set_mac_list(struct be_adapter *adapter, u8 *mac_array,
 	status = be_mcc_notify_wait(adapter);
 
 err:
-	dma_free_coherent(&adapter->pdev->dev, cmd.size, cmd.va, cmd.dma);
 	spin_unlock_bh(&adapter->mcc_lock);
+	dma_free_coherent(&adapter->pdev->dev, cmd.size, cmd.va, cmd.dma);
 	return status;
 }
 
-- 
2.39.5



