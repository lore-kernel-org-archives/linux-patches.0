Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9082C37B413;
	Tue, 10 Mar 2026 11:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142161; cv=none; b=oHjKifbOIwa9kbNwqg51cOeTEfPppC99LzBtDVA1PCWrbuyH4w1IFn6CRsRlASiKmJz1FtqNcDitnJMYOoK3qmaT1Ypu4U3TFDnyQmSbfAATWL/y9f2cqyOM+SR15KVrjq2ytEBoaQAtvShQtP0S+2Bb2ibWusyx2Ps9wA8W1Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142161; c=relaxed/simple;
	bh=P/U7vbyeANPrCQteO2eH99cvpU8x03/Um4hgS9Uqxd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duEe39f52nMrMGoqoVFqgsjcBwtXvKoqqBpQCHIjo7x8zfsAVK0rXbt7tNVCyzzGf8iOOwJRtQ9gSq2Y4/j9xlmuXA+CA76mqxiUCAcA+XF2b8Z9n2+PxaNsqNEjC+IsoUFKxlkhB8JooYow95RwMCnd7Iau7tgc3KW78zVTW6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oEDDGVRo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oEDDGVRo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1A7FC2BC9E;
	Tue, 10 Mar 2026 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142161;
	bh=P/U7vbyeANPrCQteO2eH99cvpU8x03/Um4hgS9Uqxd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oEDDGVRonLt5LkMeeh2DX3OMgUh5W8MzUdllTG4h1X7361erd0mBCPzGPJhjTbj9F
	 uWFNskRL4OtJt6zwb4MVL54X1nSc6PyLHNU9iXPA9AiMW1HyiOL8uTDUWnrYgZJSs8
	 kYKof++DPjXIxcK0KaX4BsQGmyr9IXRUFBprc49PlfWNfqgjgS9/DmLdOCAOoBaZZ5
	 z+QMDDSNFlntkOuk8a71MWnhHJLzwpocjsnhhZUgRVIhAzzbInBlIHVaNz902ADRZP
	 xdHWS3yrBDQWbsBTtuOMeK+KC++ZhihcUYoPNmPti1rT+vnpb4IpRlrVORZxtYU+lG
	 ywa3P+J02L+Aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 249/314] octeon_ep: Relocate counter updates before NAPI
Date: Tue, 10 Mar 2026 07:18:28 -0400
Message-ID: <04aec65f4968b246d654b3226e7b1996267e3720.1773141555.git.sashal@kernel.org>
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

From: Vimlesh Kumar <vimleshk@marvell.com>

[ Upstream commit 18c04a808c436d629d5812ce883e3822a5f5a47f ]

Relocate IQ/OQ IN/OUT_CNTS updates to occur before NAPI completion,
and replace napi_complete with napi_complete_done.

Moving the IQ/OQ counter updates before napi_complete_done ensures
1. Counter registers are updated before re-enabling interrupts.
2. Prevents a race where new packets arrive but counters aren't properly
   synchronized.
napi_complete_done (vs napi_complete) allows for better
interrupt coalescing.

Fixes: 37d79d0596062 ("octeon_ep: add Tx/Rx processing and interrupt support")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260227091402.1773833-2-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeon_ep/octep_main.c   | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 57db7ea2f5be9..7f8ed8f0ade49 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -555,12 +555,12 @@ static void octep_clean_irqs(struct octep_device *oct)
 }
 
 /**
- * octep_enable_ioq_irq() - Enable MSI-x interrupt of a Tx/Rx queue.
+ * octep_update_pkt() - Update IQ/OQ IN/OUT_CNT registers.
  *
  * @iq: Octeon Tx queue data structure.
  * @oq: Octeon Rx queue data structure.
  */
-static void octep_enable_ioq_irq(struct octep_iq *iq, struct octep_oq *oq)
+static void octep_update_pkt(struct octep_iq *iq, struct octep_oq *oq)
 {
 	u32 pkts_pend = oq->pkts_pending;
 
@@ -576,7 +576,17 @@ static void octep_enable_ioq_irq(struct octep_iq *iq, struct octep_oq *oq)
 	}
 
 	/* Flush the previous wrties before writing to RESEND bit */
-	wmb();
+	smp_wmb();
+}
+
+/**
+ * octep_enable_ioq_irq() - Enable MSI-x interrupt of a Tx/Rx queue.
+ *
+ * @iq: Octeon Tx queue data structure.
+ * @oq: Octeon Rx queue data structure.
+ */
+static void octep_enable_ioq_irq(struct octep_iq *iq, struct octep_oq *oq)
+{
 	writeq(1UL << OCTEP_OQ_INTR_RESEND_BIT, oq->pkts_sent_reg);
 	writeq(1UL << OCTEP_IQ_INTR_RESEND_BIT, iq->inst_cnt_reg);
 }
@@ -602,7 +612,8 @@ static int octep_napi_poll(struct napi_struct *napi, int budget)
 	if (tx_pending || rx_done >= budget)
 		return budget;
 
-	napi_complete(napi);
+	octep_update_pkt(ioq_vector->iq, ioq_vector->oq);
+	napi_complete_done(napi, rx_done);
 	octep_enable_ioq_irq(ioq_vector->iq, ioq_vector->oq);
 	return rx_done;
 }
-- 
2.51.0

