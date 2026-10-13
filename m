Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A2A747AF65;
	Tue, 13 Oct 2026 12:31:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894681; cv=none; b=RHPdvSeuFuMc/Uwi5lIU6cogatV7nDsSxu3s6H4uXdIiZr7+7xASY3c41u5YOoovHBoedQ3+FIjI+y2DZj5f2XIgbEUOE6Ff9RWTqEV6SzWWVDzKPL5qU8078cI5mR/19XWYFbvbi1CWa6wW6drn8Lux/bVQH+tias8JFlmcadc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894681; c=relaxed/simple;
	bh=Fk5Q0EksHGh++24rbq7BfUobfNiDKg40Cnr602G4KjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umvNdqYfBXp5NJzaX1l9lpfwlrbTSnX5mbzxRJGxMJfpW7mqzCWtGFCwKT476yem+KjpnAC33Mg/hx/JszQoZyo7Lf4FQXG4bSX20UbNHugknCIhKu38rlFqyCBelFYuOMKSTGeRTwsyQL6MavJdbSm964d9wDIwng2pu3YVKBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1KQhKZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1KQhKZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5591F000FF;
	Tue, 13 Oct 2026 12:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894680;
	bh=+FgvqFS/0ulGdHVvSS0zIf4sRQOb2MyzWVomFI32rH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1KQhKZvG715AxtqjFU8dk/i6XWeDPMwpp9qVLFKJKCvXMaHANzuS26pdEZLzdaWP
	 nW9eICrixN55UV5N4hUoI8iYPkKp+65d7Pgj9q6EmenSjE6YrmzovR+yhXipEfqWQ+
	 jOaKugAFGw7ZuyO4v60lBrVvcvhVXPf3F96N8P2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/497] xfs: fix cursor and pointer handling when recovering iunlink buckets
Date: Tue, 13 Oct 2026 13:33:07 +0200
Message-ID: <20261013112908.360317342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 65f39d09d73718611cee40399179323b5d4ead00 ]

LOLLM pointed out a bug in xlog_recover_iunlink_bucket:

1. We don't null out prev_ip after releasing it, which can lead to UAF
   problems if the inodegc flush call in the loop fails.

at which point I noticed even more bugs:

2. If the inodegc flush inside the loop fails, we also leak @ip.

3. We set prev_agino to agino having already advanced agino, which
   results in inodes with i_prev_unlinked set to itself.

4. If we exit the bottom of the loop with prev_ip set, then prev_ip
   aliases ip and we also set its i_prev_unlinked to itself.

Bugs 3 and 4 introduce loops into the unlinked list, though these loops
don't surface because we immediately flush each unlinked inode after
loading it.

Fix all of these issues.

Cc: stable@vger.kernel.org # v6.0
Fixes: 04755d2e5821b3 ("xfs: refactor xlog_recover_process_iunlinks()")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ Replaced unavailable xfs_agino_to_ino() with the existing XFS_AGINO_TO_INO() macro. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/xfs_log_recover.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 4884bbf5df80e..05bef0b44693c 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2730,12 +2730,13 @@ xlog_recover_iunlink_bucket(
 {
 	struct xfs_mount	*mp = pag->pag_mount;
 	struct xfs_inode	*prev_ip = NULL;
-	struct xfs_inode	*ip;
 	xfs_agino_t		prev_agino, agino;
 	int			error = 0;
 
 	agino = be32_to_cpu(agi->agi_unlinked[bucket]);
 	while (agino != NULLAGINO) {
+		struct xfs_inode	*ip;
+
 		error = xfs_iget(mp, NULL,
 				XFS_AGINO_TO_INO(mp, pag->pag_agno, agino),
 				0, 0, &ip);
@@ -2745,11 +2746,11 @@ xlog_recover_iunlink_bucket(
 		ASSERT(VFS_I(ip)->i_nlink == 0);
 		ASSERT(VFS_I(ip)->i_mode != 0);
 		xfs_iflags_clear(ip, XFS_IRECOVERY);
-		agino = ip->i_next_unlinked;
 
 		if (prev_ip) {
 			ip->i_prev_unlinked = prev_agino;
 			xfs_irele(prev_ip);
+			prev_ip = NULL;
 
 			/*
 			 * Ensure the inode is removed from the unlinked list
@@ -2761,18 +2762,20 @@ xlog_recover_iunlink_bucket(
 			 * complete.
 			 */
 			error = xfs_inodegc_flush(mp);
-			if (error)
-				break;
+			if (error) {
+				xfs_irele(ip);
+				return error;
+			}
 		}
 
 		prev_agino = agino;
+		agino = ip->i_next_unlinked;
 		prev_ip = ip;
 	}
 
 	if (prev_ip) {
 		int	error2;
 
-		ip->i_prev_unlinked = prev_agino;
 		xfs_irele(prev_ip);
 
 		error2 = xfs_inodegc_flush(mp);
-- 
2.53.0



