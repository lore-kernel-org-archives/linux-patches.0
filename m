Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217274;
	b=0HJRZk1ZUGoPVpjzQBC3aiaMZcB2kCom8L+JSXLpwY/Td0VCk9xGjWIsVoWVMXtXe8oH
	 wNZwhV3Plp9vGEMxtrxpXp2nz9dY5Aqs4yc0aj+OTGisQTBwBhrz7sBN3eXxYnkOwx/m9
	 U4Dznng7qzynjeATlx1FD1QcbZqqXma5DM4iUVAR3NOB7sEru5aNUEf5IEx3dn9iFepJI
	 DvNYEAffdoIWl6FEzB9C9h6eXJnXctYU7Clyvf0dJMTFCdcodbn0iUWHfmqRevT8qFb+v
	 YHUjL4L1g/rPRjy6GMj93bLaReL67UyUusCFt09Oebv2lsDB7lOHf4hivJw0a8fOZjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217274;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qvknYJBF0BkRfTOjk4Y2/+gXNurn9OPnDv280L83+pM=;
	b=ox+ZaCCw89cOif7cY8R1+DlvuXNJhuEA0nEfobpikF1doU2nSzWf+D0YyUtxv44W+9pV
	 cmx8qTcrHgj+STPW3X94gxRfRWXA33yVjxpT14sNnJj6X1b8PiaPIIJKYs15VfRenclAH
	 CzMZ/KRPNeaBemCB6ZQ0lw8yJc7jXOhpC70qtlOcQ9Pynq2Qz1EpkG+3uvMGsyQrStWt1
	 cwwSRmNbgsJw87uRZCilifdSigbjRMogBxNQ+dKWVfUW+3sGr6EoaU/JbYlXPjKATFf10
	 9xGGQYr5FpTf2rEs0NbRncLzGs7Yfwby7cY7qlghmDhpa95rMAPoRj+lDZSQIF3uqEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIxddSa4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5E1606A31C;
	Wed, 28 Oct 2026 19:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XIxddSa4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4461F01825;
	Wed, 28 Oct 2026 19:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217274;
	bh=qvknYJBF0BkRfTOjk4Y2/+gXNurn9OPnDv280L83+pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XIxddSa4ShXzhvdH3sjqMWSC7WKxjnb5+PmGJj/+kLHanr/Ym+/SZs9+Akg5Q0t0P
	 QSPD/Q3uNF+Y4aTXc1cGCcjfQ6nZn/cSBLOYQBBvh2QzWOjLcAaicEWBJlYNo4gwXo
	 1W5ZLgh71+9KPNH0yvczkIG2Ro+FVmpqJT7G0of4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Artemy Kovalyov <artemyko@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1848/1887] RDMA/mlx5: Fix implicit ODP hang on parent deregistration
Date: Wed, 28 Oct 2026 18:05:44 +0100
Message-ID: <20261028170541.503950124@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 3d8c6f26893d55fab218ad086719de1fc9bb86ba ]

Fix the destroy_unused_implicit_child_mr() to prevent hanging during
parent deregistration as of below [1].

Upon entering destroy_unused_implicit_child_mr(), the reference count
for the implicit MR parent is incremented using:
refcount_inc_not_zero().

A corresponding decrement must be performed if
free_implicit_child_mr_work() is not called.

The code has been updated to properly manage the reference count that
was incremented.

[1]
INFO: task python3:2157 blocked for more than 120 seconds.
Not tainted 6.12.0-rc7+ #1633
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:python3         state:D stack:0     pid:2157 tgid:2157  ppid:1685   flags:0x00000000
Call Trace:
<TASK>
__schedule+0x420/0xd30
schedule+0x47/0x130
__mlx5_ib_dereg_mr+0x379/0x5d0 [mlx5_ib]
? __pfx_autoremove_wake_function+0x10/0x10
ib_dereg_mr_user+0x5f/0x120 [ib_core]
? lock_release+0xc6/0x280
destroy_hw_idr_uobject+0x1d/0x60 [ib_uverbs]
uverbs_destroy_uobject+0x58/0x1d0 [ib_uverbs]
uobj_destroy+0x3f/0x70 [ib_uverbs]
ib_uverbs_cmd_verbs+0x3e4/0xbb0 [ib_uverbs]
? __pfx_uverbs_destroy_def_handler+0x10/0x10 [ib_uverbs]
? lock_acquire+0xc1/0x2f0
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0x116/0x170 [ib_uverbs]
? lock_release+0xc6/0x280
ib_uverbs_ioctl+0xe7/0x170 [ib_uverbs]
? ib_uverbs_ioctl+0xcb/0x170 [ib_uverbs]
 __x64_sys_ioctl+0x1b0/0xa70
? kmem_cache_free+0x221/0x400
do_syscall_64+0x6b/0x140
entry_SYSCALL_64_after_hwframe+0x76/0x7e
RIP: 0033:0x7f20f21f017b
RSP: 002b:00007ffcfc4a77c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffcfc4a78d8 RCX: 00007f20f21f017b
RDX: 00007ffcfc4a78c0 RSI: 00000000c0181b01 RDI: 0000000000000003
RBP: 00007ffcfc4a78a0 R08: 000056147d125190 R09: 00007f20f1f14c60
R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffcfc4a7890
R13: 000000000000001c R14: 000056147d100fc0 R15: 00007f20e365c9d0
</TASK>

Fixes: d3d930411ce3 ("RDMA/mlx5: Fix implicit ODP use after free")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Artemy Kovalyov <artemyko@nvidia.com>
Link: https://patch.msgid.link/80f2fcd19952dfa7d9981d93fd6359b4471f8278.1739186929.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f0e8d5e11d121..d2ef2ff88ccdf 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -227,6 +227,7 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 	if (__xa_cmpxchg(&imr->implicit_children, idx, mr, NULL, GFP_KERNEL) !=
 	    mr) {
 		xa_unlock(&imr->implicit_children);
+		mlx5r_deref_odp_mkey(&imr->mmkey);
 		return;
 	}
 
-- 
2.53.0



