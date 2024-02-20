Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6EC1509B1;
	Tue, 20 Feb 2024 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464216; cv=none; b=LJRICNABv0GI31eyURlf2VYZHZnSwha8J7kLDbkIMwFu9y+uGaFRGjIbTTpm/NFfPM6JsfhsTBMqA0/K+Dn+NQ2NEq988j0IqijGaN0VKCul8aKoJ7WbG00841kElMVy9DK3NRxF/rqJnbwP4cSeA3ZBoUZKA/5+fVHLG78rWuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464216; c=relaxed/simple;
	bh=UdBi5FxSN8KUu0Y1OQCd5subKsGSHPsXvjKbagLWbXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNHCndOLn76TJ/Co961wrsJNx++dLhdu7ixPPwW7wOxZChytEvxZkkmoXSRU+ZzrrSyFNqWcint30C3xKc2bTgJX8mqlI35og48jZnXJWqY9DzUUJ3rz4Ij+7RSnncMcQXekHs9/VQqgOEld9dsv3TCZ2P/GWKfEra65wEFX8TY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2KnXi16j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2KnXi16j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D617EC433C7;
	Tue, 20 Feb 2024 21:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464216;
	bh=UdBi5FxSN8KUu0Y1OQCd5subKsGSHPsXvjKbagLWbXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2KnXi16jqv9AFTzAbkQ6pLXS6AV8nTmeu13qikPA6EsT3uqZloPkzybmK9H7tTcJz
	 QrSN0GogxncjWPqEcTahcHQIJsMBGG83DmsW1Jx9DvSGXfYhLbOAznTfChU9vSpwDa
	 xAXxPOPvS/jxjwTvWzVTsb9GBW24b7hJ0qbNJoqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Hongyu Jin <hongyu.jin@unisoc.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Dongliang Cui <cuidongliang390@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.6 288/331] eventfs: Have event files and directories default to parent uid and gid
Date: Tue, 20 Feb 2024 21:56:44 +0100
Message-ID: <20240220205647.036705182@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

commit 0dfc852b6fe3cbecbea67332a0dce2bebeba540d upstream.

Dongliang reported:

  I found that in the latest version, the nodes of tracefs have been
  changed to dynamically created.

  This has caused me to encounter a problem where the gid I specified in
  the mounting parameters cannot apply to all files, as in the following
  situation:

  /data/tmp/events # mount | grep tracefs
  tracefs on /data/tmp type tracefs (rw,seclabel,relatime,gid=3012)

  gid 3012 = readtracefs

  /data/tmp # ls -lh
  total 0
  -r--r-----   1 root readtracefs 0 1970-01-01 08:00 README
  -r--r-----   1 root readtracefs 0 1970-01-01 08:00 available_events

  ums9621_1h10:/data/tmp/events # ls -lh
  total 0
  drwxr-xr-x 2 root root 0 2023-12-19 00:56 alarmtimer
  drwxr-xr-x 2 root root 0 2023-12-19 00:56 asoc

  It will prevent certain applications from accessing tracefs properly, I
  try to avoid this issue by making the following modifications.

To fix this, have the files created default to taking the ownership of
the parent dentry unless the ownership was previously set by the user.

Link: https://lore.kernel.org/linux-trace-kernel/1703063706-30539-1-git-send-email-dongliang.cui@unisoc.com/
Link: https://lore.kernel.org/linux-trace-kernel/20231220105017.1489d790@gandalf.local.home

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Hongyu Jin  <hongyu.jin@unisoc.com>
Fixes: 28e12c09f5aa0 ("eventfs: Save ownership and mode")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reported-by: Dongliang Cui <cuidongliang390@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/tracefs/event_inode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/tracefs/event_inode.c
+++ b/fs/tracefs/event_inode.c
@@ -148,7 +148,8 @@ static const struct file_operations even
 	.release	= eventfs_release,
 };
 
-static void update_inode_attr(struct inode *inode, struct eventfs_attr *attr, umode_t mode)
+static void update_inode_attr(struct dentry *dentry, struct inode *inode,
+			      struct eventfs_attr *attr, umode_t mode)
 {
 	if (!attr) {
 		inode->i_mode = mode;
@@ -162,9 +163,13 @@ static void update_inode_attr(struct ino
 
 	if (attr->mode & EVENTFS_SAVE_UID)
 		inode->i_uid = attr->uid;
+	else
+		inode->i_uid = d_inode(dentry->d_parent)->i_uid;
 
 	if (attr->mode & EVENTFS_SAVE_GID)
 		inode->i_gid = attr->gid;
+	else
+		inode->i_gid = d_inode(dentry->d_parent)->i_gid;
 }
 
 /**
@@ -206,7 +211,7 @@ static struct dentry *create_file(const
 		return eventfs_failed_creating(dentry);
 
 	/* If the user updated the directory's attributes, use them */
-	update_inode_attr(inode, attr, mode);
+	update_inode_attr(dentry, inode, attr, mode);
 
 	inode->i_op = &eventfs_file_inode_operations;
 	inode->i_fop = fop;
@@ -242,7 +247,8 @@ static struct dentry *create_dir(struct
 		return eventfs_failed_creating(dentry);
 
 	/* If the user updated the directory's attributes, use them */
-	update_inode_attr(inode, &ei->attr, S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
+	update_inode_attr(dentry, inode, &ei->attr,
+			  S_IFDIR | S_IRWXU | S_IRUGO | S_IXUGO);
 
 	inode->i_op = &eventfs_root_dir_inode_operations;
 	inode->i_fop = &eventfs_file_operations;


