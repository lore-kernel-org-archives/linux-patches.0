Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07DE7357CEB;
	Tue, 21 Jul 2026 21:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669702; cv=none; b=SXEkqXxo0mNNN+z6Zw5SlmOwvJg5Ec58f3QAd8tyKQ8rzbmH/6mtcrKUdKhaEyANXTY+uAhwpoo67U15k0RO7DZ0MqX4jMVx1Eszp8NDxozCTtvTgOfgVerUvk6doK2zFUJAkO+fPL4xOhjnZ0Pafz1+gKeQogA9vZrdYsPLtiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669702; c=relaxed/simple;
	bh=xO7gRm4IbcwXm4MaVE9dmzWnxJs4mcNC9NhbmPto3O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEvJOveOgxh/YaIW1mkGuXKXR3aFaOPDPRpJsp2WLFf8A+TTfSINtfcGp4Xy+vO0ZiT/XanUnbKpDHhNu7ioqDLyJ14MyAIFENPOPNpIH84iNfh52wKEHISz4IZ1chP8VhcCpSXuTmhEQNjd3jMixz7/uCcI2sTBAVv3XToiQGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kTlwS207; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kTlwS207"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954351F000E9;
	Tue, 21 Jul 2026 21:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669700;
	bh=mMFKRYsXFaZR/PkXF+VK+G+1++6dIjKuTwiPfyM4DLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTlwS207PEccBZMCECMR/fZKlXx05Ht1E+c7Ql3lBvKoZQycK7mkwhSNZu2xyEl7B
	 kgFVS0lB534ksFWNqG6EioMLB0EAi5/HDROaKDef6/VJraxhTz8DzTNiFGnTwjWf1s
	 JYUeeHkSKa3rGyHmaPmMs6UlO3+ZFdyxW45ENoFI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0652/1067] qede: fix out-of-bounds check for cqe->len_list[]
Date: Tue, 21 Jul 2026 17:20:53 +0200
Message-ID: <20260721152439.177342485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

[ Upstream commit f9ba47fce5932c15891c89c60e76dfaca919cb8d ]

Move index check before element access.

Fixes: 896f1a2493b5 ("net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()")
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Link: https://patch.msgid.link/20260623144602.3521-1-matvey.kovalev@ispras.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 273dae622c4113..1de8611a27f238 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -961,7 +961,7 @@ static inline void qede_tpa_cont(struct qede_dev *edev,
 {
 	int i;
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 
@@ -986,7 +986,7 @@ static int qede_tpa_end(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, tpa_info->buffer.mapping,
 			       PAGE_SIZE, rxq->data_direction);
 
-	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
+	for (i = 0; i < ARRAY_SIZE(cqe->len_list) && cqe->len_list[i]; i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 	if (unlikely(i > 1))
-- 
2.53.0



