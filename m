Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24D41D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:04:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251B6C433C9;
	Wed,  4 Oct 2023 18:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442690;
	bh=q5g+vTBGdfMnK26+hfVfH82OygBidX05kdnBFeEZA6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xvHC0+kHEmryZAh6Uy0JkFmmO5cf8d1/oPPsZZ/Q3pxxyuzoU6FVbmKKnfWQhUywF
	 EDfc8DvFcH7rX4bwg36qhniMgNd+BfiNMgRsEVEIgY3YXDHDTq+gII0Aok62X+tJV+
	 /ULXA96KMv2hwyRGUkZDD3/8Q9wxZ9g6vBucNESc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Leah Rumancik <leah.rumancik@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/183] xfs: check that per-cpu inodegc workers actually run on that cpu
Date: Wed,  4 Oct 2023 19:55:06 +0200
Message-ID: <20231004175207.012057471@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit b37c4c8339cd394ea6b8b415026603320a185651 ]

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Leah Rumancik <leah.rumancik@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_icache.c | 2 ++
 fs/xfs/xfs_mount.h  | 3 +++
 fs/xfs/xfs_super.c  | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ab8181f8d08a9..02022164772de 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1856,6 +1856,8 @@ xfs_inodegc_worker(
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3d58938a6f75b..29f35169bf9cf 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -66,6 +66,9 @@ struct xfs_inodegc {
 	/* approximate count of inodes in the list */
 	unsigned int		items;
 	unsigned int		shrinker_hits;
+#if defined(DEBUG) || defined(XFS_WARN)
+	unsigned int		cpu;
+#endif
 };
 
 /*
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 9b3af7611eaa9..569960e4ea3a6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1062,6 +1062,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);
-- 
2.40.1



