Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AED44AEC1;
	Mon,  1 Apr 2024 16:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990113; cv=none; b=h3DP+bhhUd7NzW3asTO4MZhpLO6Iq9EgEXhHHhKHJohajAYbElrix2vobIAZg2oYECqaB6z+aINVae2fHsGd81EmLWO+9VYhWaIE9ZRWHhIIpqAY2vWfHepa0lY3FkOTe9qdFszHEmlw3IemyTBGkq57FGutvVwc1/EYA0ZS1nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990113; c=relaxed/simple;
	bh=k+6ugTb+FT+HBGB3FBdd9i1YWqSRoYCzyBtpzvp73hY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7O5/jWOO+6wsBhM+A9o7MildDcpZfjeiCk17lb/pZG6O1+3mfUb+1h9pkkh64S2KdyyFmZL8oVKGs3JlA5L4odz2fTtHH8XlZdBZqpYMCqq5APdWDfenrNg5KUSAClaGKLC8AO8CIE4U2LfMVF21HuFE+RAB6w6cqHBShL9WyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GvTr2ujT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GvTr2ujT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAF8C433F1;
	Mon,  1 Apr 2024 16:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990113;
	bh=k+6ugTb+FT+HBGB3FBdd9i1YWqSRoYCzyBtpzvp73hY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GvTr2ujTZf5qFV5joehQvnj09IDJh6LKBCe7qG1c+vKx1OuQLKPh1w50K+4SEbaCL
	 RdlH4ffai9O1pz6xGNaR7zG8ZaV72K2eYqlmflcFcIIUjNxfAYSelEGcztL/6O5Jrl
	 HyDwJYtyXm7BGnoc8lM+2z04oTCAK4sD+FH+HLzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Aaron Ma <aaron.ma@canonical.com>
Subject: [PATCH 6.6 251/396] wifi: iwlwifi: pcie: fix RB status reading
Date: Mon,  1 Apr 2024 17:45:00 +0200
Message-ID: <20240401152555.394018746@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

commit 9f9797c7de18d2ec6be4ef6e0abbaea585040b39 upstream.

On newer hardware, a queue's RB status / write pointer
can be bigger than 4095 (0xFFF), so we cannot mask the
value by 0xFFF unconditionally. Since anyway that's
only necessary on older hardware, move the masking to
the helper function and apply it only for older HW.
This also moves the endian conversion in to handle it
more easily.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230830112059.7be2a3fff6f4.I94f11dee314a4f7c1941d2d223936b1fa8aa9ee4@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |    8 ++++----
 drivers/net/wireless/intel/iwlwifi/pcie/rx.c       |    2 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    |   12 ++++--------
 3 files changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -190,17 +190,17 @@ struct iwl_rb_allocator {
  * iwl_get_closed_rb_stts - get closed rb stts from different structs
  * @rxq - the rxq to get the rb stts from
  */
-static inline __le16 iwl_get_closed_rb_stts(struct iwl_trans *trans,
-					    struct iwl_rxq *rxq)
+static inline u16 iwl_get_closed_rb_stts(struct iwl_trans *trans,
+					 struct iwl_rxq *rxq)
 {
 	if (trans->trans_cfg->device_family >= IWL_DEVICE_FAMILY_AX210) {
 		__le16 *rb_stts = rxq->rb_stts;
 
-		return READ_ONCE(*rb_stts);
+		return le16_to_cpu(READ_ONCE(*rb_stts));
 	} else {
 		struct iwl_rb_status *rb_stts = rxq->rb_stts;
 
-		return READ_ONCE(rb_stts->closed_rb_num);
+		return le16_to_cpu(READ_ONCE(rb_stts->closed_rb_num)) & 0xFFF;
 	}
 }
 
--- a/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/rx.c
@@ -1510,7 +1510,7 @@ restart:
 	spin_lock(&rxq->lock);
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = le16_to_cpu(iwl_get_closed_rb_stts(trans, rxq)) & 0x0FFF;
+	r = iwl_get_closed_rb_stts(trans, rxq);
 	i = rxq->read;
 
 	/* W/A 9000 device step A0 wrap-around bug */
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2714,11 +2714,9 @@ static ssize_t iwl_dbgfs_rx_queue_read(s
 		pos += scnprintf(buf + pos, bufsz - pos, "\tfree_count: %u\n",
 				 rxq->free_count);
 		if (rxq->rb_stts) {
-			u32 r =	__le16_to_cpu(iwl_get_closed_rb_stts(trans,
-								     rxq));
+			u32 r =	iwl_get_closed_rb_stts(trans, rxq);
 			pos += scnprintf(buf + pos, bufsz - pos,
-					 "\tclosed_rb_num: %u\n",
-					 r & 0x0FFF);
+					 "\tclosed_rb_num: %u\n", r);
 		} else {
 			pos += scnprintf(buf + pos, bufsz - pos,
 					 "\tclosed_rb_num: Not Allocated\n");
@@ -3091,7 +3089,7 @@ static u32 iwl_trans_pcie_dump_rbs(struc
 
 	spin_lock_bh(&rxq->lock);
 
-	r = le16_to_cpu(iwl_get_closed_rb_stts(trans, rxq)) & 0x0FFF;
+	r = iwl_get_closed_rb_stts(trans, rxq);
 
 	for (i = rxq->read, j = 0;
 	     i != r && j < allocated_rb_nums;
@@ -3387,9 +3385,7 @@ iwl_trans_pcie_dump_data(struct iwl_tran
 		/* Dump RBs is supported only for pre-9000 devices (1 queue) */
 		struct iwl_rxq *rxq = &trans_pcie->rxq[0];
 		/* RBs */
-		num_rbs =
-			le16_to_cpu(iwl_get_closed_rb_stts(trans, rxq))
-			& 0x0FFF;
+		num_rbs = iwl_get_closed_rb_stts(trans, rxq);
 		num_rbs = (num_rbs - rxq->read) & RX_QUEUE_MASK;
 		len += num_rbs * (sizeof(*data) +
 				  sizeof(struct iwl_fw_error_dump_rb) +


