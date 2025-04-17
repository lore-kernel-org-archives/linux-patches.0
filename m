Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B53F71A3178;
	Thu, 17 Apr 2025 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913910; cv=none; b=aGnmbniCI9DTUvOngZg+EkH2Ps4bwBqTg+gD0E02Aeq3POGgt+a80IsAKS77/q5hoWr2I3hF2bSeCS1A8dBZXnu50UKuSLIjMMF7+Tn4eAtK9UouLru0Pb2LUC57ye3r2scs9JGYZTVORVoWXNu0ElKODG/q8OU40iweJskIg94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913910; c=relaxed/simple;
	bh=tWTrimE3Ev4RI+dCRq+86IOkeHVVtlaE1coPc4OP37U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4J4PHC7wDB63Qd2ObAOh/5aPpb30mwsiEA/FfCXfRfyiYjNAIDndDH13NlqFlzYKmZuuXK2sCuXvYcCGmoovtDjEJrGm7Ino05vQFMs6Xgs9Fg/ROfWGazoisO2APkXuILoJ4otG5cRsQieJpZyhqrYesGiUoMgFBDSpsiD3NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5YTq9Az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5YTq9Az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46922C4CEE4;
	Thu, 17 Apr 2025 18:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913910;
	bh=tWTrimE3Ev4RI+dCRq+86IOkeHVVtlaE1coPc4OP37U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I5YTq9AzRQh3Si7ECO2Su4ut4kjag/8Urqw0mLSierOODwxWitVC689do6zlxhS8e
	 lCwf4nzsXkcLnUa2WRWBPP+CeHViUGz9WABqMjWHjGoS+xvo1cqb7+4YJxqVMX3gB5
	 g0tavG73rys51P4so9Li4JPaGj40hbqJzMmCkrRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Guzik <mjguzik@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 042/414] fs: consistently deref the files table with rcu_dereference_raw()
Date: Thu, 17 Apr 2025 19:46:40 +0200
Message-ID: <20250417175113.107477191@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mateusz Guzik <mjguzik@gmail.com>

[ Upstream commit f381640e1bd4f2de7ccafbfe8703d33c3718aad9 ]

... except when the table is known to be only used by one thread.

A file pointer can get installed at any moment despite the ->file_lock
being held since the following:
8a81252b774b53e6 ("fs/file.c: don't acquire files->file_lock in fd_install()")

Accesses subject to such a race can in principle suffer load tearing.

While here redo the comment in dup_fd -- it only covered a race against
files showing up, still assuming fd_install() takes the lock.

Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
Link: https://lore.kernel.org/r/20250313135725.1320914-1-mjguzik@gmail.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 25c6e53b03f8f..97e2a9e09b70c 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -418,17 +418,25 @@ struct files_struct *dup_fd(struct files_struct *oldf, struct fd_range *punch_ho
 	old_fds = old_fdt->fd;
 	new_fds = new_fdt->fd;
 
+	/*
+	 * We may be racing against fd allocation from other threads using this
+	 * files_struct, despite holding ->file_lock.
+	 *
+	 * alloc_fd() might have already claimed a slot, while fd_install()
+	 * did not populate it yet. Note the latter operates locklessly, so
+	 * the file can show up as we are walking the array below.
+	 *
+	 * At the same time we know no files will disappear as all other
+	 * operations take the lock.
+	 *
+	 * Instead of trying to placate userspace racing with itself, we
+	 * ref the file if we see it and mark the fd slot as unused otherwise.
+	 */
 	for (i = open_files; i != 0; i--) {
-		struct file *f = *old_fds++;
+		struct file *f = rcu_dereference_raw(*old_fds++);
 		if (f) {
 			get_file(f);
 		} else {
-			/*
-			 * The fd may be claimed in the fd bitmap but not yet
-			 * instantiated in the files array if a sibling thread
-			 * is partway through open().  So make sure that this
-			 * fd is available to the new process.
-			 */
 			__clear_open_fd(open_files - i, new_fdt);
 		}
 		rcu_assign_pointer(*new_fds++, f);
@@ -679,7 +687,7 @@ struct file *file_close_fd_locked(struct files_struct *files, unsigned fd)
 		return NULL;
 
 	fd = array_index_nospec(fd, fdt->max_fds);
-	file = fdt->fd[fd];
+	file = rcu_dereference_raw(fdt->fd[fd]);
 	if (file) {
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 		__put_unused_fd(files, fd);
@@ -1245,7 +1253,7 @@ __releases(&files->file_lock)
 	 */
 	fdt = files_fdtable(files);
 	fd = array_index_nospec(fd, fdt->max_fds);
-	tofree = fdt->fd[fd];
+	tofree = rcu_dereference_raw(fdt->fd[fd]);
 	if (!tofree && fd_is_open(fd, fdt))
 		goto Ebusy;
 	get_file(file);
-- 
2.39.5



