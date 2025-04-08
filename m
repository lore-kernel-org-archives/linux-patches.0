Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0000F264A76;
	Tue,  8 Apr 2025 11:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111962; cv=none; b=kS24V074Q3wxYzT4PMWR6si2LbKZkp0xb5tU6zMFZ4tiBW/f/jY/lIs1kC0wTC07IEphC+Ne7X3MsA4ovhDlU0edOUe8YUmKfOqU74JuS6y5xWiIOG1719fsGPeyoa0x4rq4cYANfpktli1PkQ3AtiDJHh5CAWFLKed98HraFt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111962; c=relaxed/simple;
	bh=lwi8Z8fomoGD7Hbkw0YSSrYb2XfNStP/9wUoU5kkCns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sTAsGWQIjvQqvuo6tNq/Cl5eBgnWovKSszT+5OHwxNqzpOWbQNE+kM958qL6RqvHKWv1cZYHpb6Dkp+Iwj6lYW9aH1SyYyIErNaR8SwqjteSS33qevWmiFhFa0vE75PO/97Z6c0uwbavVaFa+3GiwY4hDdwABA6IoEAKr10ckgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A++o0VxH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A++o0VxH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BF99C4CEE5;
	Tue,  8 Apr 2025 11:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111961;
	bh=lwi8Z8fomoGD7Hbkw0YSSrYb2XfNStP/9wUoU5kkCns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A++o0VxHMHwAkXg5o5Cm/iAVVDiEIh0iLi7O+YjhB4MnvEt5JHKDJohS+gJW7Tt9l
	 hTN6MYrV+UiWBdA4YK7K5ksf3BiBh7ACl91g1g3UjBZ4duh7+23QId2Js/56dIZXmj
	 iZR4WLoz6tWlreyfD01YGRx74fWF8htEKHLPu4lU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 623/731] net: airoha: Fix qid report in airoha_tc_get_htb_get_leaf_queue()
Date: Tue,  8 Apr 2025 12:48:40 +0200
Message-ID: <20250408104928.765263278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 57b290d97c6150774bf929117ca737a26d8fc33d ]

Fix the following kernel warning deleting HTB offloaded leafs and/or root
HTB qdisc in airoha_eth driver properly reporting qid in
airoha_tc_get_htb_get_leaf_queue routine.

$tc qdisc replace dev eth1 root handle 10: htb offload
$tc class add dev eth1 arent 10: classid 10:4 htb rate 100mbit ceil 100mbit
$tc qdisc replace dev eth1 parent 10:4 handle 4: ets bands 8 \
 quanta 1514 3028 4542 6056 7570 9084 10598 12112
$tc qdisc del dev eth1 root

[   55.827864] ------------[ cut here ]------------
[   55.832493] WARNING: CPU: 3 PID: 2678 at 0xffffffc0798695a4
[   55.956510] CPU: 3 PID: 2678 Comm: tc Tainted: G           O 6.6.71 #0
[   55.963557] Hardware name: Airoha AN7581 Evaluation Board (DT)
[   55.969383] pstate: 20400005 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[   55.976344] pc : 0xffffffc0798695a4
[   55.979851] lr : 0xffffffc079869a20
[   55.983358] sp : ffffffc0850536a0
[   55.986665] x29: ffffffc0850536a0 x28: 0000000000000024 x27: 0000000000000001
[   55.993800] x26: 0000000000000000 x25: ffffff8008b19000 x24: ffffff800222e800
[   56.000935] x23: 0000000000000001 x22: 0000000000000000 x21: ffffff8008b19000
[   56.008071] x20: ffffff8002225800 x19: ffffff800379d000 x18: 0000000000000000
[   56.015206] x17: ffffffbf9ea59000 x16: ffffffc080018000 x15: 0000000000000000
[   56.022342] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000001
[   56.029478] x11: ffffffc081471008 x10: ffffffc081575a98 x9 : 0000000000000000
[   56.036614] x8 : ffffffc08167fd40 x7 : ffffffc08069e104 x6 : ffffff8007f86000
[   56.043748] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000001
[   56.050884] x2 : 0000000000000000 x1 : 0000000000000250 x0 : ffffff800222c000
[   56.058020] Call trace:
[   56.060459]  0xffffffc0798695a4
[   56.063618]  0xffffffc079869a20
[   56.066777]  __qdisc_destroy+0x40/0xa0
[   56.070528]  qdisc_put+0x54/0x6c
[   56.073748]  qdisc_graft+0x41c/0x648
[   56.077324]  tc_get_qdisc+0x168/0x2f8
[   56.080978]  rtnetlink_rcv_msg+0x230/0x330
[   56.085076]  netlink_rcv_skb+0x5c/0x128
[   56.088913]  rtnetlink_rcv+0x14/0x1c
[   56.092490]  netlink_unicast+0x1e0/0x2c8
[   56.096413]  netlink_sendmsg+0x198/0x3c8
[   56.100337]  ____sys_sendmsg+0x1c4/0x274
[   56.104261]  ___sys_sendmsg+0x7c/0xc0
[   56.107924]  __sys_sendmsg+0x44/0x98
[   56.111492]  __arm64_sys_sendmsg+0x20/0x28
[   56.115580]  invoke_syscall.constprop.0+0x58/0xfc
[   56.120285]  do_el0_svc+0x3c/0xbc
[   56.123592]  el0_svc+0x18/0x4c
[   56.126647]  el0t_64_sync_handler+0x118/0x124
[   56.131005]  el0t_64_sync+0x150/0x154
[   56.134660] ---[ end trace 0000000000000000 ]---

Fixes: ef1ca9271313b ("net: airoha: Add sched HTB offload support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Paolo Abeni <pabeni@redhat.com>
Link: https://patch.msgid.link/20250331-airoha-htb-qdisc-offload-del-fix-v1-1-4ea429c2c968@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/airoha_eth.c b/drivers/net/ethernet/mediatek/airoha_eth.c
index c1c2ab82a08d8..71975c490822b 100644
--- a/drivers/net/ethernet/mediatek/airoha_eth.c
+++ b/drivers/net/ethernet/mediatek/airoha_eth.c
@@ -3082,7 +3082,7 @@ static int airoha_tc_get_htb_get_leaf_queue(struct airoha_gdm_port *port,
 		return -EINVAL;
 	}
 
-	opt->qid = channel;
+	opt->qid = AIROHA_NUM_TX_RING + channel;
 
 	return 0;
 }
-- 
2.39.5



