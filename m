Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06551CF5D;
	Wed, 30 Sep 2026 18:25:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792739; cv=none; b=lUbS68FEdUa0LNjLO0u0kQinJDbWMb9FXK27FqOyqioEjGxFCZEBkjs6YkhjCI9ramu3UJn5AzhQAp9dNaaDgctRQjPfeK06cndFK4G4Pn3hQ7O1mQmUzVzpl5Na24Ffwvc7T3tik0gDjQKsLDsO+yrgsABAcutjrISaB9PffQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792739; c=relaxed/simple;
	bh=9Bw6lsnycB6qA1SEIQgil+alweg5625IC/mBd7tfL7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YujnSW0i9NMZrjYpeR6LpsikePfPwdd9j/m+z9B3Qsp5+iGm7mxC0W9gnqeaH23ISrD4ow2JnWVRjb1qWSKvqX1Pi6/66lICycNlAE9KtlAe/iZw6cEYFB3c4KUCCSto63JGKwbvt2Cog+BTh4ABW5M759sWZazHQ9EzmRivJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FfQOwBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FfQOwBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938C21F000FF;
	Wed, 30 Sep 2026 18:25:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792738;
	bh=KRfth6iqFbG3dMTTjk7Ahfb9EwPoVAgZ42/vp6PuhUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1FfQOwBvRVzDK0TzlPZ9uqntr4gUoub6BX7E9O36WfK8iglqYFuBYAtPjA/lHQOQm
	 /V3wxzldBW8AjuFyShHQnEfmbleRRCZgSS5jbWWlNBYNUBmJ/7X+vowQ+WPf/BS/21
	 RWRCBlstGT/nsc1pGBV7Rn76B/d1o/thW58Ax5pU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 001/395] xfs: dont stash removename operations with unknown ftype
Date: Wed, 30 Sep 2026 17:24:23 +0200
Message-ID: <20260930152340.627781445@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

[ Upstream commit 865b751e75039fc07838b3200f9740256653da9a ]

LOLLM notices that the behavior of xrep_dir_replay_update changes based
on the ftype recorded in the stashed removename information.  It also
notices that the unlink iops sometimes set that ftype to FT_UNKNOWN
because the regular directory tree update code paths don't need to know
the ftype of the child.

Unfortunately, this results in incorrect link counts, which eventually
trips link count errors in later phases of xfs_scrub, or in xfs_repair.
Fix this by creating a second xfs_name with the type set correctly.

Cc: stable@vger.kernel.org # v6.10
Fixes: 8559b21a64d983 ("xfs: implement live updates for directory repairs")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir_repair.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 36432705c44a7..ad3d414d9705d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1381,9 +1381,24 @@ xrep_dir_live_update(
 		if (p->delta > 0)
 			error = xrep_dir_stash_createname(rd, p->name,
 					p->ip->i_ino);
-		else
-			error = xrep_dir_stash_removename(rd, p->name,
+		else {
+			/*
+			 * xfs_dentry_to_name in unlink or rename-exchange can
+			 * pass us names with ftype FT_UNKNOWN, but we really
+			 * must know the ftype of the child that is being
+			 * removed so that we can do nlink updates correctly
+			 * without holding inode references.
+			 */
+			struct xfs_name	name = {
+				.name	= p->name->name,
+				.len	= p->name->len,
+				.type	= xfs_mode_to_ftype(
+						VFS_IC(p->ip)->i_mode),
+			};
+
+			error = xrep_dir_stash_removename(rd, &name,
 					p->ip->i_ino);
+		}
 		mutex_unlock(&rd->pscan.lock);
 		if (error)
 			goto out_abort;
-- 
2.53.0



