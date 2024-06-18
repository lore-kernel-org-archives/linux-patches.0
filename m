Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB40413A409;
	Tue, 18 Jun 2024 12:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718714899; cv=none; b=tD5ubzeRH0oVpi/VeWH1LbCNfbFzJPrm06kKZF1A1glKTJe8SfroayEM4rCoyOUbieH+mf+IGZXvcbwnarlsQ2Q4J209vg6FsBwG8o3sCrFPZKYZHYzFzKwk3OfziRzrNIJACZyc9/hIoL7agidMtKu5psQuXujoKFpT+PN3hNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718714899; c=relaxed/simple;
	bh=zSLaqsn/fRWsubYjgrThozMrUfQaL62TTc2BCQYZeDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyBOvKPbSa8cEjxZj3hyzgj/DsC7H92R666F8nukLZRqPyQqIjAtY5Ru2+XPZ/HvGm06o8/p8GTQqt7tyvAuh2C12xpn9jfqF23Jwk9tH7+TCym9hP84DzD3lSAuaBTZpJD5G441QGxJ3TBkaK7Zk08tB15xPDA0tbXTSApm9y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=12Bgfmn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12Bgfmn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA33C3277B;
	Tue, 18 Jun 2024 12:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718714899;
	bh=zSLaqsn/fRWsubYjgrThozMrUfQaL62TTc2BCQYZeDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12Bgfmn0/geaztJJxGvu4wO7MuwdrrSKdOPWe+cDVcFKw3NAtGWHCK7/6ZmshpvAo
	 QhleJ+KxFedy//4cht6ROlmo6IS1kxSsVVaWwk61YSzZbAO5jvxIW7rCanVpXnOPmx
	 OVjNcYj+MnHWxvnbD4VCGBOJlSKzrGyn0rq4igRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/770] file: Merge __alloc_fd into alloc_fd
Date: Tue, 18 Jun 2024 14:29:39 +0200
Message-ID: <20240618123412.139508749@linuxfoundation.org>
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

[ Upstream commit aa384d10f3d06d4b85597ff5df41551262220e16 ]

The function __alloc_fd was added to support binder[1].  With binder
fixed[2] there are no more users.

As alloc_fd just calls __alloc_fd with "files=current->files",
merge them together by transforming the files parameter into a
local variable initialized to current->files.

[1] dcfadfa4ec5a ("new helper: __alloc_fd()")
[2] 44d8047f1d87 ("binder: use standard functions to allocate fds")
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
v1: https://lkml.kernel.org/r/20200817220425.9389-16-ebiederm@xmission.com
Link: https://lkml.kernel.org/r/20201120231441.29911-20-ebiederm@xmission.com
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/file.c               | 11 +++--------
 include/linux/fdtable.h |  2 --
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 9e2b171b92520..48d0306e42ccc 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -509,9 +509,9 @@ static unsigned int find_next_fd(struct fdtable *fdt, unsigned int start)
 /*
  * allocate a file descriptor, mark it busy.
  */
-int __alloc_fd(struct files_struct *files,
-	       unsigned start, unsigned end, unsigned flags)
+static int alloc_fd(unsigned start, unsigned end, unsigned flags)
 {
+	struct files_struct *files = current->files;
 	unsigned int fd;
 	int error;
 	struct fdtable *fdt;
@@ -567,14 +567,9 @@ int __alloc_fd(struct files_struct *files,
 	return error;
 }
 
-static int alloc_fd(unsigned start, unsigned end, unsigned flags)
-{
-	return __alloc_fd(current->files, start, end, flags);
-}
-
 int __get_unused_fd_flags(unsigned flags, unsigned long nofile)
 {
-	return __alloc_fd(current->files, 0, nofile, flags);
+	return alloc_fd(0, nofile, flags);
 }
 
 int get_unused_fd_flags(unsigned flags)
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 6e8743a4c9d31..d26b884fcc5cc 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -124,8 +124,6 @@ int iterate_fd(struct files_struct *, unsigned,
 		int (*)(const void *, struct file *, unsigned),
 		const void *);
 
-extern int __alloc_fd(struct files_struct *files,
-		      unsigned start, unsigned end, unsigned flags);
 extern int __close_fd(struct files_struct *files,
 		      unsigned int fd);
 extern int __close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
-- 
2.43.0



