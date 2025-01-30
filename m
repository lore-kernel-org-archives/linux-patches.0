Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 572212BB15;
	Thu, 30 Jan 2025 13:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245564; cv=none; b=az8NGVReKAtzU/oOOYRo3t5RckpxWHRSdqVKxxd2uvLS2JACrNs8smLBSx8GXkxwawWbB9Sm8Q57O24SCBsPXfxIhLn5uL4WnEK5nXyIj49iLThOf1dcv8Sc6+HL0CWDligoXC+/fBvf1ZwjXI1ukmDMCT/FcIARYjsb17fblL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245564; c=relaxed/simple;
	bh=kAGM/rdz+pBORgFfGGiFgNYsmP9EGJD9NdyvTJma+6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC8W93gLx09tHD/AmvQT//MPYujIDhm18dG4D91JMXwmyZ3gi7tDQB/P7ZO2TF3IoFXqXt3q+kxs9Oh+iWNzFQ/PRgK2Q2XwQRxDrhjP4gCYGux0xeJUlsyTdLNslR9QdStK2GqEL1JIJmvEAmsuhyU9XnVvsdPqJ6xNWC3f7fo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwmFq+lo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwmFq+lo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98E4C4CED2;
	Thu, 30 Jan 2025 13:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245564;
	bh=kAGM/rdz+pBORgFfGGiFgNYsmP9EGJD9NdyvTJma+6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwmFq+loJw2hDQCmVjMDVxfgkWq7xdvsDIr7H3goGVOHpFFkMus8wwlUq29/P2MZ1
	 yicbsjcYSU7ZCVU3Yb+62NdbzV99PI9D8akWeCWUb+97GX4vwYY5onGgkoSq2xrCmP
	 QRUL1cOa1UIH/kNVLXSql/5v09UlnW9RmtgZwNCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheendra Raghav Neela <sneela@tugraz.at>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.13 10/25] cachestat: fix page cache statistics permission checking
Date: Thu, 30 Jan 2025 14:58:56 +0100
Message-ID: <20250130133457.343862392@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
References: <20250130133456.914329400@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 5f537664e705b0bf8b7e329861f20128534f6a83 upstream.

When the 'cachestat()' system call was added in commit cf264e1329fb
("cachestat: implement cachestat syscall"), it was meant to be a much
more convenient (and performant) version of mincore() that didn't need
mapping things into the user virtual address space in order to work.

But it ended up missing the "check for writability or ownership" fix for
mincore(), done in commit 134fca9063ad ("mm/mincore.c: make mincore()
more conservative").

This just adds equivalent logic to 'cachestat()', modified for the file
context (rather than vma).

Reported-by: Sudheendra Raghav Neela <sneela@tugraz.at>
Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
Tested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4376,6 +4376,20 @@ resched:
 }
 
 /*
+ * See mincore: reveal pagecache information only for files
+ * that the calling process has write access to, or could (if
+ * tried) open for writing.
+ */
+static inline bool can_do_cachestat(struct file *f)
+{
+	if (f->f_mode & FMODE_WRITE)
+		return true;
+	if (inode_owner_or_capable(file_mnt_idmap(f), file_inode(f)))
+		return true;
+	return file_permission(f, MAY_WRITE) == 0;
+}
+
+/*
  * The cachestat(2) system call.
  *
  * cachestat() returns the page cache statistics of a file in the
@@ -4430,6 +4444,9 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 	if (is_file_hugepages(fd_file(f)))
 		return -EOPNOTSUPP;
 
+	if (!can_do_cachestat(fd_file(f)))
+		return -EPERM;
+
 	if (flags != 0)
 		return -EINVAL;
 


