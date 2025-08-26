Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CF534A325;
	Tue, 26 Aug 2025 14:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217532; cv=none; b=kYrDZTdmEq2Jr5IcOqMYwTpUUqGEcWFOWHCmPMEQq2Idjbk+XXliwOoqtGJ1C2lI0edJI7dc15wsZBcp0OpoXOsUagjPXnNe/j/Sqlpwlb6GATY6i/tGowZ3NIg/nmuB5m+uy/8LveVrb1/a+pBMaCoMB9aUgzIEsPucwpMfoTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217532; c=relaxed/simple;
	bh=MqLWtnh/KJ4qHiHdUVtaZ2STsKpeKFOviDzgv6lGGLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rlwHl8cXwge0s+srzMoYxBPm3qI+foSjZAYJNnicUKq16DzI4gO/YukEsWB23c4KfhkOtAuY45MyRBa69/HmaULOo1mvgoRSruUmgUC8nOG0FX1Lbjw5veCSzCg00yuxsiqlR2BKNn/86l2JVC8qrmxGf+wRASCcvmIGs43Otd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZx9v+lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZx9v+lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A629C4CEF1;
	Tue, 26 Aug 2025 14:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217532;
	bh=MqLWtnh/KJ4qHiHdUVtaZ2STsKpeKFOviDzgv6lGGLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NZx9v+lc1iNX2PTAC0AJ76uFm3+yEbl0pMLgBDhjYCILMZQmBQgM2+GfgYwU504Ct
	 OfaUr8rDWrZeaLgq8BMXg2wngGVqLGrgVxoM91XmXm1C7mNkzUXPbnwIWUxdNqKgLW
	 2D1KmtWS0aHY/Txl2YTHyrPrXih+0UReFmuX9keo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 179/523] benet: fix BUG when creating VFs
Date: Tue, 26 Aug 2025 13:06:29 +0200
Message-ID: <20250826110928.873043044@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d9bceb26f4e5..d6984c179bae 100644
--- a/drivers/net/ethernet/emulex/benet/be_cmds.c
+++ b/drivers/net/ethernet/emulex/benet/be_cmds.c
@@ -3851,8 +3851,8 @@ int be_cmd_set_mac_list(struct be_adapter *adapter, u8 *mac_array,
 	status = be_mcc_notify_wait(adapter);
 
 err:
-	dma_free_coherent(&adapter->pdev->dev, cmd.size, cmd.va, cmd.dma);
 	spin_unlock_bh(&adapter->mcc_lock);
+	dma_free_coherent(&adapter->pdev->dev, cmd.size, cmd.va, cmd.dma);
 	return status;
 }
 
-- 
2.39.5



