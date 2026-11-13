Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591411;
	b=vg7MiNmTMbV2+LAOglP17QlLn9F9Bh9CGkLUNAtXe9n9zwOwrLNquUXeojagDPBYekgv
	 U4MdlPaAqga6GCMuhN71YCC9Jlstl98S2Na/QQ1saclh1Z+CFTBCCaZhxgBEAXutFfohY
	 2lszPY3JIDGL3ZR5kWz4WncXRWMb1MwvhlM2yUFxPB12Ud0RSV8kmDRj+sEjSB/JyAeTP
	 9jHZ7UEZgTi7ocuBct79xAa+/fraeuoUg7doxxG+A8U4dgnXeVYNGP7IKSrF1RKGG13l4
	 D15X/uXOL+TVrTIqKNNmRnSfOPaE6gohJC7JDAacFj/OWWMFc+Rzs7SQdEL7IrVMaVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVnzQtKfFp0cRTMA5P3Gr/qBPRVa3vY5VGHFnftNwbE=;
	b=kmiM7tiBsyM3fANcb5cOgwhQrSaEEHGhwmLAZmwqAio4Fu6xs349s33oVsSTmXp+ZyQD
	 KItKcqi5WkVY1A1H1I6YTAjR2m3Tt39D/TDrkaJ1Q+enrbQqk1iw9WQ8OOxW5gHhYfSJ1
	 uNuCcTAQQqzuAvBayrnQz+2LCgaLPYVagEcIjyN6KKt1zaQv0ijx41UBhyRqY2BYwncGP
	 0sGHlOsRxKbwUo0S+mex0d28zm1/VQ2gwhQ3KPO2oAMFia29A1WfxYwwfaNY7IHnLz2ZY
	 rPtqeatkfYvd11DBAa2tqJWaBmgg7YQ5INwduVurUJy4RVTbRe9VZbwNds+ILdmlDNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfRycCLE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BE56079D5B;
	Fri, 13 Nov 2026 17:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VfRycCLE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA121F000C4;
	Fri, 13 Nov 2026 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591411;
	bh=rVnzQtKfFp0cRTMA5P3Gr/qBPRVa3vY5VGHFnftNwbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VfRycCLE9hC/0NkHgW1QeKpJ7oOMntXh/K9mGMTcgZsHdzq7QsCLS+PV6BGYPsubO
	 /VTdVP4Jj8wMpwSiJIJI5nG8jH8JKBzIaPTHCD/+xit4Ky4I1KEUrB9L7uNR+anVdF
	 izfYS1x6x/Kn2K6iXUV7U8qfGztG70EQZngK5Sdg=
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
Subject: [PATCH 6.12 506/670] mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Fri, 13 Nov 2026 10:51:10 -0500
Message-ID: <20261113153829.094380406@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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

In 6.12, __wb_calc_thresh() has no freerun adjustment here. Widen the
threshold for the ratio calculations and compute the maximum share once
for the existing clamp.

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
 mm/page-writeback.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index bfb3f903bb6d5..89b2e4a290b59 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -917,7 +917,9 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 				      unsigned long thresh)
 {
 	struct wb_domain *dom = dtc_dom(dtc);
+	u64 threshold = thresh;
 	u64 wb_thresh;
+	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
 	unsigned long wb_min_ratio, wb_max_ratio;
 
@@ -927,15 +929,17 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64(threshold * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(dtc->wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
-	if (wb_thresh > (thresh * wb_max_ratio) / (100 * BDI_RATIO_SCALE))
-		wb_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64(threshold * wb_min_ratio, 100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64(threshold * wb_max_ratio, 100 * BDI_RATIO_SCALE);
+	if (wb_thresh > wb_max_thresh)
+		wb_thresh = wb_max_thresh;
 
 	return wb_thresh;
 }
-- 
2.53.0



