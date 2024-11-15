Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB40185924;
	Fri, 15 Nov 2024 06:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652907; cv=none; b=oRgy474Wp3aTVVZYfu4gORRT6kkL3TXTcGWed7OkqhxeMhAqQqn6YP+gMFrYHelPKh5tP7raV+O6wkMfQR4ZEVMkxLaaGjFcZ9nSyt28xcsnzzOdB3Ydq8QUQg/NwwzzdAEz/QIPTTbBF6cR8h80Ko2gUbTJ9MzUAmIt6/hSW44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652907; c=relaxed/simple;
	bh=90Y2JB4c/oa4etDGt/0OAjmGS5vTlrZvj0A2UL7RhsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqlr8bFcIRv+DSl6bzJS/CnMJKy07SURCRl0su7AfKDc/KvKSi3AISGJ8a6oEpPW94PFaMNgorb4cTilyFRnIGMJLOJLnaGs6grgbU/Q6+Yyv/zgdGTUNXxtZ2Kcmge2d5D7YveBDYhxHNGA17ear60JWFbvLbA4gB9faY+Q3U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2CZR4Pt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2CZR4Pt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C522DC4CECF;
	Fri, 15 Nov 2024 06:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652907;
	bh=90Y2JB4c/oa4etDGt/0OAjmGS5vTlrZvj0A2UL7RhsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u2CZR4PtmyzSjMUoVuPLXq7zrF3tRpxlFtgxCiA1epKD6oRkHiCGAkgO5emwe+/aC
	 5uzifBZ/5UjrnuhcK7AoDEfHOhFB+jY5Ncanlu7HfsrPPrrIQ8bGesrLTI76BUCZVy
	 mFsnC3an5U/mHlj+JflCZRsjPy5VYANdhR4N7HEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/52] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Fri, 15 Nov 2024 07:38:03 +0100
Message-ID: <20241115063724.658777678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessandro Zanni <alessandro.zanni87@gmail.com>

[ Upstream commit 15f34347481648a567db67fb473c23befb796af5 ]

ocfs2_setattr() uses attr->ia_mode, attr->ia_uid and attr->ia_gid in
a trace point even though ATTR_MODE, ATTR_UID and ATTR_GID aren't set.

Initialize all fields of newattrs to avoid uninitialized variables, by
checking if ATTR_MODE, ATTR_UID, ATTR_GID are initialized, otherwise 0.

Reported-by: syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6c55f725d1bdc8c52058
Signed-off-by: Alessandro Zanni <alessandro.zanni87@gmail.com>
Link: https://lore.kernel.org/r/20241017120553.55331-1-alessandro.zanni87@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/file.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 3c71c05a0581b..9062002fd56c6 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1143,9 +1143,12 @@ int ocfs2_setattr(struct dentry *dentry, struct iattr *attr)
 	trace_ocfs2_setattr(inode, dentry,
 			    (unsigned long long)OCFS2_I(inode)->ip_blkno,
 			    dentry->d_name.len, dentry->d_name.name,
-			    attr->ia_valid, attr->ia_mode,
-			    from_kuid(&init_user_ns, attr->ia_uid),
-			    from_kgid(&init_user_ns, attr->ia_gid));
+			    attr->ia_valid,
+				attr->ia_valid & ATTR_MODE ? attr->ia_mode : 0,
+				attr->ia_valid & ATTR_UID ?
+					from_kuid(&init_user_ns, attr->ia_uid) : 0,
+				attr->ia_valid & ATTR_GID ?
+					from_kgid(&init_user_ns, attr->ia_gid) : 0);
 
 	/* ensuring we don't even attempt to truncate a symlink */
 	if (S_ISLNK(inode->i_mode))
-- 
2.43.0



