Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0EE1C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC758C433D6;
	Wed, 23 Nov 2022 09:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194674;
	bh=UZRt8IoWPhF7g7NjvxY+QSSbykdytTRY1M0UPlzj3+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoM4lERC7raS68+xW7nbXgMd67CnspaSoElod8sk17wPuEufuSiN5CxcM+aHGtc6D
	 1e0UgJKfFEE4WMpmzI0IGntasrfNRRSbqQHbX7O4K4H/c7Sder+kG30zezushFQ89I
	 JKItRBndzftWkDwnjCl2B+cHtFIpQsxyI35dwP+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Brian Foster <bfoster@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: [PATCH 5.4 004/156] xfs: use MMAPLOCK around filemap_map_pages()
Date: Wed, 23 Nov 2022 09:49:21 +0100
Message-Id: <20221123084558.001361802@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dave Chinner <dchinner@redhat.com>

commit cd647d5651c0b0deaa26c1acb9e1789437ba9bc7 upstream.

The page faultround path ->map_pages is implemented in XFS via
filemap_map_pages(). This function checks that pages found in page
cache lookups have not raced with truncate based invalidation by
checking page->mapping is correct and page->index is within EOF.

However, we've known for a long time that this is not sufficient to
protect against races with invalidations done by operations that do
not change EOF. e.g. hole punching and other fallocate() based
direct extent manipulations. The way we protect against these
races is we wrap the page fault operations in a XFS_MMAPLOCK_SHARED
lock so they serialise against fallocate and truncate before calling
into the filemap function that processes the fault.

Do the same for XFS's ->map_pages implementation to close this
potential data corruption issue.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Acked-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandan.babu@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_file.c |   15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1267,10 +1267,23 @@ xfs_filemap_pfn_mkwrite(
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
+static void
+xfs_filemap_map_pages(
+	struct vm_fault		*vmf,
+	pgoff_t			start_pgoff,
+	pgoff_t			end_pgoff)
+{
+	struct inode		*inode = file_inode(vmf->vma->vm_file);
+
+	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+	filemap_map_pages(vmf, start_pgoff, end_pgoff);
+	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
+}
+
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.huge_fault	= xfs_filemap_huge_fault,
-	.map_pages	= filemap_map_pages,
+	.map_pages	= xfs_filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };


