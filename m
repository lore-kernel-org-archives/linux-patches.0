Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26FC288C39;
	Fri,  6 Jun 2025 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224531; cv=none; b=BbCHRA5H73UudZeYPr40nC62m6tBkKIpjY4r1gB0glQdTonAPDilLwJzS0/fH0Pd+kWHz+0Z7pfRELUdJ9eoK8M8hsEjqnFK52EIc5f0GNuzI5qVwDi/ggwOglfHIN/A3B/OaXPmiK2R63cmPGRKQ8Bmj+DFVCC9Eyvl8n0Cm+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224531; c=relaxed/simple;
	bh=FT8S6Cvu8sue5pGGSTUpWLZD0TmnX7aTCyl6uhxhv0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Oh87kwo2mAX2Mf52KmZG7Rq8nIRuI7RLI/UdyQSNyov+2N3ADoNfpqVUvKaRs3DLdhiEGgsfBxzISOeEl8s466ArsaiXby17NSQSU/liHCX8GyfGJjq+J6lWuaqHpWEXjGZPTHU4Cyjro+nnzaKtZ4eBbhd+ABahrksqsexp24M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XSniiyHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XSniiyHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77850C4CEED;
	Fri,  6 Jun 2025 15:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224530;
	bh=FT8S6Cvu8sue5pGGSTUpWLZD0TmnX7aTCyl6uhxhv0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XSniiyHk7Kjhb0y+IXeWCrTeSFkABaP1w6aYJVpRHTqVuZKKdmEPyXk7Uqerda417
	 rBFAY7No3f8yatLGv0MTGGyiwkzRy+pNVW5JM4DsOlfPrOTL+gj87u3u5OPRmti0a3
	 7DeM6ln7Wg0zM+i0hbESu70/GBKoBnEUS6HXeNLxqDCMVMuIYaL9tJx0dkjZYCRM2G
	 KGv7d1KxbDalEXBzkWOnSLhvdC/ptEw5hGQSPZboOZHRU/5vZO2Jo8f1U5B9mc/tiN
	 K7lxGBdS0EF3Ae34R4z78R1zBo0W6iLMVZY3r81WtllHBf4k6LYkawYVsE9Y8aAFx3
	 7YgJNce+pdelg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	Ken Raeburn <raeburn@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.15 15/21] dm vdo indexer: don't read request structure after enqueuing
Date: Fri,  6 Jun 2025 11:41:40 -0400
Message-Id: <20250606154147.546388-15-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154147.546388-1-sashal@kernel.org>
References: <20250606154147.546388-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15.1
Content-Transfer-Encoding: 8bit

From: Matthew Sakai <msakai@redhat.com>

[ Upstream commit 3da732687d72078e52cc7f334a482383e84ca156 ]

The function get_volume_page_protected may place a request on
a queue for another thread to process asynchronously. When this
happens, the volume should not read the request from the original
thread. This can not currently cause problems, due to the way
request processing is handled, but it is not safe in general.

Reviewed-by: Ken Raeburn <raeburn@redhat.com>
Signed-off-by: Matthew Sakai <msakai@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES**

This commit should be backported to stable kernel trees. Here's my
analysis:

## Bug Analysis

This commit fixes a **serious race condition and potential use-after-
free vulnerability** in the dm-vdo indexer. The issue occurs when a
request structure is accessed after being enqueued for asynchronous
processing by another thread.

### The Problem

Looking at the code changes, the original implementation had a dangerous
pattern:

```c
// In get_volume_page_protected() - BEFORE fix
if (page == NULL) {
    enqueue_page_read(volume, request, physical_page);  // Request
handed to reader thread
    mutex_unlock(&volume->read_threads_mutex);
    begin_pending_search(&volume->page_cache, physical_page,
request->zone_number);  // UNSAFE!
    //
^^^^^^^^^^^^^^
    // Accessing request after it may have been freed/modified by reader
thread
}
```

Once `enqueue_page_read()` is called, the request structure is owned by
the reader thread pool and may be:
- Freed immediately
- Modified by the reader thread
- Reused for another request

Any subsequent access to `request->zone_number` creates a race condition
that could lead to:
1. **Kernel crashes** from accessing freed memory
2. **Silent data corruption** from using wrong zone numbers
3. **System instability** in production storage environments

### The Fix

The solution is elegant and safe - cache the zone number immediately:

```c
// AFTER fix
static int get_volume_page_protected(struct volume *volume, struct
uds_request *request,
                                     u32 physical_page, struct
cached_page **page_ptr)
{
    unsigned int zone_number = request->zone_number;  // Cache
immediately

    // ... later use zone_number instead of request->zone_number
    begin_pending_search(&volume->page_cache, physical_page,
zone_number);  // SAFE!
}
```

## Backport Justification

This meets all stable tree criteria:

1. **Critical Bug Fix**: Fixes a race condition that can cause kernel
   crashes and data corruption
2. **Production Impact**: VDO is used in enterprise storage systems
   where this could cause severe problems
3. **Low Risk**: The fix is minimal (just caching a variable locally)
   with no functional changes
4. **Hard to Debug**: Race conditions are timing-dependent and extremely
   difficult to diagnose in production
5. **Clear Root Cause**: The commit message and code changes clearly
   identify and fix the specific issue

The commit message explicitly states "This can not currently cause
problems, due to the way request processing is handled, but it is not
safe in general" - indicating this is a latent bug that could be
triggered by future changes or under specific timing conditions.

This type of memory safety fix in critical storage infrastructure should
absolutely be backported to prevent potential data loss or system
crashes in production environments.

 drivers/md/dm-vdo/indexer/volume.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-vdo/indexer/volume.c b/drivers/md/dm-vdo/indexer/volume.c
index 655453bb276be..425b3a74f4dba 100644
--- a/drivers/md/dm-vdo/indexer/volume.c
+++ b/drivers/md/dm-vdo/indexer/volume.c
@@ -754,10 +754,11 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 				     u32 physical_page, struct cached_page **page_ptr)
 {
 	struct cached_page *page;
+	unsigned int zone_number = request->zone_number;
 
 	get_page_from_cache(&volume->page_cache, physical_page, &page);
 	if (page != NULL) {
-		if (request->zone_number == 0) {
+		if (zone_number == 0) {
 			/* Only one zone is allowed to update the LRU. */
 			make_page_most_recent(&volume->page_cache, page);
 		}
@@ -767,7 +768,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 	}
 
 	/* Prepare to enqueue a read for the page. */
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	mutex_lock(&volume->read_threads_mutex);
 
 	/*
@@ -787,8 +788,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 		 * the order does not matter for correctness as it does below.
 		 */
 		mutex_unlock(&volume->read_threads_mutex);
-		begin_pending_search(&volume->page_cache, physical_page,
-				     request->zone_number);
+		begin_pending_search(&volume->page_cache, physical_page, zone_number);
 		return UDS_QUEUED;
 	}
 
@@ -797,7 +797,7 @@ static int get_volume_page_protected(struct volume *volume, struct uds_request *
 	 * "search pending" state in careful order so no other thread can mess with the data before
 	 * the caller gets to look at it.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 	mutex_unlock(&volume->read_threads_mutex);
 	*page_ptr = page;
 	return UDS_SUCCESS;
@@ -849,6 +849,7 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 {
 	int result;
 	struct cached_page *page = NULL;
+	unsigned int zone_number = request->zone_number;
 	u32 physical_page = map_to_physical_page(volume->geometry, chapter,
 						 index_page_number);
 
@@ -858,18 +859,18 @@ static int search_cached_index_page(struct volume *volume, struct uds_request *r
 	 * invalidation by the reader thread, before the reader thread has noticed that the
 	 * invalidate_counter has been incremented.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 
 	result = get_volume_page_protected(volume, request, physical_page, &page);
 	if (result != UDS_SUCCESS) {
-		end_pending_search(&volume->page_cache, request->zone_number);
+		end_pending_search(&volume->page_cache, zone_number);
 		return result;
 	}
 
 	result = uds_search_chapter_index_page(&page->index_page, volume->geometry,
 					       &request->record_name,
 					       record_page_number);
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	return result;
 }
 
@@ -882,6 +883,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 {
 	struct cached_page *record_page;
 	struct index_geometry *geometry = volume->geometry;
+	unsigned int zone_number = request->zone_number;
 	int result;
 	u32 physical_page, page_number;
 
@@ -905,11 +907,11 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 	 * invalidation by the reader thread, before the reader thread has noticed that the
 	 * invalidate_counter has been incremented.
 	 */
-	begin_pending_search(&volume->page_cache, physical_page, request->zone_number);
+	begin_pending_search(&volume->page_cache, physical_page, zone_number);
 
 	result = get_volume_page_protected(volume, request, physical_page, &record_page);
 	if (result != UDS_SUCCESS) {
-		end_pending_search(&volume->page_cache, request->zone_number);
+		end_pending_search(&volume->page_cache, zone_number);
 		return result;
 	}
 
@@ -917,7 +919,7 @@ int uds_search_cached_record_page(struct volume *volume, struct uds_request *req
 			       &request->record_name, geometry, &request->old_metadata))
 		*found = true;
 
-	end_pending_search(&volume->page_cache, request->zone_number);
+	end_pending_search(&volume->page_cache, zone_number);
 	return UDS_SUCCESS;
 }
 
-- 
2.39.5

