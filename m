Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4971ABEAD;
	Mon, 14 Oct 2024 15:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918077; cv=none; b=XITRTGGJU13TExVRQ4I51+/i5X33YCrfXgl+6NqBtl3LmKLkY6omkA8gYu9pmp9LDnN9BL8PiYFCZFiQrZP0CB8x+9dhnc/dBRx8C4YJ8vozHGJY1YAFKgujdEVw0Zh0dppEgHkYEzBc92fiulr2CfvmNkDPrP/aJWb+Hasl0s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918077; c=relaxed/simple;
	bh=RHh0rT+KeIZGWFt2ssOUhdOCw5gG/joYrQIlO4C/TVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cq6egBItfX9yS4bcFjIMK/t0bivsyzuencgwa4G1ykj5fMdyY4GvW+aNCEd0Oy4ZVt3ma3ZUpL48u4mqpIMZwEMntVZWLrqKmqq7pdi0SGlEZe9gzB8cth7B6KmPdbkmJ8bwfsQXoSL0c1/XkBlFSaTZ3zKbqvbfynbvx2EYxiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C9u/MmIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C9u/MmIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26685C4CEC3;
	Mon, 14 Oct 2024 15:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918076;
	bh=RHh0rT+KeIZGWFt2ssOUhdOCw5gG/joYrQIlO4C/TVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9u/MmIz/dmo9+Q/BmABSfos7bb3eheySGF5rvyX39vZrFuRP5up6coI4DtNf4b5u
	 rK7fjWcvynUVWPjdYd5kz7VsO1aW70A7FhS7guSSoEFp0/DUD2LWN3HPBE4LZ9OyaZ
	 E292gzmwdJhCnIml8/IasoDTXmEF/gl3kSwgPVi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 215/798] IB/core: Fix ib_cache_setup_one error flow cleanup
Date: Mon, 14 Oct 2024 16:12:49 +0200
Message-ID: <20241014141226.379407943@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 1403c8b14765eab805377dd3b75e96ace8747aed ]

When ib_cache_update return an error, we exit ib_cache_setup_one
instantly with no proper cleanup, even though before this we had
already successfully done gid_table_setup_one, that results in
the kernel WARN below.

Do proper cleanup using gid_table_cleanup_one before returning
the err in order to fix the issue.

WARNING: CPU: 4 PID: 922 at drivers/infiniband/core/cache.c:806 gid_table_release_one+0x181/0x1a0
Modules linked in:
CPU: 4 UID: 0 PID: 922 Comm: c_repro Not tainted 6.11.0-rc1+ #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
RIP: 0010:gid_table_release_one+0x181/0x1a0
Code: 44 8b 38 75 0c e8 2f cb 34 ff 4d 8b b5 28 05 00 00 e8 23 cb 34 ff 44 89 f9 89 da 4c 89 f6 48 c7 c7 d0 58 14 83 e8 4f de 21 ff <0f> 0b 4c 8b 75 30 e9 54 ff ff ff 48 8    3 c4 10 5b 5d 41 5c 41 5d 41
RSP: 0018:ffffc90002b835b0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffffffff811c8527
RDX: 0000000000000000 RSI: ffffffff811c8534 RDI: 0000000000000001
RBP: ffff8881011b3d00 R08: ffff88810b3abe00 R09: 205d303839303631
R10: 666572207972746e R11: 72746e6520444947 R12: 0000000000000001
R13: ffff888106390000 R14: ffff8881011f2110 R15: 0000000000000001
FS:  00007fecc3b70800(0000) GS:ffff88813bd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000020000340 CR3: 000000010435a001 CR4: 00000000003706b0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ? show_regs+0x94/0xa0
 ? __warn+0x9e/0x1c0
 ? gid_table_release_one+0x181/0x1a0
 ? report_bug+0x1f9/0x340
 ? gid_table_release_one+0x181/0x1a0
 ? handle_bug+0xa2/0x110
 ? exc_invalid_op+0x31/0xa0
 ? asm_exc_invalid_op+0x16/0x20
 ? __warn_printk+0xc7/0x180
 ? __warn_printk+0xd4/0x180
 ? gid_table_release_one+0x181/0x1a0
 ib_device_release+0x71/0xe0
 ? __pfx_ib_device_release+0x10/0x10
 device_release+0x44/0xd0
 kobject_put+0x135/0x3d0
 put_device+0x20/0x30
 rxe_net_add+0x7d/0xa0
 rxe_newlink+0xd7/0x190
 nldev_newlink+0x1b0/0x2a0
 ? __pfx_nldev_newlink+0x10/0x10
 rdma_nl_rcv_msg+0x1ad/0x2e0
 rdma_nl_rcv_skb.constprop.0+0x176/0x210
 netlink_unicast+0x2de/0x400
 netlink_sendmsg+0x306/0x660
 __sock_sendmsg+0x110/0x120
 ____sys_sendmsg+0x30e/0x390
 ___sys_sendmsg+0x9b/0xf0
 ? kstrtouint+0x6e/0xa0
 ? kstrtouint_from_user+0x7c/0xb0
 ? get_pid_task+0xb0/0xd0
 ? proc_fail_nth_write+0x5b/0x140
 ? __fget_light+0x9a/0x200
 ? preempt_count_add+0x47/0xa0
 __sys_sendmsg+0x61/0xd0
 do_syscall_64+0x50/0x110
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: 1901b91f9982 ("IB/core: Fix potential NULL pointer dereference in pkey cache")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://patch.msgid.link/79137687d829899b0b1c9835fcb4b258004c439a.1725273354.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index c319664ca74b3..873988e5c5280 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -1629,8 +1629,10 @@ int ib_cache_setup_one(struct ib_device *device)
 
 	rdma_for_each_port (device, p) {
 		err = ib_cache_update(device, p, true, true, true);
-		if (err)
+		if (err) {
+			gid_table_cleanup_one(device);
 			return err;
+		}
 	}
 
 	return 0;
-- 
2.43.0



