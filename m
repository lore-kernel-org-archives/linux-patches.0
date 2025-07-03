Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038EE2EA49E;
	Thu,  3 Jul 2025 14:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554582; cv=none; b=kw/91Je6bwOfq8PyFfY0i8IUyt1unEMwjoeBrQPHsPn6f0ZCOxWmBa73iRdXDx+5UI8QApvHkqsDH3hKnAWLAwMpmbmu4ggxhTQK2hScJiFRjshquoutN5mPYeQfNhMKOBPFWr1MzIBz0aPPLNMbgktUffHaznVh9Zh+Vq/t2rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554582; c=relaxed/simple;
	bh=KKAS2Aam76EzPEKiSEJDIR1/MEIdDGTsaITOaOJ58Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KxMV5lKMumvgCxTStsyRdIcgsdughCE9u5HfHT0N6ylY9Pr6L6AIKoOTJuOeBQ/Ra3kklZ4nPGZXN77/yB9UWFiP/ImHPOdz+br187a08RomXsxv2MrKZ0j8wzaGSeubJtWDraldHN4xVV7RnQKXeBi9yVVmvQtupKBCHSykVDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ja1sCuby; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ja1sCuby"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A22BC4CEE3;
	Thu,  3 Jul 2025 14:56:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554581;
	bh=KKAS2Aam76EzPEKiSEJDIR1/MEIdDGTsaITOaOJ58Rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ja1sCuby1OSjNrpilgXfJAvqhU7Ghmy2zhmYfNsDMphOVKXmlbKD+lyRz7KnASoTP
	 q+2T2rLxob9S22E+QJa9R9a58w5FxDbRKalhHO0TT3K2Ya8eECQB3htDPq0qIsGdFn
	 QpQEvGW03WnJ5me+soz4DzcGSjnTTX6C7f4b5/4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ken Raeburn <raeburn@redhat.com>,
	Matthew Sakai <msakai@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 015/263] dm vdo indexer: dont read request structure after enqueuing
Date: Thu,  3 Jul 2025 16:38:55 +0200
Message-ID: <20250703144004.910481752@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

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



