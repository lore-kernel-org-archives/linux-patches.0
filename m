Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F4913A868;
	Tue, 18 Jun 2024 12:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714890; cv=none; b=Lfr8DXrIvbazlhaWep8CChcWBDTx2mvaZRFPqCr5J8CR6O6GIzs4vKXcE5xddB1SptU5buczmLZIBcq/LdRYu8oxZ3wZoJosBf5vgfhBcMd1c7ApqIbyP36ZBYquRze4LDSWppf6WrRs+l49ffS5XvyehSzwDUB6DVAsYBAuPEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714890; c=relaxed/simple;
	bh=+wDltEpUrdvGQ4hP4CSu68HIeIrII1p3ONJUe6aSHN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YcBz3+mPgkKxo91owetFbFohE6Udxcj0Aee3sgIJSTxU2tUQFZM3pIRWEfINC/AneFJdASb3MPbfEdkUUkguK6bibUHB+Raq7vO5uFodQhxiEU+OYEOo6ozypLL4MoMDYjy3Z5BH3/PAiLvSc/KQXgPqzVYsUSGHSoJWWZ9mq84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMbYcdvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMbYcdvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C934C3277B;
	Tue, 18 Jun 2024 12:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714890;
	bh=+wDltEpUrdvGQ4hP4CSu68HIeIrII1p3ONJUe6aSHN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMbYcdvFynZPxRa9+hj1EbLp4u3SlW4YPj8BO2yiNlzGTNUijwDm6DPafjKTbpL6d
	 myrHfYZ/ftCqocVjX/Dj+vm95eXrnbTF6lftxtqRJPPYMi/DqjpBfuQg6ouZTCSttg
	 urpgIDEE29X/x1M7qJ/ICWx/qtWJIclVCekgh8XA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/770] proc/fd: In fdinfo seq_show dont use get_files_struct
Date: Tue, 18 Jun 2024 14:29:36 +0200
Message-ID: <20240618123412.019175804@linuxfoundation.org>
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

[ Upstream commit 775e0656b27210ae668e33af00bece858f44576f ]

When discussing[1] exec and posix file locks it was realized that none
of the callers of get_files_struct fundamentally needed to call
get_files_struct, and that by switching them to helper functions
instead it will both simplify their code and remove unnecessary
increments of files_struct.count.  Those unnecessary increments can
result in exec unnecessarily unsharing files_struct which breaking
posix locks, and it can result in fget_light having to fallback to
fget reducing system performance.

Instead hold task_lock for the duration that task->files needs to be
stable in seq_show.  The task_lock was already taken in
get_files_struct, and so skipping get_files_struct performs less work
overall, and avoids the problems with the files_struct reference
count.

[1] https://lkml.kernel.org/r/20180915160423.GA31461@redhat.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-12-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-17-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/fd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 72c1525b4b3eb..cb51763ed554b 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -28,9 +28,8 @@ static int seq_show(struct seq_file *m, void *v)
 	if (!task)
 		return -ENOENT;
 
-	files = get_files_struct(task);
-	put_task_struct(task);
-
+	task_lock(task);
+	files = task->files;
 	if (files) {
 		unsigned int fd = proc_fd(m->private);
 
@@ -47,8 +46,9 @@ static int seq_show(struct seq_file *m, void *v)
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
-		put_files_struct(files);
 	}
+	task_unlock(task);
+	put_task_struct(task);
 
 	if (ret)
 		return ret;
@@ -57,6 +57,7 @@ static int seq_show(struct seq_file *m, void *v)
 		   (long long)file->f_pos, f_flags,
 		   real_mount(file->f_path.mnt)->mnt_id);
 
+	/* show_fd_locks() never deferences files so a stale value is safe */
 	show_fd_locks(m, file, files);
 	if (seq_has_overflowed(m))
 		goto out;
-- 
2.43.0



