Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AEA373C1A;
	Thu, 30 Jul 2026 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426230; cv=none; b=LRYvH2Lve6wbN3ho7BFtSebxtM7MpwEBPRbfMXFWO8yiC3zo+r4qVB/6VvZVMBewjoYS+Ccl6sOJBRXLUDIgnSr3uWyc09l0YppnKiuvRK9bcGzZ3gQesEs++9rbQcoNRij9dNn29UcOfntXdwQXer9brQb89lpg+gU7VHoVbyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426230; c=relaxed/simple;
	bh=Oxbe2NyngQ++GScx+gDv9f76v7Co0/RVexqUubTifV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKYRsd/iFSzEwLTyxgjftbd/tfOPfPHRAVsPtfF0T7hErjC1rtLDL8BYoEMDVbbMqphBuH+kSWr/qJjEao0Dgihycmch4/IJbyPLIp3s/0AgW+sazWLBdrUy0BRDDCV8Kn0096cFkeMyPr0MyLBQnbruAx1mdsYzd0bNuZM0WLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6oq9ttt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6oq9ttt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1621F000E9;
	Thu, 30 Jul 2026 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426229;
	bh=RVRSRbnqap80LQtM9mRM7ac7HJIOQ5gQ1w1njMYIcjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R6oq9tttLaQsa4AXoqJWRX9SNLcF+c8IFHGZeVcAPK+3D8K5kKSujawUowGVQwx4j
	 JgQCjnXjxuMe4vv/GFemCiaZHKw+yhSAhr4yAbdGRyRtGTorY4iStjy1RdkedTI4eq
	 fUcmGlWUMAcnrIF11oMvIXqcoUMXspnjOWjLJp2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.12 346/602] wifi: ath6kl: fix OOB access from firmware ADDBA window size
Date: Thu, 30 Jul 2026 16:12:18 +0200
Message-ID: <20260730141443.231372995@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

commit 44126b6994eeb28f2103b638e698f40a1244f327 upstream.

aggr_recv_addba_req_evt() logs a debug message when the firmware-supplied
win_sz is outside [AGGR_WIN_SZ_MIN, AGGR_WIN_SZ_MAX] but does not
return. The out-of-range win_sz is then used in TID_WINDOW_SZ() to
compute a kzalloc size and stored in rxtid->hold_q_sz, leading to
zero-size or overflowed allocations and subsequent out-of-bounds access.

Clean up any previously active aggregation session for the TID first,
then return early when win_sz is out of the valid range, instead of
proceeding with a broken allocation size.

Fixes: bdcd81707973 ("Add ath6kl cleaned up driver")
Cc: stable@vger.kernel.org
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Link: https://patch.msgid.link/20260702005020.708717-1-tristmd@gmail.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -1722,13 +1722,15 @@ void aggr_recv_addba_req_evt(struct ath6
 
 	rxtid = &aggr_conn->rx_tid[tid];
 
-	if (win_sz < AGGR_WIN_SZ_MIN || win_sz > AGGR_WIN_SZ_MAX)
-		ath6kl_dbg(ATH6KL_DBG_WLAN_RX, "%s: win_sz %d, tid %d\n",
-			   __func__, win_sz, tid);
-
 	if (rxtid->aggr)
 		aggr_delete_tid_state(aggr_conn, tid);
 
+	if (win_sz < AGGR_WIN_SZ_MIN || win_sz > AGGR_WIN_SZ_MAX) {
+		ath6kl_dbg(ATH6KL_DBG_WLAN_RX, "%s: win_sz %d, tid %d\n",
+			   __func__, win_sz, tid);
+		return;
+	}
+
 	rxtid->seq_next = seq_no;
 	hold_q_size = TID_WINDOW_SZ(win_sz) * sizeof(struct skb_hold_q);
 	rxtid->hold_q = kzalloc(hold_q_size, GFP_KERNEL);


