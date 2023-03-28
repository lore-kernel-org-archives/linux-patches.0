Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF1D8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F324CC433D2;
	Tue, 28 Mar 2023 15:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680016301;
	bh=pye1PK5dzUlO9UgCMGq7Xa3au9/2Q3hZylfisLuieKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOdSdBnqvP0k7Kxp5ybERdpOmNj60mO8ri0ijO4QZBBhsLVbN2IbkmwflbhSKhCt2
	 hFy9CWRoRWA7yVrgGfzgJK06jdi62XslEr/1BDoJjYpmst5DxnQE3cMPkGUC3puct1
	 I8kDMSFwPQTTXzdmgpb6Pi71HxsDWOaedprz6tp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 5.15 139/146] dm stats: check for and propagate alloc_percpu failure
Date: Tue, 28 Mar 2023 16:43:48 +0200
Message-Id: <20230328142608.468491242@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

commit d3aa3e060c4a80827eb801fc448debc9daa7c46b upstream.

Check alloc_precpu()'s return value and return an error from
dm_stats_init() if it fails. Update alloc_dev() to fail if
dm_stats_init() does.

Otherwise, a NULL pointer dereference will occur in dm_stats_cleanup()
even if dm-stats isn't being actively used.

Fixes: fd2ed4d25270 ("dm: add statistics support")
Cc: stable@vger.kernel.org
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-stats.c |    7 ++++++-
 drivers/md/dm-stats.h |    2 +-
 drivers/md/dm.c       |    4 +++-
 3 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/md/dm-stats.c
+++ b/drivers/md/dm-stats.c
@@ -188,7 +188,7 @@ static int dm_stat_in_flight(struct dm_s
 	       atomic_read(&shared->in_flight[WRITE]);
 }
 
-void dm_stats_init(struct dm_stats *stats)
+int dm_stats_init(struct dm_stats *stats)
 {
 	int cpu;
 	struct dm_stats_last_position *last;
@@ -197,11 +197,16 @@ void dm_stats_init(struct dm_stats *stat
 	INIT_LIST_HEAD(&stats->list);
 	stats->precise_timestamps = false;
 	stats->last = alloc_percpu(struct dm_stats_last_position);
+	if (!stats->last)
+		return -ENOMEM;
+
 	for_each_possible_cpu(cpu) {
 		last = per_cpu_ptr(stats->last, cpu);
 		last->last_sector = (sector_t)ULLONG_MAX;
 		last->last_rw = UINT_MAX;
 	}
+
+	return 0;
 }
 
 void dm_stats_cleanup(struct dm_stats *stats)
--- a/drivers/md/dm-stats.h
+++ b/drivers/md/dm-stats.h
@@ -21,7 +21,7 @@ struct dm_stats_aux {
 	unsigned long long duration_ns;
 };
 
-void dm_stats_init(struct dm_stats *st);
+int dm_stats_init(struct dm_stats *st);
 void dm_stats_cleanup(struct dm_stats *st);
 
 struct mapped_device;
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1818,7 +1818,9 @@ static struct mapped_device *alloc_dev(i
 	if (!md->pending_io)
 		goto bad;
 
-	dm_stats_init(&md->stats);
+	r = dm_stats_init(&md->stats);
+	if (r < 0)
+		goto bad;
 
 	/* Populate the mapping, nobody knows we exist yet */
 	spin_lock(&_minor_lock);


