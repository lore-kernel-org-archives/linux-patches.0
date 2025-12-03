Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69B933C19B;
	Wed,  3 Dec 2025 16:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780229; cv=none; b=Krqxw7UDhol1J7ZNNFdgjYCv/Jsff6eitF4qJ/ygAoPe7JOfB81Xpcp/AZDhXEaLqUYCIcQE/RmQG9Oq6G5wVRJYFc2/M0W9qu9RnEVraxBET+9WPQMLB3BorcwkTLotf9DDGbZhppD/XByJF5V22Jwm/UddToYflO1568F5kT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780229; c=relaxed/simple;
	bh=KvBLAAir+2Iw8CvIBxm9007chHRWw/3eycn819KpLSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QsXkFTBnTyceTBNo4z+uqYGXIzFo3Z6H7e1o51l54VGnfdRt8Yd6GKn0SUhfeiEse0hFZ3kumFg/fvf4IBp8/Wr/i57Xt2h6daNf+q0nPdW87I1j1CHl/dYO+evZP7WqtFpYgIFQEo8kRjvYhDL8MopkBWfuuarhebEQrrA3Fos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Y0xmnUk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Y0xmnUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0961BC4CEF5;
	Wed,  3 Dec 2025 16:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780229;
	bh=KvBLAAir+2Iw8CvIBxm9007chHRWw/3eycn819KpLSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Y0xmnUkYG9F+58NMGEfe/ji40yYuFgOEfXWyMvjBx3Nxzq+waQnF5sEyipPXsZfo
	 w/EdI8KxfXMp69IJPsMRjv0wEXgkT/AWTQFu4x7Q7LXNxnDO9lCN1mm9OuRfxCQa2b
	 PsMLauHzMU6YFPxsLMrt8NSmXsI1Pq+w+zgggeJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 462/568] net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()
Date: Wed,  3 Dec 2025 16:27:44 +0100
Message-ID: <20251203152457.625515755@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>

[ Upstream commit 896f1a2493b59beb2b5ccdf990503dbb16cb2256 ]

The loops in 'qede_tpa_cont()' and 'qede_tpa_end()', iterate
over 'cqe->len_list[]' using only a zero-length terminator as
the stopping condition. If the terminator was missing or
malformed, the loop could run past the end of the fixed-size array.

Add an explicit bound check using ARRAY_SIZE() in both loops to prevent
a potential out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 55482edc25f0 ("qede: Add slowpath/fastpath support and enable hardware GRO")
Signed-off-by: Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>
Link: https://patch.msgid.link/20251113112757.4166625-1-Pavel.Zhigulin@kaspersky.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qede/qede_fp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index cb1746bc0e0c5..273dae622c411 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
+#include <linux/array_size.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/skbuff.h>
@@ -960,7 +961,7 @@ static inline void qede_tpa_cont(struct qede_dev *edev,
 {
 	int i;
 
-	for (i = 0; cqe->len_list[i]; i++)
+	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 
@@ -985,7 +986,7 @@ static int qede_tpa_end(struct qede_dev *edev,
 		dma_unmap_page(rxq->dev, tpa_info->buffer.mapping,
 			       PAGE_SIZE, rxq->data_direction);
 
-	for (i = 0; cqe->len_list[i]; i++)
+	for (i = 0; cqe->len_list[i] && i < ARRAY_SIZE(cqe->len_list); i++)
 		qede_fill_frag_skb(edev, rxq, cqe->tpa_agg_index,
 				   le16_to_cpu(cqe->len_list[i]));
 	if (unlikely(i > 1))
-- 
2.51.0



