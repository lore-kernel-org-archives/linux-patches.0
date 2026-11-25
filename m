Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619906;
	b=AoupDLXLrs2XIZRm7eHBi86F1QP+gwcXRD+AYWvaHWJfW+uFKFiAXXfQnwpE0GbejuSh
	 6Y1o1hG+l0WciG8Y8z/7uRQZqjpZzMuoLYNU0bJg9RBdlI08B4tiCft3Bcqai9Qc1VZv4
	 /9VtGu6t2sS9wFV8mDa6YE7OSr0VHRQtbacUwmMT29YzlH8QYmEVGE5hRlicOgtMZzrWp
	 PKdDkXqcechQNoaONpSJE47cMHSdLBQf8JgPld0MNgicvqRE9LGgBXTXr+aoDnjnyT6Kl
	 TYZle500vuVjz4Qrtf0yPyPyOaJn6pvJ37NyakIZwnOrKQqXMSkNqwIR49cpVrin8Jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619906;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J4aNBGyNQjlcdhfTGFi5cxWEk7hreIHiZ/9Y5p4kj0w=;
	b=D6l54ci9DvhL553Em+bJ7Ovz01M7APpZm+9VWqr6/mgvZwaxnTv5x7k1ET4Kt+68ztVd
	 YTFu+suL9m3DtBxPiZKT7Hb1RGXQPUvX+Mmw9jj7v8WPKUPeXW2cc7IkUn4cU0Y1+TuxS
	 Rx7K2fKKfxfDQMOGDpaaEac1kgh+gfjSdwPUOUckEtfYzVEK2EaD3Cr6WLqia5uBrrdTD
	 nIQ4MUrmK3axlcLrSMeOH9evUHaH5iuU4h2/VJuWq/1gXI0mqqrGvsbiQegq7ncSFcou8
	 yqe1HYStBBy4JXBuzRsQ4/uliUxTHaZ/rahP/r5WDn8R8/dPf9EaZRducXNktbLZCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vy/u/nki";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E0606A31E;
	Wed, 25 Nov 2026 15:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vy/u/nki
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7DF1F000D2;
	Wed, 25 Nov 2026 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619906;
	bh=J4aNBGyNQjlcdhfTGFi5cxWEk7hreIHiZ/9Y5p4kj0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vy/u/nkihf3jq9/iFoTkqBmpFQKYGJ6Fn1Ins3iQ5TZNrOhZTqqFyJycLzqQxHxg/
	 +60X+34juTk3wz2JhHBpc3KCs5DuX99TZBr4cm4IdI15RU1PmN5zIfrANaqVVH4jI/
	 sg3ar8e4+FzpsmsOdNvHkP4BH+OXrkrJ7YjSsOLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0700/1005] ext4: dont read the inode block in ext4_sync_inode_metadata()
Date: Wed, 25 Nov 2026 15:33:58 +0100
Message-ID: <20261125143838.153931976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 2ca2e88b106175c1037939de52cb28e4cb545b9e upstream.

Without a journal ext4_sync_inode_metadata() looks the inode table
block up with __ext4_get_inode_loc_noinmem() which reads it from disk,
with readahead of the inode table on top, if it isn't cached. But a
block that isn't cached is neither dirty nor under writeback, so there's
nothing to write or to wait for.

That read is also something we can't afford once inode eviction calls
->sync_inode_metadata() from reclaim. So look the block up with
ext4_get_inode_loc_noio() instead and treat -EAGAIN as nothing to do.

Note that ext4_get_inode_loc_noio() also returns -EAGAIN for a block
that isn't uptodate. Such a block is being read or failed to be read
and can't be dirty either. A block whose write failed still counts as
uptodate for ext4_buffer_uptodate() so the write error still gets
reported.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-4-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5922,22 +5922,24 @@ int ext4_sync_inode_metadata(struct inod
 	if (WARN_ON_ONCE(EXT4_SB(inode->i_sb)->s_journal))
 		return -EFSCORRUPTED;
 
-	err = __ext4_get_inode_loc_noinmem(inode, &iloc);
-	if (err)
-		return err;
 	mmb = READ_ONCE(EXT4_I(inode)->i_metadata_bhs);
 	if (mmb) {
 		err = mmb_sync(mmb);
 		if (err)
-			goto out;
+			return err;
 	}
+	/* A block that isn't cached is neither dirty nor under writeback. */
+	err = ext4_get_inode_loc_noio(inode, &iloc);
+	if (err == -EAGAIN)
+		return 0;
+	if (err)
+		return err;
 	sync_dirty_buffer(iloc.bh);
 	if (buffer_write_io_error(iloc.bh)) {
 		ext4_error_inode_block(inode, iloc.bh->b_blocknr, EIO,
 				       "IO error syncing inode");
 		err = -EIO;
 	}
-out:
 	brelse(iloc.bh);
 	return err;
 }


