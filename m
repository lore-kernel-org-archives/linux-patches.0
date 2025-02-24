Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41196146A6F;
	Mon, 24 Feb 2025 14:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740409140; cv=none; b=X5VmpHp8DPGP/2BipMkr6Lc4ptr6NskFJK/xCBwANJdWdKgV2rqHQTAWm0pw06Q+rpsW/tJtgOD21Ac1AQ8HCzsXOQR8VC7QloC3nPfCS5V+SObAokUXZmwsUEiVUkw5jDAVFVhEY/OXAzHMmJk3+FozX5y+p0smXKfYQORHEf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740409140; c=relaxed/simple;
	bh=/Zq219Ba3+kgOixP2r2dzzv+f4kPDg24CKAukOF3Q8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oFM/m40ebgKuOjKmhisoO4UKZxEvDS8+Igx7o1mupIoaZXgUzuxUceEW15UOcE3l/iGVvDQ3FDtKaquEwwbW7r1HWJ2jMLdneAZAOvP1ESsXe0VKo/6e683p0YJVM+V55Cjy2MGV6iyYYWUFJQRIGr1M73ip3GYMmC48cS82RWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yj3KA+p+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yj3KA+p+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACBAC4CED6;
	Mon, 24 Feb 2025 14:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740409140;
	bh=/Zq219Ba3+kgOixP2r2dzzv+f4kPDg24CKAukOF3Q8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yj3KA+p+3lkh9CZ2b+RF2CZC1ndkSKz+klZu75YZvIHZZcBvoQGX4snRzcF/y/4dn
	 yolMWh0/0xVr8uiFW2V7mME+J285b/O79QPTtEnX5K86d0yyJhSgI45ZUKuOGDFtTH
	 wAs0xsOjEYxu9PcvDbNBDwKNQ4HBrqFYEyj5MieY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Flynn <david.flynn@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.13 109/138] xfs: fix online repair probing when CONFIG_XFS_ONLINE_REPAIR=n
Date: Mon, 24 Feb 2025 15:35:39 +0100
Message-ID: <20250224142608.764026945@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit 66314e9a57a050f95cb0ebac904f5ab047a8926e upstream.

I received a report from the release engineering side of the house that
xfs_scrub without the -n flag (aka fix it mode) would try to fix a
broken filesystem even on a kernel that doesn't have online repair built
into it:

 # xfs_scrub -dTvn /mnt/test
 EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
 Phase 1: Find filesystem geometry.
 /mnt/test: using 1 threads to scrub.
 Phase 1: Memory used: 132k/0k (108k/25k), time:  0.00/ 0.00/ 0.00s
 <snip>
 Phase 4: Repair filesystem.
 <snip>
 Info: /mnt/test/some/victimdir directory entries: Attempting repair. (repair.c line 351)
 Corruption: /mnt/test/some/victimdir directory entries: Repair unsuccessful; offline repair required. (repair.c line 204)

Source: https://blogs.oracle.com/linux/post/xfs-online-filesystem-repair

It is strange that xfs_scrub doesn't refuse to run, because the kernel
is supposed to return EOPNOTSUPP if we actually needed to run a repair,
and xfs_io's repair subcommand will perror that.  And yet:

 # xfs_io -x -c 'repair probe' /mnt/test
 #

The first problem is commit dcb660f9222fd9 (4.15) which should have had
xchk_probe set the CORRUPT OFLAG so that any of the repair machinery
will get called at all.

It turns out that some refactoring that happened in the 6.6-6.8 era
broke the operation of this corner case.  What we *really* want to
happen is that all the predicates that would steer xfs_scrub_metadata()
towards calling xrep_attempt() should function the same way that they do
when repair is compiled in; and then xrep_attempt gets to return the
fatal EOPNOTSUPP error code that causes the probe to fail.

Instead, commit 8336a64eb75cba (6.6) started the failwhale swimming by
hoisting OFLAG checking logic into a helper whose non-repair stub always
returns false, causing scrub to return "repair not needed" when in fact
the repair is not supported.  Prior to that commit, the oflag checking
that was open-coded in scrub.c worked correctly.

Similarly, in commit 4bdfd7d15747b1 (6.8) we hoisted the IFLAG_REPAIR
and ALREADY_FIXED logic into a helper whose non-repair stub always
returns false, so we never enter the if test body that would have called
xrep_attempt, let alone fail to decode the OFLAGs correctly.

The final insult (yes, we're doing The Naked Gun now) is commit
48a72f60861f79 (6.8) in which we hoisted the "are we going to try a
repair?" predicate into yet another function with a non-repair stub
always returns false.

Fix xchk_probe to trigger xrep_probe if repair is enabled, or return
EOPNOTSUPP directly if it is not.  For all the other scrub types, we
need to fix the header predicates so that the ->repair functions (which
are all xrep_notsupported) get called to return EOPNOTSUPP.  Commit
48a72 is tagged here because the scrub code prior to LTS 6.12 are
incomplete and not worth patching.

Reported-by: David Flynn <david.flynn@oracle.com>
Cc: <stable@vger.kernel.org> # v6.8
Fixes: 8336a64eb75c ("xfs: don't complain about unfixed metadata when repairs were injected")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/common.h |    5 -----
 fs/xfs/scrub/repair.h |   11 ++++++++++-
 fs/xfs/scrub/scrub.c  |   12 ++++++++++++
 3 files changed, 22 insertions(+), 6 deletions(-)

--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -212,7 +212,6 @@ static inline bool xchk_skip_xref(struct
 bool xchk_dir_looks_zapped(struct xfs_inode *dp);
 bool xchk_pptr_looks_zapped(struct xfs_inode *ip);
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 /* Decide if a repair is required. */
 static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
 {
@@ -232,10 +231,6 @@ static inline bool xchk_could_repair(con
 	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
 		!(sc->flags & XREP_ALREADY_FIXED);
 }
-#else
-# define xchk_needs_repair(sc)		(false)
-# define xchk_could_repair(sc)		(false)
-#endif /* CONFIG_XFS_ONLINE_REPAIR */
 
 int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -173,7 +173,16 @@ bool xrep_buf_verify_struct(struct xfs_b
 #else
 
 #define xrep_ino_dqattach(sc)	(0)
-#define xrep_will_attempt(sc)	(false)
+
+/*
+ * When online repair is not built into the kernel, we still want to attempt
+ * the repair so that the stub xrep_attempt below will return EOPNOTSUPP.
+ */
+static inline bool xrep_will_attempt(const struct xfs_scrub *sc)
+{
+	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_FORCE_REBUILD) ||
+		xchk_needs_repair(sc->sm);
+}
 
 static inline int
 xrep_attempt(
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -149,6 +149,18 @@ xchk_probe(
 	if (xchk_should_terminate(sc, &error))
 		return error;
 
+	/*
+	 * If the caller is probing to see if repair works but repair isn't
+	 * built into the kernel, return EOPNOTSUPP because that's the signal
+	 * that userspace expects.  If online repair is built in, set the
+	 * CORRUPT flag (without any of the usual tracing/logging) to force us
+	 * into xrep_probe.
+	 */
+	if (xchk_could_repair(sc)) {
+		if (!IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR))
+			return -EOPNOTSUPP;
+		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
+	}
 	return 0;
 }
 


