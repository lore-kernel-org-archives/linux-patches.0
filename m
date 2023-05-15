Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68C1F17730
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7FC433EF;
	Mon, 15 May 2023 18:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173903;
	bh=8owA7c1r4tUFh9YUgeL0r3Cazrnf8zHs8wRdQkoz69E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y4AUtwmsES5EsiDfhUFkRrwfGvDessbJgv2APK0lqX4boTpk1BzyV0c/nGGCeL/De
	 wp8yTDP3hYASedaZsx6kRIT2BDjFspgke0cdORcbFfUAa/g73kSrS015NHsGGxu/W1
	 Af56gnc+O3vwKNkjI6iEXRxsDRocw3psNcFVrxFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com,
	Amir Goldstein <amir73il@gmail.com>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 5.4 244/282] inotify: Avoid reporting event with invalid wd
Date: Mon, 15 May 2023 18:30:22 +0200
Message-Id: <20230515161729.570992200@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit c915d8f5918bea7c3962b09b8884ca128bfd9b0c upstream.

When inotify_freeing_mark() races with inotify_handle_inode_event() it
can happen that inotify_handle_inode_event() sees that i_mark->wd got
already reset to -1 and reports this value to userspace which can
confuse the inotify listener. Avoid the problem by validating that wd is
sensible (and pretend the mark got removed before the event got
generated otherwise).

CC: stable@vger.kernel.org
Fixes: 7e790dd5fc93 ("inotify: fix error paths in inotify_update_watch")
Message-Id: <20230424163219.9250-1-jack@suse.cz>
Reported-by: syzbot+4a06d4373fd52f0b2f9c@syzkaller.appspotmail.com
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/notify/inotify/inotify_fsnotify.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -66,7 +66,7 @@ int inotify_handle_event(struct fsnotify
 	struct inotify_event_info *event;
 	struct fsnotify_event *fsn_event;
 	int ret;
-	int len = 0;
+	int len = 0, wd;
 	int alloc_len = sizeof(struct inotify_event_info);
 
 	if (WARN_ON(fsnotify_iter_vfsmount_mark(iter_info)))
@@ -91,6 +91,13 @@ int inotify_handle_event(struct fsnotify
 			      fsn_mark);
 
 	/*
+	 * We can be racing with mark being detached. Don't report event with
+	 * invalid wd.
+	 */
+	wd = READ_ONCE(i_mark->wd);
+	if (wd == -1)
+		return 0;
+	/*
 	 * Whoever is interested in the event, pays for the allocation. Do not
 	 * trigger OOM killer in the target monitoring memcg as it may have
 	 * security repercussion.
@@ -120,7 +127,7 @@ int inotify_handle_event(struct fsnotify
 	fsn_event = &event->fse;
 	fsnotify_init_event(fsn_event, (unsigned long)inode);
 	event->mask = mask;
-	event->wd = i_mark->wd;
+	event->wd = wd;
 	event->sync_cookie = cookie;
 	event->name_len = len;
 	if (len)


