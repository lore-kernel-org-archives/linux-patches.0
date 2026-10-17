Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BECD3A7F41;
	Sat, 17 Oct 2026 16:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255796; cv=none; b=n3u+qfmfKMVDvw8bGi7mSS5m0ZbNPb7U2B3kgXjY6LoTRHkf2tCdG03SAyGxGvoUoMj3QNi4ZeWWdv/5/KHQTv9/OpKWEO1qtL3vTz2pjscpfRK+4i9EjvuMIMgAT/lfC5XPdNzC5jKxj2ARD2Le8dHTm5PiGpMygjrOyUV5Yps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255796; c=relaxed/simple;
	bh=0KyEU607t9q6qqq27pYPS4BnXCPtKo4ewOS3ozDLFl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFts7esM7uRZirGftaAgAydJxy4Np+NJeq22VehbfiELP3qRAseUb5wS5pzgBXivUF2LCXc7ie31K9N5pQcWPDrHax+zPxrVNvig8gkx+ngMyiucZHNdcggUMuQN6l18jQfJkgtxKH96f/DQUJLuE91bXIyfr6+38WFgnylDSGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLGohTgD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLGohTgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5881F000C4;
	Sat, 17 Oct 2026 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255795;
	bh=/eY1SSO/tH7FudQ8TBRUaelzKY+rI/X0xdt7MDcY/CE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JLGohTgDY8iG6W540gIIYMcc6sVGVmfLwyV9xk15NVit1WAyIQnSDj4BAsbihLENL
	 2GF7E0nR3gWsgg6A4DC9U4ExYEp9mxrw9VGPUgX6a9jVb7Jq0wW6mPI/4fjpnpbgRp
	 feHRYi2UsTz3UaR+nRGACD3UfwezdqdNBHcon6m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0004/1674] ocfs2: Avoid touching renamed directory if parent does not change
Date: Sat, 17 Oct 2026 17:37:56 +0200
Message-ID: <20261017160431.255052932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

The VFS will not be locking moved directory if its parent does not
change. Change ocfs2 rename code to avoid touching renamed directory if
its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 111e60ac19b94..886b0ddd883f0 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1342,7 +1342,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (S_ISDIR(old_inode->i_mode) && new_dir != old_dir) {
 		u64 old_inode_parent;
 
 		update_dot_dot = 1;
@@ -1359,8 +1359,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 			goto bail;
 		}
 
-		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
+		if (!new_inode && new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1603,6 +1602,9 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (update_dot_dot) {
 		status = ocfs2_update_entry(old_inode, handle,
 					    &old_inode_dot_dot_res, new_dir);
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
2.53.0



