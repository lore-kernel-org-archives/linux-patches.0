Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42EF91DDE9;
	Thu, 30 Jan 2025 14:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246546; cv=none; b=WCv5LeKhxeMRmrVuC9n5ssdoGURTkoUA6tMIIRGHMXZ1Xwc/ZkMtuWpnRJ2hFJc+rXWYDHxZKQIuZW8TAO3afG1vLHdtcmb+DAdkyh7WkFFHayDmJlMrtmsAF3ztQ8F6oldQqm+Jig/wrRzauMkFHO6DC+G+R4g4qpE5NWGjeZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246546; c=relaxed/simple;
	bh=myyL/K/zUH6FpfcP7ZkrdCb/Ms/q10j5dCW5RVM/T3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4vm54z9wf+rxU5w00gIRDVV3Vw5LD2GgowkudJiKxTlWhf752vpJ5xT54qOiC/mzZndn7Y2ejwLYcyKqUg/liSCXfQxPLQXk2tD0Z8XC/vng/QRCxZCU8juWfRdJNH0EocoTiP2NimeyzlA+zS/6nVIRXVfUFQ9PSJAf3QIasc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qgNS770e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qgNS770e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE07C4CED2;
	Thu, 30 Jan 2025 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246545;
	bh=myyL/K/zUH6FpfcP7ZkrdCb/Ms/q10j5dCW5RVM/T3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qgNS770e3nfsOWFDDS5gA0mYiyudhE3gAimavRynPlqsufRsRAnIn5+vvXlboj6U4
	 6iscK9ES93mWCstAk0ID9vH7Fc737c8KFJQyUAX1qyDbuDDgejnszDAGujBQ/n7XQa
	 gUYCwW6gK4uOslbUuVBMjF2fzoonJLvtd0bpPqsY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudheendra Raghav Neela <sneela@tugraz.at>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.6 29/43] cachestat: fix page cache statistics permission checking
Date: Thu, 30 Jan 2025 14:59:36 +0100
Message-ID: <20250130133500.075179757@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133458.903274626@linuxfoundation.org>
References: <20250130133458.903274626@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4271,6 +4271,20 @@ resched:
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
@@ -4329,6 +4343,11 @@ SYSCALL_DEFINE4(cachestat, unsigned int,
 		return -EOPNOTSUPP;
 	}
 
+	if (!can_do_cachestat(f.file)) {
+		fdput(f);
+		return -EPERM;
+	}
+
 	if (flags != 0) {
 		fdput(f);
 		return -EINVAL;


