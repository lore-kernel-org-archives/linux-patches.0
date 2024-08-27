Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54EC01C688E;
	Tue, 27 Aug 2024 15:11:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771483; cv=none; b=hNXk/Hb6ms8GTkiQk3lz3YWF06TOlOmRrNCc8zux2NlDQtPQYJt071hdXmwTosvgnaL0KH5VGicZ0Nn22E6jYwnqafJcpfm/ve0GOEnFr0UrHA97WPGnPJqets1rRgknUq3oHa4F6qzSsyzgTql8DTNoRs1skDs4skmLrplwzWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771483; c=relaxed/simple;
	bh=xaifB7cdul6sOUKpMTW5JvfnusNnnWpfX498gFmoYeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izO7mFM6VaitTiMc7TZ5tVnPnD2JS0QrF/U7tVtUd75B3pHWTGR6CqMiSW46P7qqX7NpXJypm2zdSUQXaa2MWVwR6cbndoPH8UZI662ocTkCJBx+itcHEvxsQjTyL3b1Rz7mH/BV2HKDhh49CDsOSCgkNY6bo1urfiicmbzhmok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FekEqqnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FekEqqnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C27C4DDF2;
	Tue, 27 Aug 2024 15:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771482;
	bh=xaifB7cdul6sOUKpMTW5JvfnusNnnWpfX498gFmoYeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FekEqqnUk6BAKLYJXkBeAGnAs+fmBkio02PkDgsWuJFt05IVHRmbT/MgZr1NT4cPh
	 4itfhvMVOMNvUohGeKAM/v4olmQioBQTI2Yq81RSZ0LgiHTnWYLUtuw83LqL1AspdN
	 +drZwutgAKL9MEny3lx2jS2ClHyp2qXN9Eiotr0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 170/273] bonding: fix xfrm real_dev null pointer dereference
Date: Tue, 27 Aug 2024 16:38:14 +0200
Message-ID: <20240827143839.877740598@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit f8cde9805981c50d0c029063dc7d82821806fc44 ]

We shouldn't set real_dev to NULL because packets can be in transit and
xfrm might call xdo_dev_offload_ok() in parallel. All callbacks assume
real_dev is set.

 Example trace:
 kernel: BUG: unable to handle page fault for address: 0000000000001030
 kernel: bond0: (slave eni0np1): making interface the new active one
 kernel: #PF: supervisor write access in kernel mode
 kernel: #PF: error_code(0x0002) - not-present page
 kernel: PGD 0 P4D 0
 kernel: Oops: 0002 [#1] PREEMPT SMP
 kernel: CPU: 4 PID: 2237 Comm: ping Not tainted 6.7.7+ #12
 kernel: Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-2.fc40 04/01/2014
 kernel: RIP: 0010:nsim_ipsec_offload_ok+0xc/0x20 [netdevsim]
 kernel: bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
 kernel: Code: e0 0f 0b 48 83 7f 38 00 74 de 0f 0b 48 8b 47 08 48 8b 37 48 8b 78 40 e9 b2 e5 9a d7 66 90 0f 1f 44 00 00 48 8b 86 80 02 00 00 <83> 80 30 10 00 00 01 b8 01 00 00 00 c3 0f 1f 80 00 00 00 00 0f 1f
 kernel: bond0: (slave eni0np1): making interface the new active one
 kernel: RSP: 0018:ffffabde81553b98 EFLAGS: 00010246
 kernel: bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
 kernel:
 kernel: RAX: 0000000000000000 RBX: ffff9eb404e74900 RCX: ffff9eb403d97c60
 kernel: RDX: ffffffffc090de10 RSI: ffff9eb404e74900 RDI: ffff9eb3c5de9e00
 kernel: RBP: ffff9eb3c0a42000 R08: 0000000000000010 R09: 0000000000000014
 kernel: R10: 7974203030303030 R11: 3030303030303030 R12: 0000000000000000
 kernel: R13: ffff9eb3c5de9e00 R14: ffffabde81553cc8 R15: ffff9eb404c53000
 kernel: FS:  00007f2a77a3ad00(0000) GS:ffff9eb43bd00000(0000) knlGS:0000000000000000
 kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 kernel: CR2: 0000000000001030 CR3: 00000001122ab000 CR4: 0000000000350ef0
 kernel: bond0: (slave eni0np1): making interface the new active one
 kernel: Call Trace:
 kernel:  <TASK>
 kernel:  ? __die+0x1f/0x60
 kernel: bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
 kernel:  ? page_fault_oops+0x142/0x4c0
 kernel:  ? do_user_addr_fault+0x65/0x670
 kernel:  ? kvm_read_and_reset_apf_flags+0x3b/0x50
 kernel: bond0: (slave eni0np1): making interface the new active one
 kernel:  ? exc_page_fault+0x7b/0x180
 kernel:  ? asm_exc_page_fault+0x22/0x30
 kernel:  ? nsim_bpf_uninit+0x50/0x50 [netdevsim]
 kernel: bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
 kernel:  ? nsim_ipsec_offload_ok+0xc/0x20 [netdevsim]
 kernel: bond0: (slave eni0np1): making interface the new active one
 kernel:  bond_ipsec_offload_ok+0x7b/0x90 [bonding]
 kernel:  xfrm_output+0x61/0x3b0
 kernel: bond0: (slave eni0np1): bond_ipsec_add_sa_all: failed to add SA
 kernel:  ip_push_pending_frames+0x56/0x80

Fixes: 18cb261afd7b ("bonding: support hardware encryption offload to slaves")
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 55841a0e05a47..b257504a85347 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -582,7 +582,6 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 		} else {
 			slave->dev->xfrmdev_ops->xdo_dev_state_delete(ipsec->xs);
 		}
-		ipsec->xs->xso.real_dev = NULL;
 	}
 	spin_unlock_bh(&bond->ipsec_lock);
 	rcu_read_unlock();
-- 
2.43.0



