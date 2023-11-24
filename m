Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B60933CC7;
	Fri, 24 Nov 2023 18:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyXzEk/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADA93C433C7;
	Fri, 24 Nov 2023 18:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851551;
	bh=joX28xGhRiaK4nhZheNgbrTew39SFsfLFYL5SMBsitc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyXzEk/UIpCQcak3PuU+996agp7KupGp0wINsdFA9Lej4yUn2pNFvylLF0gmFC0rs
	 cjVepw5ozulAoKgzHpsT5zysAODauV3FOQyfkIKrKj8iscTRxdbB1H4QML7YOXnjWs
	 RU4aa7p6/oehT8BG+5h7JNwB3hFIgrZEF3VrbpFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+307da6ca5cb0d01d581a@syzkaller.appspotmail.com,
	Brian Foster <bfoster@redhat.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.5 468/491] ext4: fix racy may inline data check in dio write
Date: Fri, 24 Nov 2023 17:51:44 +0000
Message-ID: <20231124172038.685896808@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Foster <bfoster@redhat.com>

commit ce56d21355cd6f6937aca32f1f44ca749d1e4808 upstream.

syzbot reports that the following warning from ext4_iomap_begin()
triggers as of the commit referenced below:

        if (WARN_ON_ONCE(ext4_has_inline_data(inode)))
                return -ERANGE;

This occurs during a dio write, which is never expected to encounter
an inode with inline data. To enforce this behavior,
ext4_dio_write_iter() checks the current inline state of the inode
and clears the MAY_INLINE_DATA state flag to either fall back to
buffered writes, or enforce that any other writers in progress on
the inode are not allowed to create inline data.

The problem is that the check for existing inline data and the state
flag can span a lock cycle. For example, if the ilock is originally
locked shared and subsequently upgraded to exclusive, another writer
may have reacquired the lock and created inline data before the dio
write task acquires the lock and proceeds.

The commit referenced below loosens the lock requirements to allow
some forms of unaligned dio writes to occur under shared lock, but
AFAICT the inline data check was technically already racy for any
dio write that would have involved a lock cycle. Regardless, lift
clearing of the state bit to the same lock critical section that
checks for preexisting inline data on the inode to close the race.

Cc: stable@kernel.org
Reported-by: syzbot+307da6ca5cb0d01d581a@syzkaller.appspotmail.com
Fixes: 310ee0902b8d ("ext4: allow concurrent unaligned dio overwrites")
Signed-off-by: Brian Foster <bfoster@redhat.com>
Link: https://lore.kernel.org/r/20231002185020.531537-1-bfoster@redhat.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/file.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -537,18 +537,20 @@ static ssize_t ext4_dio_write_iter(struc
 		return ext4_buffered_write_iter(iocb, from);
 	}
 
+	/*
+	 * Prevent inline data from being created since we are going to allocate
+	 * blocks for DIO. We know the inode does not currently have inline data
+	 * because ext4_should_use_dio() checked for it, but we have to clear
+	 * the state flag before the write checks because a lock cycle could
+	 * introduce races with other writers.
+	 */
+	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
+
 	ret = ext4_dio_write_checks(iocb, from, &ilock_shared, &extend,
 				    &unwritten, &dio_flags);
 	if (ret <= 0)
 		return ret;
 
-	/*
-	 * Make sure inline data cannot be created anymore since we are going
-	 * to allocate blocks for DIO. We know the inode does not have any
-	 * inline data now because ext4_dio_supported() checked for that.
-	 */
-	ext4_clear_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA);
-
 	offset = iocb->ki_pos;
 	count = ret;
 


