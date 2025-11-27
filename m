Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F098728D830;
	Thu, 27 Nov 2025 14:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764254975; cv=none; b=VlIlFELDKWq4uCRThWVoCA/iB6hVPpQQ3xN1zeI1W0TX+9rv3K0I4iFQMDAvmnpDLLO5awrm+LopNpXkLrmAoDFBHHi96bOLqKyxi03ygV/MTs6teYhsaURMg/a6DHOi9JWLNaUWcqE3DjBXBn+P0ezgricCQE9FSfy0cfj0xNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764254975; c=relaxed/simple;
	bh=zwpkKna52HRr+2zJWhEqLYQkn66EswwTJAVFh24Hq/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SisTGnfbG9kpfa03UMfyi0PInwzYYUVaKH9t6MaqEUTX040yP+OMNwC6WYIwPpkHKGd2xVeWYv4FNN/6727fJDr0bJERlGmjBBZOImiTKG3jqY4ZQxxS8dBrBF4p3FDEqX0C/JyTFBL7Vr4V0i5l3CUDwM1lm9tmOA8au1EREOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtYMwtMW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtYMwtMW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B6CC4CEF8;
	Thu, 27 Nov 2025 14:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764254974;
	bh=zwpkKna52HRr+2zJWhEqLYQkn66EswwTJAVFh24Hq/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtYMwtMWOyDSb3mvnt8NnOBNq5U3Rzqq9rw8fJm5QIpMAglZUO3RV+j9UcXvNxIKq
	 fyDBrvLM9hbqe0Gk0xFwsdC0IFESEuoaBgG1qmlutCr/apcKqSl4aPQtOlPcDP8StU
	 WzxcL1O2WKAHtAHIONvi3q4hYThRvk/Kw5qy2nwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Zhigulin <Pavel.Zhigulin@kaspersky.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 50/86] net: qlogic/qede: fix potential out-of-bounds read in qede_tpa_cont() and qede_tpa_end()
Date: Thu, 27 Nov 2025 15:46:06 +0100
Message-ID: <20251127144029.657840710@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
References: <20251127144027.800761504@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



