Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DED95381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7B83C433C0;
	Mon, 19 Jun 2023 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171487;
	bh=99xfb4tsifNZoI9PtdgAdNnaeBeuGeNVgfM4kUZfT00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOQuzv5LSVEvYN7a9gu5wMopZ2WUz7dQApxYdDpBE1FQIbq1nGoAfr0h4cKJY7NvA
	 34BFHBDmY5UjKi1Q2RCRG/V+Bu9WYczOz/JQRRL5t1hAMBfce+gpaWt7BIq1ZBp1Od
	 mKrk1nHPRAfEyXcW8DNdndSsd7Joh+4a/nFqeXWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nhat Pham <nphamcs@gmail.com>,
	Dan Streetman <ddstreet@ieee.org>,
	Domenico Cerasuolo <cerasuolodomenico@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Seth Jennings <sjenning@redhat.com>,
	Vitaly Wool <vitaly.wool@konsulko.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 048/166] zswap: do not shrink if cgroup may not zswap
Date: Mon, 19 Jun 2023 12:28:45 +0200
Message-ID: <20230619102157.059210586@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nhat Pham <nphamcs@gmail.com>

commit 0bdf0efa180a9cb1361cbded4e2260a49306ac89 upstream.

Before storing a page, zswap first checks if the number of stored pages
exceeds the limit specified by memory.zswap.max, for each cgroup in the
hierarchy.  If this limit is reached or exceeded, then zswap shrinking is
triggered and short-circuits the store attempt.

However, since the zswap's LRU is not memcg-aware, this can create the
following pathological behavior: the cgroup whose zswap limit is 0 will
evict pages from other cgroups continually, without lowering its own zswap
usage.  This means the shrinking will continue until the need for swap
ceases or the pool becomes empty.

As a result of this, we observe a disproportionate amount of zswap
writeback and a perpetually small zswap pool in our experiments, even
though the pool limit is never hit.

More generally, a cgroup might unnecessarily evict pages from other
cgroups before we drive the memcg back below its limit.

This patch fixes the issue by rejecting zswap store attempt without
shrinking the pool when obj_cgroup_may_zswap() returns false.

[akpm@linux-foundation.org: fix return of unintialized value]
[akpm@linux-foundation.org: s/ENOSPC/ENOMEM/]
Link: https://lkml.kernel.org/r/20230530222440.2777700-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20230530232435.3097106-1-nphamcs@gmail.com
Fixes: f4840ccfca25 ("zswap: memcg accounting")
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zswap.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1138,9 +1138,16 @@ static int zswap_frontswap_store(unsigne
 		goto reject;
 	}
 
+	/*
+	 * XXX: zswap reclaim does not work with cgroups yet. Without a
+	 * cgroup-aware entry LRU, we will push out entries system-wide based on
+	 * local cgroup limits.
+	 */
 	objcg = get_obj_cgroup_from_page(page);
-	if (objcg && !obj_cgroup_may_zswap(objcg))
-		goto shrink;
+	if (objcg && !obj_cgroup_may_zswap(objcg)) {
+		ret = -ENOMEM;
+		goto reject;
+	}
 
 	/* reclaim space if needed */
 	if (zswap_is_full()) {


