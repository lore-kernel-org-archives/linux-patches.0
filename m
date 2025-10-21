Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60A3E273D73;
	Tue, 21 Oct 2025 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076369; cv=none; b=DNYAgaMH+dPC781FWqSi7h5voeWCyyhQqlrRe0Gre868LB7TUgBa+xLOjs0hQHW4QOPuKqlTNfUrCvfx7KjBmsIW1XO4xU2ERywfTyRhR32Nsks0+wP+hR90suvD+y1dJBm5n/dOlY4BzV8tNLzm7pdhbGlrcg1b3KC29WoH63w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076369; c=relaxed/simple;
	bh=27UO3HsGbRjIhR5ejo8ziCkMR09m6iiTf8UTPKYMTQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BDo24YSgAu73pOujIEqBjxLCZ21ayiE3e7fsfcU1Pg1kSIejMb/gE8iJ2N1v1WMT6Hd8y6xPi8kRiU2QGbtzRvQFx1PP+A7UkauHJubUYdzyfLGLW6rLIbycrD5mZvXNp0+Zfqcn7S6baQ4el6jU8B70KZ1Z+oQvdSv2d1OMDMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TAl2g6UH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TAl2g6UH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE15C4CEF5;
	Tue, 21 Oct 2025 19:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076369;
	bh=27UO3HsGbRjIhR5ejo8ziCkMR09m6iiTf8UTPKYMTQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAl2g6UH/CeGsz63Sz0fAlKucWGMiOv9JdD2KlUD40y8DyQ2OMYVuD+0ax8tLHLGx
	 eX/VuHbtp/w4+z3pSyyYPttexgLWDJnRMEOsXXqvenNih2HdfQDDR8bhyswopxosJ0
	 d6HfOq7DfIJ91/lubaULs1/WogD7fSYLBA7jxojI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 006/105] ext4: wait for ongoing I/O to complete before freeing blocks
Date: Tue, 21 Oct 2025 21:50:15 +0200
Message-ID: <20251021195021.644663041@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Zhang Yi <yi.zhang@huawei.com>

commit 328a782cb138029182e521c08f50eb1587db955d upstream.

When freeing metadata blocks in nojournal mode, ext4_forget() calls
bforget() to clear the dirty flag on the buffer_head and remvoe
associated mappings. This is acceptable if the metadata has not yet
begun to be written back. However, if the write-back has already started
but is not yet completed, ext4_forget() will have no effect.
Subsequently, ext4_mb_clear_bb() will immediately return the block to
the mb allocator. This block can then be reallocated immediately,
potentially causing an data corruption issue.

Fix this by clearing the buffer's dirty flag and waiting for the ongoing
I/O to complete, ensuring that no further writes to stale data will
occur.

Fixes: 16e08b14a455 ("ext4: cleanup clean_bdev_aliases() calls")
Cc: stable@kernel.org
Reported-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Closes: https://lore.kernel.org/linux-ext4/a9417096-9549-4441-9878-b1955b899b4e@huaweicloud.com/
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20250916093337.3161016-3-yi.zhang@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4_jbd2.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -277,9 +277,16 @@ int __ext4_forget(const char *where, uns
 		  bh, is_metadata, inode->i_mode,
 		  test_opt(inode->i_sb, DATA_FLAGS));
 
-	/* In the no journal case, we can just do a bforget and return */
+	/*
+	 * In the no journal case, we should wait for the ongoing buffer
+	 * to complete and do a forget.
+	 */
 	if (!ext4_handle_valid(handle)) {
-		bforget(bh);
+		if (bh) {
+			clear_buffer_dirty(bh);
+			wait_on_buffer(bh);
+			__bforget(bh);
+		}
 		return 0;
 	}
 


