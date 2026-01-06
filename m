Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3908376BFD;
	Tue,  6 Jan 2026 18:00:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722425; cv=none; b=duc/J5q6qQSuvqUZv7V3pKcS2ALgmTl9hU/273o11TkCBeJe4XtSpl10i3GS/0k+4Kgn25J3uZMiWqPKnwWUg/2SSJvieJSWrA1vKItihyyWdJhxAtDt/yJGyZlpwZD6gc1Whk9GPKwDCa5m+j1eoc4YsRtrl8FJFYAtmixwzHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722425; c=relaxed/simple;
	bh=GuEAsQQHza2ph64jAzU8/uYFIKSpqyn/VBuRebTaRrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiZ7wvfzTC+WtaTlcGV/CWuAarK/+iglP4GJru8RpFJq8KBjIjyHVbUU+Tg9GpaKrHE4H032bVqqpTII2be6yjQAn6epyKmSz+C2QDA1xmPM9A0EMJ0bNQhuVNrWyqVb1zGD1ebQtekiDxgNWA1g33MaIVzfSCmjOXG/uzik0zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+HXyhUP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+HXyhUP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21CF5C116C6;
	Tue,  6 Jan 2026 18:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722425;
	bh=GuEAsQQHza2ph64jAzU8/uYFIKSpqyn/VBuRebTaRrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+HXyhUP2z9nqgLzPff50V5eOCw56zr3kz8cZNeWeClyg2DGL9Dg8JTxNzHGXsJ/F
	 dE/cuEGnNWGGXvDm3OK969pEnrvZj5XxNnKLpn7v/uYk98ZeXJKOPoL0g67ww+4AwD
	 VQsSw+Fg4rE3FIN1wQx/rW/zaupyJCWtK9UWb4t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 233/312] tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
Date: Tue,  6 Jan 2026 18:05:07 +0100
Message-ID: <20260106170556.280239111@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


