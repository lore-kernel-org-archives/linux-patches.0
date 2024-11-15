Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 436F514EC77;
	Fri, 15 Nov 2024 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653610; cv=none; b=V4XiOu26ioVsf0ngpNA/R8ccn2Ea3PfDHD9S5p6YV6XqqEUfRtCKL+xvT/DYs/If2xosdqDNHfFSPeq2EA6GJOQLIbfYoAKz+a3MPxWfC3vZPjMpaIZgs+0QUASUfsax0E5iLnZYArCh0PRnt5F1WFNQYSpZt+tr+j5GcyELoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653610; c=relaxed/simple;
	bh=Cbqo1j+aweMVFjAF2H5aM5WBBnnN2QrJF4bsYCLR5E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwVlqFMLTkOXSgU/keWIHudA4jmhyku9fYC5eYHnmqlqTMJg/Lx1Wpm2xiy7nP9kw2396/mC1uC0ZqZm/qKEHZz8Y+CWBoETxvuarfr9wqffM4oZCTAjXgTN/MiqqCQqEFI6Y1sYXHuLYUrlC+Gq7NPXhD0MbnSc51nZT9jvjWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AYf4d5Bl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AYf4d5Bl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5800C4CECF;
	Fri, 15 Nov 2024 06:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653610;
	bh=Cbqo1j+aweMVFjAF2H5aM5WBBnnN2QrJF4bsYCLR5E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AYf4d5BlH78r+UcZtJgzWr58LmJSODWFVVRb1GrJP4hxeArR1d0kIqWIr/XIZ0C6r
	 5QbyIIPknFpWmi4SSJbWbcCiCZ7dfmzMv59uqtVwCZWsjZHkmkrHwnYMk6t23w3AnJ
	 5M1Zha0On6wdA5B04iBbIdREWrbZLNpcU+Jjq6oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6c55f725d1bdc8c52058@syzkaller.appspotmail.com,
	Alessandro Zanni <alessandro.zanni87@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/39] fs: Fix uninitialized value issue in from_kuid and from_kgid
Date: Fri, 15 Nov 2024 07:38:34 +0100
Message-ID: <20241115063723.483028742@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.599985562@linuxfoundation.org>
References: <20241115063722.599985562@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ea7c79e8ce429..e96b947c3f5dd 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1129,9 +1129,12 @@ int ocfs2_setattr(struct user_namespace *mnt_userns, struct dentry *dentry,
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



