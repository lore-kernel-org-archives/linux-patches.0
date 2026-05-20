Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1F4E3F660B;
	Wed, 20 May 2026 18:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300420; cv=none; b=agn4g6dmGkxo7tOSABVvtsrr/LVF5Jn3o8Bpejz37s+DzhyIoZ9Tywy2PtTHP5rMFbmMDKjLgywC0/cEWjx9IksVTsKPCNoIosctst1sb1hoZ+YBvaXR5dJcmd2DZ2aTm3Od+zwV9tuxX0xifmXgNvMpeUmDzNabDXmSX4TttFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300420; c=relaxed/simple;
	bh=hiVA9+ACFpege8Nv+JFLJFIXUMvbH72eD4xHqBKjG/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aw9NN1arys2BwPMltW2ovojCUQHkbart7yMfd0WdJfJXBmCHx1QGrkuzzYy5I+btdjEHN3VpPePmFIMcniYZAZ81QJheTMOpdfvTzjud0PExVHFsFWfLon9jH7k9Tbpt31dnb9iRVzvxvkYWjIXLM/AhPclykAgsR3E3q7T22CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hing7m5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hing7m5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430741F000E9;
	Wed, 20 May 2026 18:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300419;
	bh=oznq/M1B9KM8ubItvhEhXj9IkCZO56rgo3cB4uz9DBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hing7m5yAdhw5PnA6ImwTdaAG/tarLcv6X1ts0Usg25EYp7kra8xd3twM/Azl9M/7
	 3YEhASrK08Ewl15a6/gUgqC07/1MHeHtIfkEz+k6iPv38CNP+2bi6SGWJmuFpmj1Nm
	 9AuN7HLOsQzd+GsGAtKpppveReSnqsmj4CDccxVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming-Hung Tsai <mtsai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/666] dm cache: fix write hang in passthrough mode
Date: Wed, 20 May 2026 18:15:38 +0200
Message-ID: <20260520162113.967495289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index 61f6050479d15..2f882eb77dacf 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1461,8 +1461,14 @@ static void invalidate_complete(struct dm_cache_migration *mg, bool success)
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
@@ -1502,6 +1508,22 @@ static int invalidate_cblock(struct cache *cache, dm_cblock_t cblock)
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
@@ -1514,10 +1536,8 @@ static void invalidate_remove(struct work_struct *ws)
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



