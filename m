Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A67615A493;
	Mon, 29 Jan 2024 17:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548124; cv=none; b=ruySj4siuVBPjuceeQRcs6gdGwZ/zfMEPpbGpafooy7h+YLZLO22rZl4SBJEgGnSWJHXqg+rEwvZqFjqeqBZa1gTCmvtEVHGeXjuvZjJbBJr8pcLE1rl/1Inrbbts1WED7Xacw3QSKfHhG9iYjlcCJvo8NXAiy8ZvNyiKPkgGfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548124; c=relaxed/simple;
	bh=WTsdaGT0JO2Bgw4e/KmzPhxAIOGZxiEXzvc+FbEZ0lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXEWqvfjESinCMCYVOwf1nDxeYpLRub/YDbXjIhcmmFDG2ePDu04BmUqzPk2Tz/fHccYqSGI6aFYIdrgP0AUD+NGpxhZAPE+ebkCdgijZk7jypDG1/mHlFdPpBhuwc/OJXwB5PZ4IBU9SU8yps8apZ/sdGcU9QPf6FlhFSQsmcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VL2A1reT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VL2A1reT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F7D9C433C7;
	Mon, 29 Jan 2024 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548124;
	bh=WTsdaGT0JO2Bgw4e/KmzPhxAIOGZxiEXzvc+FbEZ0lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VL2A1reTUaK51kPlWex9mCzgnNJksgspj4Gmuv1SGOCXeQSY6Hjb5a1p8aaMoK7Yc
	 5TXcfyCX1xzlaQN2paE2oNuvoZT23YEjXe4gJBXY+dzu6qn5k9oBghkLSQrTFP7LAg
	 jPVqfOFyWfRH0Pvx7Q4SQOGSVAlXgUeYKi6odQMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Gospodarek <andrew.gospodarek@broadcom.com>,
	Ajit Khaparde <ajit.khaparde@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 152/346] bnxt_en: Prevent kernel warning when running offline self test
Date: Mon, 29 Jan 2024 09:03:03 -0800
Message-ID: <20240129170020.882324114@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 1019b4dc7bed..22c8bfb5ed9d 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10627,10 +10627,12 @@ int bnxt_half_open_nic(struct bnxt *bp)
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
@@ -10649,6 +10651,7 @@ int bnxt_half_open_nic(struct bnxt *bp)
 void bnxt_half_close_nic(struct bnxt *bp)
 {
 	bnxt_hwrm_resource_free(bp, false, true);
+	bnxt_del_napi(bp);
 	bnxt_free_skbs(bp);
 	bnxt_free_mem(bp, true);
 	clear_bit(BNXT_STATE_HALF_OPEN, &bp->state);
-- 
2.43.0



