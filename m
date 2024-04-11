Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A782814600E;
	Thu, 11 Apr 2024 10:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831084; cv=none; b=ooOoUyODatBAnqGedmyAHYTFUV9/ebez4jJPmDjsyLpZwbDgNxExTZ9WWNz/iyZYYENZThTktGZOCnOh6tUVcESsbRBexqnuJ9y9qBgEhlXCTQNYTtHC4Xbd4q6aKl4iZXpuX93y0wnoWes+REDtYZP2tVmj8xsheh1qkT3NJB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831084; c=relaxed/simple;
	bh=51tYNEo6f0EIPrWeR6c1Ycs02DnpMuvcCEdw3QVs3iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OlH3BBrwHjh5arTPg1uaBpNAJg5vjxYrTRmyc6HfHlpUq+Bp3Sj/QMwCCEqlO84J53OJ9pjnVL5Y5GLi6krhYAdH/iA/aRgrqSbp3JAQUIDbp78T2V2qFaKiXEWh+Ass29WLHJhI7LyDAtUlnOiXn2PQi9+nRNRvelQ7T8toGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/8zS13k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/8zS13k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD7AC433F1;
	Thu, 11 Apr 2024 10:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831084;
	bh=51tYNEo6f0EIPrWeR6c1Ycs02DnpMuvcCEdw3QVs3iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/8zS13kuDFwAUKucIWTYUfukFVCR+asXFY1F1sW+KRcNgovkBpTSHSja+cdSm3pZ
	 98/sF8U6FeRcX14TXVXEehjg5UCVam0xsaDzkj691F7s8163BdqDZzarxgpGvGxqbt
	 ZUd1uTDgdhl8mWeZeSfW96SK4/Uf1ErRh3KkVlvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roman Smirnov <r.smirnov@omp.ru>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/215] block: prevent division by zero in blk_rq_stat_sum()
Date: Thu, 11 Apr 2024 11:56:42 +0200
Message-ID: <20240411095430.663106673@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 93f52fbeaf4b676b21acfe42a5152620e6770d02 ]

The expression dst->nr_samples + src->nr_samples may
have zero value on overflow. It is necessary to add
a check to avoid division by zero.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20240305134509.23108-1-r.smirnov@omp.ru
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-stat.c b/block/blk-stat.c
index 940f15d600f8a..af482d8f9f7a4 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -28,7 +28,7 @@ void blk_rq_stat_init(struct blk_rq_stat *stat)
 /* src is a per-cpu stat, mean isn't initialized */
 void blk_rq_stat_sum(struct blk_rq_stat *dst, struct blk_rq_stat *src)
 {
-	if (!src->nr_samples)
+	if (dst->nr_samples + src->nr_samples <= dst->nr_samples)
 		return;
 
 	dst->min = min(dst->min, src->min);
-- 
2.43.0



