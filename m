Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57AC234F474;
	Thu, 12 Mar 2026 20:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347013; cv=none; b=h3n0yQV3DK5feLHWNHq8uj0DqCy7O3NBcGKfImdp5mV3rA4EdC8UR6yv4VryMrlY3k7VcT1OUGzKyraHSMxB1b0JqeWz7ofaYi9ia9CUTXRPiaoqAWvyuXVKxEp3j05k5Rf1wb/+7PVgZXTV2ZwRRvHkV133l6zY202ckNiMjDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347013; c=relaxed/simple;
	bh=LdsWnXvkjJSRQ3TZrX4L5XsXfuZ4Hbor8vbVycC8468=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABb1xSdE+IfTifNTEMPQWI3OS4/1JzmacEbH6NsJ7pjrQ3ZjLSaG7DZhQ57WP6CbSvTzha/f/Gjq6+ABsu59Ys03DXCCcyoLloxeru3T9BRng3Pe57JCpN0SWM97rKaCnq3H/GtVuR++FQLhZlyel92YbBebYOxXJznih3/IGHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmkoFerY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmkoFerY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA23CC4CEF7;
	Thu, 12 Mar 2026 20:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347013;
	bh=LdsWnXvkjJSRQ3TZrX4L5XsXfuZ4Hbor8vbVycC8468=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmkoFerYRWUHHA55xeA5jiZQ22Q9zJ62foi3D3LrSsd8gJstSn59OErt1leuQ1LPq
	 WhoDTZgBzlK6CYvALqPh7MyCUD/YynPn80OqgsRuQZeTM8tZrXMPZgk+gEpLF2cI8G
	 se87A5RI+OLW+IqHVHm/WiWX6yVT7j4BqJ+X9IEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Vazquez <brianvv@google.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Eric Dumazet <edumazet@google.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 180/265] idpf: change IRQ naming to match netdev and ethtool queue numbering
Date: Thu, 12 Mar 2026 21:09:27 +0100
Message-ID: <20260312201024.808442196@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit 1500a8662d2d41d6bb03e034de45ddfe6d7d362d ]

The code uses the vidx for the IRQ name but that doesn't match ethtool
reporting nor netdev naming, this makes it hard to tune the device and
associate queues with IRQs. Sequentially requesting irqs starting from
'0' makes the output consistent.

This commit changes the interrupt numbering but preserves the name
format, maintaining ABI compatibility. Existing tools relying on the old
numbering are already non-functional, as they lack a useful correlation
to the interrupts.

Before:

ethtool -L eth1 tx 1 combined 3

grep . /proc/irq/*/*idpf*/../smp_affinity_list
/proc/irq/67/idpf-Mailbox-0/../smp_affinity_list:0-55,112-167
/proc/irq/68/idpf-eth1-TxRx-1/../smp_affinity_list:0
/proc/irq/70/idpf-eth1-TxRx-3/../smp_affinity_list:1
/proc/irq/71/idpf-eth1-TxRx-4/../smp_affinity_list:2
/proc/irq/72/idpf-eth1-Tx-5/../smp_affinity_list:3

ethtool -S eth1 | grep -v ': 0'
NIC statistics:
     tx_q-0_pkts: 1002
     tx_q-1_pkts: 2679
     tx_q-2_pkts: 1113
     tx_q-3_pkts: 1192 <----- tx_q-3 vs idpf-eth1-Tx-5
     rx_q-0_pkts: 1143
     rx_q-1_pkts: 3172
     rx_q-2_pkts: 1074

After:

ethtool -L eth1 tx 1 combined 3

grep . /proc/irq/*/*idpf*/../smp_affinity_list

/proc/irq/67/idpf-Mailbox-0/../smp_affinity_list:0-55,112-167
/proc/irq/68/idpf-eth1-TxRx-0/../smp_affinity_list:0
/proc/irq/70/idpf-eth1-TxRx-1/../smp_affinity_list:1
/proc/irq/71/idpf-eth1-TxRx-2/../smp_affinity_list:2
/proc/irq/72/idpf-eth1-Tx-3/../smp_affinity_list:3

ethtool -S eth1 | grep -v ': 0'
NIC statistics:
     tx_q-0_pkts: 118
     tx_q-1_pkts: 134
     tx_q-2_pkts: 228
     tx_q-3_pkts: 138 <--- tx_q-3 matches idpf-eth1-Tx-3
     rx_q-0_pkts: 111
     rx_q-1_pkts: 366
     rx_q-2_pkts: 120

Fixes: d4d558718266 ("idpf: initialize interrupts and enable vport")
Signed-off-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 3ddf7b1e85ef4..6d33783ac8db4 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3477,7 +3477,7 @@ static int idpf_vport_intr_req_irq(struct idpf_vport *vport)
 			continue;
 
 		name = kasprintf(GFP_KERNEL, "%s-%s-%s-%d", drv_name, if_name,
-				 vec_name, vidx);
+				 vec_name, vector);
 
 		err = request_irq(irq_num, idpf_vport_intr_clean_queues, 0,
 				  name, q_vector);
-- 
2.51.0



