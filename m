Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F20232AAD6;
	Thu, 17 Sep 2026 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666615; cv=none; b=OYKGp3IaMw/cHKIiWGDyyOFHtb/v1izC1KA4r0udf1GCUu21BATZoenShYqSG88umSqscgxkKAMbMgvMapQ/lki5Fe9LsAaqWXbsczBiJ5QjACCtkDYtrjnZuWfAOCYmHn/6tf6/Ng3CqtrljKjx/idbjLPe7LhwR34K30H8QA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666615; c=relaxed/simple;
	bh=x6DuNLY/e/W+b1CJkUDDvlyTB+iMc0kGYTKE6JgzZ1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzEDQbEa6Oh72U95SrTiEdNxvWJQnygKcjCFZwQg98SZPDhNpeVIiuz+Ixd80K8l026y9L8SlrIUj+3yYFgmVw50/HJNHhT8T+znnVGqFPgGHzpgwyhjss5GCKBjScw2KXBbDIeFi13JJ/slFJHfwGNAgbjNAI3zteFbCOGzK9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=owSz+Dqx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="owSz+Dqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027A01F000FF;
	Thu, 17 Sep 2026 17:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666613;
	bh=qf1BRONVe9yBillYKCYGNzSFbHuFMncyYAnvRZFzQds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owSz+Dqxq5c037Fn6C+U0v4wX0OVS28BNbBmWwMCKOypyDGQJf8jrPWFg21WDLKsi
	 yrPzG0M4nveGcYH/DegyJ1qZeJwVc3KCK7qHfyJuNDS9QWY8zJxrZPeQuFuJA6weuO
	 deDp2kQ2ihgRsZeKmrp/ih8Ou5oRFRI6LQfdLLEk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1095/1250] xfs: report nonexistent parents as a filesystem corruption
Date: Thu, 17 Sep 2026 16:14:50 +0100
Message-ID: <20260917151621.851744923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 014c1aff607a839b8ddc732da919b94560ae58c2 upstream.

LOLLM noticed that when the directory tree scrubber tries to walk up a
parent pointer but the parent inumber doesn't point to an allocated
inode, we allow the EINVAL/ENOENT error code to bubble up to userspace.
That's not right, we should be reporting that as a cross-referencing
error so that someone runs the parent pointer checker.

Also add a termination check to xchk_dirpath_step_up because it's a loop
body function.

Cc: stable@vger.kernel.org # v6.10
Fixes: 928b721a11789a ("xfs: teach online scrub to find directory tree structure problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/dirtree.c |   30 ++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h   |   33 +++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 2 deletions(-)

--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -368,12 +368,38 @@ xchk_dirpath_step_up(
 	struct xfs_inode	*dp;
 	xfs_ino_t		parent_ino = be64_to_cpu(dl->pptr_rec.p_ino);
 	unsigned int		lock_mode;
-	int			error;
+	int			error = 0;
+
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Grab and lock the parent directory. */
 	error = xchk_iget(sc, parent_ino, &dp);
-	if (error)
+	switch (error) {
+	case -EINVAL:
+	case -ENOENT:
+		mutex_lock(&dl->lock);
+
+		if (dl->stale) {
+			/* live update detected a change in this path */
+			error = -ESTALE;
+		} else {
+			/* inode doesn't exist, path invalid */
+			error = -EFSCORRUPTED;
+
+			trace_xchk_dirpath_badino(dl->sc, path->path_nr,
+					path->nr_steps, &dl->xname,
+					&dl->pptr_rec);
+		}
+
+		mutex_unlock(&dl->lock);
+		return error;
+	case 0:
+		/* keep going */
+		break;
+	default:
 		return error;
+	}
 
 	lock_mode = xfs_ilock_attr_map_shared(dp);
 	mutex_lock(&dl->lock);
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1706,6 +1706,39 @@ DEFINE_EVENT(xchk_dirtree_class, name, \
 DEFINE_XCHK_DIRTREE_EVENT(xchk_dirtree_create_path);
 DEFINE_XCHK_DIRTREE_EVENT(xchk_dirpath_walk_upwards);
 
+TRACE_EVENT(xchk_dirpath_badino,
+	TP_PROTO(struct xfs_scrub *sc, unsigned int path_nr,
+		unsigned int step_nr, const struct xfs_name *name,
+		const struct xfs_parent_rec *pptr),
+	TP_ARGS(sc, path_nr, step_nr, name, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, path_nr)
+		__field(unsigned int, step_nr)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->step_nr = step_nr;
+		__entry->parent_ino = be64_to_cpu(pptr->p_ino);
+		__entry->parent_gen = be32_to_cpu(pptr->p_gen);
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d path %u step %u parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->step_nr,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 DECLARE_EVENT_CLASS(xchk_dirpath_class,
 	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip,
 		 unsigned int path_nr, unsigned int step_nr,


