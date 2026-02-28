Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2620D47CC8F;
	Sat, 28 Feb 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301395; cv=none; b=rIOaAU/HV26/yWyfHS2ZjqmPDTKSHu2+8RfLL/2GMM1TBHQI0cwB2OQ/WKYHNwheWBzyf43OAMvrj0Q5+C6PpIbsADZf3ntCkHWqOgkdyoOzAAeRIlLeoATqpIm31HgWGrDql/a+xCV7pSGVq3S2oOMMhhoDCsxR9n/va5zW8Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301395; c=relaxed/simple;
	bh=N7CdfqBKedIpGbc05wZJXcW3C4kxgnQn9K71vRcipjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SuGdpvDuXFzjsL5n9FLaZ7XO/zrgURv4ry2puYPiU+Qz8Yg4EuAGSVRbKyo0TJGVsItKLBVt+Rnn94bfGes6cMTz5vuiy2Ih3jJA5CccKp2W91PZdXqYebedJh0+f7ua6zY1Oy6CPnUGj/jKF83rLP1Th6Or9uZ+X/IWPWpOCHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OMcJK+cl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OMcJK+cl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5648AC19424;
	Sat, 28 Feb 2026 17:56:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301395;
	bh=N7CdfqBKedIpGbc05wZJXcW3C4kxgnQn9K71vRcipjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMcJK+cljA1tCDU2heZFPjZzx0/o48WHSWPzZv1aE0zuaUwaxNONwIZbG1PdEkQcZ
	 cIBxvmC+9k0upugtBC4uEfjOAMDCsJVXjKLRyZyl9UDcCqqW0a74bAMTicGwQhFkfY
	 oMGIrnOpgai07uw9HWh3yKR6L9vVSPZNBkWaY8jju6gJvHV5V4iFubt+uD9NLF0Gbf
	 BEygkJoaA8lFzPzkwma0twXMGJ08iqqHUkLD7q0ETVxLV738D6AEh8ohs46yewv2wu
	 5K4CRVrWCdUyhx6rLe79NFKPyw1RagBIItht5X8jPqbuovMb3WGA+LijNm6L95ka83
	 mg9nVDqq2FDwA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	stable@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 583/752] xfs: mark data structures corrupt on EIO and ENODATA
Date: Sat, 28 Feb 2026 12:44:54 -0500
Message-ID: <20260228174750.1542406-583-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

[ Upstream commit f39854a3fb2f06dc69b81ada002b641ba5b4696b ]

I learned a few things this year: first, blk_status_to_errno can return
ENODATA for critical media errors; and second, the scrub code doesn't
mark data structures as corrupt on ENODATA or EIO.

Currently, scrub failing to capture these errors isn't all that
impactful -- the checking code will exit to userspace with EIO/ENODATA,
and xfs_scrub will log a complaint and exit with nonzero status.  Most
people treat fsck tools failing as a sign that the fs is corrupt, but
online fsck should mark the metadata bad and keep moving.

Cc: stable@vger.kernel.org # v4.15
Fixes: 4700d22980d459 ("xfs: create helpers to record and deal with scrub problems")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/btree.c   | 2 ++
 fs/xfs/scrub/common.c  | 4 ++++
 fs/xfs/scrub/dabtree.c | 2 ++
 3 files changed, 8 insertions(+)

diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index acade92c5fce1..b497f6a474c77 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -42,6 +42,8 @@ __xchk_btree_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2ef7742be7d3d..e6145c2eda02a 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -103,6 +103,8 @@ __xchk_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
@@ -177,6 +179,8 @@ __xchk_fblock_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= errflag;
 		*error = 0;
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 056de4819f866..a6a5d3a75d994 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -45,6 +45,8 @@ xchk_da_process_error(
 		break;
 	case -EFSBADCRC:
 	case -EFSCORRUPTED:
+	case -EIO:
+	case -ENODATA:
 		/* Note the badness but don't abort. */
 		sc->sm->sm_flags |= XFS_SCRUB_OFLAG_CORRUPT;
 		*error = 0;
-- 
2.51.0

