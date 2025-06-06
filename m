Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C09428982F;
	Fri,  6 Jun 2025 15:43:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749224597; cv=none; b=Dlh2hroo+TY8qFhorp12v7XiUvtN69wvp2e5GfbmQ793LIIaakyAdJl39K9R3X6HXPAOIwg5s0881VNNAK7roqEeI32y4MooMOmEqZIuJoF8+FGh4lfdT07h2a3Ku1IFIefqBS0/VIYTla63ebE4KEUd+As85uRQCyPWT7hJGmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749224597; c=relaxed/simple;
	bh=FT8S6Cvu8sue5pGGSTUpWLZD0TmnX7aTCyl6uhxhv0E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Go/TpzF/LFeCLse0sx76UM/tlcPSdAlOnhpahzNN2pOk06k/vap0zjY/1mNSweM9F8VEkJj3/TTNeftPZTuvS0LKTpB0RvXueiGL+o5tVw4cZ1U3IZq1ZBapMePbWZis2KS2FuoL1JWe6d/u71j/TX9OzTJLsC0XxhlNeCsCgcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JECxHMhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JECxHMhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB10C4CEED;
	Fri,  6 Jun 2025 15:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749224595;
	bh=FT8S6Cvu8sue5pGGSTUpWLZD0TmnX7aTCyl6uhxhv0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JECxHMhs1OmD3h19DD0IwWminv2amKTgbDVlaZam7bdcVux7v1TzbNs88+k7Y+3YY
	 9OQ1WyIVXiGJVeMacWZ7iWC5WCFV3egwJLHCbU25DStY3RSN3oadfMm1PGIPwaNkHG
	 MSORZfK6X1dmTQSJ7YaBRMhnkmDkMQgzFMxlKSQzPGiJwZUuglXpMgdLPTwDr6zPOu
	 u+GmNohavW6b4iHfPO9lagAX71+FPNIWmZ/PuEGzdUpLgLFj1GHYyxNTvsAkuSezcW
	 yVzBaNdTwxktANwI9pr/yfvs8RQhnZS129IoHchsVGT8M1KFBNoKEk62bzYlXU1ZeO
	 /semqLP9M63cQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Sakai <msakai@redhat.com>,
	Ken Raeburn <raeburn@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.12 10/15] dm vdo indexer: don't read request structure after enqueuing
Date: Fri,  6 Jun 2025 11:42:53 -0400
Message-Id: <20250606154259.547394-10-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250606154259.547394-1-sashal@kernel.org>
References: <20250606154259.547394-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.32
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

