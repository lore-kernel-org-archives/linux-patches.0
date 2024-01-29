Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B5617375F;
	Mon, 29 Jan 2024 17:15:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548553; cv=none; b=dmiEiAMPP55aNivB/16ijO6yfhA/a5e5T3nIzu3ZL9dai74REMw+hfcK4S7Gs5YB8ewzDrf8Gt1MTHszfN42mnbkcG3rEHE5yb1w7vNIDDc2xnMSa5APpSGJ14CwKPDOAaM0V74Y/i9gzGZYPBKpE8uWW+aH4pL7fBUX8rbIeHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548553; c=relaxed/simple;
	bh=QxZR/taOluZWn4rWMG8chZfsPLxzbniLtVZvig9WV8U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgukaLxubIY556exv6X+PiW5s0JAVDhuWLTg+8uHTZ8SRqJCGPIzdKnTOWBLLAZp22FN4hHBtINyfcBcsyhywcHTvgQWwQPgL+VYLHYmwnuk8005mOWg96Qe94tF4o2rMDA8EtKCWWZM4nTAuWi83fJJDeNBu5vBPVmSUH8xbio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UncZ4Nho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UncZ4Nho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64C9EC433C7;
	Mon, 29 Jan 2024 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548553;
	bh=QxZR/taOluZWn4rWMG8chZfsPLxzbniLtVZvig9WV8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UncZ4NhoINiOd/eqoP3J7Q8iL2UPdWQ7UbHgqlav3wYM8lfK/aEJwqR3nPhtEjIUE
	 aGTgpgw72TcC22Gdoacm+MU+QE/S6pHEUy3eAj8FxIuOjsNTi5TQKfm5pBPxdI/SNK
	 YsEcjyWkl3G2f60SRFiC7UEWr5sNhH0J2PszNpDw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/331] bnxt_en: Prevent kernel warning when running offline self test
Date: Mon, 29 Jan 2024 09:03:57 -0800
Message-ID: <20240129170019.973219673@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit c20f482129a582455f02eb9a6dcb2a4215274599 ]

We call bnxt_half_open_nic() to setup the chip partially to run
loopback tests.  The rings and buffers are initialized normally
so that we can transmit and receive packets in loopback mode.
That means page pool buffers are allocated for the aggregation ring
just like the normal case.  NAPI is not needed because we are just
polling for the loopback packets.

When we're done with the loopback tests, we call bnxt_half_close_nic()
to clean up.  When freeing the page pools, we hit a WARN_ON()
in page_pool_unlink_napi() because the NAPI state linked to the
page pool is uninitialized.

The simplest way to avoid this warning is just to initialize the
NAPIs during half open and delete the NAPIs during half close.
Trying to skip the page pool initialization or skip linking of
NAPI during half open will be more complicated.

This fix avoids this warning:

WARNING: CPU: 4 PID: 46967 at net/core/page_pool.c:946 page_pool_unlink_napi+0x1f/0x30
CPU: 4 PID: 46967 Comm: ethtool Tainted: G S      W          6.7.0-rc5+ #22
Hardware name: Dell Inc. PowerEdge R750/06V45N, BIOS 1.3.8 08/31/2021
RIP: 0010:page_pool_unlink_napi+0x1f/0x30
Code: 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44 00 00 48 8b 47 18 48 85 c0 74 1b 48 8b 50 10 83 e2 01 74 08 8b 40 34 83 f8 ff 74 02 <0f> 0b 48 c7 47 18 00 00 00 00 c3 cc cc cc cc 66 90 90 90 90 90 90
RSP: 0018:ffa000003d0dfbe8 EFLAGS: 00010246
RAX: ff110003607ce640 RBX: ff110010baf5d000 RCX: 0000000000000008
RDX: 0000000000000000 RSI: ff110001e5e522c0 RDI: ff110010baf5d000
RBP: ff11000145539b40 R08: 0000000000000001 R09: ffffffffc063f641
R10: ff110001361eddb8 R11: 000000000040000f R12: 0000000000000001
R13: 000000000000001c R14: ff1100014553a080 R15: 0000000000003fc0
FS:  00007f9301c4f740(0000) GS:ff1100103fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f91344fa8f0 CR3: 00000003527cc005 CR4: 0000000000771ef0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
 <TASK>
 ? __warn+0x81/0x140
 ? page_pool_unlink_napi+0x1f/0x30
 ? report_bug+0x102/0x200
 ? handle_bug+0x44/0x70
 ? exc_invalid_op+0x13/0x60
 ? asm_exc_invalid_op+0x16/0x20
 ? bnxt_free_ring.isra.123+0xb1/0xd0 [bnxt_en]
 ? page_pool_unlink_napi+0x1f/0x30
 page_pool_destroy+0x3e/0x150
 bnxt_free_mem+0x441/0x5e0 [bnxt_en]
 bnxt_half_close_nic+0x2a/0x40 [bnxt_en]
 bnxt_self_test+0x21d/0x450 [bnxt_en]
 __dev_ethtool+0xeda/0x2e30
 ? native_queued_spin_lock_slowpath+0x17f/0x2b0
 ? __link_object+0xa1/0x160
 ? _raw_spin_unlock_irqrestore+0x23/0x40
 ? __create_object+0x5f/0x90
 ? __kmem_cache_alloc_node+0x317/0x3c0
 ? dev_ethtool+0x59/0x170
 dev_ethtool+0xa7/0x170
 dev_ioctl+0xc3/0x530
 sock_do_ioctl+0xa8/0xf0
 sock_ioctl+0x270/0x310
 __x64_sys_ioctl+0x8c/0xc0
 do_syscall_64+0x3e/0xf0
 entry_SYSCALL_64_after_hwframe+0x6e/0x76

Fixes: 294e39e0d034 ("bnxt: hook NAPIs to page pools")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Reviewed-by: Ajit Khaparde <ajit.khaparde@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20240117234515.226944-5-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 9e04db1273a5..dac4f9510c17 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10598,10 +10598,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
 		netdev_err(bp->dev, "bnxt_alloc_mem err: %x\n", rc);
 		goto half_open_err;
 	}
+	bnxt_init_napi(bp);
 	set_bit(BNXT_STATE_HALF_OPEN, &bp->state);
 	rc = bnxt_init_nic(bp, true);
 	if (rc) {
 		clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
+		bnxt_del_napi(bp);
 		netdev_err(bp->dev, "bnxt_init_nic err: %x\n", rc);
 		goto half_open_err;
 	}
@@ -10620,6 +10622,7 @@ int bnxt_half_open_nic(struct bnxt *bp)
 void bnxt_half_close_nic(struct bnxt *bp)
 {
 	bnxt_hwrm_resource_free(bp, false, true);
+	bnxt_del_napi(bp);
 	bnxt_free_skbs(bp);
 	bnxt_free_mem(bp, true);
 	clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
-- 
2.43.0



