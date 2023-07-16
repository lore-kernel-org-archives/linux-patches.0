Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1738F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E88E4C433C8;
	Sun, 16 Jul 2023 20:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689541030;
	bh=D0VDPiQbXztK6K5pvmVM1cm5DXmAd6VL7bLtKmKaEwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vC7rG/p2S1Ipdd3PvRbS6V01XDbymUD46b14nLX1T7Sl6fCno6xswxUVYe3AZ0dGb
	 GjsFoSHJFsGEPATGGwDqyAD2KF4wXv669wqpgYnDsqg5b8kovgL0nUrbRq7HYeVOws
	 7wsWNZeYkvJLjz3YU2T2Qp3VrCSH9gzUEEw17HQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Dave Chinner <david@fromorbit.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6.1 574/591] xfs: disable reaping in fscounters scrub
Date: Sun, 16 Jul 2023 21:51:53 +0200
Message-ID: <20230716194938.710681447@linuxfoundation.org>
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

commit 2d5f38a31980d7090f5bf91021488dc61a0ba8ee upstream.

The fscounters scrub code doesn't work properly because it cannot
quiesce updates to the percpu counters in the filesystem, hence it
returns false corruption reports.  This has been fixed properly in
one of the online repair patchsets that are under review by replacing
the xchk_disable_reaping calls with an exclusive filesystem freeze.
Disabling background gc isn't sufficient to fix the problem.

In other words, scrub doesn't need to call xfs_inodegc_stop, which is
just as well since it wasn't correct to allow scrub to call
xfs_inodegc_start when something else could be calling xfs_inodegc_stop
(e.g. trying to freeze the filesystem).

Neuter the scrubber for now, and remove the xchk_*_reaping functions.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.c     |   26 --------------------------
 fs/xfs/scrub/common.h     |    2 --
 fs/xfs/scrub/fscounters.c |   13 ++++++-------
 fs/xfs/scrub/scrub.c      |    2 --
 fs/xfs/scrub/scrub.h      |    1 -
 5 files changed, 6 insertions(+), 38 deletions(-)

--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -865,29 +865,3 @@ xchk_ilock_inverted(
 	}
 	return -EDEADLOCK;
 }
-
-/* Pause background reaping of resources. */
-void
-xchk_stop_reaping(
-	struct xfs_scrub	*sc)
-{
-	sc->flags |= XCHK_REAPING_DISABLED;
-	xfs_blockgc_stop(sc->mp);
-	xfs_inodegc_stop(sc->mp);
-}
-
-/* Restart background reaping of resources. */
-void
-xchk_start_reaping(
-	struct xfs_scrub	*sc)
-{
-	/*
-	 * Readonly filesystems do not perform inactivation or speculative
-	 * preallocation, so there's no need to restart the workers.
-	 */
-	if (!xfs_is_readonly(sc->mp)) {
-		xfs_inodegc_start(sc->mp);
-		xfs_blockgc_start(sc->mp);
-	}
-	sc->flags &= ~XCHK_REAPING_DISABLED;
-}
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -148,7 +148,5 @@ static inline bool xchk_skip_xref(struct
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 int xchk_ilock_inverted(struct xfs_inode *ip, uint lock_mode);
-void xchk_stop_reaping(struct xfs_scrub *sc);
-void xchk_start_reaping(struct xfs_scrub *sc);
 
 #endif	/* __XFS_SCRUB_COMMON_H__ */
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -128,13 +128,6 @@ xchk_setup_fscounters(
 	if (error)
 		return error;
 
-	/*
-	 * Pause background reclaim while we're scrubbing to reduce the
-	 * likelihood of background perturbations to the counters throwing off
-	 * our calculations.
-	 */
-	xchk_stop_reaping(sc);
-
 	return xchk_trans_alloc(sc, 0);
 }
 
@@ -354,6 +347,12 @@ xchk_fscounters(
 		xchk_set_corrupt(sc);
 
 	/*
+	 * XXX: We can't quiesce percpu counter updates, so exit early.
+	 * This can be re-enabled when we gain exclusive freeze functionality.
+	 */
+	return 0;
+
+	/*
 	 * If ifree exceeds icount by more than the minimum variance then
 	 * something's probably wrong with the counters.
 	 */
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -171,8 +171,6 @@ xchk_teardown(
 	}
 	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR)
 		mnt_drop_write_file(sc->file);
-	if (sc->flags & XCHK_REAPING_DISABLED)
-		xchk_start_reaping(sc);
 	if (sc->buf) {
 		kmem_free(sc->buf);
 		sc->buf = NULL;
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -88,7 +88,6 @@ struct xfs_scrub {
 
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
-#define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 /* Metadata scrubbers */


