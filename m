Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F15E92F998D;
	Mon, 13 Oct 2025 15:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369763; cv=none; b=N8LzWgU4EGLaqg2uAcrAIwY5y7PPYprnhQ3FSRLF2e8ee9r07qst1lisFy8M3X//rEnxkijQRq5YtVBarD0TuHletnDEBH1xfr3hJPlQ3nSpqq46MP2fTW5QxvcJMi+je4SE0dzFSFP77xbsghWKHy/1ptjW1yjI+zyxArvG+hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369763; c=relaxed/simple;
	bh=1R1Hr6lVUkX3pWbNqdkzlVO2zLXCfsVs2c6tW9GTAUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bq2Gm71u3ZMhgHJQJFdBHbvVglGlpT6QN3w6JPYDKQZseDqd9S8VQ1YWABlP1UlVr00qqyyMQjGfJzruROUlJNRfzCjrKrrrAY8u6+1wB02zzZ1dOwc2onfqZq1rd/p+9r5wOtLRZO2+Ohzej269SROXh0vb/PTeSJh2he8Q65c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=km+yHZZE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="km+yHZZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F05C19425;
	Mon, 13 Oct 2025 15:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369762;
	bh=1R1Hr6lVUkX3pWbNqdkzlVO2zLXCfsVs2c6tW9GTAUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=km+yHZZEmyDxF2v8Q8GkqeufLy73GyBy1cLfmz4LWqf+aMWHAUjiMnOuDC7EX0drZ
	 3fTIdSp0lOQmBGSeo1daNSO1bNKbWXR7bjA5UT+KJ/y4Vu7NwqFrSDFTG0+PtpB265
	 kUqYfbLJ2Wxu/B16mHU6/qlXhzddCFm2DwxJHjIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 342/563] mm/slub: Fix cmp_loc_by_count() to return 0 when counts are equal
Date: Mon, 13 Oct 2025 16:43:23 +0200
Message-ID: <20251013144423.658214774@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

[ Upstream commit e1c4350327b39c9cad27b6c5779b3754384f26c8 ]

The comparison function cmp_loc_by_count() used for sorting stack trace
locations in debugfs currently returns -1 if a->count > b->count and 1
otherwise. This breaks the antisymmetry property required by sort(),
because when two counts are equal, both cmp(a, b) and cmp(b, a) return
1.

This can lead to undefined or incorrect ordering results. Fix it by
updating the comparison logic to explicitly handle the case when counts
are equal, and use cmp_int() to ensure the comparison function adheres
to the required mathematical properties of antisymmetry.

Fixes: 553c0369b3e1 ("mm/slub: sort debugfs output by frequency of stack traces")
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/slub.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index d257141896c95..264fc76455d73 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7731,10 +7731,7 @@ static int cmp_loc_by_count(const void *a, const void *b, const void *data)
 	struct location *loc1 = (struct location *)a;
 	struct location *loc2 = (struct location *)b;
 
-	if (loc1->count > loc2->count)
-		return -1;
-	else
-		return 1;
+	return cmp_int(loc2->count, loc1->count);
 }
 
 static void *slab_debugfs_start(struct seq_file *seq, loff_t *ppos)
-- 
2.51.0



