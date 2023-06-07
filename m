Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF443922B
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3E0FC4339C;
	Wed,  7 Jun 2023 20:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171180;
	bh=CiIboLuGy7TvH0bL8RB8Ctmmu91im++apW1wnmla0Jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+CbfaLV5+2I3OipIvBlK7WYGS/0gge/fA3SI2V+G8lOFCufeI0Dtvawk8DIWFkc8
	 1+VAzzcSkwFpaQXvy8Ze7CUwf50WAHbUIxh5mSI6BolYe/13iajP5x1NLNk51HODL2
	 WXCQCUCCk67Q8TnylQap6zTG149vCxa+gcL4Cr44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 20/99] net: sched: fix NULL pointer dereference in mq_attach
Date: Wed,  7 Jun 2023 22:16:12 +0200
Message-ID: <20230607200900.888839314@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200900.195572674@linuxfoundation.org>
References: <20230607200900.195572674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 36eec020fab668719b541f34d97f44e232ffa165 ]

When use the following command to test:
1)ip link add bond0 type bond
2)ip link set bond0 up
3)tc qdisc add dev bond0 root handle ffff: mq
4)tc qdisc replace dev bond0 parent ffff:fff1 handle ffff: mq

The kernel reports NULL pointer dereference issue. The stack information
is as follows:
Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Internal error: Oops: 0000000096000006 [#1] SMP
Modules linked in:
pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : mq_attach+0x44/0xa0
lr : qdisc_graft+0x20c/0x5cc
sp : ffff80000e2236a0
x29: ffff80000e2236a0 x28: ffff0000c0e59d80 x27: ffff0000c0be19c0
x26: ffff0000cae3e800 x25: 0000000000000010 x24: 00000000fffffff1
x23: 0000000000000000 x22: ffff0000cae3e800 x21: ffff0000c9df4000
x20: ffff0000c9df4000 x19: 0000000000000000 x18: ffff80000a934000
x17: ffff8000f5b56000 x16: ffff80000bb08000 x15: 0000000000000000
x14: 0000000000000000 x13: 6b6b6b6b6b6b6b6b x12: 6b6b6b6b00000001
x11: 0000000000000000 x10: 0000000000000000 x9 : 0000000000000000
x8 : ffff0000c0be0730 x7 : bbbbbbbbbbbbbbbb x6 : 0000000000000008
x5 : ffff0000cae3e864 x4 : 0000000000000000 x3 : 0000000000000001
x2 : 0000000000000001 x1 : ffff8000090bc23c x0 : 0000000000000000
Call trace:
mq_attach+0x44/0xa0
qdisc_graft+0x20c/0x5cc
tc_modify_qdisc+0x1c4/0x664
rtnetlink_rcv_msg+0x354/0x440
netlink_rcv_skb+0x64/0x144
rtnetlink_rcv+0x28/0x34
netlink_unicast+0x1e8/0x2a4
netlink_sendmsg+0x308/0x4a0
sock_sendmsg+0x64/0xac
____sys_sendmsg+0x29c/0x358
___sys_sendmsg+0x90/0xd0
__sys_sendmsg+0x7c/0xd0
__arm64_sys_sendmsg+0x2c/0x38
invoke_syscall+0x54/0x114
el0_svc_common.constprop.1+0x90/0x174
do_el0_svc+0x3c/0xb0
el0_svc+0x24/0xec
el0t_64_sync_handler+0x90/0xb4
el0t_64_sync+0x174/0x178

This is because when mq is added for the first time, qdiscs in mq is set
to NULL in mq_attach(). Therefore, when replacing mq after adding mq, we
need to initialize qdiscs in the mq before continuing to graft. Otherwise,
it will couse NULL pointer dereference issue in mq_attach(). And the same
issue will occur in the attach functions of mqprio, taprio and htb.
ffff:fff1 means that the repalce qdisc is ingress. Ingress does not allow
any qdisc to be attached. Therefore, ffff:fff1 is incorrectly used, and
the command should be dropped.

Fixes: 6ec1c69a8f64 ("net_sched: add classful multiqueue dummy scheduler")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Tested-by: Peilin Ye <peilin.ye@bytedance.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20230527093747.3583502-1-shaozhengchao@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index 84d371d30d444..6ca0cba8aad16 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1589,6 +1589,10 @@ static int tc_modify_qdisc(struct sk_buff *skb, struct nlmsghdr *n,
 					NL_SET_ERR_MSG(extack, "Qdisc parent/child loop detected");
 					return -ELOOP;
 				}
+				if (clid == TC_H_INGRESS) {
+					NL_SET_ERR_MSG(extack, "Ingress cannot graft directly");
+					return -EINVAL;
+				}
 				qdisc_refcount_inc(q);
 				goto graft;
 			} else {
-- 
2.39.2



