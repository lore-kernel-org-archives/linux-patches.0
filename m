Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAE034D385;
	Thu, 30 Jul 2026 14:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422752; cv=none; b=Zfl4pbkQIJABsjQw70rrdfUdWnCPwLMmJsjSQzZkrnItv3/+5tkIfRzB8jXwr/38DllS8cIy1Ls8wvENHqN6pFrGgBH+XIAxeBozU0Gabh74fLNoDjYvHHSTJ7ABL35hqijaTOIPQpnEZpsjS3Hu3p75hcZGDv2QC72g5GWR7Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422752; c=relaxed/simple;
	bh=WglJgg5reqXbKNVm7djSeq3EbWY5i1MuBqYQjTCDGjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt3NWnnRxYk3iExLKJYOiEUbrjatttmj+I9RIibbk6hnYM/S4RBLGGSzM1CpQWIEUJxmaB2NHOe2x7uPuMf71bc905YluApdQl7zLqHLC01wTz1aptVbCSS3so76/hiip81UQXsfHahBqAwiSn0jtPhue3pkflN1w5myWEHiQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RNFuGYMZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RNFuGYMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 519C21F000E9;
	Thu, 30 Jul 2026 14:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422750;
	bh=R2P5sGU1a9+6cRhQgTU8xknpQVmHIS+qSsPt8LgT5xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RNFuGYMZexPqUi2U2ces1mHOwD2MkQ9MsWhWVsjUg+ESLBaO49+KsbDQ1M/hO37+H
	 bpvUStqq4kTrLfHQ9n+UhjqimCSuM2gmNWPO0ByEhMYJ2G5/LqeEnKMY6PotA8fqsJ
	 0ZDms34V5beT4OnW8ZXrboCWvPBJ3hjXFRuwaAT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 7.1 543/744] wifi: ath6kl: fix OOB access from firmware ADDBA window size
Date: Thu, 30 Jul 2026 16:13:36 +0200
Message-ID: <20260730141455.817378352@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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
@@ -1723,13 +1723,15 @@ void aggr_recv_addba_req_evt(struct ath6
 
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


