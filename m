Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDA613A409;
	Tue, 18 Jun 2024 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714896; cv=none; b=A9CZb18YkpDL86WsnyfzB9nlG4g9Z5UgZXn6PhuSP8WAf3nOv3aeGjFwZZqMWo84xDpIozZnae15xPJ9k+vpNHLdSbBO57jWtnfwCDwgJh+tH5TbqVAGEALYOt4K+p7XSbfvLVSgQHLFiU/aUGjOE+YOYt8meEKtWY9AFTAeutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714896; c=relaxed/simple;
	bh=kEfE1YMA2ZY297nPPEzm4ccJ6rgxkXyfEyubvKeKBn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA+DKMJQsav0o6l7Pp8oqfzJUk9KefWJnSOtlb6YjEEzhEl2xCzVelorEnFt1y+qLB57Hc+VYNOFaC8t4FDxZprN2QLTP4vCP5wQMhIvjQ1nG/lFz5+yMtb61NTV7i4FKIA/jtkdleafLOyhWyO2QEO02SGmhE8UCIkG5dvBkpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zoy/DbYD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zoy/DbYD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BE0C3277B;
	Tue, 18 Jun 2024 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714896;
	bh=kEfE1YMA2ZY297nPPEzm4ccJ6rgxkXyfEyubvKeKBn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zoy/DbYDtqacR+E/KbGlDpkA4i4AmLWIUTBi6iW3G0GpXT95Y4o4eyp8FjnAa/l+2
	 JLD19uf6388aTdy3/3hg3RhxHtinYZL+ZNe1fH9ClznPd1IRVgfeOXsHqeQRCD5xxE
	 RLMCQc1OeUKeqrrqncea1d295vnNbi8/no7dO5oQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 125/770] file: In f_dupfd read RLIMIT_NOFILE once.
Date: Tue, 18 Jun 2024 14:29:38 +0200
Message-ID: <20240618123412.096298377@linuxfoundation.org>
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

Simplify the code, and remove the chance of races by reading
RLIMIT_NOFILE only once in f_dupfd.

Pass the read value of RLIMIT_NOFILE into alloc_fd which is the other
location the rlimit was read in f_dupfd.  As f_dupfd is the only
caller of alloc_fd this changing alloc_fd is trivially safe.

Further this causes alloc_fd to take all of the same arguments as
__alloc_fd except for the files_struct argument.

Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-15-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-19-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index a80deabe7f7dc..9e2b171b92520 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -567,9 +567,9 @@ int __alloc_fd(struct files_struct *files,
 	return error;
 }
 
-static int alloc_fd(unsigned start, unsigned flags)
+static int alloc_fd(unsigned start, unsigned end, unsigned flags)
 {
-	return __alloc_fd(current->files, start, rlimit(RLIMIT_NOFILE), flags);
+	return __alloc_fd(current->files, start, end, flags);
 }
 
 int __get_unused_fd_flags(unsigned flags, unsigned long nofile)
@@ -1235,10 +1235,11 @@ SYSCALL_DEFINE1(dup, unsigned int, fildes)
 
 int f_dupfd(unsigned int from, struct file *file, unsigned flags)
 {
+	unsigned long nofile = rlimit(RLIMIT_NOFILE);
 	int err;
-	if (from >= rlimit(RLIMIT_NOFILE))
+	if (from >= nofile)
 		return -EINVAL;
-	err = alloc_fd(from, flags);
+	err = alloc_fd(from, nofile, flags);
 	if (err >= 0) {
 		get_file(file);
 		fd_install(err, file);
-- 
2.43.0



