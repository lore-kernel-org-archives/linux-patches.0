Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2873D15E5A2;
	Tue, 18 Jun 2024 12:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714861; cv=none; b=L8GlGbemHFd1Mf/qA0Fi1vB0mwbL379kKrtCXdsYQSShSUbbM5KE3FcCSJefH73JxKRO2Y3dSqn7TsWVZAziohdQ+wCEdxEuR/5MDH+Q9aqiUzWuLRVP+rAOc9MH7h19DsWhmwBj5vPuKavAoaJEvkdcnLkmw0olUCKRKRLEzNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714861; c=relaxed/simple;
	bh=G3FYv8c7uAKB3ZeJgyrNYvkcTj6GKr8ZHPgR4eXtmP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dHSly0mzbkyO3Vfljfyt1wROhMsSdgA6hat8PYt6N3pvqGsB6GTKKTj5JNNpnTFC4lWNIcf/+sv18QQa5bWUVFqzrhQWYAQki6F1UtVmKadiOTzLtL8RFU6ka7b+OLr8xdX3cHQ5MXe9q3B0+522DAih0NtEbHcCMfU12YcUXlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H95n2noN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H95n2noN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE7BC3277B;
	Tue, 18 Jun 2024 12:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714861;
	bh=G3FYv8c7uAKB3ZeJgyrNYvkcTj6GKr8ZHPgR4eXtmP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H95n2noNHU4nFHtqBqwyTHq0mX1VFMt1NjwZnUvfTnNMIQ/tviiRfmzlyHgDdoF9u
	 ucHqGaDifMgLE7mTzMBu3V63kqYQGMSGvAmT/Msq5MXxxYPu/gTv0QR+wK14en9grA
	 mMg1zSagMZPMhKWra8jqLr2wUiAYhl662JRNEYDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/770] file: Rename __fcheck_files to files_lookup_fd_raw
Date: Tue, 18 Jun 2024 14:29:27 +0200
Message-ID: <20240618123411.671165962@linuxfoundation.org>
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

[ Upstream commit bebf684bf330915e6c96313ad7db89a5480fc9c2 ]

The function fcheck despite it's comment is poorly named
as it has no callers that only check it's return value.
All of fcheck's callers use the returned file descriptor.
The same is true for fcheck_files and __fcheck_files.

A new less confusing name is needed.  In addition the names
of these functions are confusing as they do not report
the kind of locks that are needed to be held when these
functions are called making error prone to use them.

To remedy this I am making the base functio name lookup_fd
and will and prefixes and sufficies to indicate the rest
of the context.

Name the function (previously called __fcheck_files) that proceeds
from a struct files_struct, looks up the struct file of a file
descriptor, and requires it's callers to verify all of the appropriate
locks are held files_lookup_fd_raw.

The need for better names became apparent in the last round of
discussion of this set of changes[1].

[1] https://lkml.kernel.org/r/CAHk-=wj8BQbgJFLa+J0e=iT-1qpmCRTbPAJ8gd6MJQ=kbRPqyQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20201120231441.29911-7-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
[ cel: adjusted to apply to v5.10.y ]
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 4 ++--
 include/linux/fdtable.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index fea693acc065e..eb1e2b7220ac6 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -866,7 +866,7 @@ static struct file *__fget_files(struct files_struct *files, unsigned int fd,
 			file = NULL;
 		else if (!get_file_rcu_many(file, refs))
 			goto loop;
-		else if (__fcheck_files(files, fd) != file) {
+		else if (files_lookup_fd_raw(files, fd) != file) {
 			fput_many(file, refs);
 			goto loop;
 		}
@@ -933,7 +933,7 @@ static unsigned long __fget_light(unsigned int fd, fmode_t mask)
 	struct file *file;
 
 	if (atomic_read(&files->count) == 1) {
-		file = __fcheck_files(files, fd);
+		file = files_lookup_fd_raw(files, fd);
 		if (!file || unlikely(file->f_mode & mask))
 			return 0;
 		return (unsigned long)file;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index c0ca6fb3f0f95..10e75b4c30a43 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -80,7 +80,7 @@ struct dentry;
 /*
  * The caller must ensure that fd table isn't shared or hold rcu or file lock
  */
-static inline struct file *__fcheck_files(struct files_struct *files, unsigned int fd)
+static inline struct file *files_lookup_fd_raw(struct files_struct *files, unsigned int fd)
 {
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
 
@@ -96,7 +96,7 @@ static inline struct file *fcheck_files(struct files_struct *files, unsigned int
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() &&
 			   !lockdep_is_held(&files->file_lock),
 			   "suspicious rcu_dereference_check() usage");
-	return __fcheck_files(files, fd);
+	return files_lookup_fd_raw(files, fd);
 }
 
 /*
-- 
2.43.0



