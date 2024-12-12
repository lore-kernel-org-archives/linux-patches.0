Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CED2054F8;
	Thu, 12 Dec 2024 16:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021264; cv=none; b=O9c1qbF2RYyxg2opCIQMfy3NL9grWHLUSKz2dgkHjZa715G4ZrolrnsUImZBSkXncLqaQXMcbcKxDaYfI7t8wO7onRNpvN2EdqpfXc8stVVwhbWKU1DYwiPzMFKXwVHoat8SR0jO7uEJTnHJzolYpcgnNbWv09qCTZ+K7iUkhCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021264; c=relaxed/simple;
	bh=IZWcq7SsygHkpqBQ1Kk9cA83MXdSmetXEI9OUAuSzEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YjER1Mfdrg0mc99uzZ44TEJnWCvesOUbZmB+xms7X/xcuaZtPYXNDgE9LIoJuweAgQRWaFuJhm6w7VPXRWPBadB+iXxxYJkltQDOKMBjH9N9Hoo5QUvE4GNgQeuOVH2fGzVqR3kUWP3xZrvPs1n+kNDIut26xjcHrt82zc2FBvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poqY2Fc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poqY2Fc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF20AC4CECE;
	Thu, 12 Dec 2024 16:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021264;
	bh=IZWcq7SsygHkpqBQ1Kk9cA83MXdSmetXEI9OUAuSzEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poqY2Fc+nJQFvLq91BXI68Iv8qqW1fyg2F9u0FF1/CwIhv+Vgqb84mhLRbCmS0OfF
	 xDfw6qpb7dGutohHNurdjuqqNeMgAPCk1q/Os2Gbbx5BI83XNWFa8jt7iqaDfcHSqV
	 4ZM2YUisd3AyVVgk6ljPc77nGE8hN1T+O0dnd+Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert van Bolhuis <nvbolhuis@gmail.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 691/772] wifi: brcmfmac: Fix oops due to NULL pointer dereference in brcmf_sdiod_sglist_rw()
Date: Thu, 12 Dec 2024 16:00:36 +0100
Message-ID: <20241212144418.461709079@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Norbert van Bolhuis <nvbolhuis@gmail.com>

[ Upstream commit 857282b819cbaa0675aaab1e7542e2c0579f52d7 ]

This patch fixes a NULL pointer dereference bug in brcmfmac that occurs
when a high 'sd_sgentry_align' value applies (e.g. 512) and a lot of queued SKBs
are sent from the pkt queue.

The problem is the number of entries in the pre-allocated sgtable, it is
nents = max(rxglom_size, txglom_size) + max(rxglom_size, txglom_size) >> 4 + 1.
Given the default [rt]xglom_size=32 it's actually 35 which is too small.
Worst case, the pkt queue can end up with 64 SKBs. This occurs when a new SKB
is added for each original SKB if tailroom isn't enough to hold tail_pad.
At least one sg entry is needed for each SKB. So, eventually the "skb_queue_walk loop"
in brcmf_sdiod_sglist_rw may run out of sg entries. This makes sg_next return
NULL and this causes the oops.

The patch sets nents to max(rxglom_size, txglom_size) * 2 to be able handle
the worst-case.
Btw. this requires only 64-35=29 * 16 (or 20 if CONFIG_NEED_SG_DMA_LENGTH) = 464
additional bytes of memory.

Signed-off-by: Norbert van Bolhuis <nvbolhuis@gmail.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://patch.msgid.link/20241107132903.13513-1-nvbolhuis@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index e300278ea38c6..9217e9f6e9076 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -770,7 +770,7 @@ void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
 
 	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
 		      sdiodev->settings->bus.sdio.txglomsz);
-	nents += (nents >> 4) + 1;
+	nents *= 2;
 
 	WARN_ON(nents > sdiodev->max_segment_count);
 
-- 
2.43.0



