Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 983592F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E66C433D2;
	Wed, 12 Apr 2023 08:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288765;
	bh=NdJIdttaNnPy+/lC6CYgAQwQRlNTxsx9GHiIsy2XfZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ya2ODr7fM/e4QMTA2otqYy5aEd4hdAy5LvQJQt2QYhONx37bKBVGnN561pb37rabc
	 fz5a54Xx14Ah5XkO5RBW/S9tEg2HzU39XbryfHY4G3JRupdJQSabbZFWfnhxFCdAbO
	 UBbcnf9MCWhhrrcDvejJkw1MfBiYWbKp7pEEGHrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Thornber <ejt@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/164] dm cache: Add some documentation to dm-cache-background-tracker.h
Date: Wed, 12 Apr 2023 10:32:03 +0200
Message-Id: <20230412082836.775989971@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Joe Thornber <ejt@redhat.com>

[ Upstream commit 22c40e134c4c7a828ac09d25a5a8597b1e45c031 ]

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Stable-dep-of: f7b58a69fad9 ("dm: fix improper splitting for abnormal bios")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-cache-background-tracker.h | 40 ++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-background-tracker.h b/drivers/md/dm-cache-background-tracker.h
index 27ab90dbc2752..b5056e8275c15 100644
--- a/drivers/md/dm-cache-background-tracker.h
+++ b/drivers/md/dm-cache-background-tracker.h
@@ -12,19 +12,44 @@
 
 /*----------------------------------------------------------------*/
 
+/*
+ * The cache policy decides what background work should be performed,
+ * such as promotions, demotions and writebacks. The core cache target
+ * is in charge of performing the work, and does so when it sees fit.
+ *
+ * The background_tracker acts as a go between. Keeping track of future
+ * work that the policy has decided upon, and handing (issuing) it to
+ * the core target when requested.
+ *
+ * There is no locking in this, so calls will probably need to be
+ * protected with a spinlock.
+ */
+
 struct background_work;
 struct background_tracker;
 
 /*
- * FIXME: discuss lack of locking in all methods.
+ * Create a new tracker, it will not be able to queue more than
+ * 'max_work' entries.
  */
 struct background_tracker *btracker_create(unsigned max_work);
+
+/*
+ * Destroy the tracker. No issued, but not complete, work should
+ * exist when this is called. It is fine to have queued but unissued
+ * work.
+ */
 void btracker_destroy(struct background_tracker *b);
 
 unsigned btracker_nr_writebacks_queued(struct background_tracker *b);
 unsigned btracker_nr_demotions_queued(struct background_tracker *b);
 
 /*
+ * Queue some work within the tracker. 'work' should point to the work
+ * to queue, this will be copied (ownership doesn't pass).  If pwork
+ * is not NULL then it will be set to point to the tracker's internal
+ * copy of the work.
+ *
  * returns -EINVAL iff the work is already queued.  -ENOMEM if the work
  * couldn't be queued for another reason.
  */
@@ -33,11 +58,20 @@ int btracker_queue(struct background_tracker *b,
 		   struct policy_work **pwork);
 
 /*
+ * Hands out the next piece of work to be performed.
  * Returns -ENODATA if there's no work.
  */
 int btracker_issue(struct background_tracker *b, struct policy_work **work);
-void btracker_complete(struct background_tracker *b,
-		       struct policy_work *op);
+
+/*
+ * Informs the tracker that the work has been completed and it may forget
+ * about it.
+ */
+void btracker_complete(struct background_tracker *b, struct policy_work *op);
+
+/*
+ * Predicate to see if an origin block is already scheduled for promotion.
+ */
 bool btracker_promotion_already_present(struct background_tracker *b,
 					dm_oblock_t oblock);
 
-- 
2.39.2



