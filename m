Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAB813A877;
	Tue, 18 Jun 2024 12:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714947; cv=none; b=oblqQuxTpKtu/3a5U4saXK1Gu4gEYRwm1Of5JVLUxgaEoeCK2VCVSwWr3rJ1TCR1OwJa38OKXJNzWQFSfhV3N/HBJzR1crsszKIXUl1t97hYtbKk+SIa3Y2UgsKKz+BAbmvd5hYZJtye2Byet4UzwyyQ0WgM1tFOwKaih+Ex1kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714947; c=relaxed/simple;
	bh=9/W6aD2HsAMG4hbyPhjZiuK0wMsJhkjUHlT+3C0Vrzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p5Pv7X5Vv5t0i/KgpwLEG07LJy4mM7+0eP/Cxj8/n23GMCKCL6jC7pYle9qiJOA+ReQptHHIG6hgg2LBwp6uxu1U3Lat11hno2rrkv01/KxhrIheKtVN1IS/M8N+XmmH17QHBCLWV5J1yQ9EIR43ktrsKogsMqLQcMDJsWRXBm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJ9WvdIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJ9WvdIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679FEC3277B;
	Tue, 18 Jun 2024 12:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714946;
	bh=9/W6aD2HsAMG4hbyPhjZiuK0wMsJhkjUHlT+3C0Vrzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VJ9WvdIFu//sweaOFBgcUBD3nULOWTNaKCOEqkdRFEtb1vn9R6dCnxS9xt46sIpI3
	 CTOJsi5Rd4NgZxY2Kfki1JBOzdMByGx/1feo5sW5xfRUNn/e7Szokeeo8ZG8oPoVQS
	 h7OoMcVTopQXx7Ed728uxAzUX94fFfGotsMlsnqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 111/770] bpf: In bpf_task_fd_query use fget_task
Date: Tue, 18 Jun 2024 14:29:24 +0200
Message-ID: <20240618123411.557297534@linuxfoundation.org>
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

[ Upstream commit b48845af0152d790a54b8ab78cc2b7c07485fc98 ]

Use the helper fget_task to simplify bpf_task_fd_query.

As well as simplifying the code this removes one unnecessary increment of
struct files_struct.  This unnecessary increment of files_struct.count can
result in exec unnecessarily unsharing files_struct and breaking posix
locks, and it can result in fget_light having to fallback to fget reducing
performance.

This simplification comes from the observation that none of the
callers of get_files_struct actually need to call get_files_struct
that was made when discussing[1] exec and posix file locks.

[1] https://lkml.kernel.org/r/20180915160423.GA31461@redhat.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-5-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-5-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e1bee8cd34044..fbe7f8e2b022c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3929,7 +3929,6 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	pid_t pid = attr->task_fd_query.pid;
 	u32 fd = attr->task_fd_query.fd;
 	const struct perf_event *event;
-	struct files_struct *files;
 	struct task_struct *task;
 	struct file *file;
 	int err;
@@ -3949,23 +3948,11 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	if (!task)
 		return -ENOENT;
 
-	files = get_files_struct(task);
-	put_task_struct(task);
-	if (!files)
-		return -ENOENT;
-
 	err = 0;
-	spin_lock(&files->file_lock);
-	file = fcheck_files(files, fd);
+	file = fget_task(task, fd);
+	put_task_struct(task);
 	if (!file)
-		err = -EBADF;
-	else
-		get_file(file);
-	spin_unlock(&files->file_lock);
-	put_files_struct(files);
-
-	if (err)
-		goto out;
+		return -EBADF;
 
 	if (file->f_op == &bpf_link_fops) {
 		struct bpf_link *link = file->private_data;
@@ -4005,7 +3992,6 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 	err = -ENOTSUPP;
 put_file:
 	fput(file);
-out:
 	return err;
 }
 
-- 
2.43.0



