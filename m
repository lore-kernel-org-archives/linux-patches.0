Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225AC299959;
	Tue, 26 Aug 2025 11:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207574; cv=none; b=rISospnF6Ewr9cUaDcjj7LNIev+/PACpqh5LBeA3ZqwikJ18vOI0amGVZ7FDJkAePNt90LlJHvO7ihACU1UO7DjGUpgY9GKqyfCUNZs5AWozlQItciLG+vPwWxCH1ULYMuiaYnf0kJRwc6eqq7fwcVh1n+GJyfaFqBTN/2Bpm7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207574; c=relaxed/simple;
	bh=dyNYS8MYFWZBVOdzGHS9e5i+020xCCWlXp45oq3Emgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rScG6717U3OZ9VJ6Lgcu1U5LnSa9TzXViLx9lRa7eXy7he8mnI8v9fp9SlQRo/PzPN4ovpKYx3t7nky8huDX1KOq35YkhoTuoj+hflWQKOZgufEh3uZJMAE+R3g3BJC2RDysvETVwHB+6S87Usfk1gk1EIQ/1b+JgOT5NZoQnt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NO0KWIrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NO0KWIrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B6BC4CEF1;
	Tue, 26 Aug 2025 11:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207574;
	bh=dyNYS8MYFWZBVOdzGHS9e5i+020xCCWlXp45oq3Emgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NO0KWIrEtfKmeTYLSKCTBQonSQzeZ82S2Y2Vm2HEBtDJ3cfvpn/MHvvj0zI2n+bFx
	 CwK2covnKeNiMVyEwP+jQ0gIRSKroEe6yG+Huf3F7c3untqZB4tzIQQ1zfeQMEGMxP
	 iGtw2sWDsK1s0wONoBTr4B+MYhB5hexOU8dtLyc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 234/457] mm/damon/core: fix commit_ops_filters by using correct nth function
Date: Tue, 26 Aug 2025 13:08:38 +0200
Message-ID: <20250826110943.157669522@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Heon Jeon <ekffu200098@gmail.com>

commit 63f5dec16760f2cd7d3f9034d18fc1fa0d83652f upstream.

damos_commit_ops_filters() incorrectly uses damos_nth_filter() which
iterates core_filters.  As a result, performing a commit unintentionally
corrupts ops_filters.

Add damos_nth_ops_filter() which iterates ops_filters.  Use this function
to fix issues caused by wrong iteration.

Link: https://lkml.kernel.org/r/20250810124201.15743-1-ekffu200098@gmail.com
Fixes: 3607cc590f18 ("mm/damon/core: support committing ops_filters") # 6.15.x
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -843,6 +843,18 @@ static struct damos_filter *damos_nth_fi
 	return NULL;
 }
 
+static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
+{
+	struct damos_filter *filter;
+	int i = 0;
+
+	damos_for_each_ops_filter(filter, s) {
+		if (i++ == n)
+			return filter;
+	}
+	return NULL;
+}
+
 static void damos_commit_filter_arg(
 		struct damos_filter *dst, struct damos_filter *src)
 {
@@ -906,7 +918,7 @@ static int damos_commit_ops_filters(stru
 	int i = 0, j = 0;
 
 	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+		src_filter = damos_nth_ops_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else


