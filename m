Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590329;
	b=KM/g9U0rTgfOS4sy1Wjj00fY7D3IOO3sFSa27yWeNLEbwAP0kbhMbzrSoXEQyl8dke9A
	 D7KzVCDAoBh2IdbjkNsyQUos0cLDYmSS54+63tYZCRP9CbwFqm5AxDdzj0nI1h3oPqBiF
	 UcEpvrqSqlHSXq/p/93tqk/EaAwb3ctzSqz/0t3rTPkzLVsxM+dLZQKdfjPBalacJwyQf
	 +ZBeLOv1dNXlIyuAuzFFShzrHkepCdyYLT0oP0FB4pxmSwGmbB4dN0xv9yIdYa6JcGW8B
	 EUQ801cmRATT8u70aD04GoMwzODFloLJ0/vLRta+XYs+bI5/IG+V7brQdtRn+6zvcrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=59ekWSvpUyXQFgxhCKD84+HIlZkVx6uNNd4DE057qHk=;
	b=m4I8TtsuksNnd0qc/OwpqPZxOxBL7PUdGyrc57Gq/8iU9w8jVe5FxeKPWiOunReU5oNB
	 +pP9y3TSmMB15VoyEgG3mamN1LUpZ2jK7UvdIxPVWASkOUvptg24nD2jMAiQHdcqABiFW
	 y05oL0QIAhWyO7EaCJWEJttfY8b4JJt39XO+DuUvpsyXzL0rkZx3LMhcxtEkkJoEs8YSp
	 BD3VGCf46vYMmCThFFtC/QxMIoUatqF1+KzS2QeUOoOBBYg+GntQtfC9UAB6wwUrmIP9i
	 oBaKI4wJtxBhCOkoE67P25DyZj8fULfOnoloFfJv3K5un4nNjClrL+KRR+h82tBYGHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVQtJ37D;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9189C607EE54;
	Fri, 13 Nov 2026 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PVQtJ37D
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455431F000C7;
	Fri, 13 Nov 2026 17:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590329;
	bh=59ekWSvpUyXQFgxhCKD84+HIlZkVx6uNNd4DE057qHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PVQtJ37Dq5X51yfNAtDtv9gU33SptpJKr7WaaTU4OeQTvcNV5H10MNJVAgSVDPbb0
	 fmMCXNvLAQZKIL0pHygLhtQw5T7wFw0uH4h8OinYpFAoWGDhW7TiNqmmNugm0eY27i
	 MVJctHuZgHnUOdu5WHGtreBKDs5rtNv9OEbWu8/c=
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
Subject: [PATCH 6.18 309/686] mm/page-writeback: avoid 32-bit overflow in dirty threshold shares
Date: Fri, 13 Nov 2026 10:47:22 -0500
Message-ID: <20261113153831.417404759@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 mm/page-writeback.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 757bc4d3b5b55..17b12b4c4b667 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -902,6 +902,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 {
 	struct wb_domain *dom = dtc_dom(dtc);
 	struct bdi_writeback *wb = dtc->wb;
+	u64 threshold = thresh;
 	u64 wb_thresh;
 	u64 wb_max_thresh;
 	unsigned long numerator, denominator;
@@ -913,13 +914,14 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 	fprop_fraction_percpu(&dom->completions, dtc->wb_completions,
 			      &numerator, &denominator);
 
-	wb_thresh = (thresh * (100 * BDI_RATIO_SCALE - bdi_min_ratio)) / (100 * BDI_RATIO_SCALE);
+	wb_thresh = div_u64(threshold * (100 * BDI_RATIO_SCALE - bdi_min_ratio),
+			    100 * BDI_RATIO_SCALE);
 	wb_thresh *= numerator;
 	wb_thresh = div64_ul(wb_thresh, denominator);
 
 	wb_min_max_ratio(wb, &wb_min_ratio, &wb_max_ratio);
 
-	wb_thresh += (thresh * wb_min_ratio) / (100 * BDI_RATIO_SCALE);
+	wb_thresh += div_u64(threshold * wb_min_ratio, 100 * BDI_RATIO_SCALE);
 
 	/*
 	 * It's very possible that wb_thresh is close to 0 not because the
@@ -935,7 +937,7 @@ static unsigned long __wb_calc_thresh(struct dirty_throttle_control *dtc,
 			wb_thresh = max(wb_thresh, (thresh - dtc->dirty) / 8);
 	}
 
-	wb_max_thresh = thresh * wb_max_ratio / (100 * BDI_RATIO_SCALE);
+	wb_max_thresh = div_u64(threshold * wb_max_ratio, 100 * BDI_RATIO_SCALE);
 	if (wb_thresh > wb_max_thresh)
 		wb_thresh = wb_max_thresh;
 
-- 
2.53.0



