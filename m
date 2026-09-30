Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FA051597D;
	Wed, 30 Sep 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788910; cv=none; b=g05dlQO9tQ+vgwtwr7ekQRTaoJcA3kbMMsOzGuJFifOLn2Y+f9+I6O1z05f1bjPDLNJ40ucl01OpET0rlzuwZ0kPkWuPUGgg/5weWMgETXSdOe19KI5jJ1+nRP1TpBYNYrOK8k3D6OLppkSqPg6AtrhyZ/yed39eyK1jxpLspL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788910; c=relaxed/simple;
	bh=rfA6W5K/fLej9+ae2Z2wzeM2FR7FG7oYJHzmzlF1+hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z1WgQ9biseZlct/FaL03e+qyY94qtCmXsbDGENqNXAYEf92kAPx3A/W0kigbK52HqnsXfWgBhqlt4IcEv15vk9XrvERq3dK6ZaKVETKk6iuzITeaos2tiCYcJ7G4KQK8wJItwVi5o9u+novPoWcvGeH3Gejjrz1NjBZmzJHfRNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eNfHW7WT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eNfHW7WT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C1B31F000FF;
	Wed, 30 Sep 2026 17:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788909;
	bh=n3xDlLEmQS5fU3i+MS8SDBjQaA/MK8OKPL/Xza2Gr8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eNfHW7WTKv6WXaF1O+KE1if2H9GUdpYpojESplWX+NQw8PAR5i4EpU2exljKTTQ/O
	 zp1frHOzL5V4Xk1Ok7Z6Aww4HlvswUSr3AycZTCRCHIrjYWsBAB+AAXUSphMQXB+yp
	 WsaNNjBGQQZ+VGKM8/zNc3BCNb8YSn3gAqJJwY3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 290/877] xfs: dont stash removename operations with unknown ftype
Date: Wed, 30 Sep 2026 17:20:01 +0200
Message-ID: <20260930152420.968330833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index 53272c2540200..bea08dcae5b3d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -1379,9 +1379,24 @@ xrep_dir_live_update(
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



