Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE7C1C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:10:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF1FC433D7;
	Wed, 23 Nov 2022 09:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194650;
	bh=f1bDRj6OAyJRuUGqDEx6V/FpKuGuv4W1By/viGxlurQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j2kvL4Dzs0zrij9AwFQqvxPUbWYWA3YbIubF0egT7wsC4EYtSJjr51mabpByma/J4
	 FD1oQVI9wyI3INUqGYB9nII77miz+otDvgjMDhTngj6y35lovUBhHNenxXN+m/qw/D
	 H6lFB/o+GcacJ4UrHbLPaQtqQA7s0vkn3X07wpDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/156] can: af_can: fix NULL pointer dereference in can_rx_register()
Date: Wed, 23 Nov 2022 09:49:39 +0100
Message-Id: <20221123084558.743823803@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
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

[ Upstream commit 8aa59e355949442c408408c2d836e561794c40a1 ]

It causes NULL pointer dereference when testing as following:
(a) use syscall(__NR_socket, 0x10ul, 3ul, 0) to create netlink socket.
(b) use syscall(__NR_sendmsg, ...) to create bond link device and vxcan
    link device, and bind vxcan device to bond device (can also use
    ifenslave command to bind vxcan device to bond device).
(c) use syscall(__NR_socket, 0x1dul, 3ul, 1) to create CAN socket.
(d) use syscall(__NR_bind, ...) to bind the bond device to CAN socket.

The bond device invokes the can-raw protocol registration interface to
receive CAN packets. However, ml_priv is not allocated to the dev,
dev_rcv_lists is assigned to NULL in can_rx_register(). In this case,
it will occur the NULL pointer dereference issue.

The following is the stack information:
BUG: kernel NULL pointer dereference, address: 0000000000000008
PGD 122a4067 P4D 122a4067 PUD 1223c067 PMD 0
Oops: 0000 [#1] PREEMPT SMP
RIP: 0010:can_rx_register+0x12d/0x1e0
Call Trace:
<TASK>
raw_enable_filters+0x8d/0x120
raw_enable_allfilters+0x3b/0x130
raw_bind+0x118/0x4f0
__sys_bind+0x163/0x1a0
__x64_sys_bind+0x1e/0x30
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
</TASK>

Fixes: 4e096a18867a ("net: introduce CAN specific pointer in the struct net_device")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/all/20221028085650.170470-1-shaozhengchao@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index c758a12ffe46..f7dc68cd86e4 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -450,7 +450,7 @@ int can_rx_register(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* insert new receiver  (dev,canid,mask) -> (func,data) */
 
-	if (dev && dev->type != ARPHRD_CAN)
+	if (dev && (dev->type != ARPHRD_CAN || !can_get_ml_priv(dev)))
 		return -ENODEV;
 
 	if (dev && !net_eq(net, dev_net(dev)))
-- 
2.35.1



