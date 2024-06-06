Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BA551990DC;
	Thu,  6 Jun 2024 14:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683145; cv=none; b=JcN/nkzs0daiCSf4rFAs02SysFDcwMGAvlgZa3IfWh8Sfxq7C2tWKvN7AptGcXJaGKLx+CrAR1BIUxqz5/MY5qyAn6IXxNaq3baqxsA1O2mn8CZ8lBwHzC/tYLnl8kRQtGIfWVprAuSyYvwwwoBEYSF8wLXO6xQvHmGb34rM89g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683145; c=relaxed/simple;
	bh=HllS7wGNt/7tOi6mZeR8wZZA8VacO8tYzpp7SJNyJ/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSDJhU2IWU+eHWcHTI0MVQRakqPjIya6cqUn1V3wX5ebYKd7ULky2xrppZ1WQboO5R/rg40AU0SyyJMOMYzHzZ1smaoHjzb4WjgZ3wvYZ6dmnwkh7gHiubmgQuSXlA3ZplI59DrB9E+bfoeMgQQJmjfjqN3p32jR2qUiA85ljy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERmNEkZj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERmNEkZj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5EC7C2BD10;
	Thu,  6 Jun 2024 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683144;
	bh=HllS7wGNt/7tOi6mZeR8wZZA8VacO8tYzpp7SJNyJ/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ERmNEkZjiTjrH93hGGJy74twg0355ISAA9R9o50TyZa1GdkGgaIvzz0wuBvYwp09J
	 AoGemVoTJI7kDJDIa30IdPQtfD1a9qvNnQ9g/cAr36VkzhUtv51VrKImAzL1O4VHaA
	 kkaGRpmnCPup0iadSD3IH1aIS/jAn7o4dWEDFvxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 090/744] epoll: be better about file lifetimes
Date: Thu,  6 Jun 2024 15:56:02 +0200
Message-ID: <20240606131735.288954742@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit 4efaa5acf0a1d2b5947f98abb3acf8bfd966422b ]

epoll can call out to vfs_poll() with a file pointer that may race with
the last 'fput()'. That would make f_count go down to zero, and while
the ep->mtx locking means that the resulting file pointer tear-down will
be blocked until the poll returns, it means that f_count is already
dead, and any use of it won't actually get a reference to the file any
more: it's dead regardless.

Make sure we have a valid ref on the file pointer before we call down to
vfs_poll() from the epoll routines.

Link: https://lore.kernel.org/lkml/0000000000002d631f0615918f1e@google.com/
Reported-by: syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 1d9a71a0c4c16..0ed73bc7d4652 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -876,6 +876,34 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 	return res;
 }
 
+/*
+ * The ffd.file pointer may be in the process of being torn down due to
+ * being closed, but we may not have finished eventpoll_release() yet.
+ *
+ * Normally, even with the atomic_long_inc_not_zero, the file may have
+ * been free'd and then gotten re-allocated to something else (since
+ * files are not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).
+ *
+ * But for epoll, users hold the ep->mtx mutex, and as such any file in
+ * the process of being free'd will block in eventpoll_release_file()
+ * and thus the underlying file allocation will not be free'd, and the
+ * file re-use cannot happen.
+ *
+ * For the same reason we can avoid a rcu_read_lock() around the
+ * operation - 'ffd.file' cannot go away even if the refcount has
+ * reached zero (but we must still not call out to ->poll() functions
+ * etc).
+ */
+static struct file *epi_fget(const struct epitem *epi)
+{
+	struct file *file;
+
+	file = epi->ffd.file;
+	if (!atomic_long_inc_not_zero(&file->f_count))
+		file = NULL;
+	return file;
+}
+
 /*
  * Differs from ep_eventpoll_poll() in that internal callers already have
  * the ep->mtx so we need to start from depth=1, such that mutex_lock_nested()
@@ -884,14 +912,22 @@ static __poll_t __ep_eventpoll_poll(struct file *file, poll_table *wait, int dep
 static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt,
 				 int depth)
 {
-	struct file *file = epi->ffd.file;
+	struct file *file = epi_fget(epi);
 	__poll_t res;
 
+	/*
+	 * We could return EPOLLERR | EPOLLHUP or something, but let's
+	 * treat this more as "file doesn't exist, poll didn't happen".
+	 */
+	if (!file)
+		return 0;
+
 	pt->_key = epi->event.events;
 	if (!is_file_epoll(file))
 		res = vfs_poll(file, pt);
 	else
 		res = __ep_eventpoll_poll(file, pt, depth);
+	fput(file);
 	return res & epi->event.events;
 }
 
-- 
2.43.0



