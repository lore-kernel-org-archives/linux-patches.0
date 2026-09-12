Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79593326938;
	Sat, 12 Sep 2026 14:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223694; cv=none; b=Ho3QRfPyOBBaQaS48glDLi+h0pj/7OgoPiDCy3C2NPO/Qrtm5v65CN+6gtbK8Ky68ayAkPNAfvi2txrA78dxHSbvchP774sRTkQyPEAdd6p8ywOh2+hiko1+ThHu70Yn4CKe6YbpRjx1p8gdwTyBNTUDhUdko5wrSPxYhKzfd/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223694; c=relaxed/simple;
	bh=Vsqk4zL9x+9ojwcAJZgOeeKbOyCX03B3VMMWvGBJGZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E/pIByNdzuZ/+nmTK2SiPxaZ3hhfFAYI1cdhfeceLkTYzGMQQVn4RuM64rmT/yF7UhVhOwXAQ1e/hdBKXMoJ5s0rqRXPt0gJ38xwlWlT1PfW71JHP9efWxl9j5cQwLvTFv1sxaFhupZLYhc4vac2YxVGujuX8sug/MBsLxoYa8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5xVUm8/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5xVUm8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194961F000FF;
	Sat, 12 Sep 2026 14:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223693;
	bh=2vY9L8Z8k0Tysn4o8solBzBERlrHK00ZV3NuhCfValg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5xVUm8/j8DSl7KifavF+W84Mm4zuXN2AfgtdAGdw5R7wJ4Ti5otU+1u1RpvjStu1
	 ApRIRxJeRHz+a8aeSciZ1nDbQSUZ1iMC5VpBtcb8t0ypab5ehnaJ3WrwZ+g02uxUll
	 Rkl6Iw/rv+ZOPvZRArbZgulDoLGpZPeAFkvqwYqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0841/1424] RDMA/core: Fix use after free in ib_query_qp()
Date: Sat, 12 Sep 2026 08:54:33 +0200
Message-ID: <20260912065626.142613064@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 709ba0e5311bd034eb4d9c1c00cc4e1109d6dc3e ]

When querying a QP via the netlink flow the only synchronization
mechanism for the said QP is rdma_restrack_get(), meanwhile during the
QP destroy path rdma_restrack_del() is called at the end of the
ib_destroy_qp_user() function which is too late, since by then the
vendor specific resources for said QP would already be destroyed, and
till the rdma_restrack_del() is called this QP can still be accessed,
which could cause the use after free below.

Fix this by moving the rdma_restrack_begin_del() to the start of the
ib_destroy_qp_user(), which in turn waits for all usages of the QP to be
done then removes it from the database to prevent access to it while it
is being destroyed.

RIP: 0010:ib_query_qp+0x15/0x50 [ib_core]
Code: 48 83 05 5d 8e b9 ff 01 eb b5 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 c7 46 40 00 00 00 00 48 c7 46 78 00 00 00 00 <48> 8b 07 48 8b 80 88 01 00 00 48 85 c0 74 1a 48 83 05 54 91 b9 ff
RSP: 0018:ff11000108a8f2f0 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ff11000108a8f370 RCX: ff11000108a8f370
RDX: 0000000000000000 RSI: ff11000108a8f3d8 RDI: 0000000000000000
RBP: ff1100010de5a000 R08: 0000000000000e80 R09: 0000000000000004
R10: ff110001057a604c R11: 0000000000000000 R12: ff11000108a8f370
R13: ff110001090e8000 R14: 0000000000000000 R15: ff110001057a602c
FS:  00007f2ffd8db6c0(0000) GS:ff110008dc90b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010b9a7004 CR4: 0000000000373eb0
Call Trace:
 <TASK>
 mlx5_ib_gsi_query_qp+0x21/0x50 [mlx5_ib]
 mlx5_ib_query_qp+0x689/0x9d0 [mlx5_ib]
 ib_query_qp+0x35/0x50 [ib_core]
 fill_res_qp_entry_query.isra.0+0x47/0x280 [ib_core]
 ? __wake_up+0x40/0x50
 ? netlink_broadcast_filtered+0x15a/0x550
 ? kobject_uevent_env+0x562/0x710
 ? ep_poll_callback+0x242/0x270
 ? __nla_put+0xc/0x20
 ? nla_put+0x28/0x40
 ? nla_put_string+0x2e/0x40 [ib_core]
 fill_res_qp_entry+0x138/0x190 [ib_core]
 res_get_common_dumpit+0x4a5/0x800 [ib_core]
 ? fill_res_qp_entry_query.isra.0+0x280/0x280 [ib_core]
 nldev_res_get_qp_dumpit+0x1e/0x30 [ib_core]
 netlink_dump+0x16f/0x450
 __netlink_dump_start+0x1ce/0x2e0
 rdma_nl_rcv_msg+0x1d3/0x330 [ib_core]
 ? nldev_res_get_qp_raw_dumpit+0x30/0x30 [ib_core]
 rdma_nl_rcv_skb.constprop.0.isra.0+0x108/0x180 [ib_core]
 rdma_nl_rcv+0x12/0x20 [ib_core]
 netlink_unicast+0x255/0x380
 ? __alloc_skb+0xfa/0x1e0
 netlink_sendmsg+0x1f3/0x420
 __sock_sendmsg+0x38/0x60
 ____sys_sendmsg+0x1e8/0x230
 ? copy_msghdr_from_user+0xea/0x170
 ___sys_sendmsg+0x7c/0xb0
 ? __futex_wait+0x95/0xf0
 ? __futex_wake_mark+0x40/0x40
 ? futex_wait+0x67/0x100
 ? futex_wake+0xac/0x1b0
 __sys_sendmsg+0x5f/0xb0
 do_syscall_64+0x55/0xb90
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 514aee660df4 ("RDMA: Globally allocate and release QP memory")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-2-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index ac00b070d320b..90cb7904ba11f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2086,6 +2086,8 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (qp->real_qp != qp)
 		return __ib_destroy_shared_qp(qp);
 
+	rdma_restrack_begin_del(&qp->res);
+
 	sec  = qp->qp_sec;
 	if (sec)
 		ib_destroy_qp_security_begin(sec);
@@ -2098,6 +2100,7 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (ret) {
 		if (sec)
 			ib_destroy_qp_security_abort(sec);
+		rdma_restrack_abort_del(&qp->res);
 		return ret;
 	}
 
@@ -2110,7 +2113,7 @@ int ib_destroy_qp_user(struct ib_qp *qp, struct ib_udata *udata)
 	if (sec)
 		ib_destroy_qp_security_end(sec);
 
-	rdma_restrack_del(&qp->res);
+	rdma_restrack_commit_del(&qp->res);
 	kfree(qp);
 	return ret;
 }
-- 
2.53.0



