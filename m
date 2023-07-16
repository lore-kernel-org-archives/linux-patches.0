Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A91568F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23D48C433C9;
	Sun, 16 Jul 2023 20:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541027;
	bh=j5bjUonKG+UZK6a4Vy8kNrdlInYzsWEqRxjpfcg16c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bvQkBI1votEnYSoclgtsUkzX61WldYrapDfJLKL7waEc2/o/8xJwXRWggw3mshui8
	 lVR4B93v+lhWA2udVvdN2NxpXQmc0WTEY4pN7SkLk2mvrAhePpVfFag4CjSZ0ojw/B
	 aPjKxr3BJR4BwDhiP5G8rngAB92UmZJts+5M6QxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 573/591] xfs: check that per-cpu inodegc workers actually run on that cpu
Date: Sun, 16 Jul 2023 21:51:52 +0200
Message-ID: <20230716194938.682895999@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

commit b37c4c8339cd394ea6b8b415026603320a185651 upstream.

Now that we've allegedly worked out the problem of the per-cpu inodegc
workers being scheduled on the wrong cpu, let's put in a debugging knob
to let us know if a worker ever gets mis-scheduled again.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_icache.c |    2 ++
 fs/xfs/xfs_mount.h  |    3 +++
 fs/xfs/xfs_super.c  |    3 +++
 3 files changed, 8 insertions(+)

--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1848,6 +1848,8 @@ xfs_inodegc_worker(
 	struct llist_node	*node = llist_del_all(&gc->list);
 	struct xfs_inode	*ip, *n;
 
+	ASSERT(gc->cpu == smp_processor_id());
+
 	WRITE_ONCE(gc->items, 0);
 
 	if (!node)
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
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1084,6 +1084,9 @@ xfs_inodegc_init_percpu(
 
 	for_each_possible_cpu(cpu) {
 		gc = per_cpu_ptr(mp->m_inodegc, cpu);
+#if defined(DEBUG) || defined(XFS_WARN)
+		gc->cpu = cpu;
+#endif
 		init_llist_head(&gc->list);
 		gc->items = 0;
 		INIT_DELAYED_WORK(&gc->work, xfs_inodegc_worker);


