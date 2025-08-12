Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24E82FDC52;
	Tue, 12 Aug 2025 18:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021748; cv=none; b=fVJGpscSUl2xaNmOOu+0ctKju+7sbcDzvNebaj0xAO6gzpheLe7SKm8UOM7SqX1NuM7aISnPGrRaPX80RMcsxulXpJP8THiWROhPYQwdaJTtMIi8FFXtU0svIKOmAKwjl5+YqOP7PtEBiC5VJ9f8JtTVdvKxjqCdrv4mXIpItFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021748; c=relaxed/simple;
	bh=M2JRQNS+USDgaGb039mm7DL/jIEDh7Kg6VPeRKXsTkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRj5m1AqNdER/hN0mYbA5Kl6bfcFPQA8n13Eff2XMdFnZGloowTHNSai6bTB0m9te+qoIWmwHl3pn04rCWaM6JNFgLezr7d1Xzd0IrMO+EBCYZ7tYFj2a4qBSZV+PxZCED0J9+wlWzCR1eBpk9HJ+bdpnpYKjhen/iZ4o/6cuXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5C10BsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5C10BsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB26C4CEF0;
	Tue, 12 Aug 2025 18:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021748;
	bh=M2JRQNS+USDgaGb039mm7DL/jIEDh7Kg6VPeRKXsTkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5C10BsXSQJ/HB8QpNM2qcrIOVd/rX0DOOa3PTYZezP0D+VEOQQ9Y/scxmA+aEAd/
	 y8OG6R8JKo50gK+oqF/iNNpLtznKj0lOsEr6aNkDzg7VwfcCiG1znNpZvln6r52U46
	 WtLTnMafYQOqs3QhcvF3++WQbk7RbT3EmEZL1lug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/262] benet: fix BUG when creating VFs
Date: Tue, 12 Aug 2025 19:30:01 +0200
Message-ID: <20250812173002.217817466@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



