Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B20020F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F2C9C433C7;
	Fri, 21 Jul 2023 19:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966555;
	bh=TQBhKDBqgXOfDHCSx0L0+L5nrBXcAoJtgRfaQv5XGmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JB3+YEhvQCVPA5j8bF9rqBhpIGZT+9a5TEXez8XJG0UFLVvN395NiebEwl0qgqba7
	 zmfQWQ/Hqf3pCp89i+3Jhs3MoSrvyJ/HwTbOYCzo8M76pBW11TCbAaC0lsIjFiMfe/
	 II6lhpQ9mzoX7YtRcRXDSZIkuSnjAGssrLIP7THk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.15 378/532] fanotify: disallow mount/sb marks on kernel internal pseudo fs
Date: Fri, 21 Jul 2023 18:04:42 +0200
Message-ID: <20230721160634.995402350@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Amir Goldstein <amir73il@gmail.com>

commit 69562eb0bd3e6bb8e522a7b254334e0fb30dff0c upstream.

Hopefully, nobody is trying to abuse mount/sb marks for watching all
anonymous pipes/inodes.

I cannot think of a good reason to allow this - it looks like an
oversight that dated back to the original fanotify API.

Link: https://lore.kernel.org/linux-fsdevel/20230628101132.kvchg544mczxv2pm@quack3/
Fixes: 0ff21db9fcc3 ("fanotify: hooks the fanotify_mark syscall to the vfsmount code")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
Message-Id: <20230629042044.25723-1-amir73il@gmail.com>
[backport to 5.x.y]
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/fanotify/fanotify_user.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1337,8 +1337,11 @@ static int fanotify_test_fid(struct path
 	return 0;
 }
 
-static int fanotify_events_supported(struct path *path, __u64 mask)
+static int fanotify_events_supported(struct path *path, __u64 mask,
+				     unsigned int flags)
 {
+	unsigned int mark_type = flags & FANOTIFY_MARK_TYPE_BITS;
+
 	/*
 	 * Some filesystems such as 'proc' acquire unusual locks when opening
 	 * files. For them fanotify permission events have high chances of
@@ -1350,6 +1353,21 @@ static int fanotify_events_supported(str
 	if (mask & FANOTIFY_PERM_EVENTS &&
 	    path->mnt->mnt_sb->s_type->fs_flags & FS_DISALLOW_NOTIFY_PERM)
 		return -EINVAL;
+
+	/*
+	 * mount and sb marks are not allowed on kernel internal pseudo fs,
+	 * like pipe_mnt, because that would subscribe to events on all the
+	 * anonynous pipes in the system.
+	 *
+	 * SB_NOUSER covers all of the internal pseudo fs whose objects are not
+	 * exposed to user's mount namespace, but there are other SB_KERNMOUNT
+	 * fs, like nsfs, debugfs, for which the value of allowing sb and mount
+	 * mark is questionable. For now we leave them alone.
+	 */
+	if (mark_type != FAN_MARK_INODE &&
+	    path->mnt->mnt_sb->s_flags & SB_NOUSER)
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -1476,7 +1494,7 @@ static int do_fanotify_mark(int fanotify
 		goto fput_and_out;
 
 	if (flags & FAN_MARK_ADD) {
-		ret = fanotify_events_supported(&path, mask);
+		ret = fanotify_events_supported(&path, mask, flags);
 		if (ret)
 			goto path_put_and_out;
 	}


