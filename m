Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038260;
	b=h5WJ7Nt4L9HmDnEDfsIDaD060XuUiAv9fQVFAeDlz6WEQtybKlovvkWYMYeGRPUODd/9
	 cMNFhO1lbYQyW1grHWnqojxw3b2p4+8pKROIggDdtaWKXzl9r3d9pQOk15TSzwSHXZJk3
	 ORniyDcK4UcV3x1e8R+kdwyh25sL4nAMrRKg9pWZLbWO3mb4u+NyeHRAEjys5ZhmY442b
	 jbNUJNOvu+NPZXgL+ggmxwCgGbmHAEvsXywRmiNa3PRkU++GuCG10G7xJ33zkS0u+f4mD
	 8Yr2i+dm0fAlvhm4ynY1fqCUPgovmMzFzpY0qTXnwUIHukiTDu37craUK6TnRPvmhtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZEA/ZraemiEiLCJ0Io05E2DJ+FpL3N1pLhti5VWyQHE=;
	b=XaQrGgiAEaGXrpfa2CQpYwUwTOw8VHB5JJzPA/OpmIzaNs5csXgx3otnP5kodP0jWOh0
	 +bIIJD+WeRHyYgdXRHV2qq7zH/4VmmbY97KR9f+u9dz1SyjUPp/iPvrgtIwYVzSWG8UYd
	 iyxR0wD449cHyP5Hi3Ev5osDJkQLqKP4oyvyDaoSRhXMjKM0j/Q+ffPH09HZrauFDJhC2
	 5EX3HFKAxMRL282JXhrIbBMD10QTh0a7WGMeAVw32zhFd0Zn1rrOiyVEnFtUQX9/VDveN
	 jus/iQEPQ4IapmHEqm6EXI9WAujplahVihTICA1w+cfNgQ1bX0cN+2EXIGiG+zb8TMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KfSQNa4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596C9606A31C;
	Wed, 18 Nov 2026 21:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1KfSQNa4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D661F000C4;
	Wed, 18 Nov 2026 21:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038260;
	bh=ZEA/ZraemiEiLCJ0Io05E2DJ+FpL3N1pLhti5VWyQHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KfSQNa48ygotSQiug8ZnPtmjo+cZ83W2P7MFmNY+/Otuj0NPj9MLdt7dl6jgwaG+
	 rw4E9l7kdml/zv3tG9Rp/9DpfEg8tgFfPtP4BahjlYI1Wdbq05XwWa8bhJuZlx+fvx
	 F/vouziXFczwHY7RAvFJWAjPbbY/wtm/1SBt9dAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Stefan Roesch <shr@devkernel.io>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1681/3318] mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Wed, 18 Nov 2026 15:38:23 +0100
Message-ID: <20261118150412.243156706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 9597c2056e05bd79df9d343a9b42e84a54de1c52 ]

The ratios used by __wb_calc_thresh() are scaled to parts per million, but
the threshold and ratio operands are unsigned long.  On 32-bit kernels,
their multiplication can wrap before the result is assigned to u64.

For example, with a threshold of 25600 pages and the default maximum ratio
of 1000000, wb_max_thresh becomes 4125 pages instead of 25600.  The shared
threshold and minimum share calculations can overflow in the same way,
producing incorrect per-writeback dirty limits.

Use a u64 threshold for the three ratio multiplications and div_u64() to
retain the existing division order and rounding.

In 6.6, __wb_calc_thresh() gets the threshold from dtc->thresh and
has no freerun adjustment here. Widen the local threshold and compute
the maximum share once for the existing clamp.

Link: https://lore.kernel.org/20261021060654.27855-1-dennylin0707@gmail.com
Fixes: ae82291e9ca4 ("mm: use part per 1000000 for bdi ratios")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Stefan Roesch <shr@devkernel.io>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page-writeback.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e7a7233f6d5d0..136438343266e 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -883,8 +883,9 @@ static void mdtc_calc_avail(struct dirty_throttle_control *mdtc,
 static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc)
 {
 	struct wb_domain *dom = dtc_dom(dtc);
-	unsigned long thresh = dtc->thresh;
+	u64 thresh = dtc->thresh;
 	u64 wb_thresh;
+	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
 
@@ -894,15 +895,17 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc)
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64(thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
-	if (wb_thresh > (thresh * wb_max_ratio) / (100 * BDI_RATIO_SCALE))
-		wb_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64(thresh * wb_min_ratio, 100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64(thresh * wb_max_ratio, 100 * BDI_RATIO_SCALE);
+	if (wb_thresh > wb_max_thresh)
+		wb_thresh = wb_max_thresh;
 
 	return wb_thresh;
 }
-- 
2.53.0



