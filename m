Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A80581C6B5;
	Sat,  3 Feb 2024 04:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933840; cv=none; b=JBGLD3OX5GBvY25B0hlIoHKqRHnAQOJNtE7+CD3wi0aZ03y7mGo1tLl8JOfb0v7htGic+eO3F5TPFUh4SuCVPdFddaKz/iJjv99imwU10RalbAAoJRSk2eSFP3Wr8sh57+m6wTF6cw9Nb77KuT2h9TUBFGk0fa+UPRd9AMX6pCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933840; c=relaxed/simple;
	bh=KQnQRLlux5glK8XFGesd33Bv/lrZ8kiO37wH/+64gsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBS0frbi1IylDy5hNe81/JVDKhapoqmBRkjK8BOdUlUIZACGvdp6LQKsnKJJGDddwghdIzIb9s+pol7irby1U+CIujw+HsmoctZxWvz6+zqnNPGZotCLRajYEMNpKfBIb9szEwTFEDXiE+Ny0H820EzuX7X2TDH0a2/ruGEog9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLQ32r+L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLQ32r+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F340C43390;
	Sat,  3 Feb 2024 04:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933840;
	bh=KQnQRLlux5glK8XFGesd33Bv/lrZ8kiO37wH/+64gsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oLQ32r+LzCQ3nKNGSMYOcTurepbsipIYSu1VrF80seja39KkVFUJIQ/eiS+J4IA/m
	 pG50CpXvZ/x+u0chLBoAroBSTN1swN8kamk32Tmtksf09HABg445pJoAkq1wKkGTaj
	 lNH+QgVWXI35OLPVSzAfcWZGoRx7izLpzn3lo1Bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 166/353] ocfs2: Avoid touching renamed directory if parent does not change
Date: Fri,  2 Feb 2024 20:04:44 -0800
Message-ID: <20240203035408.892817585@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 9d618d19b29c2943527e3a43da0a35aea91062fc ]

The VFS will not be locking moved directory if its parent does not
change. Change ocfs2 rename code to avoid touching renamed directory if
its parent does not change as without locking that can corrupt the
filesystem.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/namei.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 814733ba2f4b..9221a33f917b 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1336,7 +1336,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 		goto bail;
 	}
 
-	if (S_ISDIR(old_inode->i_mode)) {
+	if (S_ISDIR(old_inode->i_mode) && new_dir != old_dir) {
 		u64 old_inode_parent;
 
 		update_dot_dot = 1;
@@ -1353,8 +1353,7 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 			goto bail;
 		}
 
-		if (!new_inode && new_dir != old_dir &&
-		    new_dir->i_nlink >= ocfs2_link_max(osb)) {
+		if (!new_inode && new_dir->i_nlink >= ocfs2_link_max(osb)) {
 			status = -EMLINK;
 			goto bail;
 		}
@@ -1601,6 +1600,9 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 			mlog_errno(status);
 			goto bail;
 		}
+	}
+
+	if (S_ISDIR(old_inode->i_mode)) {
 		drop_nlink(old_dir);
 		if (new_inode) {
 			drop_nlink(new_inode);
-- 
2.43.0



