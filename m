Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD533145B37;
	Tue, 18 Jun 2024 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714884; cv=none; b=VhufR5moP72FC3TWMwuPRrzWo9h/1nkfbqlVHVz0zU4UEa06L+DZCKudNboWp5usKuCmcEGY1TsOQGWC/RrC8mi87IgzlxvuaPLKrSyLGucz9TbpjwL71soA6zXDoY7tKOzFOzy5r9PB/k2PkQOczv9tBatpzZDNwzX7+PeS6zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714884; c=relaxed/simple;
	bh=Gkbl7KrLo6iuAm6Xmf/CM2FSJEK4ZUBO5Vk5CIiqFSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qNLdyOSKmUWUOfXjOdxUfOMqqCIbW7051gO1s4IsAZQ5uFDL4zcyRSIW98eVYXmA96glgrdH0g4gcx7uSDjfE0qSHDYxLqDLpKkB6bPGvDLeNo1n6gnzEUyR9Ey2/2Cy6yZL2KFU1x8uFh9OaG8D1nj5z9k+LSvTPsZn6aEHNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cSyn9LxP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cSyn9LxP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30811C3277B;
	Tue, 18 Jun 2024 12:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714884;
	bh=Gkbl7KrLo6iuAm6Xmf/CM2FSJEK4ZUBO5Vk5CIiqFSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cSyn9LxPhRiBqWI2uars6LBk6XGtA2Dq8M2V2E3jEskmMjyBrQlbjcDkaaQnWK3Kc
	 vXfdULUabA1Hhl/pS0woZbUYViclyk/v3S/A0F2B6LhU7xyo1OYD0R/I/GVPDAsqF0
	 qcYJCJbM+9LQi6mxmYZ9Fvrl1uENyWwUArmNecgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Andy Lavr <andy.lavr@gmail.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/770] proc/fd: In proc_readfd_common use task_lookup_next_fd_rcu
Date: Tue, 18 Jun 2024 14:29:35 +0200
Message-ID: <20240618123411.980534092@linuxfoundation.org>
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

[ Upstream commit 5b17b61870e2f4b0a4fdc5c6039fbdb4ffb796df ]

When discussing[1] exec and posix file locks it was realized that none
of the callers of get_files_struct fundamentally needed to call
get_files_struct, and that by switching them to helper functions
instead it will both simplify their code and remove unnecessary
increments of files_struct.count.  Those unnecessary increments can
result in exec unnecessarily unsharing files_struct which breaking
posix locks, and it can result in fget_light having to fallback to
fget reducing system performance.

Using task_lookup_next_fd_rcu simplifies proc_readfd_common, by moving
the checking for the maximum file descritor into the generic code, and
by remvoing the need for capturing and releasing a reference on
files_struct.

As task_lookup_fd_rcu may update the fd ctx->pos has been changed
to be the fd +2 after task_lookup_fd_rcu returns.

[1] https://lkml.kernel.org/r/20180915160423.GA31461@redhat.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Tested-by: Andy Lavr <andy.lavr@gmail.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-10-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-15-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/fd.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index c1a984f3c4df7..72c1525b4b3eb 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -217,7 +217,6 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 			      instantiate_t instantiate)
 {
 	struct task_struct *p = get_proc_task(file_inode(file));
-	struct files_struct *files;
 	unsigned int fd;
 
 	if (!p)
@@ -225,22 +224,18 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 
 	if (!dir_emit_dots(file, ctx))
 		goto out;
-	files = get_files_struct(p);
-	if (!files)
-		goto out;
 
 	rcu_read_lock();
-	for (fd = ctx->pos - 2;
-	     fd < files_fdtable(files)->max_fds;
-	     fd++, ctx->pos++) {
+	for (fd = ctx->pos - 2;; fd++) {
 		struct file *f;
 		struct fd_data data;
 		char name[10 + 1];
 		unsigned int len;
 
-		f = files_lookup_fd_rcu(files, fd);
+		f = task_lookup_next_fd_rcu(p, &fd);
+		ctx->pos = fd + 2LL;
 		if (!f)
-			continue;
+			break;
 		data.mode = f->f_mode;
 		rcu_read_unlock();
 		data.fd = fd;
@@ -249,13 +244,11 @@ static int proc_readfd_common(struct file *file, struct dir_context *ctx,
 		if (!proc_fill_cache(file, ctx,
 				     name, len, instantiate, p,
 				     &data))
-			goto out_fd_loop;
+			goto out;
 		cond_resched();
 		rcu_read_lock();
 	}
 	rcu_read_unlock();
-out_fd_loop:
-	put_files_struct(files);
 out:
 	put_task_struct(p);
 	return 0;
-- 
2.43.0



