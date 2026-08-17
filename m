Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794CE442370;
	Mon, 17 Aug 2026 15:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979419; cv=none; b=GBXhF+7KOY4Vpu6PBumRV+eiAoz+tup9IXceJLaVn8TkYb7Xr4CG3pYAhZWKFT3xUovbGRIdEEwK/jQZJZqc47ynQ1vyY4QUnODi8BwBJB/1VXhuihuXEBdhMU/8dx3+SOAVoVN2ZOeSDm3H3kKQcIA5ML16m2xvfbRV/mPabMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979419; c=relaxed/simple;
	bh=24h8/A3aH5Sv6kqcDpNUSlVKY2fg6HerSfyJb4UeIAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRtZRbP+UBNRWXILaNuqexFLSLp/Q19eTZQys8nm9oXfaGYsVje1ZtPcyDScYoQSSHbsV/l/ZPnna1wV9i/CLndJLTFZ0gt1ld4MA2T3FzD2wgk2FfyuCT7Fdm4yKfGN/8IUAIUqbm4SEq+indlegkiaHIN3rp9Gmrdt5DfFAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EELTGrsw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EELTGrsw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC5A1F000E9;
	Mon, 17 Aug 2026 15:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979418;
	bh=JC5zFO97zWdcGWtpBA7MsBCmGIQRNt2qABGrpcQWOt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EELTGrswSPLFVU2k/c+O0oMqjt7fDgI4LU5NusaHYJoAAC6x10sTUs23nfJkrdXTO
	 jyavMpDKFxMcJFewbW6xNJB9ghRptN5SUeedts7p255effcChIro2cbjCU3IoY2Q6I
	 YDqDULuVuhWM2FBqYjlDqh4OuFxUrUAvZKFTOhgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 6.1 219/609] wifi: ath6kl: fix OOB access from firmware ADDBA window size
Date: Mon, 17 Aug 2026 15:28:35 +0200
Message-ID: <20260817132551.422530480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


