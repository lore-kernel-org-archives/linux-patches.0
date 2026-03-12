Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A91F2D0606;
	Thu, 12 Mar 2026 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347092; cv=none; b=a44paEaKihiWgsd0wNp+DbZx7d9HulNxcQN99nmKBQk4YTsxsL0tzd+J5Spg41pyxcarOwkkDJekqFI8fmLgBkw6gnNaz/8tvSFYqBEJTKkboN89lHzvA/14qtJkZlyVMejotgFOfT5R9l8YRvxXIJ+f/fbbEK2MKD/FoN5XawM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347092; c=relaxed/simple;
	bh=O87yiyeHch3BedHH2zx5vLrN4Gu3NgT0y28NJDnFFPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJ62Ju9dB7kk6xF8foEcperIdJqavvoU8mEn7Ue4vzSQwJisn2Pp/w+wfIoMMzzjO9+9bN3pb3mmNredknc3HC4GsLiHAEKZDr/xcb93ZXFOZrCJQ9Sg3X/opp7pCvTepq9xrOcp9+ORbMqNQ5jStL+JFjJpFb/4QF9jz/HwFGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TinjGtOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TinjGtOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BD6C2BC86;
	Thu, 12 Mar 2026 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347092;
	bh=O87yiyeHch3BedHH2zx5vLrN4Gu3NgT0y28NJDnFFPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TinjGtOwvywTWMkuUGkXWojzn5vz0ITs5H/iS9ZxFHyYszC7C8yoYzI9gBjcsIEDe
	 Cdqk2UBsVObPiNbZjNgUanfQmLiUodngupeGa5uasuT6E4UjxyyuMqHB0snhd2HGed
	 FF1XWR16BX5owhy2wC3L1RWRn7RugCfspgHnJEIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathesh Edara <sedara@marvell.com>,
	Shinas Rasheed <srasheed@marvell.com>,
	Vimlesh Kumar <vimleshk@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/265] octeon_ep: Relocate counter updates before NAPI
Date: Thu, 12 Mar 2026 21:09:48 +0100
Message-ID: <20260312201025.579870362@linuxfoundation.org>
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
index 449c55c09b4a5..b7b1e4fd306d1 100644
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



