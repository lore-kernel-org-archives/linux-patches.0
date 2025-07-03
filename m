Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4CB15442C;
	Thu,  3 Jul 2025 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556241; cv=none; b=ttA7yrdk4I3W+tJr2vFycpHIW0SDwI+2PNtT7ro131ndKakq67m5681sfIzq1vJpNNe/2fJdm75XpItp3S/r5MD2YBP18r8EuBRHcjG/2u46Y72k2w1ZmoGqQdE+r+le6mc+3DE3ubKPYec1TDPYnaaEJtCgPLIllCs0DKirsF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556241; c=relaxed/simple;
	bh=N9ruSI4utnlQrfZXzzy9lNUBOHOvVwfGQ8qaseKbPEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPhJkDwCbSkS4cRbRJYi2nTDOS6WvO69dVGcVDqnlnOEsd57io6NNwxoB6zA+bOxM8fTsnUSfKWW4I9HrYohtKCo/5QeH50gnzt3hujWctRPHzieYwPBqnKafMmje6niEo0ZiwqTx6BuPyS8EdFQGI1l1m6ttP5gHxQIKozTgWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRb5rGJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRb5rGJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FFFC4CEEE;
	Thu,  3 Jul 2025 15:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556240;
	bh=N9ruSI4utnlQrfZXzzy9lNUBOHOvVwfGQ8qaseKbPEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRb5rGJsybeq8kshEv7elbwyp8eq2mGQ+StFpT1myPbRwAv5/ORHYsLylL2uYh1lB
	 9280JHEZmCoRk7OoqSWJUiY6DqNybl/kL2hUtjB+/tIwkz3igLp4+v81i+MouyEyF4
	 yEYlINjp6qQ3FZT5wRxzS3C3aGGTrWaq5L1J3GvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 6.1 118/132] fs: omfs: Use flexible-array member in struct omfs_extent
Date: Thu,  3 Jul 2025 16:43:27 +0200
Message-ID: <20250703143944.023225915@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo A. R. Silva <gustavoars@kernel.org>

commit 4d8cbf6dbcdaebe949461b0a933ae4c71cb53edc upstream.

Memory for 'struct omfs_extent' and a 'e_extent_count' number of extent
entries is indirectly allocated through 'bh->b_data', which is a pointer
to data within the page. This implies that the member 'e_entry'
(which is the start of extent entries) functions more like an array than
a single object of type 'struct omfs_extent_entry'.

So we better turn this object into a proper array, in this case a
flexible-array member, and with that, fix the following
-Wstringop-overflow warning seen after building s390 architecture with
allyesconfig (GCC 13):

fs/omfs/file.c: In function 'omfs_grow_extent':
include/linux/fortify-string.h:57:33: warning: writing 16 bytes into a region of size 0 [-Wstringop-overflow=]
   57 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:648:9: note: in expansion of macro '__underlying_memcpy'
  648 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:693:26: note: in expansion of macro '__fortify_memcpy_chk'
  693 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
fs/omfs/file.c:170:9: note: in expansion of macro 'memcpy'
  170 |         memcpy(terminator, entry, sizeof(struct omfs_extent_entry));
      |         ^~~~~~
In file included from fs/omfs/omfs.h:8,
                 from fs/omfs/file.c:11:
fs/omfs/omfs_fs.h:80:34: note: at offset 16 into destination object 'e_entry' of size 16
   80 |         struct omfs_extent_entry e_entry;       /* start of extent entries */
      |                                  ^~~~~~~

There are some binary differences before and after changes, but this are
expected due to the change in the size of 'struct omfs_extent' and the
necessary adjusments.

This helps with the ongoing efforts to globally enable
-Wstringop-overflow.

Link: https://github.com/KSPP/linux/issues/330
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/omfs/file.c    |   12 ++++++------
 fs/omfs/omfs_fs.h |    2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -14,7 +14,7 @@ static u32 omfs_max_extents(struct omfs_
 {
 	return (sbi->s_sys_blocksize - offset -
 		sizeof(struct omfs_extent)) /
-		sizeof(struct omfs_extent_entry) + 1;
+		sizeof(struct omfs_extent_entry);
 }
 
 void omfs_make_empty_table(struct buffer_head *bh, int offset)
@@ -24,8 +24,8 @@ void omfs_make_empty_table(struct buffer
 	oe->e_next = ~cpu_to_be64(0ULL);
 	oe->e_extent_count = cpu_to_be32(1),
 	oe->e_fill = cpu_to_be32(0x22),
-	oe->e_entry.e_cluster = ~cpu_to_be64(0ULL);
-	oe->e_entry.e_blocks = ~cpu_to_be64(0ULL);
+	oe->e_entry[0].e_cluster = ~cpu_to_be64(0ULL);
+	oe->e_entry[0].e_blocks = ~cpu_to_be64(0ULL);
 }
 
 int omfs_shrink_inode(struct inode *inode)
@@ -68,7 +68,7 @@ int omfs_shrink_inode(struct inode *inod
 
 		last = next;
 		next = be64_to_cpu(oe->e_next);
-		entry = &oe->e_entry;
+		entry = oe->e_entry;
 
 		/* ignore last entry as it is the terminator */
 		for (; extent_count > 1; extent_count--) {
@@ -117,7 +117,7 @@ static int omfs_grow_extent(struct inode
 			u64 *ret_block)
 {
 	struct omfs_extent_entry *terminator;
-	struct omfs_extent_entry *entry = &oe->e_entry;
+	struct omfs_extent_entry *entry = oe->e_entry;
 	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
 	u32 extent_count = be32_to_cpu(oe->e_extent_count);
 	u64 new_block = 0;
@@ -245,7 +245,7 @@ static int omfs_get_block(struct inode *
 
 		extent_count = be32_to_cpu(oe->e_extent_count);
 		next = be64_to_cpu(oe->e_next);
-		entry = &oe->e_entry;
+		entry = oe->e_entry;
 
 		if (extent_count > max_extents)
 			goto out_brelse;
--- a/fs/omfs/omfs_fs.h
+++ b/fs/omfs/omfs_fs.h
@@ -77,7 +77,7 @@ struct omfs_extent {
 	__be64 e_next;			/* next extent table location */
 	__be32 e_extent_count;		/* total # extents in this table */
 	__be32 e_fill;
-	struct omfs_extent_entry e_entry;	/* start of extent entries */
+	struct omfs_extent_entry e_entry[];	/* start of extent entries */
 };
 
 #endif


