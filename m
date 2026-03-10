Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B532138758A;
	Tue, 10 Mar 2026 11:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141232; cv=none; b=tQSzCNDhoDSau/SfGeQSQXGbRVGNJWtqpl7mRovfqx0ODsK43nCc5h/xh83Q233a10P1U386zcy3rhefOn9PnKC3+Mu4N+BylFzRDTu9r0ihzbK1hlo5+etjQ94ufDbNnXFOdCLNcPA93hv5eqGG1QgiF009VtTH/HgtG0uSpo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141232; c=relaxed/simple;
	bh=P/U7vbyeANPrCQteO2eH99cvpU8x03/Um4hgS9Uqxd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C8nSFwRpukH0hhr0ZlEGzwtMNA1t3Yb4shrcaWknGOgkcqbrTw9lUmJOVTCShvg9DeC/zrj2OQLLxvIsemPFXPEwBK4/Zys9r0/0O3igE8TG3hhSHgTacnGogSCJJ45lxd4RXHTs/LiDieX8oNA8KIb5vmaGARdR7BG37PjmhXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NFs2GZgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NFs2GZgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA089C19423;
	Tue, 10 Mar 2026 11:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141232;
	bh=P/U7vbyeANPrCQteO2eH99cvpU8x03/Um4hgS9Uqxd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFs2GZgfoiChgHF0soHHktwdL7wUJr6fqUcrgq5V6jlAcPsc/8HMJhh5l6GnCc4BA
	 afYSBlfUov0fnElD/mvKWATaCuC/Sru0Wk8UstXzVkik1VxTySBKKSinuA1iGqTK4N
	 c4t+rDDf098cYhascQgXv2C5GsKhnLt9SE02DRUbiW61UYy86np3hUsk6vFW8lOavm
	 cKdBWyzFBvyugimFfpAZfk2+Yj4gBgmhQvEOkT431oBc+uyk8U3jBeTQrQd+oFmt3r
	 6e0nevKorqZSeIK5Ko3R1WQcIl2BmdtGMKpDxYlyfqmNjJhtTI1T0qdKdO3JQZA+u7
	 kpqFPXzRHxDpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vimlesh Kumar <vimleshk@marvell.com>,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 234/311] octeon_ep: Relocate counter updates before NAPI
Date: Tue, 10 Mar 2026 07:04:41 -0400
Message-ID: <a92cee81884093cc2274c08598bcaa3a7aa93efb.1773140655.git.sashal@kernel.org>
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

