Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C20D1459FC;
	Tue, 18 Jun 2024 12:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714864; cv=none; b=mWadJln8EkZ29MBoTGWfiP0Kl+zu/IxK1MUMGiCFeOA5aaTueOVASvvNtLXW8AVrjCcKH9PLCMTwJ24VkvrSfRig56rM8XwuufUBGAhbW5wBHiqJ9Oejrv2lc01Q6nYoKhhKIe26pTGnk4SptmBIr7YbxyGwS00skIg/iSVSeR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714864; c=relaxed/simple;
	bh=CLirKKSgIgzhsexmUYPDej1xr4z1Nv6MUv1AL+t8q7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dszgbFQJQYEessMavHFZf8WYnyHNSzd2cTxJR3td3FOaUbVp9HwG7pig3TdELEJO+845lLy9mgh/T6zc9odzztiaWYXZAGPJnd8n8leZbjDwycn+AgmB8GnhkxiFCQNlECEW99BFfBsF1y/V4qKTuEUDXhzZNqa2GeqkwwJTFzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcgXZgOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcgXZgOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 885A1C3277B;
	Tue, 18 Jun 2024 12:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714863;
	bh=CLirKKSgIgzhsexmUYPDej1xr4z1Nv6MUv1AL+t8q7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcgXZgOg2VdR5ghtYJ4V/QjesSjDzecJ5E7URtMmmQeDJPRTFivq3yvDLWmwsAM2P
	 HLTcgs9NNXb8l6alQsBYeZY0eVHqyf09k8nNxJLyyGIOCxP/zYKBD3zNcaHnE1hPcV
	 z4n8ZJEtnP9478YsBkKQUu27v59/kgp4DB0Nk1Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/770] file: Factor files_lookup_fd_locked out of fcheck_files
Date: Tue, 18 Jun 2024 14:29:28 +0200
Message-ID: <20240618123411.710230731@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric W. Biederman <ebiederm@xmission.com>

[ Upstream commit 120ce2b0cd52abe73e8b16c23461eb14df5a87d8 ]

To make it easy to tell where files->file_lock protection is being
used when looking up a file create files_lookup_fd_locked.  Only allow
this function to be called with the file_lock held.

Update the callers of fcheck and fcheck_files that are called with the
files->file_lock held to call files_lookup_fd_locked instead.

Hopefully this makes it easier to quickly understand what is going on.

The need for better names became apparent in the last round of
discussion of this set of changes[1].

[1] https://lkml.kernel.org/r/CAHk-=wj8BQbgJFLa+J0e=iT-1qpmCRTbPAJ8gd6MJQ=kbRPqyQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20201120231441.29911-8-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               |  2 +-
 fs/locks.c              | 14 ++++++++------
 fs/proc/fd.c            |  2 +-
 include/linux/fdtable.h |  7 +++++++
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index eb1e2b7220ac6..6a6b03ce4ad69 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -1158,7 +1158,7 @@ static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 
 	spin_lock(&files->file_lock);
 	err = expand_files(files, newfd);
-	file = fcheck(oldfd);
+	file = files_lookup_fd_locked(files, oldfd);
 	if (unlikely(!file))
 		goto Ebadf;
 	if (unlikely(err < 0)) {
diff --git a/fs/locks.c b/fs/locks.c
index cbb5701ce9f37..873f97504bddf 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2536,14 +2536,15 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 	 */
 	if (!error && file_lock->fl_type != F_UNLCK &&
 	    !(file_lock->fl_flags & FL_OFDLCK)) {
+		struct files_struct *files = current->files;
 		/*
 		 * We need that spin_lock here - it prevents reordering between
 		 * update of i_flctx->flc_posix and check for it done in
 		 * close(). rcu_read_lock() wouldn't do.
 		 */
-		spin_lock(&current->files->file_lock);
-		f = fcheck(fd);
-		spin_unlock(&current->files->file_lock);
+		spin_lock(&files->file_lock);
+		f = files_lookup_fd_locked(files, fd);
+		spin_unlock(&files->file_lock);
 		if (f != filp) {
 			file_lock->fl_type = F_UNLCK;
 			error = do_lock_file_wait(filp, cmd, file_lock);
@@ -2667,14 +2668,15 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 	 */
 	if (!error && file_lock->fl_type != F_UNLCK &&
 	    !(file_lock->fl_flags & FL_OFDLCK)) {
+		struct files_struct *files = current->files;
 		/*
 		 * We need that spin_lock here - it prevents reordering between
 		 * update of i_flctx->flc_posix and check for it done in
 		 * close(). rcu_read_lock() wouldn't do.
 		 */
-		spin_lock(&current->files->file_lock);
-		f = fcheck(fd);
-		spin_unlock(&current->files->file_lock);
+		spin_lock(&files->file_lock);
+		f = files_lookup_fd_locked(files, fd);
+		spin_unlock(&files->file_lock);
 		if (f != filp) {
 			file_lock->fl_type = F_UNLCK;
 			error = do_lock_file_wait(filp, cmd, file_lock);
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index d58960f6ee524..2cca9bca3b3a3 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -35,7 +35,7 @@ static int seq_show(struct seq_file *m, void *v)
 		unsigned int fd = proc_fd(m->private);
 
 		spin_lock(&files->file_lock);
-		file = fcheck_files(files, fd);
+		file = files_lookup_fd_locked(files, fd);
 		if (file) {
 			struct fdtable *fdt = files_fdtable(files);
 
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 10e75b4c30a43..87be704268d26 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -91,6 +91,13 @@ static inline struct file *files_lookup_fd_raw(struct files_struct *files, unsig
 	return NULL;
 }
 
+static inline struct file *files_lookup_fd_locked(struct files_struct *files, unsigned int fd)
+{
+	RCU_LOCKDEP_WARN(!lockdep_is_held(&files->file_lock),
+			   "suspicious rcu_dereference_check() usage");
+	return files_lookup_fd_raw(files, fd);
+}
+
 static inline struct file *fcheck_files(struct files_struct *files, unsigned int fd)
 {
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
-- 
2.43.0



