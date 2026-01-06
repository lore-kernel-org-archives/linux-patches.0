Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80ED3288C2D;
	Tue,  6 Jan 2026 17:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721125; cv=none; b=ut2ZfgfiwUYoTEZcxc41tb/Afiz3KPgyaBBshF2aH8QuoSw1K/ZLdxi/WFAyoDnHH5ocLNRYIctGWpKUBAMsca0IrQwLYgTXaIaGVJczCa49xsGXkfc3ZnIPWXz+xKY/0pnxMpEJ48GtCU84VFgSUCVFndFJE049HOUHCJxGNy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721125; c=relaxed/simple;
	bh=Uv69icqC686xl+Cd06KSq/wj3meEfc3KbMjtOGa12Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mWP6MI18Jjqzmi0JcK/VK+EC3gGkiqjuPmBmglRfPAAWeisduBptz3/WmOFCX9UNfbDtWUKh6PSBli07ERhQCGLZ51Tx5gQgkJ21LN0zRfwu+z4VJpk9NZ8O9A74yJVS1GBpyVGaQALZnMgIodTk2a7cJErRsU3RwIpqKBvMDCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GuAz6oir; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GuAz6oir"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88EEC116C6;
	Tue,  6 Jan 2026 17:38:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721125;
	bh=Uv69icqC686xl+Cd06KSq/wj3meEfc3KbMjtOGa12Es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GuAz6oiruENSwcD4Wlyyz1bylT+UE7mEiUcWvKDl8O2pn71zrFb8tgxzfhmFPSa9W
	 QNLLyn8GUagRI++mIcvKNygmVQFP+6DCvj4hQgdupGBJ1KFlotaBXemBrd7j15MIDL
	 G/3tGvl0SEZQG5we6qjNfYTlbOkbdnqUd5y8C48I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 443/567] tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
Date: Tue,  6 Jan 2026 18:03:45 +0100
Message-ID: <20260106170507.738633375@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 7013803444dd3bbbe28fd3360c084cec3057c554 upstream.

The ternary operator in compare_ts() returns 1 when timestamps are equal,
causing unstable sorting behavior. Replace with explicit three-way
comparison that returns 0 for equal timestamps, ensuring stable qsort
ordering and consistent output.

Link: https://lkml.kernel.org/r/20251209044552.3396468-1-kaushlendra.kumar@intel.com
Fixes: 8f9c447e2e2b ("tools/vm/page_owner_sort.c: support sorting pid and time")
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/mm/page_owner_sort.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -183,7 +183,11 @@ static int compare_ts(const void *p1, co
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+	if (l1->ts_nsec < l2->ts_nsec)
+		return -1;
+	if (l1->ts_nsec > l2->ts_nsec)
+		return 1;
+	return 0;
 }
 
 static int compare_cull_condition(const void *p1, const void *p2)


