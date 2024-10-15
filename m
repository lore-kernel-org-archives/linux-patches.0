Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570B71D4154;
	Tue, 15 Oct 2024 11:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993219; cv=none; b=hVnkWYW3t4s9NI/WsIgZx+UH+xbdlBh85cemOzYwSAtRum0g9BOlJhInBeutiX9JQJdxK04MdFTAGm4iYUBCSrBUhOQzwuBN6uLRQL38/4wX9GZzMVYHKWGj96oxBkDLxswVLlO3mcnQZKBsjKTUK5CgQaIIW2DWgZi0fscQyM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993219; c=relaxed/simple;
	bh=JIWKZXauhtSLyKlosUFAByvo0li9BdAbOEosgNpzLTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giFfxZqHMpa0FFqjGS60U99UOOKFL/6E1CFSVataWIOsb1SYZ8t60RI43IYmgDurq+JbNYyWR9nSk7CPZ6tEm7Z0FHr1Y8kgNhNfcgDXn487XYBOwySzxp6y5CTwaaXUsWYikta1kbwmD1i+xRUqv9pSHtEVdJCBOV2UtJ0Q7VY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pPlX4Vbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pPlX4Vbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B15E4C4CEC6;
	Tue, 15 Oct 2024 11:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993219;
	bh=JIWKZXauhtSLyKlosUFAByvo0li9BdAbOEosgNpzLTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pPlX4VbbqDGz3bNJrUnYH5yuc9IU6ugVkCZzmG8xXU0uxeMPrVOyUb/DKbWN3AyHh
	 EYylnKp99TmoVrElYYk0QO+xF3ABBMA/693BDWCwKl2yxI10Sdf7OV88bWzEZlL31P
	 ebv0nAeAWo5cy+3I4KqBNDxLZRO4sM4aOJFIgm3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+67ba3c42bcbb4665d3ad@syzkaller.appspotmail.com,
	Julian Sun <sunjunchao2870@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Christian Brauner <brauner@kernel.org>
Subject: [PATCH 5.15 345/691] vfs: fix race between evice_inodes() and find_inode()&iput()
Date: Tue, 15 Oct 2024 13:24:53 +0200
Message-ID: <20241015112454.032793278@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

From: Julian Sun <sunjunchao2870@gmail.com>

commit 88b1afbf0f6b221f6c5bb66cc80cd3b38d696687 upstream.

Hi, all

Recently I noticed a bug[1] in btrfs, after digged it into
and I believe it'a race in vfs.

Let's assume there's a inode (ie ino 261) with i_count 1 is
called by iput(), and there's a concurrent thread calling
generic_shutdown_super().

cpu0:                              cpu1:
iput() // i_count is 1
  ->spin_lock(inode)
  ->dec i_count to 0
  ->iput_final()                    generic_shutdown_super()
    ->__inode_add_lru()               ->evict_inodes()
      // cause some reason[2]           ->if (atomic_read(inode->i_count)) continue;
      // return before                  // inode 261 passed the above check
      // list_lru_add_obj()             // and then schedule out
   ->spin_unlock()
// note here: the inode 261
// was still at sb list and hash list,
// and I_FREEING|I_WILL_FREE was not been set

btrfs_iget()
  // after some function calls
  ->find_inode()
    // found the above inode 261
    ->spin_lock(inode)
   // check I_FREEING|I_WILL_FREE
   // and passed
      ->__iget()
    ->spin_unlock(inode)                // schedule back
                                        ->spin_lock(inode)
                                        // check (I_NEW|I_FREEING|I_WILL_FREE) flags,
                                        // passed and set I_FREEING
iput()                                  ->spin_unlock(inode)
  ->spin_lock(inode)			  ->evict()
  // dec i_count to 0
  ->iput_final()
    ->spin_unlock()
    ->evict()

Now, we have two threads simultaneously evicting
the same inode, which may trigger the BUG(inode->i_state & I_CLEAR)
statement both within clear_inode() and iput().

To fix the bug, recheck the inode->i_count after holding i_lock.
Because in the most scenarios, the first check is valid, and
the overhead of spin_lock() can be reduced.

If there is any misunderstanding, please let me know, thanks.

[1]: https://lore.kernel.org/linux-btrfs/000000000000eabe1d0619c48986@google.com/
[2]: The reason might be 1. SB_ACTIVE was removed or 2. mapping_shrinkable()
return false when I reproduced the bug.

Reported-by: syzbot+67ba3c42bcbb4665d3ad@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=67ba3c42bcbb4665d3ad
CC: stable@vger.kernel.org
Fixes: 63997e98a3be ("split invalidate_inodes()")
Signed-off-by: Julian Sun <sunjunchao2870@gmail.com>
Link: https://lore.kernel.org/r/20240823130730.658881-1-sunjunchao2870@gmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/inode.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/inode.c
+++ b/fs/inode.c
@@ -678,6 +678,10 @@ again:
 			continue;
 
 		spin_lock(&inode->i_lock);
+		if (atomic_read(&inode->i_count)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
 			spin_unlock(&inode->i_lock);
 			continue;


