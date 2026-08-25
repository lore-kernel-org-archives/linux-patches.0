Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD1C423A85;
	Tue, 25 Aug 2026 13:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666222; cv=none; b=rc3yf3EDD4ekCBg32GRO54VN/Il7U0e7HvLQQUUzaSJajjTMAf5S8N0wWEfJBwEvMTiLV+rxVNFVx/hgjtlvNYSCVAJKB5hfGMHpLomriFfusoWhoZzRN+aktNTJR3OxQ7DR4X0B1cvAjfWcRrZulaMyt2D+nxPsJcDkVC692fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666222; c=relaxed/simple;
	bh=iS/alMa6BSxFX6imbMALvlwMXt9BA4cy3eMET8dJ/vA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EUlBtnrfzrOcoBRm8iutFhBVJWbEgQ1ZPRWWbtZmjxsN4SLSyp2aWoFBSYPgDTp0ZZ6S5c7VrSq7ieqvzOKpiwv4QFNv//FM6scIxP4hOJaF6yHZ2IEswwvJ4OHIvl9/l8D7uZrbUMnbZjXouSurxD7KhqYJSfaun1z6T3VwUYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yD7mBfhk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yD7mBfhk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364441F000E9;
	Tue, 25 Aug 2026 13:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666220;
	bh=yhT7c1Fjsdo9zMKpQG6Fa93joQOsXBzlFCCL9ubtHow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yD7mBfhk5OXSTn82PWRloHlY5fxlmMOBdlqbARBqs+OqAd1DWpVCSBIimglAbjQ/c
	 dLy6gIYktgyGXIJIfUGN91YUb4B/6buvB7FZfhVTHV0IJLKP55CiYVEMYZ7iXG1Sij
	 usYGSDYd26XtSTVdKvhxy6KqLXgjmTDMEbIuOg9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 07/76] ext4: stop retrying saturated xattr cache entries
Date: Tue, 25 Aug 2026 15:26:00 +0200
Message-ID: <20260825132541.829709801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
References: <20260825132541.568214149@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Goergens <matthias.goergens@gmail.com>

commit 54b6bd40898de7906acb2bccc9a96d1b8e6b4323 upstream.

ext4_xattr_block_set() retries when a cache entry selected for reuse
has a saturated reference count after taking the buffer lock. The retry
returns to the mbcache lookup without making that entry ineligible, so
it can select the same unusable entry indefinitely. A task spinning
there can hold the parent directory's i_rwsem and leave concurrent
rmdir callers blocked.

Normally a reusable entry has a reference count below
EXT4_XATTR_REFCOUNT_MAX because the count and MBE_REUSABLE_B are
updated under the same buffer lock. A corrupted filesystem can violate
that invariant. The syzbot reproducer reports allocator and xattr
corruption before triggering this retry loop.

Check the untrusted on-disk count before incrementing it, avoiding
overflow, and clear MBE_REUSABLE_B when it is already saturated. The
next lookup then skips the entry that was just proven unusable. This
mirrors the normal transition at EXT4_XATTR_REFCOUNT_MAX; the release
path marks the entry reusable again on the exact 1024-to-1023
transition.

Using the same QEMU harness and guest parameters, current unpatched
Linux hung in 6 of 8 420-second trials with the do_rmdir signature;
representative NMI backtraces caught the owner spinning in
ext4_xattr_block_set(). The patched kernel completed 28 of 28 trials
without a hung-task report; the final twelve trials exercised the
reviewed overflow-safe form of the change. syzbot's patch testing also
completed without reproducing the hang.

Reported-and-tested-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e68dbebd9617a9250e8d
Fixes: 65f8b80053a1 ("ext4: fix race when reusing xattr blocks")
Cc: stable@vger.kernel.org
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reported-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
Tested-by: syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com
Link: https://patch.msgid.link/20260802065941.1726052-1-matthias.goergens@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/xattr.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -2049,12 +2049,13 @@ inserted:
 				 * stable so we can check the additional
 				 * reference fits.
 				 */
-				ref = le32_to_cpu(BHDR(new_bh)->h_refcount) + 1;
-				if (ref > EXT4_XATTR_REFCOUNT_MAX) {
+				ref = le32_to_cpu(BHDR(new_bh)->h_refcount);
+				if (ref >= EXT4_XATTR_REFCOUNT_MAX) {
 					/*
 					 * Undo everything and check mbcache
 					 * again.
 					 */
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 					unlock_buffer(new_bh);
 					dquot_free_block(inode,
 							 EXT4_C2B(EXT4_SB(sb),
@@ -2065,6 +2066,7 @@ inserted:
 					new_bh = NULL;
 					goto inserted;
 				}
+				ref++;
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
 					clear_bit(MBE_REUSABLE_B, &ce->e_flags);


