Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951E4318EC1;
	Mon, 13 Apr 2026 16:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099127; cv=none; b=CqF13kExnN1glD1LcMzuQLxyiESjKQQ3LhVtHm4yc9ErB9ymLPlLRmLlpA+v7PUpeBkSJ7YV55KypN5Y44NpHrHvjvsTpl9tbVkbUs4IGV8rUH5D/kqTnEwcYQ1d3jZbH0siL4nF7SWTdbC4FCjVH4npo5u62AegItfdJ8g7KZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099127; c=relaxed/simple;
	bh=/BBGXEredEBYsprOWLO+NsXEoXSJlT0XK2zY6J6gY3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q30EjBYGFyYSEyOfTYqDJejCFjSaHfFzW8nHAoMStxGbT/X7jsluBelUTMRQwulrF9j3qz1Im4hgq+taqoqtIrEUvgUiZQ0ckw2xTGjvxLZ8v1urtQtyGb33fj1iMwxrSi232nERTRCJ3gxF95dpRUf4W1RdcGpGZGu0/nNZ9fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xHco4hAP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xHco4hAP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44BBC2BCAF;
	Mon, 13 Apr 2026 16:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099127;
	bh=/BBGXEredEBYsprOWLO+NsXEoXSJlT0XK2zY6J6gY3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xHco4hAPBCvkXMnH5FgvmGr26c9HwiSn77GNFD3LuMQq560G9LvGLiFbwS5zkM6YY
	 vdfjZlcugnar21jbrJDahJfUgVDnAFfDr7LwpGRUAbpbUW7ZYe1DuPWZqGK+jV5eqn
	 BtRE5dQC+GHIeK8vbm0syl1vlS1Gq1cMuei4+5ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 221/491] net: macb: fix uninitialized rx_fs_lock
Date: Mon, 13 Apr 2026 17:57:46 +0200
Message-ID: <20260413155827.337872571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 34b11cc56e4369bc08b1f4c4a04222d75ed596ce ]

If hardware doesn't support RX Flow Filters, rx_fs_lock spinlock is not
initialized leading to the following assertion splat triggerable via
set_rxnfc callback.

INFO: trying to register non-static key.
The code is fine but needs lockdep annotation, or maybe
you didn't initialize this object before use?
turning off the locking correctness validator.
CPU: 1 PID: 949 Comm: syz.0.6 Not tainted 6.1.164+ #113
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.16.1-0-g3208b098f51a-prebuilt.qemu.org 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x8d/0xba lib/dump_stack.c:106
 assign_lock_key kernel/locking/lockdep.c:974 [inline]
 register_lock_class+0x141b/0x17f0 kernel/locking/lockdep.c:1287
 __lock_acquire+0x74f/0x6c40 kernel/locking/lockdep.c:4928
 lock_acquire kernel/locking/lockdep.c:5662 [inline]
 lock_acquire+0x190/0x4b0 kernel/locking/lockdep.c:5627
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:110 [inline]
 _raw_spin_lock_irqsave+0x33/0x50 kernel/locking/spinlock.c:162
 gem_del_flow_filter drivers/net/ethernet/cadence/macb_main.c:3562 [inline]
 gem_set_rxnfc+0x533/0xac0 drivers/net/ethernet/cadence/macb_main.c:3667
 ethtool_set_rxnfc+0x18c/0x280 net/ethtool/ioctl.c:961
 __dev_ethtool net/ethtool/ioctl.c:2956 [inline]
 dev_ethtool+0x229c/0x6290 net/ethtool/ioctl.c:3095
 dev_ioctl+0x637/0x1070 net/core/dev_ioctl.c:510
 sock_do_ioctl+0x20d/0x2c0 net/socket.c:1215
 sock_ioctl+0x577/0x6d0 net/socket.c:1320
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x18c/0x210 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:46 [inline]
 do_syscall_64+0x35/0x80 arch/x86/entry/common.c:76
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

A more straightforward solution would be to always initialize rx_fs_lock,
just like rx_fs_list.  However, in this case the driver set_rxnfc callback
would return with a rather confusing error code, e.g. -EINVAL.  So deny
set_rxnfc attempts directly if the RX filtering feature is not supported
by hardware.

Fixes: ae8223de3df5 ("net: macb: Added support for RX filtering")
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20260316103826.74506-2-pchelkin@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cadence/macb_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index c407e8d0eb618..f49e4e0494db3 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -3381,6 +3381,9 @@ static int gem_set_rxnfc(struct net_device *netdev, struct ethtool_rxnfc *cmd)
 	struct macb *bp = netdev_priv(netdev);
 	int ret;
 
+	if (!(netdev->hw_features & NETIF_F_NTUPLE))
+		return -EOPNOTSUPP;
+
 	switch (cmd->cmd) {
 	case ETHTOOL_SRXCLSRLINS:
 		if ((cmd->fs.location >= bp->max_tuples)
-- 
2.51.0



