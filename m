Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5767EEF6;
	Wed, 21 Feb 2024 14:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524750; cv=none; b=bX+jIO+A3WRV0VBiPm8K2ZlbzXijj10q559W3YJDa0sULQtgxgiTukfDxvJ+WW1cToLDoRkWjVrg9yWkjfOGjB1TuouizBPEnwZHJNpMHDcVBcVSnGqgeeVPNPfxRBE+3hUUGugM+rE/pHA34lKr12aMgoPvNcsjfrI1tKFxFNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524750; c=relaxed/simple;
	bh=pSSH0QPh9/zJwtqQgJ+p9wZhVlZs/wZaHnboIzDFZBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/cw8H8gXsetxxsFR2SuPqJ9DNlebD9wgW7+czSIcuDrv0UHFqBoAslfrDmDgWmCxalFNfyRXNQ9pSFyKQiH1sh0NqmCa5T5yue92pGe5msWbVbQ+9ye2lXHGFjOKsWTNfQLHqcZGXUq0YwVD5k2BhcKmD7uqTdG7uF22mEJB7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMwtMC0E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMwtMC0E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF6BC433C7;
	Wed, 21 Feb 2024 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524750;
	bh=pSSH0QPh9/zJwtqQgJ+p9wZhVlZs/wZaHnboIzDFZBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMwtMC0EwAWQmeJnSPIpMi9LwCM3bEqIJCOUUBUdz9u3/Nm9Wv58ivYeluIr7XVjU
	 tZNIuNq/KINoIVmyUTJsUkPuig9wXAUZ9Ae1mDQZOfHyGlasyJNsjH4o8tl0hZJ1Ij
	 ChtWcJAvRzE/IjrnDx0olqvw1U6UU5/OpjxzEHHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	syzbot+ee2ae68da3b22d04cd8d@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 336/379] nilfs2: fix hang in nilfs_lookup_dirty_data_buffers()
Date: Wed, 21 Feb 2024 14:08:35 +0100
Message-ID: <20240221130004.919267100@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


