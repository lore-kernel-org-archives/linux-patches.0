Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE79EEB8;
	Mon, 11 Dec 2023 18:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L3cS/1L5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC107C433C8;
	Mon, 11 Dec 2023 18:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319450;
	bh=6cB9hJlNt1faLV2DOPiJ+hQAiIAkdGZdpROkSET4GL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3cS/1L5HegqZ0x/hQyqSZ1Njhf4Pku1FFrTPO7EKu6Xl60I3yfentVgQAMTc1Sfn
	 oHe/tR3YKmzAKKCoS95+LnbtQz49PkTBh2zJ7uVVY9eVAwTq7gLXJtxLf9kOlXzR13
	 Ep8vapAU0vSFnhxB19bv8IOfxpuikjUtAT8/5IO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/244] RDMA/core: Fix uninit-value access in ib_get_eth_speed()
Date: Mon, 11 Dec 2023 19:19:32 +0100
Message-ID: <20231211182049.334656079@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 0550d4604e2ca4e653dc13f0c009fc42106b6bfc ]

KMSAN reported the following uninit-value access issue:

lo speed is unknown, defaulting to 1000
=====================================================
BUG: KMSAN: uninit-value in ib_get_width_and_speed drivers/infiniband/core/verbs.c:1889 [inline]
BUG: KMSAN: uninit-value in ib_get_eth_speed+0x546/0xaf0 drivers/infiniband/core/verbs.c:1998
 ib_get_width_and_speed drivers/infiniband/core/verbs.c:1889 [inline]
 ib_get_eth_speed+0x546/0xaf0 drivers/infiniband/core/verbs.c:1998
 siw_query_port drivers/infiniband/sw/siw/siw_verbs.c:173 [inline]
 siw_get_port_immutable+0x6f/0x120 drivers/infiniband/sw/siw/siw_verbs.c:203
 setup_port_data drivers/infiniband/core/device.c:848 [inline]
 setup_device drivers/infiniband/core/device.c:1244 [inline]
 ib_register_device+0x1589/0x1df0 drivers/infiniband/core/device.c:1383
 siw_device_register drivers/infiniband/sw/siw/siw_main.c:72 [inline]
 siw_newlink+0x129e/0x13d0 drivers/infiniband/sw/siw/siw_main.c:490
 nldev_newlink+0x8fd/0xa60 drivers/infiniband/core/nldev.c:1763
 rdma_nl_rcv_skb drivers/infiniband/core/netlink.c:239 [inline]
 rdma_nl_rcv+0xe8a/0x1120 drivers/infiniband/core/netlink.c:259
 netlink_unicast_kernel net/netlink/af_netlink.c:1342 [inline]
 netlink_unicast+0xf4b/0x1230 net/netlink/af_netlink.c:1368
 netlink_sendmsg+0x1242/0x1420 net/netlink/af_netlink.c:1910
 sock_sendmsg_nosec net/socket.c:730 [inline]
 __sock_sendmsg net/socket.c:745 [inline]
 ____sys_sendmsg+0x997/0xd60 net/socket.c:2588
 ___sys_sendmsg+0x271/0x3b0 net/socket.c:2642
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2680 [inline]
 __se_sys_sendmsg net/socket.c:2678 [inline]
 __x64_sys_sendmsg+0x2fa/0x4a0 net/socket.c:2678
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable lksettings created at:
 ib_get_eth_speed+0x4b/0xaf0 drivers/infiniband/core/verbs.c:1974
 siw_query_port drivers/infiniband/sw/siw/siw_verbs.c:173 [inline]
 siw_get_port_immutable+0x6f/0x120 drivers/infiniband/sw/siw/siw_verbs.c:203

CPU: 0 PID: 11257 Comm: syz-executor.1 Not tainted 6.6.0-14500-g1c41041124bd #10
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
=====================================================

If __ethtool_get_link_ksettings() fails, `netdev_speed` is set to the
default value, SPEED_1000. In this case, if `lanes` field of struct
ethtool_link_ksettings is not initialized, an uninitialized value is passed
to ib_get_width_and_speed(). This causes the above issue. This patch
resolves the issue by initializing `lanes` to 0.

Fixes: cb06b6b3f6cb ("RDMA/core: Get IB width and speed from netdev")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Link: https://lore.kernel.org/r/20231108143113.1360567-1-syoshida@redhat.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 41ff5595c8606..186ed3c22ec9e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1968,7 +1968,7 @@ int ib_get_eth_speed(struct ib_device *dev, u32 port_num, u16 *speed, u8 *width)
 	int rc;
 	u32 netdev_speed;
 	struct net_device *netdev;
-	struct ethtool_link_ksettings lksettings;
+	struct ethtool_link_ksettings lksettings = {};
 
 	if (rdma_port_get_link_layer(dev, port_num) != IB_LINK_LAYER_ETHERNET)
 		return -EINVAL;
-- 
2.42.0



