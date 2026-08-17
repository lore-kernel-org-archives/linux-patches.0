Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB7B43F0B1;
	Mon, 17 Aug 2026 14:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977006; cv=none; b=Us9eG2iPXTdI6T4yVyKA8k7JCQkpuk2yiQz4UrhjJX+0wa6fCOCp1W0YWuLhvSjsBmcV4jZdUbThRLY8X95Q4JiGvpLZkFzE3NDcdCq25Vf+UxolpnORBLpdCcEKpI2si4oY6dezesI8w8j2+rnE/3GxtFWAOgp5fm6sn0pvxas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977006; c=relaxed/simple;
	bh=K2qPyBp1yOh8s/m0CSRL6iuZFSovpxgSYKqYtR5nx9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRYW3FN/wiGUmDDPTqK/XphKJYh1PGd9i5SEWEnBoKJHrabAWthhoSf9H+DUo+0qVwyIVuCrC8DSQVUO0AFuWYN1S2WLIMXu3VUUJwSDvtuvSNyVRAoj9Ew8Af9nhQxwOAjNDBQ9Vp3FOnlWjCNfCxlLZlKtAAHMg5oREgw7AwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4yOHDks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4yOHDks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303411F00A3D;
	Mon, 17 Aug 2026 14:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977003;
	bh=CdvplcpdC+05ykCvp53NfwNVhs+hT7KCRfrcC2vbNzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4yOHDksrEIzl43gjhLvoZLOZiH0AeRr/GrG7UiakPlm6ldDamxFrqHkLVpuO5stK
	 L8cF8Zau2z2UxN21l5Y634tLDDg9q9yhZKF3cjBCEVDyXb5zgqkraGrPEjRCAZETLt
	 EyDCRN8u0q40CNduz/jCvBu/0Uts/4AtoZtikC5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Tristan Madani <tristan@talencesecurity.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Subject: [PATCH 5.15 178/456] wifi: ath6kl: fix OOB access from firmware ADDBA window size
Date: Mon, 17 Aug 2026 15:29:28 +0200
Message-ID: <20260817132547.079102038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


