Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFE215DBC0;
	Tue, 18 Jun 2024 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714858; cv=none; b=lYKBLsVYzNWzrQpL0kI7ne4KmfU5jPiGFCUZQJd1pwZv0CQV5wSHZTCtlnvD855lwmTmE97x7cGROK4lb4AXDhuFozIHGUUlk4/twyrNMSoecoPGJS+cR1DsakVmJlWoCjj2FhRDKZ/qoOFv0uh9OUlR+ReHnsyPOuqtXRWlX58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714858; c=relaxed/simple;
	bh=pXs4vmIk+0Y9aDNrD76mYPyghkvXp4EJmHrcY0dZHGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RvRtgb1Ijo7xgwEguMSDGIa14RllMNXnFKJwxiAPt79xLnczY5Otth6+1a1qBJmABBe7ap2NW9LQRWqzatYbN4lKMb2niRjQwH1oBXTN3nsK4rDWHZSJtiWYtsLL39fvADcmEk+UgRM2yLiclqQFflMaiFti6afVm7BgLcPS154=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xq3bAFhD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xq3bAFhD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD2B1C3277B;
	Tue, 18 Jun 2024 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714858;
	bh=pXs4vmIk+0Y9aDNrD76mYPyghkvXp4EJmHrcY0dZHGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xq3bAFhDu99jBj7HGycLKeOzT8FgbEapgJrl64TICymbY4DO8jMSzyI0vo91ohMJt
	 X/hEx0Ov28Wfg9RWlkL1sRk9dhKiIEVYee9Ojz6MiJ5GWNHYd8kWfIbuqzyDvJel3l
	 +rIN2kfXgUcHl6Yk4BsGUhHY1IUvZaSDvx+ACCPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 113/770] Revert "fget: clarify and improve __fget_files() implementation"
Date: Tue, 18 Jun 2024 14:29:26 +0200
Message-ID: <20240618123411.632871019@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

Temporarily revert commit 0849f83e4782 ("fget: clarify and improve
__fget_files() implementation") to enable subsequent upstream
commits to apply and build cleanly.

Stable-dep-of: bebf684bf330 ("file: Rename __fcheck_files to files_lookup_fd_raw")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 72 +++++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 56 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 5065252bb474e..fea693acc065e 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -849,68 +849,28 @@ void do_close_on_exec(struct files_struct *files)
 	spin_unlock(&files->file_lock);
 }
 
-static inline struct file *__fget_files_rcu(struct files_struct *files,
-	unsigned int fd, fmode_t mask, unsigned int refs)
-{
-	for (;;) {
-		struct file *file;
-		struct fdtable *fdt = rcu_dereference_raw(files->fdt);
-		struct file __rcu **fdentry;
-
-		if (unlikely(fd >= fdt->max_fds))
-			return NULL;
-
-		fdentry = fdt->fd + array_index_nospec(fd, fdt->max_fds);
-		file = rcu_dereference_raw(*fdentry);
-		if (unlikely(!file))
-			return NULL;
-
-		if (unlikely(file->f_mode & mask))
-			return NULL;
-
-		/*
-		 * Ok, we have a file pointer. However, because we do
-		 * this all locklessly under RCU, we may be racing with
-		 * that file being closed.
-		 *
-		 * Such a race can take two forms:
-		 *
-		 *  (a) the file ref already went down to zero,
-		 *      and get_file_rcu_many() fails. Just try
-		 *      again:
-		 */
-		if (unlikely(!get_file_rcu_many(file, refs)))
-			continue;
-
-		/*
-		 *  (b) the file table entry has changed under us.
-		 *       Note that we don't need to re-check the 'fdt->fd'
-		 *       pointer having changed, because it always goes
-		 *       hand-in-hand with 'fdt'.
-		 *
-		 * If so, we need to put our refs and try again.
-		 */
-		if (unlikely(rcu_dereference_raw(files->fdt) != fdt) ||
-		    unlikely(rcu_dereference_raw(*fdentry) != file)) {
-			fput_many(file, refs);
-			continue;
-		}
-
-		/*
-		 * Ok, we have a ref to the file, and checked that it
-		 * still exists.
-		 */
-		return file;
-	}
-}
-
 static struct file *__fget_files(struct files_struct *files, unsigned int fd,
 				 fmode_t mask, unsigned int refs)
 {
 	struct file *file;
 
 	rcu_read_lock();
-	file = __fget_files_rcu(files, fd, mask, refs);
+loop:
+	file = fcheck_files(files, fd);
+	if (file) {
+		/* File object ref couldn't be taken.
+		 * dup2() atomicity guarantee is the reason
+		 * we loop to catch the new file (or NULL pointer)
+		 */
+		if (file->f_mode & mask)
+			file = NULL;
+		else if (!get_file_rcu_many(file, refs))
+			goto loop;
+		else if (__fcheck_files(files, fd) != file) {
+			fput_many(file, refs);
+			goto loop;
+		}
+	}
 	rcu_read_unlock();
 
 	return file;
-- 
2.43.0



