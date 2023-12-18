Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEA74988E;
	Mon, 18 Dec 2023 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y1XL98m+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0312DC433C8;
	Mon, 18 Dec 2023 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908125;
	bh=gGotgVnBcv4JRMSgT0BLYmYE85yKCmBtkOa6ETBTOTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y1XL98m+imI7v5I/zBOZ3VP4FjGLiM1xX8deEhFdBAmOMBCALvwCpHVfz58Ax8LDr
	 Cnwq02C4h9oQ0y84y1wkH2sH5rVhc/h1UtfnAB/Cja2LWt831IEDyvKr9RvAJMDjcu
	 o9odjOY1xRNsMnOGEmk0dj5qiyDgjjZA7vjBLXJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 063/166] fuse: disable FOPEN_PARALLEL_DIRECT_WRITES with FUSE_DIRECT_IO_ALLOW_MMAP
Date: Mon, 18 Dec 2023 14:50:29 +0100
Message-ID: <20231218135107.862049034@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
References: <20231218135104.927894164@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 3f29f1c336c0e8a4bec52f1e5217f88835553e5b upstream.

The new fuse init flag FUSE_DIRECT_IO_ALLOW_MMAP breaks assumptions made by
FOPEN_PARALLEL_DIRECT_WRITES and causes test generic/095 to hit
BUG_ON(fi->writectr < 0) assertions in fuse_set_nowrite():

generic/095 5s ...
  kernel BUG at fs/fuse/dir.c:1756!
...
  ? fuse_set_nowrite+0x3d/0xdd
  ? do_raw_spin_unlock+0x88/0x8f
  ? _raw_spin_unlock+0x2d/0x43
  ? fuse_range_is_writeback+0x71/0x84
  fuse_sync_writes+0xf/0x19
  fuse_direct_io+0x167/0x5bd
  fuse_direct_write_iter+0xf0/0x146

Auto disable FOPEN_PARALLEL_DIRECT_WRITES when server negotiated
FUSE_DIRECT_IO_ALLOW_MMAP.

Fixes: e78662e818f9 ("fuse: add a new fuse init flag to relax restrictions in no cache mode")
Cc: <stable@vger.kernel.org> # v6.6
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 89e870d1a526..a660f1f21540 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -1574,6 +1574,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	ssize_t res;
 	bool exclusive_lock =
 		!(ff->open_flags & FOPEN_PARALLEL_DIRECT_WRITES) ||
+		get_fuse_conn(inode)->direct_io_allow_mmap ||
 		iocb->ki_flags & IOCB_APPEND ||
 		fuse_direct_write_extending_i_size(iocb, from);
 
@@ -1581,6 +1582,7 @@ static ssize_t fuse_direct_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	 * Take exclusive lock if
 	 * - Parallel direct writes are disabled - a user space decision
 	 * - Parallel direct writes are enabled and i_size is being extended.
+	 * - Shared mmap on direct_io file is supported (FUSE_DIRECT_IO_ALLOW_MMAP).
 	 *   This might not be needed at all, but needs further investigation.
 	 */
 	if (exclusive_lock)
-- 
2.43.0



