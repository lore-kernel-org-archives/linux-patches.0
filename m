Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF019145B37;
	Tue, 18 Jun 2024 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714872; cv=none; b=HDObzAE5tN0sVGS4x6znxiQtvw+kZrsWpsV3Bh/Mtc2y3J+EgEf/SluM7bzIsCzh/5pPQ7ozuVPA5MucNqjiWz/9Z2Nf6tpLO1secQsrK6SxIqZKmtin3jmy9B5B9HzfTaw6BugkkHOv8kpd4jJggy8pzpOrQGDXh+jFOcIKilk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714872; c=relaxed/simple;
	bh=dhrNyziVaX7OT6TffuGG3Wk06A+Cua8oEZWWisqsHNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXj++DWouzOy5IScKME/g6QofOSoqxmC0ZbAwyQwXkE5QEIDw7kB9ShKlMjfwUnyKYJPYui2uhH5tMUIsx7yDCRAyog7RnR46iqzplOJjrM40z1nXUJv5fBjrGX4pjIyQ3exFuv6A4vLkDwREEk3ipJ9RzD+J2Eqliy6IYVw9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Do69nqI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Do69nqI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EAFC3277B;
	Tue, 18 Jun 2024 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714872;
	bh=dhrNyziVaX7OT6TffuGG3Wk06A+Cua8oEZWWisqsHNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Do69nqI21P0dYhtpgoMnb0Db7VYWKMU0Jo7OTVqJ9E2jypuolm/xBsbsM7ClxnGZv
	 /VqbaTA9hKSGvf9Ohh9L+n79h7mcmjEhQhPJ2voug+IARKjy8xR2yBifEWUxjLKsNl
	 mmvFEEgv28zEU14FjtzCghTUW2QnUTnfbeiQC3VQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/770] file: Implement task_lookup_fd_rcu
Date: Tue, 18 Jun 2024 14:29:31 +0200
Message-ID: <20240618123411.824808054@linuxfoundation.org>
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

[ Upstream commit 3a879fb38082125cc0d8aa89b70c7f3a7cdf584b ]

As a companion to lookup_fd_rcu implement task_lookup_fd_rcu for
querying an arbitrary process about a specific file.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200818103713.aw46m7vprsy4vlve@wittgenstein
Link: https://lkml.kernel.org/r/20201120231441.29911-11-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 15 +++++++++++++++
 include/linux/fdtable.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/fs/file.c b/fs/file.c
index 6149f75a18a66..60a3ccba728cd 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -911,6 +911,21 @@ struct file *fget_task(struct task_struct *task, unsigned int fd)
 	return file;
 }
 
+struct file *task_lookup_fd_rcu(struct task_struct *task, unsigned int fd)
+{
+	/* Must be called with rcu_read_lock held */
+	struct files_struct *files;
+	struct file *file = NULL;
+
+	task_lock(task);
+	files = task->files;
+	if (files)
+		file = files_lookup_fd_rcu(files, fd);
+	task_unlock(task);
+
+	return file;
+}
+
 /*
  * Lightweight file lookup - no refcnt increment if fd table isn't shared.
  *
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 695306cc5337a..a88f68f740677 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -110,6 +110,8 @@ static inline struct file *lookup_fd_rcu(unsigned int fd)
 	return files_lookup_fd_rcu(current->files, fd);
 }
 
+struct file *task_lookup_fd_rcu(struct task_struct *task, unsigned int fd);
+
 struct task_struct;
 
 struct files_struct *get_files_struct(struct task_struct *);
-- 
2.43.0



