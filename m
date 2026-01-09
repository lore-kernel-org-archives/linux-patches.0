Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033D03176E4;
	Fri,  9 Jan 2026 12:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961111; cv=none; b=jXp5Gfg3kvY0+UmLYaSTmyKMEBFP9rfvMPmDTJhMI5I6qyOX3Pz7K80mehGkAS7vjfx6Jgs4db0r3DC1b3caHNAlDtfZixaAKGrghFIEtylafewnt86hRz5MPEh+Z6sPdZgsv0se/J21GPYMBIVr0BBzppEnN74cvCxI6oRFLCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961111; c=relaxed/simple;
	bh=59g/XvlEuXOzlBNEiwAuQwiUmpbRlbYChDJgk4RJ5vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjAmSScIrlgm01n0/Q3w1FDiPHxKW/+DeqmLqNqQH+lY43IFLzI4lG0jCH1aratkJQflYcrbiGvN20W3NPnQ5znbYZzjiixFvbOI8LT1Cc+2J9VOEh5F7+w3uPe7cfZsfI8hvKuRhynUyMwWWISQJxiyDCp9zczNW7oDpVHLApY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tDVpUwDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tDVpUwDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B647C4CEF1;
	Fri,  9 Jan 2026 12:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961110;
	bh=59g/XvlEuXOzlBNEiwAuQwiUmpbRlbYChDJgk4RJ5vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDVpUwDkBNucKG5iku9s7g/tPihHbqtcpCEQQVlHYIeiEWnbe+ZpKW0nOZRCtFzcv
	 REoLNCej5J+OSn5Q3WYDXHJRTBsLwXqnJQun2NE2Jr3raHAB4sjpsYoH794tght2mY
	 j/rbfXsAlNjKvVhEBFjFDE6ChvjAjkzoG9SiU7Iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 605/737] tools/mm/page_owner_sort: fix timestamp comparison for stable sorting
Date: Fri,  9 Jan 2026 12:42:24 +0100
Message-ID: <20260109112156.764973928@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -178,7 +178,11 @@ static int compare_ts(const void *p1, co
 {
 	const struct block_list *l1 = p1, *l2 = p2;
 
-	return l1->ts_nsec < l2->ts_nsec ? -1 : 1;
+	if (l1->ts_nsec < l2->ts_nsec)
+		return -1;
+	if (l1->ts_nsec > l2->ts_nsec)
+		return 1;
+	return 0;
 }
 
 static int compare_free_ts(const void *p1, const void *p2)


