Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45C8B431488;
	Thu, 30 Jul 2026 14:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421796; cv=none; b=jfLjxctC8QKIMJ/4zr5lUULNbU7dbEsbb46Z+QxEKqhE22eLZpPIjyQForS18Honu3xhXJ0yWyhs+aistZKs84SQHYF8acaL4TDe48VZARSUPctqwMUA253P4f49ipXVlj9PlwSCN2Ehkvosk6zl0zGSZ+yRGXocI6Upic3fWEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421796; c=relaxed/simple;
	bh=2tzp2zpjseYirD9sWyKTuy1FpLz2N+dyGE8U4ZHBIoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ri7Go1s4xt7pj+kHku+ErG3z/n6eYNpwsw3LUS255e0ht/cqp6TlcYrSo9K2fAcwxLgvyjSZsSDf+/O6D8Efwgno6T+R+8xlxNDNJqXEUXgHqAaVjP+Cfn5Y2gMiSuHd2AoSkkTPI1uI0nxMWqN1CgCCrGkUZmOyXN+n9wCos3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hw2ZT2M7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hw2ZT2M7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FFD21F000E9;
	Thu, 30 Jul 2026 14:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421795;
	bh=hniuPC1PDw5miaM5PJuEZvjlmehQSP1AJjEnBbb9E8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hw2ZT2M7cHU11C1ojHVju6uo8NUGaqp03auWIvuKw9A3fWP2XGMOABoeNhhXJBZ4d
	 uNOoqzZsV2yWEeKb+pm1k4CVomlhiyPZLb/MDkUuzsmAOGb1br1jhB0KZJ2l437PpQ
	 EmpPdtCA2S7JN05YFp4OXNXFWT6dHuvxbMVgaZJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 178/744] wifi: ath10k: fix skb leak on incomplete msdu during rx pop
Date: Thu, 30 Jul 2026 16:07:31 +0200
Message-ID: <20260730141448.069123607@linuxfoundation.org>
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

From: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>

[ Upstream commit 7393878255e492515858f751ba4c260f248fb108 ]

When ath10k_htt_rx_pop_paddr32_list() or
ath10k_htt_rx_pop_paddr64_list() encounters an incomplete frame
(RX_ATTENTION_FLAGS_MSDU_DONE not set), it returns -EIO without
purging the skb list built up so far, leaking any skbs already
queued in the list.

Other early-exit paths within these same functions already call
__skb_queue_purge() before returning an error. Add it before the
-EIO return as well to be consistent and prevent the leak.

Tested-on: WCN3990 hw1.0 WLAN.HL.3.2.2.c10-00754-QCAHLSWMTPL-1

Fixes: c545070e404b ("ath10k: implement rx reorder support")
Fixes: 3b0b55b19d1d ("ath10k: Add support for 64 bit HTT in-order indication msg")
Signed-off-by: Manikanta Pubbisetty <manikanta.pubbisetty@oss.qualcomm.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Link: https://patch.msgid.link/20260623064355.1876743-1-manikanta.pubbisetty@oss.qualcomm.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/htt_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 25ab945fecef2c..8f88ea116a32c7 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -707,6 +707,7 @@ static int ath10k_htt_rx_pop_paddr32_list(struct ath10k_htt *htt,
 			if (!(__le32_to_cpu(rxd_attention->flags) &
 			      RX_ATTENTION_FLAGS_MSDU_DONE)) {
 				ath10k_warn(htt->ar, "tried to pop an incomplete frame, oops!\n");
+				__skb_queue_purge(list);
 				return -EIO;
 			}
 		}
@@ -771,6 +772,7 @@ static int ath10k_htt_rx_pop_paddr64_list(struct ath10k_htt *htt,
 			if (!(__le32_to_cpu(rxd_attention->flags) &
 			      RX_ATTENTION_FLAGS_MSDU_DONE)) {
 				ath10k_warn(htt->ar, "tried to pop an incomplete frame, oops!\n");
+				__skb_queue_purge(list);
 				return -EIO;
 			}
 		}
-- 
2.53.0



