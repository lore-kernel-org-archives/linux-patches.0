Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39ED517AAB
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BBFC433C7;
	Wed,  9 Aug 2023 11:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581303;
	bh=lhAByeL4+rirM/cyv6Jo8yjGIYIEqS7+yGGjKizxJJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z13TwdM3HEOHEgXaWvbpKs92A+XOsMg7A1PXF8T9zCQOAe1OJlBMM9w4YcgnE47Db
	 0MOK+HE+ksboKPA6VAxk78USzkE8cSbzY1JMOw0iCSJ0Zl/wlWiZCbapDPhEcmyiEr
	 z/lsQJmmmgCAkmacmr62p7HQbpxGnT/Bf1G5V8iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 176/201] file: reinstate f_pos locking optimization for regular files
Date: Wed,  9 Aug 2023 12:42:58 +0200
Message-ID: <20230809103649.641898484@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 797964253d358cf8d705614dda394dbe30120223 upstream.

In commit 20ea1e7d13c1 ("file: always lock position for
FMODE_ATOMIC_POS") we ended up always taking the file pos lock, because
pidfd_getfd() could get a reference to the file even when it didn't have
an elevated file count due to threading of other sharing cases.

But Mateusz Guzik reports that the extra locking is actually measurable,
so let's re-introduce the optimization, and only force the locking for
directory traversal.

Directories need the lock for correctness reasons, while regular files
only need it for "POSIX semantics".  Since pidfd_getfd() is about
debuggers etc special things that are _way_ outside of POSIX, we can
relax the rules for that case.

Reported-by: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>
Link: https://lore.kernel.org/linux-fsdevel/20230803095311.ijpvhx3fyrbkasul@f/
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/file.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/file.c
+++ b/fs/file.c
@@ -1007,12 +1007,28 @@ unsigned long __fdget_raw(unsigned int f
 	return __fget_light(fd, 0);
 }
 
+/*
+ * Try to avoid f_pos locking. We only need it if the
+ * file is marked for FMODE_ATOMIC_POS, and it can be
+ * accessed multiple ways.
+ *
+ * Always do it for directories, because pidfd_getfd()
+ * can make a file accessible even if it otherwise would
+ * not be, and for directories this is a correctness
+ * issue, not a "POSIX requirement".
+ */
+static inline bool file_needs_f_pos_lock(struct file *file)
+{
+	return (file->f_mode & FMODE_ATOMIC_POS) &&
+		(file_count(file) > 1 || S_ISDIR(file_inode(file)->i_mode));
+}
+
 unsigned long __fdget_pos(unsigned int fd)
 {
 	unsigned long v = __fdget(fd);
 	struct file *file = (struct file *)(v & ~3);
 
-	if (file && (file->f_mode & FMODE_ATOMIC_POS)) {
+	if (file && file_needs_f_pos_lock(file)) {
 		v |= FDPUT_POS_UNLOCK;
 		mutex_lock(&file->f_pos_lock);
 	}


