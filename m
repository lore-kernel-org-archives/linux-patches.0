Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C99017B505;
	Wed,  5 Mar 2025 18:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197972; cv=none; b=W+OgyKhgtRsbo0hpdtqQTS36qzJ1aeHMeyeoFbwt/UZmhzyXh0B5JOKadS9mh8BGlqK8+pHXRlOu0ZcxejVk/9Aa0GbIfaz68BEkzvgrOLXlf6eQ5saetkI8EsQtkpmk8hSQoQHmVgpb8O1KvslDVm3FawgWqSWE7ls3zBx1pjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197972; c=relaxed/simple;
	bh=uCP3ZhZio8gRMP4MS6ThR+nQMiAHJ8ouf0+ups5dQr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q13wNtiOJ7Sj8G/pgPufeXIpJkYNdVhDajX8t2kuZEDfdGusCqfz52Hp/0upzPGlCoT5ZCFE5bJ9OIYvVoN1rV+qp97H67VomOTHcr2K6ikjx/bBJQ55Gc5uXbcdPrXNuhtnMZsIvn+tNTH255KBrzf0JrOXW09vUlDy+Xevz94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2TzEkEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2TzEkEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44C6C4CED1;
	Wed,  5 Mar 2025 18:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197972;
	bh=uCP3ZhZio8gRMP4MS6ThR+nQMiAHJ8ouf0+ups5dQr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2TzEkEFiw47pkAhrG9mQqdF15yQ1VIrayO6TBo93sHCZMkRi0/NhLk3+Miv5tOld
	 h+3VHIlvyNMeG4U9SmuiAGNyXQTrtdk1N/2Lxd3CXxdBqIvxtF6B013k+mmvx7S3UK
	 GmdcOE4dQAiliJKYqZFqSZcvktaZQqAm1H2yMVOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Artemy Kovalyov <artemyko@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/150] RDMA/mlx5: Fix implicit ODP hang on parent deregistration
Date: Wed,  5 Mar 2025 18:47:30 +0100
Message-ID: <20250305174504.662217215@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174503.801402104@linuxfoundation.org>
References: <20250305174503.801402104@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1d3bf56157702..b4e2a6f9cb9c3 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -242,6 +242,7 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 	if (__xa_cmpxchg(&imr->implicit_children, idx, mr, NULL, GFP_KERNEL) !=
 	    mr) {
 		xa_unlock(&imr->implicit_children);
+		mlx5r_deref_odp_mkey(&imr->mmkey);
 		return;
 	}
 
-- 
2.39.5



