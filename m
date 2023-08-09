Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2399317744
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:30:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A32C433C7;
	Wed,  9 Aug 2023 11:30:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580642;
	bh=6hIdId1yqY9QBdbekgub2Y2doSMGNu3qzrtXTVKKTDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ulb+KFrEgImMqmxe6TirAwENnKYIF/IQz1Mtc5dNjEEclKrhAk8bjWh72TvvQJ+Gi
	 01tfTDvYEWdZeA4Jn5uQbrMHWZE66zCyvc4Il0qQVOHsryfEbf3dC+QK3xajZTYIOM
	 re2SWeVFLbVhJ6WhlnbHkKvOo5u2oUwAI/ZAMNRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Jeffery <djeffery@redhat.com>,
	Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.4 080/154] dm cache policy smq: ensure IO doesnt prevent cleaner policy progress
Date: Wed,  9 Aug 2023 12:41:51 +0200
Message-ID: <20230809103639.634727085@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joe Thornber <ejt@redhat.com>

commit 1e4ab7b4c881cf26c1c72b3f56519e03475486fb upstream.

When using the cleaner policy to decommission the cache, there is
never any writeback started from the cache as it is constantly delayed
due to normal I/O keeping the device busy. Meaning @idle=false was
always being passed to clean_target_met()

Fix this by adding a specific 'cleaner' flag that is set when the
cleaner policy is configured. This flag serves to always allow the
cleaner's writeback work to be queued until the cache is
decommissioned (even if the cache isn't idle).

Reported-by: David Jeffery <djeffery@redhat.com>
Fixes: b29d4986d0da ("dm cache: significant rework to leverage dm-bio-prison-v2")
Cc: stable@vger.kernel.org
Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-policy-smq.c |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

--- a/drivers/md/dm-cache-policy-smq.c
+++ b/drivers/md/dm-cache-policy-smq.c
@@ -854,7 +854,13 @@ struct smq_policy {
 
 	struct background_tracker *bg_work;
 
-	bool migrations_allowed;
+	bool migrations_allowed:1;
+
+	/*
+	 * If this is set the policy will try and clean the whole cache
+	 * even if the device is not idle.
+	 */
+	bool cleaner:1;
 };
 
 /*----------------------------------------------------------------*/
@@ -1133,7 +1139,7 @@ static bool clean_target_met(struct smq_
 	 * Cache entries may not be populated.  So we cannot rely on the
 	 * size of the clean queue.
 	 */
-	if (idle) {
+	if (idle || mq->cleaner) {
 		/*
 		 * We'd like to clean everything.
 		 */
@@ -1716,11 +1722,9 @@ static void calc_hotspot_params(sector_t
 		*hotspot_block_size /= 2u;
 }
 
-static struct dm_cache_policy *__smq_create(dm_cblock_t cache_size,
-					    sector_t origin_size,
-					    sector_t cache_block_size,
-					    bool mimic_mq,
-					    bool migrations_allowed)
+static struct dm_cache_policy *
+__smq_create(dm_cblock_t cache_size, sector_t origin_size, sector_t cache_block_size,
+	     bool mimic_mq, bool migrations_allowed, bool cleaner)
 {
 	unsigned i;
 	unsigned nr_sentinels_per_queue = 2u * NR_CACHE_LEVELS;
@@ -1807,6 +1811,7 @@ static struct dm_cache_policy *__smq_cre
 		goto bad_btracker;
 
 	mq->migrations_allowed = migrations_allowed;
+	mq->cleaner = cleaner;
 
 	return &mq->policy;
 
@@ -1830,21 +1835,24 @@ static struct dm_cache_policy *smq_creat
 					  sector_t origin_size,
 					  sector_t cache_block_size)
 {
-	return __smq_create(cache_size, origin_size, cache_block_size, false, true);
+	return __smq_create(cache_size, origin_size, cache_block_size,
+			    false, true, false);
 }
 
 static struct dm_cache_policy *mq_create(dm_cblock_t cache_size,
 					 sector_t origin_size,
 					 sector_t cache_block_size)
 {
-	return __smq_create(cache_size, origin_size, cache_block_size, true, true);
+	return __smq_create(cache_size, origin_size, cache_block_size,
+			    true, true, false);
 }
 
 static struct dm_cache_policy *cleaner_create(dm_cblock_t cache_size,
 					      sector_t origin_size,
 					      sector_t cache_block_size)
 {
-	return __smq_create(cache_size, origin_size, cache_block_size, false, false);
+	return __smq_create(cache_size, origin_size, cache_block_size,
+			    false, false, true);
 }
 
 /*----------------------------------------------------------------*/


