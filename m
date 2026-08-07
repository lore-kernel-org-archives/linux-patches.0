Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCDA42D758;
	Fri,  7 Aug 2026 15:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116884; cv=none; b=BC6mlRI77cOyxijttixtnt5vA7D/RwGSi9c8nrWNTnTi2so/ZBgqWSG0L82kj2c2YIlHD4kXjeXjCiu47sAwbwarxevDJYmH5CNEgzM51eGtQcTWPGIUseMRl+NLJgV1DsFmHsnexUPL2Wjc0I4vZ3s9ri3rDF2ekwctrWjaAyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116884; c=relaxed/simple;
	bh=NX8cLBdx42GnH0YPBC+81v4M+/1WeoHWO0avWUJLTqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MV1ph7DRXbTMK0qCCnsBWaESol5F61/4Yle+cYnyDVsBtYjBX7HKSd6cV+diDgcAZZk18mEXPOYGaA1ac8Am8gfr7pXiArM4yh6oLIUGNsA+NKmh/U1fg7XqQDaJQ+2OfvLMWFR5Bx7P0Vz76El30gRobqpOIScsJNrzqYZDEmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HIx+wE0C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HIx+wE0C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A644C1F000E9;
	Fri,  7 Aug 2026 15:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116883;
	bh=Jh0TuWFLqg0S7OQmgYmbOQDpUImLEWCNiNnU3LPtmGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HIx+wE0C4gl7qA0WqgmbqS7DZiezlIWGNsb41w+dOvuan8rG4SBVDK6ILgPoqCHa/
	 Q5p+Fi1EjG843krNQ85DsaamAWTcFNq4y4ApCooefGEmMstQj650VU8YDbrGnoxNb0
	 i76si6R/DHYeTHGY+wNsRyntBXtt0qyFaxEOLtaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hay <joshua.a.hay@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 125/438] idpf: adjust TxQ ring count minimum
Date: Fri,  7 Aug 2026 16:35:21 +0200
Message-ID: <20260807143430.660218813@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joshua Hay <joshua.a.hay@intel.com>

[ Upstream commit bef152db47debcd14cbacefc5767f6f026c4bc89 ]

Set the TxQ ring count minimum to 128 descriptors. Any lower than this,
and the queue will stall and trigger Tx timeouts in flow based
scheduling mode. This is because next_to_clean might never be updated.

In flow based scheduling mode, next_to_clean is only updated after a
descriptor completion is processed, i.e. after the RE bit is set in the
last descriptor of a Tx packet. This will never happen with a ring size
of 64 and an IDPF_TX_SPLITQ_RE_MIN_GAP of 64. No matter what the value
of last_re is initialized/set to, the calculated gap will be at most 63
and never trigger the RE bit.

Even a ring size of 96 does not solve this. Because of how infrequent
next_to_clean is updated and how small the ring is, IDPF_DESC_UNUSED
will be much smaller on average. This increases the chance the queue
will be stopped because a multi-descriptor packet, e.g. a large LSO
packet, does not see enough resources on the ring. In this case, the
queue will trigger the stop logic. The queue permanently stalls because
there is no chance for a descriptor completion to update next_to_clean
since it is dependent on a packet being sent.

Fixes: 5f417d551324 ("idpf: replace flow scheduling buffer ring with buffer pool")
Signed-off-by: Joshua Hay <joshua.a.hay@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 5 +----
 drivers/net/ethernet/intel/idpf/idpf_txrx.h | 2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index f6b3b15364ff6..bddb601ee411c 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3097,10 +3097,7 @@ static netdev_tx_t idpf_tx_splitq_frame(struct sk_buff *skb,
 
 		tx_params.dtype = IDPF_TX_DESC_DTYPE_FLEX_FLOW_SCHE;
 		tx_params.eop_cmd = IDPF_TXD_FLEX_FLOW_CMD_EOP;
-		/* Set the RE bit to periodically "clean" the descriptor ring.
-		 * MIN_GAP is set to MIN_RING size to ensure it will be set at
-		 * least once each time around the ring.
-		 */
+		/* Set the RE bit periodically to "clean" the descriptor ring */
 		if (idpf_tx_splitq_need_re(tx_q)) {
 			tx_params.eop_cmd |= IDPF_TXD_FLEX_FLOW_CMD_RE;
 			tx_q->txq_grp->num_completions_pending++;
diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.h b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
index 4be5b3b6d3ed2..908dfa28674eb 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.h
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.h
@@ -21,7 +21,7 @@
 /* Mailbox Queue */
 #define IDPF_MAX_MBXQ				1
 
-#define IDPF_MIN_TXQ_DESC			64
+#define IDPF_MIN_TXQ_DESC			128
 #define IDPF_MIN_RXQ_DESC			64
 #define IDPF_MIN_TXQ_COMPLQ_DESC		256
 #define IDPF_MAX_QIDS				256
-- 
2.53.0



