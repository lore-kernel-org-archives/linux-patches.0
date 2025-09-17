Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA391C07C4;
	Wed, 17 Sep 2025 12:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113011; cv=none; b=WVcAe2M1V/0x3wnqPd+IiIv2H6a3gCfU+Kpx7UAyCGVZGRSMMir73dHao3Q5oYJMqOFfClNfvdL6pwWiJwiz+44wxym3z214CEqrmikB51WK5Gh03iFZQdNoWmSH7ycLKAH/AopefGc2pki5WiXyapXghq6YA6sNyQmq9nqGM4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113011; c=relaxed/simple;
	bh=viTBSAxQOSWLBBMSlBtHNcjWgQH+lVOedp99w1vqIV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFL1jSrOPcZe1Zv+MPwQQuoCqSP6w1un6HSjpwcSj5/tdNzeqcUJHQxhNoUksYdq0pCCYRW6jmIRpg2/LL+gd1iojiOc5GN3tT+ModzFqDTFcvuIkYrRmRyT9k5kXOhCTRqel1oHslbyPjmFoDeW6KcsfWGD+sTsNO5qHdBUI8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdCSkxqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdCSkxqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A53C4CEFA;
	Wed, 17 Sep 2025 12:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113011;
	bh=viTBSAxQOSWLBBMSlBtHNcjWgQH+lVOedp99w1vqIV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdCSkxqBTvAEF/LmflsBM+QbPPkDeLtRZ5MhfJjATccApW+tXATexORCwqxdg/6/O
	 hJatsLdq/8AvgFPNqSCexyNEdQ+NvpYO6Q5nzogKS7j41AGnuCA88je1j0Tgk55kT1
	 C7p87db2oLo7SjHPBBbyH+k2QbftgZZv/7V0LBHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Schmidt <mschmidt@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 6.16 142/189] i40e: fix IRQ freeing in i40e_vsi_request_irq_msix error path
Date: Wed, 17 Sep 2025 14:34:12 +0200
Message-ID: <20250917123355.334253977@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

From: Michal Schmidt <mschmidt@redhat.com>

[ Upstream commit 915470e1b44e71d1dd07ee067276f003c3521ee3 ]

If request_irq() in i40e_vsi_request_irq_msix() fails in an iteration
later than the first, the error path wants to free the IRQs requested
so far. However, it uses the wrong dev_id argument for free_irq(), so
it does not free the IRQs correctly and instead triggers the warning:

 Trying to free already-free IRQ 173
 WARNING: CPU: 25 PID: 1091 at kernel/irq/manage.c:1829 __free_irq+0x192/0x2c0
 Modules linked in: i40e(+) [...]
 CPU: 25 UID: 0 PID: 1091 Comm: NetworkManager Not tainted 6.17.0-rc1+ #1 PREEMPT(lazy)
 Hardware name: [...]
 RIP: 0010:__free_irq+0x192/0x2c0
 [...]
 Call Trace:
  <TASK>
  free_irq+0x32/0x70
  i40e_vsi_request_irq_msix.cold+0x63/0x8b [i40e]
  i40e_vsi_request_irq+0x79/0x80 [i40e]
  i40e_vsi_open+0x21f/0x2f0 [i40e]
  i40e_open+0x63/0x130 [i40e]
  __dev_open+0xfc/0x210
  __dev_change_flags+0x1fc/0x240
  netif_change_flags+0x27/0x70
  do_setlink.isra.0+0x341/0xc70
  rtnl_newlink+0x468/0x860
  rtnetlink_rcv_msg+0x375/0x450
  netlink_rcv_skb+0x5c/0x110
  netlink_unicast+0x288/0x3c0
  netlink_sendmsg+0x20d/0x430
  ____sys_sendmsg+0x3a2/0x3d0
  ___sys_sendmsg+0x99/0xe0
  __sys_sendmsg+0x8a/0xf0
  do_syscall_64+0x82/0x2c0
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
  [...]
  </TASK>
 ---[ end trace 0000000000000000 ]---

Use the same dev_id for free_irq() as for request_irq().

I tested this with inserting code to fail intentionally.

Fixes: 493fb30011b3 ("i40e: Move q_vectors from pointer to array to array of pointers")
Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f1c9e575703ea..26dcdceae741e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -4182,7 +4182,7 @@ static int i40e_vsi_request_irq_msix(struct i40e_vsi *vsi, char *basename)
 		irq_num = pf->msix_entries[base + vector].vector;
 		irq_set_affinity_notifier(irq_num, NULL);
 		irq_update_affinity_hint(irq_num, NULL);
-		free_irq(irq_num, &vsi->q_vectors[vector]);
+		free_irq(irq_num, vsi->q_vectors[vector]);
 	}
 	return err;
 }
-- 
2.51.0



