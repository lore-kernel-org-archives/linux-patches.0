Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3BB32B11F;
	Sat, 30 May 2026 17:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161007; cv=none; b=F/AUc8H7i3leVCPp2VzSFfXrJu+walbVtQZ6H5Paw3ZMwYImudQhIewFScSi8MOW4w1pwSSgeR7ay2TCR6J9vHwWNWj7yyM1H1bpOYl2gNJKgSIgxX4HlIiZUuMaftDW8r1MTuJfjuwZhsRy1V7LPHuYoVP6sPJ8tfQdvbAPniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161007; c=relaxed/simple;
	bh=9bDnC1Jd41HP1hnNaG4zi8JWMv2rOBTovczNPXD3dxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1a3c6BlUwf4JSImkmg1p/I5b02U/DAZRysc+d+firpV0duCNVFQ2qHDHzl+BFeQooP9Zl89Q+OiV1e6s/mFW+P+ZMC591wEqyQKedqAoz/sniK0gsBiBSnyFX3P4QLyCmg/AG4vkSMznDjR/JRrK1J9g9Ch5HCU/emAXHkWxWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlUA63Oa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlUA63Oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 841D71F00893;
	Sat, 30 May 2026 17:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161006;
	bh=le5AAz/36srjC2zGgi10hqvDMzG++rCjn6Y/gN5Yy0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YlUA63OaTddoT81rcDjGTar4Nvu4FG2C4Ml9jq4TeK1t2KChK76aRZqDK8xleKwWx
	 Kib1qyhUBoxUH/vyHfIp0Vn0hz6HmtoTy6XaPK9Tin4lQnDIGTBUdL7GDZX0JG7CWb
	 NEOCo69E/KWdzT+KP6SmUQKxe/CodRnGLCtMhCIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 497/969] dm cache: fix write hang in passthrough mode
Date: Sat, 30 May 2026 18:00:21 +0200
Message-ID: <20260530160314.048612531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e2e234c3649a0..f7da6f853ec33 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1445,8 +1445,14 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
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
@@ -1483,6 +1489,22 @@ static int invalidate_cblock(struct cache *cache, dm_cblock_t cblock)
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
@@ -1495,10 +1517,8 @@ static void invalidate_remove(struct work_struct *ws)
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



