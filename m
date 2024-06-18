Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E4146582;
	Tue, 18 Jun 2024 12:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714875; cv=none; b=bqz2P/Z8tr4VCnCDOjS+aIXoNgfDF9EjWypUDeteq2is6suGX7u0n+X9z18hoOKdd1oVgQX5PO5O2OQdIUhq6pQLIq7SV1G7XJ3FqAqv5RAx263pOF1N6jonToJ4SLme517v/OPVwaOMi9o7CMmhVj9Y/yzag6Dm5OeXWqhL4XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714875; c=relaxed/simple;
	bh=8rec3HIS7ZCyFfexhZGfmy7oIz9vTEp1J3TF62ra6Lw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QlWndI/ItyvjnvgtEQLxI8uLYnU/bt40KkVn8v/evytjO9ZudT4aLqX5nVS4oMzum5bm2w33w66UndU+aNMJ1p1civG1VblVW0UwSG1uvemKGCmUfEn2O8ahtdhEhS36we7z7weNrbR2XhVQloU/c7chxUvqX9hleavNmODeArs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrlI1R76; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrlI1R76"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41C56C3277B;
	Tue, 18 Jun 2024 12:47:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714875;
	bh=8rec3HIS7ZCyFfexhZGfmy7oIz9vTEp1J3TF62ra6Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrlI1R7681OLd9ipq1V+3kWv+nBH0c5MmcLzomoYpbdWz2z9k+jC71PCwLj7MRPkT
	 kH+9LBDwsP0hVr03G8ymSXwMhu6MgrZ2ZD2JQkdrz2ueY6htpACo5gpb7NGbxbpHE3
	 JCIq4fEbzs8zFty6K9lICpL6AGkMgjh3yQqNStek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/770] proc/fd: In tid_fd_mode use task_lookup_fd_rcu
Date: Tue, 18 Jun 2024 14:29:32 +0200
Message-ID: <20240618123411.862793619@linuxfoundation.org>
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

[ Upstream commit 64eb661fda0269276b4c46965832938e3f268268 ]

When discussing[1] exec and posix file locks it was realized that none
of the callers of get_files_struct fundamentally needed to call
get_files_struct, and that by switching them to helper functions
instead it will both simplify their code and remove unnecessary
increments of files_struct.count.  Those unnecessary increments can
result in exec unnecessarily unsharing files_struct which breaking
posix locks, and it can result in fget_light having to fallback to
fget reducing system performance.

Instead of manually coding finding the files struct for a task and
then calling files_lookup_fd_rcu, use the helper task_lookup_fd_rcu
that combines those to steps.   Making the code simpler and removing
the need to get a reference on a files_struct.

[1] https://lkml.kernel.org/r/20180915160423.GA31461@redhat.com
Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-7-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-12-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/fd.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 3dec44d7c5c5c..c1a984f3c4df7 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -83,18 +83,13 @@ static const struct file_operations proc_fdinfo_file_operations = {
 
 static bool tid_fd_mode(struct task_struct *task, unsigned fd, fmode_t *mode)
 {
-	struct files_struct *files = get_files_struct(task);
 	struct file *file;
 
-	if (!files)
-		return false;
-
 	rcu_read_lock();
-	file = files_lookup_fd_rcu(files, fd);
+	file = task_lookup_fd_rcu(task, fd);
 	if (file)
 		*mode = file->f_mode;
 	rcu_read_unlock();
-	put_files_struct(files);
 	return !!file;
 }
 
-- 
2.43.0



