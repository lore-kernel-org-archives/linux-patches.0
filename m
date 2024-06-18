Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCA414C5A7;
	Tue, 18 Jun 2024 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714950; cv=none; b=lSmFMQgBacqN+oAJTlp9B4D5x7/HrtDikH/5fI1+oT65iF3BIA1CW/orfaMUBGeQ9eNUwXcwIT39EvULed9mEasR2o23e56zfe1/a7gtH3V8UFVyfAFdMnH9zITLk0b41qH9iIHnkoS2RgBbJUfLDXfTNYUOOo51Yg3Jd4SAJhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714950; c=relaxed/simple;
	bh=Mevzi+b9gGg+lBcPu32VExafc1MIi+qjaJ1v9MND8A4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ejp72nQ9ura9HVmBuf7JZcBgGjzWvLH+zpT/WgbH/aVyMB4DjtDn2UAjpjIiiFxKJMyDyeFK8Htl661NxT+ZbQBzELc6UUknzDmSaw2UJtXwNMOTecl2hOgkzpELThiG67WfzfMSwpPz/aFDBuU7uu8opH6YilU/rNlqMf2Avqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hz+b6BE0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hz+b6BE0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54418C3277B;
	Tue, 18 Jun 2024 12:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714949;
	bh=Mevzi+b9gGg+lBcPu32VExafc1MIi+qjaJ1v9MND8A4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hz+b6BE0VC1bkELSENXXDD/+2Tia+Anjh0dGFAZ8DYzLa74A+G9iCFZmjGNFEi1b7
	 He/L7T/PL5Wx4tpg2DOFWHj4bKgixxIOwtQxSopLwtaxTIc+D0HFB6zbENvMbx9xr8
	 Z68aY0hLNibgeuxQF29rbMGtmZCi+ZHo6acDiT80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/770] proc/fd: In proc_fd_link use fget_task
Date: Tue, 18 Jun 2024 14:29:25 +0200
Message-ID: <20240618123411.595179751@linuxfoundation.org>
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

[ Upstream commit 439be32656035d3239fd56f9b83353ec06cb3b45 ]

When discussing[1] exec and posix file locks it was realized that none
of the callers of get_files_struct fundamentally needed to call
get_files_struct, and that by switching them to helper functions
instead it will both simplify their code and remove unnecessary
increments of files_struct.count.  Those unnecessary increments can
result in exec unnecessarily unsharing files_struct which breaking
posix locks, and it can result in fget_light having to fallback to
fget reducing system performance.

Simplifying proc_fd_link is a little bit tricky.  It is necessary to
know that there is a reference to fd_f	 ile while path_get is running.
This reference can either be guaranteed to exist either by locking the
fdtable as the code currently does or by taking a reference on the
file in question.

Use fget_task to remove the need for get_files_struct and
to take a reference to file in question.

[1] https://lkml.kernel.org/r/20180915160423.GA31461@redhat.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-8-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-6-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/fd.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 81882a13212d3..d58960f6ee524 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -146,29 +146,22 @@ static const struct dentry_operations tid_fd_dentry_operations = {
 
 static int proc_fd_link(struct dentry *dentry, struct path *path)
 {
-	struct files_struct *files = NULL;
 	struct task_struct *task;
 	int ret = -ENOENT;
 
 	task = get_proc_task(d_inode(dentry));
 	if (task) {
-		files = get_files_struct(task);
-		put_task_struct(task);
-	}
-
-	if (files) {
 		unsigned int fd = proc_fd(d_inode(dentry));
 		struct file *fd_file;
 
-		spin_lock(&files->file_lock);
-		fd_file = fcheck_files(files, fd);
+		fd_file = fget_task(task, fd);
 		if (fd_file) {
 			*path = fd_file->f_path;
 			path_get(&fd_file->f_path);
 			ret = 0;
+			fput(fd_file);
 		}
-		spin_unlock(&files->file_lock);
-		put_files_struct(files);
+		put_task_struct(task);
 	}
 
 	return ret;
-- 
2.43.0



