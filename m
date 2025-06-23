Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B9F7482;
	Mon, 23 Jun 2025 21:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713502; cv=none; b=W4Qi+zSFNxwepdhRZuR2OY8ZkU/sEb1Cil/s0NJYyPvjFE8jx+JE4NTVhCCE6mkGw5gx3WKtPI4+Y+j/6ppNcDLC3zyY42/EDQE5MsnPyaZieAcJG7Vc08flYR6pKBUzj3051xJGagQAkb+Ecp9FdA2xz/7CrgXX/eFkQifXlO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713502; c=relaxed/simple;
	bh=ZP+JbBusfCKZ1VFFfJjZoTytByYze+us+fiyaOmPhpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fJdfGvpypGp+68SUSPCjcbDGAEkRBxz6T4IQ+X3QAaLNSGANwD2huD29Vg5PK6fnDS2Xet7/aMYJUXQBrtBO6c2M5A/gvT1Qt/XsF/tc90HScrKKrZt0VZumYd6C91TsyKrvIme4zQdmVvhYiZRwPh2rOrRj/Wq2oYdUgrYNR0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kz/5p0Ev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kz/5p0Ev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8385DC4CEF0;
	Mon, 23 Jun 2025 21:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713501;
	bh=ZP+JbBusfCKZ1VFFfJjZoTytByYze+us+fiyaOmPhpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kz/5p0Ev9OBmwmkToO/gZmBJjBUbPwdXKKJA1tcOs0ObiyAfym4fhZ5dVSvpHFdHQ
	 gJWYklMUpBy/SS/DCt7IZ0E4dzUsBfwQh77ePJfnhdmVSZr0dyKQvTYaz1mNKr3m4J
	 igawrusGPz6KuIv2LGh7AmW4Op+r5pQmFoijxBD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+de24c3fe3c4091051710@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 5.10 169/355] jbd2: fix data-race and null-ptr-deref in jbd2_journal_dirty_metadata()
Date: Mon, 23 Jun 2025 15:06:10 +0200
Message-ID: <20250623130631.787516428@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jeongjun Park <aha310510@gmail.com>

commit af98b0157adf6504fade79b3e6cb260c4ff68e37 upstream.

Since handle->h_transaction may be a NULL pointer, so we should change it
to call is_handle_aborted(handle) first before dereferencing it.

And the following data-race was reported in my fuzzer:

==================================================================
BUG: KCSAN: data-race in jbd2_journal_dirty_metadata / jbd2_journal_dirty_metadata

write to 0xffff888011024104 of 4 bytes by task 10881 on cpu 1:
 jbd2_journal_dirty_metadata+0x2a5/0x770 fs/jbd2/transaction.c:1556
 __ext4_handle_dirty_metadata+0xe7/0x4b0 fs/ext4/ext4_jbd2.c:358
 ext4_do_update_inode fs/ext4/inode.c:5220 [inline]
 ext4_mark_iloc_dirty+0x32c/0xd50 fs/ext4/inode.c:5869
 __ext4_mark_inode_dirty+0xe1/0x450 fs/ext4/inode.c:6074
 ext4_dirty_inode+0x98/0xc0 fs/ext4/inode.c:6103
....

read to 0xffff888011024104 of 4 bytes by task 10880 on cpu 0:
 jbd2_journal_dirty_metadata+0xf2/0x770 fs/jbd2/transaction.c:1512
 __ext4_handle_dirty_metadata+0xe7/0x4b0 fs/ext4/ext4_jbd2.c:358
 ext4_do_update_inode fs/ext4/inode.c:5220 [inline]
 ext4_mark_iloc_dirty+0x32c/0xd50 fs/ext4/inode.c:5869
 __ext4_mark_inode_dirty+0xe1/0x450 fs/ext4/inode.c:6074
 ext4_dirty_inode+0x98/0xc0 fs/ext4/inode.c:6103
....

value changed: 0x00000000 -> 0x00000001
==================================================================

This issue is caused by missing data-race annotation for jh->b_modified.
Therefore, the missing annotation needs to be added.

Reported-by: syzbot+de24c3fe3c4091051710@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de24c3fe3c4091051710
Fixes: 6e06ae88edae ("jbd2: speedup jbd2_journal_dirty_metadata()")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://patch.msgid.link/20250514130855.99010-1-aha310510@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1492,7 +1492,7 @@ int jbd2_journal_dirty_metadata(handle_t
 				jh->b_next_transaction == transaction);
 		spin_unlock(&jh->b_state_lock);
 	}
-	if (jh->b_modified == 1) {
+	if (data_race(jh->b_modified == 1)) {
 		/* If it's in our transaction it must be in BJ_Metadata list. */
 		if (data_race(jh->b_transaction == transaction &&
 		    jh->b_jlist != BJ_Metadata)) {
@@ -1511,7 +1511,6 @@ int jbd2_journal_dirty_metadata(handle_t
 		goto out;
 	}
 
-	journal = transaction->t_journal;
 	spin_lock(&jh->b_state_lock);
 
 	if (is_handle_aborted(handle)) {
@@ -1526,6 +1525,8 @@ int jbd2_journal_dirty_metadata(handle_t
 		goto out_unlock_bh;
 	}
 
+	journal = transaction->t_journal;
+
 	if (jh->b_modified == 0) {
 		/*
 		 * This buffer's got modified and becoming part


