Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1115778B7C;
	Wed, 21 Feb 2024 13:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523346; cv=none; b=YxkIZBB17JwfiaS+1r3uYC+rtCAmhP2DMvoSTtM408xi1TkhWg+xCXgH1f/yvom+afhNLsOeGLhEvuc+O8/PsrKdKpPAul1dZR2HNQ1VZC64LbLZye6c+2OkhL3Mhkh0RkWxlNIegdvVUunHnE41nlIbwFbz9zoarIcCqLyqsew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523346; c=relaxed/simple;
	bh=+d11iy90u0e+yq6vng0KE80+p840FzdYpfBxjfc8zbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMTiZgvS9MU8YyeGuGlH+q1aP9X/bMpyJxjNq8GExvfmG7aEk0YhpOqRsKWG/QMUvfnpNIqFIMTx3OXPhjOfhaxnRdUqHG8aTT2TIw6dn2M9d0CJXLuxWMVBKw4cG7Kuy+Oc9p7WOk5AJdai+AmWxJvH7QLMlwzA5i/qgU1Iqjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KX6P8cQW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KX6P8cQW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D62EC433B1;
	Wed, 21 Feb 2024 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523345;
	bh=+d11iy90u0e+yq6vng0KE80+p840FzdYpfBxjfc8zbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KX6P8cQW48eazMor57S9h8dZsXQWwb2A3jPtVk4IHhN39cnjMEGKCfv2ggTPhAOnd
	 X9T3r6R3ESh82cHZRQg+GKrDSpG+1rYie+RzLQeB6dB2kjFrD5Bfo6pcf2i8C4i0Kk
	 IFSjxBmhF29f2EC1o2L+giBo+Kx6Te4IcsEHThvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+ee2ae68da3b22d04cd8d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 408/476] nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
Date: Wed, 21 Feb 2024 14:07:39 +0100
Message-ID: <20240221130023.083609746@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 38296afe3c6ee07319e01bb249aa4bb47c07b534 upstream.

Syzbot reported a hang issue in migrate_pages_batch() called by mbind()
and nilfs_lookup_dirty_data_buffers() called in the log writer of nilfs2.

While migrate_pages_batch() locks a folio and waits for the writeback to
complete, the log writer thread that should bring the writeback to
completion picks up the folio being written back in
nilfs_lookup_dirty_data_buffers() that it calls for subsequent log
creation and was trying to lock the folio.  Thus causing a deadlock.

In the first place, it is unexpected that folios/pages in the middle of
writeback will be updated and become dirty.  Nilfs2 adds a checksum to
verify the validity of the log being written and uses it for recovery at
mount, so data changes during writeback are suppressed.  Since this is
broken, an unclean shutdown could potentially cause recovery to fail.

Investigation revealed that the root cause is that the wait for writeback
completion in nilfs_page_mkwrite() is conditional, and if the backing
device does not require stable writes, data may be modified without
waiting.

Fix these issues by making nilfs_page_mkwrite() wait for writeback to
finish regardless of the stable write requirement of the backing device.

Link: https://lkml.kernel.org/r/20240131145657.4209-1-konishi.ryusuke@gmail.com
Fixes: 1d1d1a767206 ("mm: only enforce stable page writes if the backing device requires it")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reported-by: syzbot+ee2ae68da3b22d04cd8d@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/00000000000047d819061004ad6c@google.com
Tested-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/file.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/file.c
+++ b/fs/nilfs2/file.c
@@ -105,7 +105,13 @@ static vm_fault_t nilfs_page_mkwrite(str
 	nilfs_transaction_commit(inode->i_sb);
 
  mapped:
-	wait_for_stable_page(page);
+	/*
+	 * Since checksumming including data blocks is performed to determine
+	 * the validity of the log to be written and used for recovery, it is
+	 * necessary to wait for writeback to finish here, regardless of the
+	 * stable write requirement of the backing device.
+	 */
+	wait_on_page_writeback(page);
  out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(ret);


