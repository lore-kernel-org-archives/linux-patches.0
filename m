Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 061D1389471;
	Tue, 10 Mar 2026 11:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142131; cv=none; b=i8YA5zZDZK89DGwhyS+bMj6oUN323ms+0fsjtiEbvF15Y4fUg6Ei0db68v+KJ1TD7wp4amyTZuzcGy7NCi6Iw6mlC83C4gVn7dvd7TSxD3CojyrpUl/Vavj7P8BgyBVrOR1c5J8ApHUzY6SzT/d59pKmSeAzecHdBdTDyDzQjnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142131; c=relaxed/simple;
	bh=6cVlYM+xom/ldvAZv/JBjKwJK9GzTSPcAb/IlysbBPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o88u2UAXOMmRkrLKJUilWtHub7QMxZx3DohEFciNpClqwUHElvso5Jyky1Gt5OBbY8OkVhoqptPhj3wS49Fvwtq4mQOcDtFEMTko0izxxEQuIOqUu9es5Z2lca0EBb71aVw4JJl3HkY4KRyuR4wPZVNiEQ0bnYW51rdfkxfyz/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5JtDtmy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5JtDtmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AE9C2BC9E;
	Tue, 10 Mar 2026 11:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142130;
	bh=6cVlYM+xom/ldvAZv/JBjKwJK9GzTSPcAb/IlysbBPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5JtDtmy3JC08uLcgq0GzPTYuMLoQz9Kra+cZfdQJJbzDSSKrABD1UO+F6uBL+QTw
	 kayZF6AktPWC0LSzC8K0RZuDzoDCwNB6cKbCPKPDyZ2mH7l7ae080FoQsW2nLZgGKg
	 pzA3BwP/dY4QdJAtNZsyxd1cVSD+LBeAUEAamsBlfvOFvcyRmA0RC3S4NxmjDS1vc7
	 zs+RQ5OmTgDSYvDUa5wZ1w4xeaxZGvT+qHGSdaprsAD8WSQ66MCb3vuhlaodg7auy+
	 HXnvtvKrCQZ64m8rX+CXVQpHIIonpijeJQa1wX5tU3WzJfR/0HXTudh+F2hHZe1o+F
	 Grgwafw7MiPJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Brian Vazquez <brianvv@google.com>,
	Brett Creeley <brett.creeley@amd.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Eric Dumazet <edumazet@google.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 219/314] idpf: change IRQ naming to match netdev and ethtool queue numbering
Date: Tue, 10 Mar 2026 07:17:58 -0400
Message-ID: <1f30b65db9cdec0cc6ac9478b49d452d1c00e69f.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 83cc9504e7e1a..c859665b2dc89 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -4038,7 +4038,7 @@ static int idpf_vport_intr_req_irq(struct idpf_vport *vport)
 			continue;
 
 		name = kasprintf(GFP_KERNEL, "%s-%s-%s-%d", drv_name, if_name,
-				 vec_name, vidx);
+				 vec_name, vector);
 
 		err = request_irq(irq_num, idpf_vport_intr_clean_queues, 0,
 				  name, q_vector);
-- 
2.51.0

