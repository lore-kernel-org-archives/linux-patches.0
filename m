Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0EE38758A;
	Tue, 10 Mar 2026 11:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141234; cv=none; b=esc8SWlunmcqq6KdZd+Lg99mj8yvdqhH1wsAT1dRGhi7i6pjF3+ldqCEXLr5gXrG1pUkvXXa8CRtza31QHSnnf40jXusmAXn6sOdwxjuDF9HUp/mc8K0RVnEp4aTbhHQswFBtN3FlmaHa8PVXs8rabs2b3WuMHGgx0yw1BSg660=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141234; c=relaxed/simple;
	bh=LfPb6PnVHObb82wjpXWZ74Qo5NTXmf9poH5MsQo+8/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDDYFVD3Rh0XwNhGj9fwVEjq2esbZwi0fuo+bgCsXr/duz28xOblzbUjCv0id4T2FU7cyZwVGyuwfVWKm0jLv0H6Lf1NM3yebalJGzCaxQ644e25xVddI1Hyvq0ngwbZ+GtSPypoZJYsz+q7t5zDzwg238qF4wGtJZt7pG1yrUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O2Zvqcuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O2Zvqcuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BDEC2BC86;
	Tue, 10 Mar 2026 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141234;
	bh=LfPb6PnVHObb82wjpXWZ74Qo5NTXmf9poH5MsQo+8/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2Zvqcuja3LvaOCW4kLMpbz7JEb3h1BhMBPwy+r0dm1UsfFTgV4hufMQyqttuuawN
	 cwAprZMLWE6WghGZshZ0pVJhsZNRVYVpAz9e6EISa2Vhyrnah9naKmq5ob1BBRTviH
	 BPs8hfLrm9nOXGTenQxoJ1A3JVDXCT5PJsJApSRIp+PVsBg+xJ7WLAa7ZvXu1M8NtP
	 e8+PHBKPLXmVl8EtvH1P3Dkfe0pZGnrMFNA78qHE0emqstWK/eTdzjD1frkwQPXzQo
	 hVje4AZ40GE0nTVq4OKiVSQRNxyRRAJHafyGZfdtuB0Tq26s3Tqrgmr0SUxmH6ApMv
	 w3Lxydx+7EW1w==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 236/311] octeon_ep_vf: Relocate counter updates before NAPI
Date: Tue, 10 Mar 2026 07:04:43 -0400
Message-ID: <f453f9b7dcc977b53b4b6d3c3fa6abbeb6061074.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

[ Upstream commit 2ae7d20fb24f598f60faa8f6ecc856dac782261a ]

Relocate IQ/OQ IN/OUT_CNTS updates to occur before NAPI completion.
Moving the IQ/OQ counter updates before napi_complete_done ensures
1. Counter registers are updated before re-enabling interrupts.
2. Prevents a race where new packets arrive but counters aren't properly
   synchronized.

Fixes: 1cd3b407977c3 ("octeon_ep_vf: add Tx/Rx processing and interrupt support")
Signed-off-by: Sathesh Edara <sedara@marvell.com>
Signed-off-by: Shinas Rasheed <srasheed@marvell.com>
Signed-off-by: Vimlesh Kumar <vimleshk@marvell.com>
Link: https://patch.msgid.link/20260227091402.1773833-4-vimleshk@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeon_ep_vf/octep_vf_main.c        | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
index 1d9760b4b8f47..17efc8eab4cfb 100644
--- a/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep_vf/octep_vf_main.c
@@ -286,12 +286,13 @@ static void octep_vf_clean_irqs(struct octep_vf_device *oct)
 }
 
 /**
- * octep_vf_enable_ioq_irq() - Enable MSI-x interrupt of a Tx/Rx queue.
+ * octep_vf_update_pkt() - Update IQ/OQ IN/OUT_CNT registers.
  *
  * @iq: Octeon Tx queue data structure.
  * @oq: Octeon Rx queue data structure.
  */
-static void octep_vf_enable_ioq_irq(struct octep_vf_iq *iq, struct octep_vf_oq *oq)
+
+static void octep_vf_update_pkt(struct octep_vf_iq *iq, struct octep_vf_oq *oq)
 {
 	u32 pkts_pend = oq->pkts_pending;
 
@@ -308,6 +309,17 @@ static void octep_vf_enable_ioq_irq(struct octep_vf_iq *iq, struct octep_vf_oq *
 
 	/* Flush the previous wrties before writing to RESEND bit */
 	smp_wmb();
+}
+
+/**
+ * octep_vf_enable_ioq_irq() - Enable MSI-x interrupt of a Tx/Rx queue.
+ *
+ * @iq: Octeon Tx queue data structure.
+ * @oq: Octeon Rx queue data structure.
+ */
+static void octep_vf_enable_ioq_irq(struct octep_vf_iq *iq,
+				    struct octep_vf_oq *oq)
+{
 	writeq(1UL << OCTEP_VF_OQ_INTR_RESEND_BIT, oq->pkts_sent_reg);
 	writeq(1UL << OCTEP_VF_IQ_INTR_RESEND_BIT, iq->inst_cnt_reg);
 }
@@ -333,6 +345,7 @@ static int octep_vf_napi_poll(struct napi_struct *napi, int budget)
 	if (tx_pending || rx_done >= budget)
 		return budget;
 
+	octep_vf_update_pkt(ioq_vector->iq, ioq_vector->oq);
 	if (likely(napi_complete_done(napi, rx_done)))
 		octep_vf_enable_ioq_irq(ioq_vector->iq, ioq_vector->oq);
 
-- 
2.51.0

