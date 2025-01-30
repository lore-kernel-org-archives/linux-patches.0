Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8431E3775;
	Thu, 30 Jan 2025 14:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245734; cv=none; b=EWqJ+NY7cqZjUC6iPrM5Z31Pjiv7VkFpCDBP7PKJ7O/A4VcXRiaLlioqC9etltllsuNQrIW+vypJn/lPUXm2o9I3vTDtggwbRcWkXPaIy9F2W3k/55GyVAqA4ok+WsYYZ8ljJhbDFyndhP9NMj/e8fyQ+NvxgRzcl0CwYSslFVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245734; c=relaxed/simple;
	bh=jBxKXjv5bfoO27IkKorB8hM5iaIADC375WXWGtH4bE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D7d9zj/UzTGK3o6+yxtaLq6ABgZmeSA4cwqcINBgKPwtcLXi20NJ7NV3tgpu8g5Fmwf0m2XkLbyOEQEJgEv8vhA6dhxvTnuxp1ULOBNr2Y2vnCQy4WKD4xkj/0DpOxkjjy1po/G2Kz84JQkAUOWprPs3iYyEZITpmm4KvfNUv2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0uaVxsrS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0uaVxsrS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB06C4CED2;
	Thu, 30 Jan 2025 14:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245734;
	bh=jBxKXjv5bfoO27IkKorB8hM5iaIADC375WXWGtH4bE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0uaVxsrSW1ACab1QLbr9tuMgyznE9EemKTzGB04rzYjCmgLltKd83Qff44KfUxbza
	 82afnvQ0HYL2D3DYrIcUjkPPWsSYakY6s+7Kzhek3juPWzjczwcdWXfZZszKnagRCz
	 2YkZcoDexMi5y+kf9S8xV/icLxN5H+X95/0E1FmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheendra Raghav Neela <sneela@tugraz.at>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.12 26/40] cachestat: fix page cache statistics permission checking
Date: Thu, 30 Jan 2025 14:59:26 +0100
Message-ID: <20250130133500.754796018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 mm/filemap.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -4384,6 +4384,20 @@ resched:
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
@@ -4442,6 +4456,11 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 		return -EOPNOTSUPP;
 	}
 
+	if (!can_do_cachestat(fd_file(f))) {
+		fdput(f);
+		return -EPERM;
+	}
+
 	if (flags != 0) {
 		fdput(f);
 		return -EINVAL;


