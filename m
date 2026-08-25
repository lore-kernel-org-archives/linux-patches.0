Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B48392C21;
	Tue, 25 Aug 2026 13:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665787; cv=none; b=keNbXOaKxUvcsOPnpz6VzLcL2penjicmHE7RT9ZrDXLO2Sk3Ohe0x7Al3E3qzn50Qbo9QyfMR0dVm5e8TkbcU9QMra5QQzc2lxACi8snxYtszRAoWgANd9m7i1CCZ1Kr/Za7jb8IWAapkhCVo3iS5pUXbVDtIKyubV8kuvP7GJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665787; c=relaxed/simple;
	bh=WaTdkqrFifKC1A5PntjF0HM46hx2KuIuTKbH+s6udZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lR0uwa3BbXIpN6xT5477AB3RAgPSxNm4gZnrjaZvJUnQgEGdr6IasxfAxOn02/NOyfhScWTblyPq+0YAmGa+mL6vwdJ/i5puoLk4uv4ekOoOgNMC5n+1oBguyAJpe+tZzKodj5s53li1E9TOtImNr1FncYGt5JqMe66NDJe+mS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEzgCrtS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEzgCrtS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C4B1F00A3A;
	Tue, 25 Aug 2026 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665786;
	bh=6KrpOgW20J7O9o3sGvK639BuGx4vRoYGMcjdpskNB+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEzgCrtS3HL90ed6C7WraYQ3GMAczyJ7iCGFS6lHYe7nLZl9onOzXSJat/hlNQdYL
	 HqDJeYVdBw0UxKmPn4tcvAKv0i2CpPJQomnGQyboAontpKxmXI7l4GtVUw7E1tYiWw
	 0Z8Oc14wb75nk4i2F9tmOj79CymGoS9+aCWcdE1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	syzbot+e68dbebd9617a9250e8d@syzkaller.appspotmail.com,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.6 26/87] ext4: stop retrying saturated xattr cache entries
Date: Tue, 25 Aug 2026 15:25:49 +0200
Message-ID: <20260825132542.863786234@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.813800447@linuxfoundation.org>
References: <20260825132541.813800447@linuxfoundation.org>
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
@@ -2070,12 +2070,13 @@ inserted:
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
@@ -2086,6 +2087,7 @@ inserted:
 					new_bh = NULL;
 					goto inserted;
 				}
+				ref++;
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
 					clear_bit(MBE_REUSABLE_B, &ce->e_flags);


