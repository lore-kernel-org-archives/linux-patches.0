Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030020;
	b=MHTeVVHq1TrucsKna2j8rZln8sz1za2Iq9AOBx7VJpey6lWEu2UI57moJDRoOnGnQtbl
	 ugPIJigTmbaRsftTudVrXVmTiWOzbI5KXEk6an8qbJfknrgkAXrsUReThzeI76pSVVSx2
	 ZOgJHRVBp451++RcoEDBvaSY2B9ttj3Os2w8PH8Tq+QdBpdmsNIRUm6LdbmK1xbR27M2H
	 +/d4gUFo7+9m0eYBWaM0KQyYctpHZX4oomvD16iPne3ZebQjJhlSKzQXiDdgIdwxrGCbo
	 Z5Yl5HaToGqlAijM4xx5ZE9YH8kunfoiWbqqO+1omgaIPB1UXNCCQe6JQvs7yS6mOdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gx/s4QVMMaibRILgjdDI8sRmSVzIYqBlAU6Fyifzpt4=;
	b=BIovbSX7tK25XrjMTdOJ8SPU8E2eYv9p4EDy48A2jyktfwqyj4deDxcAoS+j9tXUU5B0
	 uEoNlMXmSD0jufOGkyT4a1WfyOHWnEJ2kvygT8230OCvLVCSzG/XAH7/hSSdW6QaXbQNg
	 BOGpU/rZpL2lVQoH6Tw/MRXL1tuHe4L7C7uoEqtBCA/H9T2hp6ACY8SvS3QcoBK4SEuYP
	 mr4/Rg3La1xy1ZaJrdPWbVwejY1z+Zm+Aw8zklMOKF09UIRemXHk2/DWQ3haRkpBve+qJ
	 AmyQ98Qmskxkeif7HoiedeuV8WspqLk/ePs/LYXCHxUewjhnUiNbtkdDlIeb7IKu9yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPTqrZ8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395C5606A31C;
	Wed, 18 Nov 2026 19:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UPTqrZ8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBB21F000C4;
	Wed, 18 Nov 2026 19:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030020;
	bh=gx/s4QVMMaibRILgjdDI8sRmSVzIYqBlAU6Fyifzpt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UPTqrZ8EnMf2jnVBOy7ZQObvGrz+XMKjniDEEiaYKQGTc311BYfn6xaNSDs57OZ00
	 oG5uzJklhpTxR8rsZCUPPy2GH3OGtR7L3S1lj9nBBVpwzGwgWJG4hoB/rcXyiXDH/+
	 Jmpq3NwuUz5Ttch9HAbC4ejDBrvX7ogUhHaVzTV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0554/1756] ext2: drain in-flight DIO before buffered write fallback
Date: Wed, 18 Nov 2026 15:44:41 +0100
Message-ID: <20261118150031.168252345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 1e2ef9f221e142ed19d874a71b2cae7fabbaf138 ]

An asynchronous direct write can remain in flight after the inode lock is
released.  If another direct write falls back to buffered I/O while the
first write is still pending, generic_perform_write() can dirty pages
before the first write completes its post-I/O page cache invalidation.
The invalidation then finds dirty pages, reports a page cache invalidation
failure, and records -EIO in the mapping error sequence.  A later fsync()
therefore returns -EIO.

Commit 15cdefd0c0522f9d5e12d947fa04f4c11649b699 ("ext4: drain
in-flight DIO before buffered write fallback") fixed the same race in
ext4.  Ext2 has an equivalent fallback after iomap_dio_rw() returns
-ENOTBLK or a short write, but does not drain other in-flight DIO before
dirtying the page cache.

Wait for in-flight DIO before calling generic_perform_write() in the
fallback path.

A reproducer using concurrent AIO direct writes and buffered fallback
triggered the following warning and made a subsequent fsync() return
-EIO:

  Page cache invalidation failure on direct I/O.  Possible data corruption
  due to collision with buffered I/O!

Fixes: fb5de4358e1a ("ext2: Move direct-io to use iomap")
Link: https://lore.kernel.org/r/20260629113827.4074335-3-libaokun@linux.alibaba.com
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260924105125.577714-2-yaojiale02@163.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext2/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 0f047c33e0feb..ca5466fbc79d0 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -251,6 +251,13 @@ static ssize_t ext2_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		int ret2;
 
 		iocb->ki_flags &= ~IOCB_DIRECT;
+
+		/*
+		 * Prevent concurrent direct I/O and buffered I/O to the same file
+		 * range. Wait for in-flight DIO to finish before dirtying pages.
+		 */
+		inode_dio_wait(inode);
+
 		pos = iocb->ki_pos;
 		status = generic_perform_write(iocb, from);
 		if (unlikely(status < 0)) {
-- 
2.53.0



