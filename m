Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FF2145B37;
	Tue, 18 Jun 2024 12:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714881; cv=none; b=T4T9fjUZOZZUtUieM/hSv9UJx3VeIcnaC90WLZlChZgZQ1an0YrlEDWYk1NUqs9Eq6k/TLQFmFBvlSDdpqnN4YD8AU308hw0qOOjqbkfgugimf1toqoV0BKxncEzVyZinZGyijo1eP+m1+G+wnLYSxJ+PiBI2QDi9RN5D0pjmfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714881; c=relaxed/simple;
	bh=IGf35mfFTdibHo50s65KlLFALziXSu+TuCZNHqj6Y2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KUXG2EWjm2rP7AjuLxSKzBZpt1b9wdbqYCWXhfqPhEuqPhovnYfaKMCPUmy9nXBpbgDlaRhFn2bOqNIGob4bMrmMkQfSmI3tTnLelXrTHHTgx8kB25bb/JX2BO636UrgXoXHAVJckxp+b38rNPdJRcigL8KFhQ2Oe/OnLlE3IBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnltjL+k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnltjL+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDDFC3277B;
	Tue, 18 Jun 2024 12:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714881;
	bh=IGf35mfFTdibHo50s65KlLFALziXSu+TuCZNHqj6Y2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnltjL+kcFbmPSLdsX9zq9WOhoNk02OkBCpHMfgQtdfivAtZU1WLuo/wfXriBWcfW
	 VgherLNTUCscllYyGzYn3dor0rSxEkvIGNEyho8UGmfKdWwxQBawy5t51IoeYbY9Tp
	 8izVKpNVpcKoymrRDks5k1OGY3izYS757fdaqeck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/770] file: Implement task_lookup_next_fd_rcu
Date: Tue, 18 Jun 2024 14:29:34 +0200
Message-ID: <20240618123411.942036270@linuxfoundation.org>
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

[ Upstream commit e9a53aeb5e0a838f10fcea74235664e7ad5e6e1a ]

As a companion to fget_task and task_lookup_fd_rcu implement
task_lookup_next_fd_rcu that will return the struct file for the first
file descriptor number that is equal or greater than the fd argument
value, or NULL if there is no such struct file.

This allows file descriptors of foreign processes to be iterated
through safely, without needed to increment the count on files_struct.

Some concern[1] has been expressed that this function takes the task_lock
for each iteration and thus for each file descriptor.  This place
where this function will be called in a commonly used code path is for
listing /proc/<pid>/fd.  I did some small benchmarks and did not see
any measurable performance differences.  For ordinary users ls is
likely to stat each of the directory entries and tid_fd_mode called
from tid_fd_revalidae has always taken the task lock for each file
descriptor.  So this does not look like it will be a big change in
practice.

At some point is will probably be worth changing put_files_struct to
free files_struct after an rcu grace period so that task_lock won't be
needed at all.

[1] https://lkml.kernel.org/r/20200817220425.9389-10-ebiederm@xmission.com
v1: https://lkml.kernel.org/r/20200817220425.9389-9-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-14-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 21 +++++++++++++++++++++
 include/linux/fdtable.h |  1 +
 2 files changed, 22 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 60a3ccba728cd..9fa49e6298fba 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -926,6 +926,27 @@ struct file *task_lookup_fd_rcu(struct task_struct *task, unsigned int fd)
 	return file;
 }
 
+struct file *task_lookup_next_fd_rcu(struct task_struct *task, unsigned int *ret_fd)
+{
+	/* Must be called with rcu_read_lock held */
+	struct files_struct *files;
+	unsigned int fd = *ret_fd;
+	struct file *file = NULL;
+
+	task_lock(task);
+	files = task->files;
+	if (files) {
+		for (; fd < files_fdtable(files)->max_fds; fd++) {
+			file = files_lookup_fd_rcu(files, fd);
+			if (file)
+				break;
+		}
+	}
+	task_unlock(task);
+	*ret_fd = fd;
+	return file;
+}
+
 /*
  * Lightweight file lookup - no refcnt increment if fd table isn't shared.
  *
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a88f68f740677..b0c6a959c6a00 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -111,6 +111,7 @@ static inline struct file *lookup_fd_rcu(unsigned int fd)
 }
 
 struct file *task_lookup_fd_rcu(struct task_struct *task, unsigned int fd);
+struct file *task_lookup_next_fd_rcu(struct task_struct *task, unsigned int *fd);
 
 struct task_struct;
 
-- 
2.43.0



