Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9AC1EF080;
	Tue, 15 Oct 2024 12:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994375; cv=none; b=maukk63YTl2Yg9yQOASvmqnbrZH1FFEEh73YJTwRBupop28cRp+Rnk8WYxQW17qy///9+WjzpYa5tyPfaBqm0JyimU5rlcdGtgbjODK1RdVbfBub+VrTvMz3RxAndkExqdJsCBmNpXcNVe8yQAB0NMMydA5+s7E+cTxWtuVhtxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994375; c=relaxed/simple;
	bh=Jn9Y6ZK57ElMCKRI1SDJgFpbNV8wGEW92AMRWLrP1hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MddmMZljZkaHLZ6iVY6SiJDEpxl9qf28EUNf68zhWPx7CbsWuKg4ONHRhVhHI9CgRpAQp8zFgExXoAJDKp9b2VDZehzRizDFFkBsiSCFSEH1bGHg4FlPvq9lTU+rzJAiTenHNO08j2nZxRlxKcTvPAdNmjo6QP2dHcAIUbyoGmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poEbHxfM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poEbHxfM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65D9C4CEC6;
	Tue, 15 Oct 2024 12:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994375;
	bh=Jn9Y6ZK57ElMCKRI1SDJgFpbNV8wGEW92AMRWLrP1hQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poEbHxfMFxHGD7mjEoc8pN0586jcWtyGL62jH95/g5/d7i1G0JkIvmCuS8pOlyeW+
	 6idn9xTtkepjF0kiVZ9kAlTKTJt75VIy9KXqXOLKafWEcLQbqq6JEPTITxFv0mZIl/
	 z1ePOobxNXaXC0d3lTM1v4j8+Rt83+wGN5ujdvNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+47479b71cdfc78f56d30@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 688/691] ext4: fix warning in ext4_dio_write_end_io()
Date: Tue, 15 Oct 2024 13:30:36 +0200
Message-ID: <20241015112507.625611687@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit 619f75dae2cf117b1d07f27b046b9ffb071c4685 upstream.

The syzbot has reported that it can hit the warning in
ext4_dio_write_end_io() because i_size < i_disksize. Indeed the
reproducer creates a race between DIO IO completion and truncate
expanding the file and thus ext4_dio_write_end_io() sees an inconsistent
inode state where i_disksize is already updated but i_size is not
updated yet. Since we are careful when setting up DIO write and consider
it extending (and thus performing the IO synchronously with i_rwsem held
exclusively) whenever it goes past either of i_size or i_disksize, we
can use the same test during IO completion without risking entering
ext4_handle_inode_extension() without i_rwsem held. This way we make it
obvious both i_size and i_disksize are large enough when we report DIO
completion without relying on unreliable WARN_ON.

Reported-by:  <syzbot+47479b71cdfc78f56d30@syzkaller.appspotmail.com>
Fixes: 91562895f803 ("ext4: properly sync file size update after O_SYNC direct IO")
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Link: https://lore.kernel.org/r/20231130095653.22679-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/file.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -322,9 +322,10 @@ static void ext4_inode_extension_cleanup
 		return;
 	}
 	/*
-	 * If i_disksize got extended due to writeback of delalloc blocks while
-	 * the DIO was running we could fail to cleanup the orphan list in
-	 * ext4_handle_inode_extension(). Do it now.
+	 * If i_disksize got extended either due to writeback of delalloc
+	 * blocks or extending truncate while the DIO was running we could fail
+	 * to cleanup the orphan list in ext4_handle_inode_extension(). Do it
+	 * now.
 	 */
 	if (!list_empty(&EXT4_I(inode)->i_orphan) && inode->i_nlink) {
 		handle_t *handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
@@ -359,10 +360,11 @@ static int ext4_dio_write_end_io(struct
 	 * blocks. But the code in ext4_iomap_alloc() is careful to use
 	 * zeroed/unwritten extents if this is possible; thus we won't leave
 	 * uninitialized blocks in a file even if we didn't succeed in writing
-	 * as much as we intended.
+	 * as much as we intended. Also we can race with truncate or write
+	 * expanding the file so we have to be a bit careful here.
 	 */
-	WARN_ON_ONCE(i_size_read(inode) < READ_ONCE(EXT4_I(inode)->i_disksize));
-	if (pos + size <= READ_ONCE(EXT4_I(inode)->i_disksize))
+	if (pos + size <= READ_ONCE(EXT4_I(inode)->i_disksize) &&
+	    pos + size <= i_size_read(inode))
 		return size;
 	return ext4_handle_inode_extension(inode, pos, size);
 }


