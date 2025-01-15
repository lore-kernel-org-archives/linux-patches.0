Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918E21E98FA;
	Wed, 15 Jan 2025 10:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937918; cv=none; b=G9pamapJclxOsXt1gnQwVrFrrwmRQVE7/KXIxnOh+wUbTVLiMei2yIW/4EgLDy5vOZUM3mLu1djJJWidJmRBIuUae6gJKdQRVlJd2oPLlHUwlXngkgwMvoYGeZDDBEcoMT9Q7T43kjPg2g5IavpXvapFPgYF2uVw9F92s3qQB/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937918; c=relaxed/simple;
	bh=Y0R5b6+j3yv/njmmZ9SExVUPpS7IeKztbaeXaqU1ZoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KK+8K+Wx8nVILCgP5m4el1YE6x+7oom8VwnJpaEOkBh/j049+xStO4B4TA3KB5UrUz6ceZFqy74I0oAEoV0I7hUmxf9M0Z5EXXMZYk1fm/yUuELx7a1Lgkc71R6b0/OtA6JprmvkKxh1zeMBFw266WBIkF8JjKsE1IyuudjKnvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCmCmHor; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCmCmHor"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE851C4CEDF;
	Wed, 15 Jan 2025 10:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937918;
	bh=Y0R5b6+j3yv/njmmZ9SExVUPpS7IeKztbaeXaqU1ZoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCmCmHor/iS4l2QMox43pSN4nab632sVhOynzNschxkacVF1PtVuTm8O+nyE2fg4j
	 N3Dy/enfwpAO5venYRyeW+EdCe4XiNi3UpFPyjhpX04xLTftIUw9LejEInlWN6uicH
	 XieCjGCQlhesrnMt/rF7hoCxwIuCxpLrPSO6L9uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Li <leo.lilong@huawei.com>,
	Brian Foster <bfoster@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/189] iomap: fix zero padding data issue in concurrent append writes
Date: Wed, 15 Jan 2025 11:35:01 +0100
Message-ID: <20250115103606.571186439@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Long Li <leo.lilong@huawei.com>

[ Upstream commit 51d20d1dacbec589d459e11fc88fbca419f84a99 ]

During concurrent append writes to XFS filesystem, zero padding data
may appear in the file after power failure. This happens due to imprecise
disk size updates when handling write completion.

Consider this scenario with concurrent append writes same file:

  Thread 1:                  Thread 2:
  ------------               -----------
  write [A, A+B]
  update inode size to A+B
  submit I/O [A, A+BS]
                             write [A+B, A+B+C]
                             update inode size to A+B+C
  <I/O completes, updates disk size to min(A+B+C, A+BS)>
  <power failure>

After reboot:
  1) with A+B+C < A+BS, the file has zero padding in range [A+B, A+B+C]

  |<         Block Size (BS)      >|
  |DDDDDDDDDDDDDDDD0000000000000000|
  ^               ^        ^
  A              A+B     A+B+C
                         (EOF)

  2) with A+B+C > A+BS, the file has zero padding in range [A+B, A+BS]

  |<         Block Size (BS)      >|<           Block Size (BS)    >|
  |DDDDDDDDDDDDDDDD0000000000000000|00000000000000000000000000000000|
  ^               ^                ^               ^
  A              A+B              A+BS           A+B+C
                                  (EOF)

  D = Valid Data
  0 = Zero Padding

The issue stems from disk size being set to min(io_offset + io_size,
inode->i_size) at I/O completion. Since io_offset+io_size is block
size granularity, it may exceed the actual valid file data size. In
the case of concurrent append writes, inode->i_size may be larger
than the actual range of valid file data written to disk, leading to
inaccurate disk size updates.

This patch modifies the meaning of io_size to represent the size of
valid data within EOF in an ioend. If the ioend spans beyond i_size,
io_size will be trimmed to provide the file with more accurate size
information. This is particularly useful for on-disk size updates
at completion time.

After this change, ioends that span i_size will not grow or merge with
other ioends in concurrent scenarios. However, these cases that need
growth/merging rarely occur and it seems no noticeable performance impact.
Although rounding up io_size could enable ioend growth/merging in these
scenarios, we decided to keep the code simple after discussion [1].

Another benefit is that it makes the xfs_ioend_is_append() check more
accurate, which can reduce unnecessary end bio callbacks of xfs_end_bio()
in certain scenarios, such as repeated writes at the file tail without
extending the file size.

Link [1]: https://patchwork.kernel.org/project/xfs/patch/20241113091907.56937-1-leo.lilong@huawei.com

Fixes: ae259a9c8593 ("fs: introduce iomap infrastructure") # goes further back than this
Signed-off-by: Long Li <leo.lilong@huawei.com>
Link: https://lore.kernel.org/r/20241209114241.3725722-3-leo.lilong@huawei.com
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/iomap/buffered-io.c | 45 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/iomap.h  |  2 +-
 2 files changed, 46 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 05e5cc3bf976..25d1ede6bb0e 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1784,7 +1784,52 @@ static int iomap_add_to_ioend(struct iomap_writepage_ctx *wpc,
 
 	if (ifs)
 		atomic_add(len, &ifs->write_bytes_pending);
+
+	/*
+	 * Clamp io_offset and io_size to the incore EOF so that ondisk
+	 * file size updates in the ioend completion are byte-accurate.
+	 * This avoids recovering files with zeroed tail regions when
+	 * writeback races with appending writes:
+	 *
+	 *    Thread 1:                  Thread 2:
+	 *    ------------               -----------
+	 *    write [A, A+B]
+	 *    update inode size to A+B
+	 *    submit I/O [A, A+BS]
+	 *                               write [A+B, A+B+C]
+	 *                               update inode size to A+B+C
+	 *    <I/O completes, updates disk size to min(A+B+C, A+BS)>
+	 *    <power failure>
+	 *
+	 *  After reboot:
+	 *    1) with A+B+C < A+BS, the file has zero padding in range
+	 *       [A+B, A+B+C]
+	 *
+	 *    |<     Block Size (BS)   >|
+	 *    |DDDDDDDDDDDD0000000000000|
+	 *    ^           ^        ^
+	 *    A          A+B     A+B+C
+	 *                       (EOF)
+	 *
+	 *    2) with A+B+C > A+BS, the file has zero padding in range
+	 *       [A+B, A+BS]
+	 *
+	 *    |<     Block Size (BS)   >|<     Block Size (BS)    >|
+	 *    |DDDDDDDDDDDD0000000000000|00000000000000000000000000|
+	 *    ^           ^             ^           ^
+	 *    A          A+B           A+BS       A+B+C
+	 *                             (EOF)
+	 *
+	 *    D = Valid Data
+	 *    0 = Zero Padding
+	 *
+	 * Note that this defeats the ability to chain the ioends of
+	 * appending writes.
+	 */
 	wpc->ioend->io_size += len;
+	if (wpc->ioend->io_offset + wpc->ioend->io_size > end_pos)
+		wpc->ioend->io_size = end_pos - wpc->ioend->io_offset;
+
 	wbc_account_cgroup_owner(wbc, folio, len);
 	return 0;
 }
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index f61407e3b121..d204dcd35063 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -330,7 +330,7 @@ struct iomap_ioend {
 	u16			io_type;
 	u16			io_flags;	/* IOMAP_F_* */
 	struct inode		*io_inode;	/* file being written to */
-	size_t			io_size;	/* size of the extent */
+	size_t			io_size;	/* size of data within eof */
 	loff_t			io_offset;	/* offset in the file */
 	sector_t		io_sector;	/* start sector of ioend */
 	struct bio		io_bio;		/* MUST BE LAST! */
-- 
2.39.5



