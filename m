Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E011208A7;
	Sun,  1 Sep 2024 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209756; cv=none; b=eOz8fRX4Ogn8URy6o3EmquDvZKjSsIUkW9JTPu+KwRr/hvvjMVq3k/bOs97ype8rVwu10+mKJgWL2InwYYQVmjdbL1Ey4/UAhd5v9SxE6xI4LPMBnlqX3iBFcvGvKxr/V0Hw9wokqZJ4nWhSHg6Mym++09xFbplMuhMo1x8A43c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209756; c=relaxed/simple;
	bh=MjF7rB+Ix7zsbAi9l3UxOL+l4Az7wdDLJqEDcLD1oEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXvbG5sZGAba6lQkBpJPm2lRKh+SOP6E4/5kBEJcD75S076cKNrw03JC7BauBn8ZoOEOgLVm05BnngtCSubJ/B+9CdGufJODgfZfO0cEFhS+nGxAmLEGsOTPpxgAYXPFsI3i6U//rY5AaGrPP+kiyC1g+yHv5Uev7OnUI7jxqPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8Vu7Khn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8Vu7Khn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD7C4CEC3;
	Sun,  1 Sep 2024 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209756;
	bh=MjF7rB+Ix7zsbAi9l3UxOL+l4Az7wdDLJqEDcLD1oEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8Vu7KhnUTgGuwScw0duz1kt3KsbMH1SxDZDSIEvyMOC6Q8AV6RXifwFUt5ih9WPa
	 SUh0Sue+pRizxUiwcasdn4kQboakiwht+B7SE/a1ihtPVsvq4O2KgXYD+Iq0YTSzX8
	 BrH2kFINjh8XUUAAJUV7IaWkUrbOmeHbl7hom+iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/151] bonding: fix xfrm real_dev null pointer dereference
Date: Sun,  1 Sep 2024 18:17:34 +0200
Message-ID: <20240901160817.651592956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bd74b2d64ad48..506b6d1cc27df 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -540,7 +540,6 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 		} else {
 			slave->dev->xfrmdev_ops->xdo_dev_state_delete(ipsec->xs);
 		}
-		ipsec->xs->xso.real_dev = NULL;
 	}
 	spin_unlock_bh(&bond->ipsec_lock);
 	rcu_read_unlock();
-- 
2.43.0



