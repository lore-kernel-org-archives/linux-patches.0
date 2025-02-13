Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05ED2222CA;
	Thu, 13 Feb 2025 14:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457496; cv=none; b=JJtisBBeLQLE/WVvXAXnNE7bxmorpIq0P2c5wt5/G/CjvTFP6TPerW8tksR0z5p9Moq2k5o93wafVDmpnHhz5Kn4OIfOD0mUp+kXni8iiaaihtKT/tERaqLpRUle/gvwFikFrjn2GdJebn2GZAMfLAswM3teHN9JHEsm8BHdkLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457496; c=relaxed/simple;
	bh=QnsHu11J0CjlTZQS2ksfBzf4Ce8EGUsoCSrfEgzDNbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R1wQTttC5d4W/SuVFmF8ljcykTkOOLoMfHySu0dDthBTkzoInJyZpacD3HOqIy7chq6hwRmTlbwy7mbS1LobMZx3g+uEZiYJyNnDYNGj45C+LGGGvbySFxWxdhB4il2iYkeko5x0RbLkWpgaD6VBP3i1NRagq2FHPDZdZhneZr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mQJYqlj7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mQJYqlj7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C4F5C4CED1;
	Thu, 13 Feb 2025 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457495;
	bh=QnsHu11J0CjlTZQS2ksfBzf4Ce8EGUsoCSrfEgzDNbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mQJYqlj74qQeVr6OL3eJUiIVerOx6ft0BAGtkm9UvkFfD+b824U3jL+b+OIHRTxm6
	 9/kKlBfaLa0/DmW+XK/VJoKrUpj9qTmLvOJZlR2BJJKKFfKnW4Ms7eJNAGF71C/zhG
	 BVqlLKeV47z+mR7tu3KUgai5cvGXSHa7Yka06dBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanuel Florac <eflorac@intellique.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/422] xfs: dont over-report free space or inodes in statvfs
Date: Thu, 13 Feb 2025 15:24:04 +0100
Message-ID: <20250213142440.219957732@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 4b8d867ca6e2fc6d152f629fdaf027053b81765a ]

Emmanual Florac reports a strange occurrence when project quota limits
are enabled, free space is lower than the remaining quota, and someone
runs statvfs:

  # mkfs.xfs -f /dev/sda
  # mount /dev/sda /mnt -o prjquota
  # xfs_quota  -x -c 'limit -p bhard=2G 55' /mnt
  # mkdir /mnt/dir
  # xfs_io -c 'chproj 55' -c 'chattr +P' -c 'stat -vvvv' /mnt/dir
  # fallocate -l 19g /mnt/a
  # df /mnt /mnt/dir
  Filesystem      Size  Used Avail Use% Mounted on
  /dev/sda         20G   20G  345M  99% /mnt
  /dev/sda        2.0G     0  2.0G   0% /mnt

I think the bug here is that xfs_fill_statvfs_from_dquot unconditionally
assigns to f_bfree without checking that the filesystem has enough free
space to fill the remaining project quota.  However, this is a
longstanding behavior of xfs so it's unclear what to do here.

Cc: <stable@vger.kernel.org> # v2.6.18
Fixes: 932f2c323196c2 ("[XFS] statvfs component of directory/project quota support, code originally by Glen.")
Reported-by: Emmanuel Florac <eflorac@intellique.com>
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_qm_bhv.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 262f035b15c99..ed1d597c30ca2 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -32,21 +32,28 @@ xfs_fill_statvfs_from_dquot(
 	limit = blkres->softlimit ?
 		blkres->softlimit :
 		blkres->hardlimit;
-	if (limit && statp->f_blocks > limit) {
-		statp->f_blocks = limit;
-		statp->f_bfree = statp->f_bavail =
-			(statp->f_blocks > blkres->reserved) ?
-			 (statp->f_blocks - blkres->reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > blkres->reserved)
+			remaining = limit - blkres->reserved;
+
+		statp->f_blocks = min(statp->f_blocks, limit);
+		statp->f_bfree = min(statp->f_bfree, remaining);
+		statp->f_bavail = min(statp->f_bavail, remaining);
 	}
 
 	limit = dqp->q_ino.softlimit ?
 		dqp->q_ino.softlimit :
 		dqp->q_ino.hardlimit;
-	if (limit && statp->f_files > limit) {
-		statp->f_files = limit;
-		statp->f_ffree =
-			(statp->f_files > dqp->q_ino.reserved) ?
-			 (statp->f_files - dqp->q_ino.reserved) : 0;
+	if (limit) {
+		uint64_t	remaining = 0;
+
+		if (limit > dqp->q_ino.reserved)
+			remaining = limit - dqp->q_ino.reserved;
+
+		statp->f_files = min(statp->f_files, limit);
+		statp->f_ffree = min(statp->f_ffree, remaining);
 	}
 }
 
-- 
2.39.5



