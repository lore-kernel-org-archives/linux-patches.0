Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65DD13B58A;
	Thu, 13 Feb 2025 14:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458701; cv=none; b=srw5hqEkORAM1HLJBrStW3V1v7HC2HHGVh8VfzObWOC4ZcIi4xr4+WlDlRVa4hsZljWup3z5z4HSbyvaRyk+EWqXaWII9vcG+39Rzp8QATHSLJ0/0Yzs/j+GabR/lPUULkrSMcBSjYKAOScylKdH44r6BiYLEoI/b8hXTHBbRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458701; c=relaxed/simple;
	bh=uORuIQvjeNNuo8eZnjGQdCXIiMCxHz2NMwrn+mJ+P3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BoO9vrkZlyPJoCJsIWpdHUTgFN65vT0rKwTnSDWRbgwyITCF7o+cfAjdgkk1Hg6ePq8LDBI46XdPtN0AyO62l9Qm/dzUDO2Ie3Yo8glITei9pbPFu7jtRphLRiOokML46yCSJVrQotKNjy01n8ESiYDDAyRiKD+n6MnSLviqyp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uEbcAOLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uEbcAOLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2541FC4CEE5;
	Thu, 13 Feb 2025 14:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458701;
	bh=uORuIQvjeNNuo8eZnjGQdCXIiMCxHz2NMwrn+mJ+P3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uEbcAOLxCWEhjxPYYLo3RwxOp3Bqp5roju2m1cWVjjZhEbD2c1w4MtzOkVxGxGLvF
	 De/iQToIRCloctnQCCa6jMhh34PTgouLwoINP/JRlDA30q6gsk23hNPQtIfBw7c4uI
	 +8dPxluDQMJElJeCPx/KDfJTLo3JCslyIafSszYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Przybylski <karprzy7@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 053/443] wifi: ath12k: Fix for out-of bound access error
Date: Thu, 13 Feb 2025 15:23:38 +0100
Message-ID: <20250213142442.667988629@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Przybylski <karprzy7@gmail.com>

[ Upstream commit eb8c0534713865d190856f10bfc97cf0b88475b1 ]

Selfgen stats are placed in a buffer using print_array_to_buf_index() function.
Array length parameter passed to the function is too big, resulting in possible
out-of bound memory error.
Decreasing buffer size by one fixes faulty upper bound of passed array.

Discovered in coverity scan, CID 1600742 and CID 1600758

Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
Acked-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241105101132.374372-1-karprzy7@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index c9980c0193d1d..43ea87e981f42 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -1562,7 +1562,8 @@ ath12k_htt_print_tx_selfgen_ac_stats_tlv(const void *tag_buf, u16 tag_len,
 			 le32_to_cpu(htt_stats_buf->ac_mu_mimo_ndp));
 	len += print_array_to_buf_index(buf, len, "ac_mu_mimo_brpollX_tried = ", 1,
 					htt_stats_buf->ac_mu_mimo_brpoll,
-					ATH12K_HTT_TX_NUM_AC_MUMIMO_USER_STATS, "\n\n");
+					ATH12K_HTT_TX_NUM_AC_MUMIMO_USER_STATS - 1,
+					"\n\n");
 
 	stats_req->buf_len = len;
 }
@@ -1590,7 +1591,7 @@ ath12k_htt_print_tx_selfgen_ax_stats_tlv(const void *tag_buf, u16 tag_len,
 			 le32_to_cpu(htt_stats_buf->ax_mu_mimo_ndp));
 	len += print_array_to_buf_index(buf, len, "ax_mu_mimo_brpollX_tried = ", 1,
 					htt_stats_buf->ax_mu_mimo_brpoll,
-					ATH12K_HTT_TX_NUM_AX_MUMIMO_USER_STATS, "\n");
+					ATH12K_HTT_TX_NUM_AX_MUMIMO_USER_STATS - 1, "\n");
 	len += scnprintf(buf + len, buf_len - len, "ax_basic_trigger = %u\n",
 			 le32_to_cpu(htt_stats_buf->ax_basic_trigger));
 	len += scnprintf(buf + len, buf_len - len, "ax_ulmumimo_total_trigger = %u\n",
-- 
2.39.5



