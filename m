Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619903;
	b=mWZiLq7PoBNu167ASKnieyPbCqzEwdmIaSWfMy+cN3gTlH2s/4/wWLM2AKlkQHNbnTHh
	 pN8tnMDHwyL5Zv/tB3KgVdNqbIDU/r+uNeJBLRIT8GkV7d0rydgMC0uhyiHuewSOv1Vrw
	 y/R8hwLJSitURAjo7AVAPGdttPLNXMmj/rP98HGs0krlIjK7Pu1Om8ROijdHnK69mqC19
	 CbUxOVkexJiNBA0isC1cpMqyBnUyW2TC8/H1Ysti0BmnflBf3OGsr2LGeIeAyr+RQkpF+
	 H3IoDefJ5CdBvFRXath9zyWuFQeGcdabk7XNvnrWYWaOdf2lmtgeL4A6YJrCXBYxgyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619903;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P8ZGvcuQpW6A4H3+e3VBVbGSONuALvq/w6sapPKWzY0=;
	b=MFZI2ejw25dQayeGWc+mj7bgrzJH3x0mI7xljTYHzWyJMrv2rvdErRi/cYEFYHgkB8B4
	 czE6Q32MLD2g0jkl3sQsF1L7EGHnPNnXlpaGF643eaQWJvFUv5r/MlEECZnmTRKnQvqzm
	 1tsMeZbklN13p8Ous7gfpqkuwTUCOGRUoUsBD6vfbKiv1+hlxisEvlpiRZ/41BPzMJEMn
	 usFLTxK5XpfPU46Sb2wuGqN/dsvfLaHkiNRNMAVlxHK5Wl93zQLYcubE7X2X7cqXwPTnB
	 U798a2KkT7cjcsjGmR18a+V+BWRVNRdVJCOBY9rS0plBBeUQvO+WrO79Sjsg3LCwRbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLvrwige;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F38606A31E;
	Wed, 25 Nov 2026 15:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VLvrwige
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 676FB1F000C4;
	Wed, 25 Nov 2026 15:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619902;
	bh=P8ZGvcuQpW6A4H3+e3VBVbGSONuALvq/w6sapPKWzY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VLvrwigeXb/xq+FAP+QERrxkOX6ROFcBb5VLjmxCFEgjIxcd28ZEjUKVeFcV2HSji
	 KdBouU+jmD2PpQnTjvYrlq+ya/jieBpBoF0u4uIUYO9QUCKNlakMdGP5vTyJ8pTgIm
	 E8DX25r8UmHf8nszuNdijRy4FLsPf2ffALpRCRjo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.3 0699/1005] ext4: use sb_find_get_block_nonatomic() in ext4_get_inode_loc_noio()
Date: Wed, 25 Nov 2026 15:33:57 +0100
Message-ID: <20261125143838.130306568@linuxfoundation.org>
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

commit d25c14b2d79e4e8292b19041efd1aae4057bf383 upstream.

ext4_get_inode_loc_noio() looks the inode table block up with
sb_find_get_block(). That's the atomic lookup. It serializes against
try_to_free_buffers() with i_private_lock instead of the folio lock and
gives up if the folio is being migrated. So it can report the block as
not cached while it is.

For ext4_fc_snapshot_inode() that only means falling back to a full
commit. But ext4_sync_inode_metadata() is going to use
ext4_get_inode_loc_noio() to find the inode block that fsync() has to
write out and there a dirty block must not be skipped.

ext4_fc_snapshot_inode() is the only caller and it can sleep. It runs
under jbd2_journal_lock_updates() and allocates the snapshot with
GFP_NOFS. So use sb_find_get_block_nonatomic() which takes the folio
lock and waits for the migration instead.

Suggested-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org # v7.3
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20261109-work-inode-metadata_writeback-v3-3-91ac6c024018@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5060,7 +5060,8 @@ int ext4_get_inode_loc(struct inode *ino
 /*
  * ext4_get_inode_loc_noio() is a best-effort variant of ext4_get_inode_loc().
  * It looks up the inode table block in the buffer cache and returns -EAGAIN if
- * the block is not present or not uptodate, without starting any I/O.
+ * the block is not present or not uptodate, without starting any I/O. It may
+ * sleep on the folio lock of the block.
  */
 int ext4_get_inode_loc_noio(struct inode *inode, struct ext4_iloc *iloc)
 {
@@ -5096,7 +5097,7 @@ int ext4_get_inode_loc_noio(struct inode
 	}
 	block += inode_offset / inodes_per_block;
 
-	bh = sb_find_get_block(sb, block);
+	bh = sb_find_get_block_nonatomic(sb, block);
 	if (!bh)
 		return -EAGAIN;
 	if (!ext4_buffer_uptodate(bh)) {


