Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448113FF1AC;
	Fri, 15 May 2026 15:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860511; cv=none; b=iSHi9qzvK0IDWSr64XkJmdC4YUfSA5ixH+1mP5q73BFki26hFcr6C2Z+GY0QpWppAe7ucnxAKPUh+hCpzrPyPAJwJOfTRdnKSaSBOZWB15MGdk4U+Nq0UItZnN5W05zl4snOrvDLTV3O1L/B3GYi5MPUZW2zsjucgPsoK+5dok0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860511; c=relaxed/simple;
	bh=udOZkQFsLId99vgDkfqxMsYFKMKWrXP6ECdLRCEmmUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY7gvjBw0pFMUuonNgFrWev7PEv+dmgXYQqkTpX6JR8c1AyKm0L/yUioruof4QFOXG+rOGuOjf0HDtKjcHx8eRiL7KCbrrQZAJnFr6Z4qvTpmnonUBzfZhPQ4DwiO6p5x0Bd2ziLDD26JjpuoERbzp1LMgTtjR0BCYeoggS5wT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=izNrSiEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="izNrSiEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE43EC2BCB0;
	Fri, 15 May 2026 15:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860511;
	bh=udOZkQFsLId99vgDkfqxMsYFKMKWrXP6ECdLRCEmmUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=izNrSiEMR3N+p7FfRer13eiYkFS3QOYD+9hk0eZDvmawQUMc9p1IHU/IIIihVLEpW
	 d0wRVj/cqarJPGrACB8vg73MOrO1tYQ+RTJ3tmCOf8i/nVYfeEEs94Te7WhNszt+ra
	 tEhzhMyztRA1pQbiTwiUyJhxSdV63UwpeMJrtjjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/144] block: reorganize struct blk_zone_wplug
Date: Fri, 15 May 2026 17:49:04 +0200
Message-ID: <20260515154656.234769848@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ca1a897fb266c4b23b5ecb99fe787ed18559057d ]

Reorganize the fields of struct blk_zone_wplug to remove a hole after
the wp_offset field and avoid having the bio_work structure split
between 2 cache lines.

No functional changes.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: b7d4ffb51037 ("block: fix zone write plug removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -41,6 +41,11 @@ static const char *const zone_cond_name[
 /*
  * Per-zone write plug.
  * @node: hlist_node structure for managing the plug using a hash table.
+ * @bio_list: The list of BIOs that are currently plugged.
+ * @bio_work: Work struct to handle issuing of plugged BIOs
+ * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
+ * @disk: The gendisk the plug belongs to.
+ * @lock: Spinlock to atomically manipulate the plug.
  * @ref: Zone write plug reference counter. A zone write plug reference is
  *       always at least 1 when the plug is hashed in the disk plug hash table.
  *       The reference is incremented whenever a new BIO needing plugging is
@@ -50,27 +55,22 @@ static const char *const zone_cond_name[
  *       reference is dropped whenever the zone of the zone write plug is reset,
  *       finished and when the zone becomes full (last write BIO to the zone
  *       completes).
- * @lock: Spinlock to atomically manipulate the plug.
  * @flags: Flags indicating the plug state.
  * @zone_no: The number of the zone the plug is managing.
  * @wp_offset: The zone write pointer location relative to the start of the zone
  *             as a number of 512B sectors.
- * @bio_list: The list of BIOs that are currently plugged.
- * @bio_work: Work struct to handle issuing of plugged BIOs
- * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
- * @disk: The gendisk the plug belongs to.
  */
 struct blk_zone_wplug {
 	struct hlist_node	node;
-	refcount_t		ref;
-	spinlock_t		lock;
-	unsigned int		flags;
-	unsigned int		zone_no;
-	unsigned int		wp_offset;
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
 	struct gendisk		*disk;
+	spinlock_t		lock;
+	refcount_t		ref;
+	unsigned int		flags;
+	unsigned int		zone_no;
+	unsigned int		wp_offset;
 };
 
 static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)


