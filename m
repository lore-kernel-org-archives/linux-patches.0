Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAA02BE02A;
	Wed, 20 May 2026 16:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295004; cv=none; b=kPBcUT7qU69/TUMRH46vlqHUppKR3gQMBhj9fWgc8OtOE5xBgRFVbpuEm8udoeonmo+aWxIHC2dzNkeK176ln59h+C6ALPVhligr1ugsGBPw1LZoCE4jtC3WCnEZEglFewgZzU9rU1TmDgEWdVkdfwZodUVdMesZp2EdO/V1Y0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295004; c=relaxed/simple;
	bh=33Ue2V5mzN1HE11nIZ98i1Ax9aEfJDB2970OHyZ38Qs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZx5ZIYgumYjs7Dwt/36K2u6/rOI1G3Hi6b+Gks1QqVQEohKoWBcKXQCdM3lid0CU2RmTVufdrrzzzWbLTAvi4rU0/d4lphbLYDpZ9OJUJK8vgkl74z49ZqhLutXDB2brBhj3++cpQ8jFvi30liU99CEaKXlfN+QTO56EduofJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6bWeJe8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6bWeJe8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBBD1F000E9;
	Wed, 20 May 2026 16:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295003;
	bh=n+NRfc11Esc1bXe4htvh1rQuTpf/FRlcD5p1HbdzX3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d6bWeJe8Ej7w+xFZgBCeROzQcD0pt705EGTajlFS3q31KIS/Yz/KugDzE5j/U5s7D
	 kYIMvAMh39EHgBMLjr4CEwu+jhh0V+Zre5qSPnYgDiaz8FA/L8JmCOQ/IZd6MXCVR6
	 tzYw3Q6poE7hxvif6sAIe2tcCkY7OeqSAnkJWoCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0252/1146] dm cache: fix write hang in passthrough mode
Date: Wed, 20 May 2026 18:08:22 +0200
Message-ID: <20260520162153.937683558@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming-Hung Tsai <mtsai@redhat.com>

[ Upstream commit 4ca8b8bd952df7c3ccdc68af9bd3419d0839a04b ]

The invalidate_remove() function has incomplete logic for handling write
hit bios after cache invalidation. It sets up the remapping for the
overwrite_bio but then drops it immediately without submission, causing
write operations to hang.

Fix by adding a new invalidate_committed() continuation that submits
the remapped writes to the cache origin after metadata commit completes,
while using the overwrite_endio hook to ensure proper completion
sequencing. This maintains existing coherency. Also improve error
handling in invalidate_complete() to preserve the original error status
instead of using bio_io_error() unconditionally.

Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Signed-off-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-target.c | 30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index b608e88acd511..d3ef88b859ab3 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1467,8 +1467,14 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
 			free_prison_cell(cache, mg->cell);
 	}
 
-	if (!success && mg->overwrite_bio)
-		bio_io_error(mg->overwrite_bio);
+	if (mg->overwrite_bio) {
+		// Set generic error if the bio hasn't been issued yet,
+		// e.g., invalidation or metadata commit failed before bio
+		// submission. Otherwise preserve the bio's own error status.
+		if (!success && !mg->overwrite_bio->bi_status)
+			mg->overwrite_bio->bi_status = BLK_STS_IOERR;
+		bio_endio(mg->overwrite_bio);
+	}
 
 	free_migration(mg);
 	defer_bios(cache, &bios);
@@ -1508,6 +1514,22 @@ static int invalidate_cblock(struct cache *cache, dm_cblock_t cblock)
 	return r;
 }
 
+static void invalidate_committed(struct work_struct *ws)
+{
+	struct dm_cache_migration *mg = ws_to_mg(ws);
+	struct cache *cache = mg->cache;
+	struct bio *bio = mg->overwrite_bio;
+	struct per_bio_data *pb = get_per_bio_data(bio);
+
+	if (mg->k.input)
+		invalidate_complete(mg, false);
+
+	init_continuation(&mg->k, invalidate_completed);
+	remap_to_origin_clear_discard(cache, bio, mg->invalidate_oblock);
+	dm_hook_bio(&pb->hook_info, bio, overwrite_endio, mg);
+	dm_submit_bio_remap(bio, NULL);
+}
+
 static void invalidate_remove(struct work_struct *ws)
 {
 	int r;
@@ -1520,10 +1542,8 @@ static void invalidate_remove(struct work_struct *ws)
 		return;
 	}
 
-	init_continuation(&mg->k, invalidate_completed);
+	init_continuation(&mg->k, invalidate_committed);
 	continue_after_commit(&cache->committer, &mg->k);
-	remap_to_origin_clear_discard(cache, mg->overwrite_bio, mg->invalidate_oblock);
-	mg->overwrite_bio = NULL;
 	schedule_commit(&cache->committer);
 }
 
-- 
2.53.0



