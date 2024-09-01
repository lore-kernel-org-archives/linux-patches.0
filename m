Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12191C68C;
	Sun,  1 Sep 2024 16:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208912; cv=none; b=AAFSPquh5W9d/7gjBZMdZv37AKd9FD6EOK74Gi4M60aqhCrDgwbggio7GGqAstLzizLrJZH5a+fZvvFyryFDqpbLNofPYragr3+Oe77PbKiprPbY4rCpY/7N2YMWsHl9RrVRuK15gd1gvLTRb1HY6deZ1M+k2vhOA1tYP/sxj2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208912; c=relaxed/simple;
	bh=NWCG1epY3mCCDCfjJc1qHy3+zbgW8dCDNOsMtdH5ljk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDzorn7bCz7ak9wr9rcn3L2oHNMFE2N6KRlJiBph+Q0DDszwmoIGCfvouA7OBrBSHNjTazEUEiEyAId0qJcK5iH1XfZPnQtpk9XFKDhUazwCz+aZ8w/JWxIVI/EAqe8LN2nWQFKSj0P7s8X1qP/SPJxfRNqwIF0ETceHDjzACkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JW40p1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JW40p1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 632CEC4CEC3;
	Sun,  1 Sep 2024 16:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208911;
	bh=NWCG1epY3mCCDCfjJc1qHy3+zbgW8dCDNOsMtdH5ljk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JW40p1Eu++mLQU3pgvmiu3f4RBUWLjh7TjXvmWjMMUCPfWXd+ktUmQPTpgZYB8kv
	 8K4O5JJtduiqF7MUErRPMS83YRDgl9EKWrXqrKPJKBNNvyRifjpJQUpCjB51NsWv2k
	 LwyMfSXa9TZYdrdcFc/9NU7ntkcKp8eHM46JHrFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Mike Snitzer <snitzer@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 077/134] dm mpath: pass IO start time to path selector
Date: Sun,  1 Sep 2024 18:17:03 +0200
Message-ID: <20240901160812.999595523@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit 087615bf3acdafd0ba7c7c9ed5286e7b7c80fe1b ]

The HST path selector needs this information to perform path
prediction. For request-based mpath, struct request's io_start_time_ns
is used, while for bio-based, use the start_time stored in dm_io.

Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Stable-dep-of: 1e1fd567d32f ("dm suspend: return -ERESTARTSYS instead of -EINTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-mpath.c         | 9 ++++++---
 drivers/md/dm-path-selector.h | 2 +-
 drivers/md/dm-queue-length.c  | 2 +-
 drivers/md/dm-service-time.c  | 2 +-
 drivers/md/dm.c               | 9 +++++++++
 include/linux/device-mapper.h | 2 ++
 6 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 54ecfea2cf47b..4f6a54452b1ca 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -558,7 +558,8 @@ static void multipath_release_clone(struct request *clone,
 		if (pgpath && pgpath->pg->ps.type->end_io)
 			pgpath->pg->ps.type->end_io(&pgpath->pg->ps,
 						    &pgpath->path,
-						    mpio->nr_bytes);
+						    mpio->nr_bytes,
+						    clone->io_start_time_ns);
 	}
 
 	blk_put_request(clone);
@@ -1568,7 +1569,8 @@ static int multipath_end_io(struct dm_target *ti, struct request *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 clone->io_start_time_ns);
 	}
 
 	return r;
@@ -1612,7 +1614,8 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 		struct path_selector *ps = &pgpath->pg->ps;
 
 		if (ps->type->end_io)
-			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes);
+			ps->type->end_io(ps, &pgpath->path, mpio->nr_bytes,
+					 dm_start_time_ns_from_clone(clone));
 	}
 
 	return r;
diff --git a/drivers/md/dm-path-selector.h b/drivers/md/dm-path-selector.h
index b6eb5365b1a46..c47bc0e20275b 100644
--- a/drivers/md/dm-path-selector.h
+++ b/drivers/md/dm-path-selector.h
@@ -74,7 +74,7 @@ struct path_selector_type {
 	int (*start_io) (struct path_selector *ps, struct dm_path *path,
 			 size_t nr_bytes);
 	int (*end_io) (struct path_selector *ps, struct dm_path *path,
-		       size_t nr_bytes);
+		       size_t nr_bytes, u64 start_time);
 };
 
 /* Register a path selector */
diff --git a/drivers/md/dm-queue-length.c b/drivers/md/dm-queue-length.c
index 969c4f1a36336..5fd018d184187 100644
--- a/drivers/md/dm-queue-length.c
+++ b/drivers/md/dm-queue-length.c
@@ -227,7 +227,7 @@ static int ql_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int ql_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm-service-time.c b/drivers/md/dm-service-time.c
index f006a9005593b..9cfda665e9ebd 100644
--- a/drivers/md/dm-service-time.c
+++ b/drivers/md/dm-service-time.c
@@ -309,7 +309,7 @@ static int st_start_io(struct path_selector *ps, struct dm_path *path,
 }
 
 static int st_end_io(struct path_selector *ps, struct dm_path *path,
-		     size_t nr_bytes)
+		     size_t nr_bytes, u64 start_time)
 {
 	struct path_info *pi = path->pscontext;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a7724ba45b437..36d21a5d09ebf 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -659,6 +659,15 @@ static bool md_in_flight(struct mapped_device *md)
 		return md_in_flight_bios(md);
 }
 
+u64 dm_start_time_ns_from_clone(struct bio *bio)
+{
+	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
+	struct dm_io *io = tio->io;
+
+	return jiffies_to_nsecs(io->start_time);
+}
+EXPORT_SYMBOL_GPL(dm_start_time_ns_from_clone);
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 60631f3abddbd..b077f32043653 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -332,6 +332,8 @@ void *dm_per_bio_data(struct bio *bio, size_t data_size);
 struct bio *dm_bio_from_per_bio_data(void *data, size_t data_size);
 unsigned dm_bio_get_target_bio_nr(const struct bio *bio);
 
+u64 dm_start_time_ns_from_clone(struct bio *bio);
+
 int dm_register_target(struct target_type *t);
 void dm_unregister_target(struct target_type *t);
 
-- 
2.43.0



