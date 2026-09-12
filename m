Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8232BDC0E;
	Sat, 12 Sep 2026 11:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212323; cv=none; b=qj5Sj/OhzWeIKLK8+6Z0HExkOpLZ4mh6sCmXZT8FmCBUJgzLMoMUiDqYclq+VKlqy97I/GB7R8ZTQRLZSyU6t/dwqdwZfYYUWqstinU5phy9LE2fvi4Ef/icM7rhPNBOJ+MFUMMk8Q3mLf5d8XfyoEZYzNnikFopD/gBV7/tUSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212323; c=relaxed/simple;
	bh=DIz1nPovK5TgmeEN0QXZVY2xMpgrtgUFy1FHEM+aHWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adAVtEcVqL6P+LXGnkzm5FWAuNDZQqMRlRWkMEn/i1epKzNqdHj1KN0/1YfustkelTpcnapV+AKTGQrcWr4J9swYoKgmzj1xoDZmBaun8wb44YXYXRtbhTqZP4JTvngFFoJe5Q5WTHqXEXdNLaSz8QMiE4wsUfUftPAMPSjBoGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NtuCDCkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NtuCDCkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B461F000FF;
	Sat, 12 Sep 2026 11:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212322;
	bh=/yL8YxtTPjE6n/Jv77Fgis0nwkezuJsBBvqOYQraQSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NtuCDCknd0M8l0gg2QcJ05TA6VqPAqj6T3gl6AKJPHQp3ktgA5q0feC/SIDnoPnUy
	 /UuYOpSYc/503a6/fN4+bq/8/OCZVVSX73c9QRMxPN3udBmXeJsTEGJHk1daa4VDST
	 0+G0PgNOqTpLqhBVzpPJVHbTQYjkHpr/nezbclU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joe Perches <joe@perches.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1412/1518] maple_tree: catch race in mas_alloc_cyclic()
Date: Sat, 12 Sep 2026 08:59:41 +0200
Message-ID: <20260912065655.492079048@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Liam R. Howlett (Oracle) <liam@infradead.org>

[ Upstream commit 35f1342e5b893a740eff2ef9ab337bfaa63ab76d ]

If mas_alloc_cyclic() is called during a low memory situation, it is
possible the lock may be dropped so reclaim can occur.  There is a window
where some other task may allocate the same id and cause the mas_insert()
to fail with -EEXIST.  In this scenario the function will return -EEXIST,
which is not expected.

Modifying the retry on mas_nomem() to re-search for a slot means that any
race with other writes will not matter as the lock will be held between
finding the index and writing the index.

Moving the flag logic avoids cases where the flag is modified on drop
lock/reacquire or when the write fails after clearing the flag.

No existing users are exposed to this issue.

Link: https://lore.kernel.org/20260821192627.4085470-13-liam@infradead.org
Fixes: 9b6713cc7522 ("maple_tree: Add mtree_alloc_cyclic()")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Reported-by: Chris Mason <clm@meta.com>
Reviewed-by: Chuck Lever <cel@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/maple_tree.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index 5aa4c95000188..cff42ec10f4bf 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -4026,35 +4026,40 @@ int mas_alloc_cyclic(struct ma_state *mas, unsigned long *startp,
 		void *entry, unsigned long range_lo, unsigned long range_hi,
 		unsigned long *next, gfp_t gfp)
 {
-	unsigned long min = range_lo;
-	int ret = 0;
-
-	range_lo = max(min, *next);
-	ret = mas_empty_area(mas, range_lo, range_hi, 1);
-	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
-		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
-		ret = 1;
-	}
-	if (ret < 0 && range_lo > min) {
-		mas_reset(mas);
-		ret = mas_empty_area(mas, min, range_hi, 1);
-		if (ret == 0)
-			ret = 1;
-	}
-	if (ret < 0)
-		return ret;
+	int ret;
+	unsigned long min;
 
+	min = range_lo;
 	do {
+		range_lo = max(min, *next);
+		ret = mas_empty_area(mas, range_lo, range_hi, 1);
+		if (ret < 0 && range_lo > min) {
+			mas_reset(mas);
+			ret = mas_empty_area(mas, min, range_hi, 1);
+			if (ret == 0)
+				ret = 1;
+		}
+		if (ret < 0)
+			goto out;
+
 		mas_insert(mas, entry);
 	} while (mas_nomem(mas, gfp));
-	if (mas_is_err(mas))
-		return xa_err(mas->node);
 
+	if (mas_is_err(mas)) {
+		ret = xa_err(mas->node);
+		goto out;
+	}
+
+	if ((mas->tree->ma_flags & MT_FLAGS_ALLOC_WRAPPED) && ret == 0) {
+		mas->tree->ma_flags &= ~MT_FLAGS_ALLOC_WRAPPED;
+		ret = 1;
+	}
 	*startp = mas->index;
 	*next = *startp + 1;
 	if (*next == 0)
 		mas->tree->ma_flags |= MT_FLAGS_ALLOC_WRAPPED;
 
+out:
 	mas_destroy(mas);
 	return ret;
 }
-- 
2.53.0



