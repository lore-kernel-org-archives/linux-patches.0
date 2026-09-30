Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 585DD44F574;
	Wed, 30 Sep 2026 17:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787685; cv=none; b=UQR6ySZ5H3bpxVJ0NSmpExlP7W1E9nVOs+AIIUIdtHKZhDM43A5Ro10n8FGEyczJFDECwfI7HTEKkGOHCgjxDAaes3e8hi4VfcfPVc3MtMJLpKtseCeLm7cEpMvdv4lcUBSWhyl2yV5S59kybTzf8XUWvkG3YMzMneaC3Wp03Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787685; c=relaxed/simple;
	bh=0loVeLQJfn0BsISkbWGDyvC4VGoN8RB9v5z2X1MVJvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQemY1ZFyPlfKuZQqK6oRFJMddOeiUNgXxR5dHhb7Sjf34h7ai2O8yg8+SGbD//2hQHkukNKyZ+fRTbAc4+qu7ZxSU22NzdxOn6Pbw9o2XkbCQAcIYWc4IkWTsWKOcWOtRpcI9F4zMmyPRVpcgllXCJeN9yTy/ZAyg0Y5Z/MHAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jKTy0KK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jKTy0KK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3EE31F000FF;
	Wed, 30 Sep 2026 17:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787684;
	bh=5SH7FmQ9LZnDAth/bKs/KkgrsfOAroIxcwLRBSojlRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2jKTy0KKcN5hAuA85VdOPVU89WBhXWOEGv0C1M44UmKfF8hz8CPiHuAL4GOP5i0w4
	 gSC02K5azi5H5/rm78sWUHt6u7g9of7D6WpUM6CzknKUj7LvlsZ5//vmZvSnTvG+NI
	 yrXEPofamwmeKJMtdfYpEea4d372cxO3xX5t8gCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 317/457] mm/damon/core: allow esz to be set to zero
Date: Wed, 30 Sep 2026 17:27:02 +0200
Message-ID: <20260930152352.866451469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liew Rui Yan <aethernet65535@gmail.com>

commit 90179da203ba8b708c84a12a07cd44be0f346334 upstream.

When the temporal quota goal tuner determines that the goal has been
achieved (score >= 10000), it sets esz_bp to zero so that the esz becomes
zero.  However, damos_set_effective_quota() clamps the esz to
min_region_sz when quota->ms is set.

This is a minor issue, the main problem is that it doesn't match the
description in the documentation, which state that if the goal has already
been [over-]achieved, the quota will be set to zero.

Fix this by set quota (esz) as minimum as possible.

Link: https://lore.kernel.org/20260908135413.97570-1-sj@kernel.org
Fixes: 8bbde987c2b8 ("mm/damon/core: disallow time-quota setting zero esz")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # v7.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2896,6 +2896,7 @@ static void damos_set_effective_quota(st
 	struct damos_quota *quota = &s->quota;
 	unsigned long throughput;
 	unsigned long esz = ULONG_MAX;
+	unsigned long esz_time;
 
 	if (!quota->ms && list_empty(&quota->goals)) {
 		quota->esz = quota->sz;
@@ -2916,8 +2917,8 @@ static void damos_set_effective_quota(st
 					1000000, quota->total_charged_ns);
 		else
 			throughput = PAGE_SIZE * 1024;
-		esz = min(throughput * quota->ms, esz);
-		esz = max(ctx->min_region_sz, esz);
+		esz_time = max(throughput * quota->ms, ctx->min_region_sz);
+		esz = min(esz_time, esz);
 	}
 
 	if (quota->sz && quota->sz < esz)


