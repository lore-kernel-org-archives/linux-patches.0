Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED43189919;
	Fri, 15 Nov 2024 06:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653988; cv=none; b=J6zaJpAKP9hISIwqsA2DRphR4hWbu3IScHN6Ibxj/URzdXp2rrK6n0ra2p8QvyZNGrlx/4bVrxfab6FbPSTBkhQYhsyy5yE6BsA1TWhO6impILZes8HYMy60rFVtwOzl+f6RmAJe6LDHgwmFsV7s9bzF1RJrP8lPQT2p3XfJcgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653988; c=relaxed/simple;
	bh=WZL6X/kSQeW3oeSL8uwtKWaN5Ae3hW1ldMC6J7qQJYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEwx8r/fsIoZDSuV/LOf1Y3Hp82B+jN9PNIpwZ0pL4WEtUrZliqOP/STOBE+m/klAvOt/zfwLzJcldXjPr09Z1nvHuXYW3KjVJSx7U2HjLBRPlirXcNTrY1J20tHrOKnuysjp0UaE6x29tW4JFOnuuBUYWNxTPlBkwhqyJoXXZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pg+fjQBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pg+fjQBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60D6C4CECF;
	Fri, 15 Nov 2024 06:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653988;
	bh=WZL6X/kSQeW3oeSL8uwtKWaN5Ae3hW1ldMC6J7qQJYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pg+fjQBrEcfaiq5IG/XZWn3BNOGbD2XGNVfW6IDdSno7GyIiX05m7VOHwL/abzSk7
	 8w4i33Mdif2VDTMFIWr/EZmpw7z5HH9Ek6SunPfR9TFFr9kpqKAyD69UF6Z78elvFb
	 YRZMXd3Y42yyxIQEKv5UT6rRnkR7kh7dh/fijB+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 12/22] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Fri, 15 Nov 2024 07:38:58 +0100
Message-ID: <20241115063721.618410377@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063721.172791419@linuxfoundation.org>
References: <20241115063721.172791419@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fc1e929ae0381..3c9316bf8a695 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1132,9 +1132,12 @@ int ocfs2_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
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



