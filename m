Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C558B238C21;
	Tue, 29 Apr 2025 17:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948327; cv=none; b=C6EO5XyXWQj22Ivf3Muomwy7R6sjFRbWK0nAX69q1mAZV31Q4J5xJ/l08ukJNBfHMP1tr1CnoieZgbl66L0frn7pcsQ20AXTXwnhXl80BD60JlCSTUhvZNoVJzLzHGS2LcrGLa6M1G2nC+rMYg3G/D4K1VhyqJxXDuNBmS2aLMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948327; c=relaxed/simple;
	bh=fCzUAGNlekbak1W8W76NRsCtdQw2gKudaGzTaKIybKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIK/i6RCB+T40ZUdjFGQKdas/ZhU2IrY8tvSiedrYHtbXsMoEay1juqHST9brLsxMTBa2uxtZq8pLSZF/aWIl3rVlxD+ljD+lB+nm68ZT1YovIhrrpf1Y82GuD7LH96YsUzhOix2fssrHPWIQxz39EpINSei31Tc1T2SyNp/TFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I6uGi3Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I6uGi3Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 849FEC4CEE3;
	Tue, 29 Apr 2025 17:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948327;
	bh=fCzUAGNlekbak1W8W76NRsCtdQw2gKudaGzTaKIybKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I6uGi3Gue674epYlro7W5/Ca6bJhDUC52/CVaH2w+KIgw1z/B+UiSuKmbcixoP46f
	 +eqqicsUtFbXiJLFc0est7YCPsEny0ezqHz/iJtKiVxDXEtYjQtlh4oqtcBSwhBu4s
	 nvrArwnaUeDoJ8rNZi2rOhgFSi/Pj5MgE7/tVVJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.12 254/280] xfs: flush inodegc before swapon
Date: Tue, 29 Apr 2025 18:43:15 +0200
Message-ID: <20250429161125.526839090@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

Commit 2d873efd174bae9005776937d5ac6a96050266db upstream

Fix the brand new xfstest that tries to swapon on a recently unshared
file and use the chance to document the other bit of magic in this
function.

The big comment is taken from a mailinglist post by Dave Chinner.

Fixes: 5e672cd69f0a53 ("xfs: introduce xfs_inodegc_push()")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |   35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)


--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -19,6 +19,7 @@
 #include "xfs_reflink.h"
 #include "xfs_errortag.h"
 #include "xfs_error.h"
+#include "xfs_icache.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -533,7 +534,39 @@ xfs_vm_swap_activate(
 	struct file			*swap_file,
 	sector_t			*span)
 {
-	sis->bdev = xfs_inode_buftarg(XFS_I(file_inode(swap_file)))->bt_bdev;
+	struct xfs_inode		*ip = XFS_I(file_inode(swap_file));
+
+	/*
+	 * Swap file activation can race against concurrent shared extent
+	 * removal in files that have been cloned.  If this happens,
+	 * iomap_swapfile_iter() can fail because it encountered a shared
+	 * extent even though an operation is in progress to remove those
+	 * shared extents.
+	 *
+	 * This race becomes problematic when we defer extent removal
+	 * operations beyond the end of a syscall (i.e. use async background
+	 * processing algorithms).  Users think the extents are no longer
+	 * shared, but iomap_swapfile_iter() still sees them as shared
+	 * because the refcountbt entries for the extents being removed have
+	 * not yet been updated.  Hence the swapon call fails unexpectedly.
+	 *
+	 * The race condition is currently most obvious from the unlink()
+	 * operation as extent removal is deferred until after the last
+	 * reference to the inode goes away.  We then process the extent
+	 * removal asynchronously, hence triggers the "syscall completed but
+	 * work not done" condition mentioned above.  To close this race
+	 * window, we need to flush any pending inodegc operations to ensure
+	 * they have updated the refcountbt records before we try to map the
+	 * swapfile.
+	 */
+	xfs_inodegc_flush(ip->i_mount);
+
+	/*
+	 * Direct the swap code to the correct block device when this file
+	 * sits on the RT device.
+	 */
+	sis->bdev = xfs_inode_buftarg(ip)->bt_bdev;
+
 	return iomap_swapfile_activate(sis, swap_file, span,
 			&xfs_read_iomap_ops);
 }


