Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308675C613;
	Wed, 10 Dec 2025 07:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352153; cv=none; b=Z9BGc+0JDn0ZQ9vKwu7kU/TOh3LomA/wDWoT+Oiscp6zfxNAbcKDWZoM4s8QUV5AtYb2B7uEOgO6p1pi6EFS4giUQdED+uHt40bPLmj3J87DvhUG3MTWTCYdVDpIt0u5Go32CvjBURP+om4JkFnV7ccb3v2/T87RZVnT5cFeCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352153; c=relaxed/simple;
	bh=RN13y1MmYhAPtCDRXs/fRaYKTRV0BGh1KNVrh+8fEO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8sJFplzC37kqFNmLMJaui+aHewmM/ufyaeB/fdFw2b6YgUw5AOPkqtOjv+H3Pr5C1e2/+JYWevNDKVcLIknIXhR5yscRYxULV0yvpsEc3FObGzEtSyGYy0UCVOhQIgjSswYSVToYB9/b34kVjm4LJPL/6JYoz/L3xfOylqO3aI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hqWR4rLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hqWR4rLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CE68C4CEF1;
	Wed, 10 Dec 2025 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352152;
	bh=RN13y1MmYhAPtCDRXs/fRaYKTRV0BGh1KNVrh+8fEO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hqWR4rLUzH8fIfdHODtZoAbXMHVOlpffKnoEZIudtQNUv4WMAb/Ta+5/SATBipO/4
	 Tx5m4Cj6dLBlmFIMyNiHtzr9f0vd/SSvJ9QSQFSjAgxdVq2vs/tKUHdwautRuujxe7
	 ckfKb0DkYehzXr6uKA5F3TTmA0WMENIUdKBv+wFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Bin <yebin10@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.18 02/29] jbd2: avoid bug_on in jbd2_journal_get_create_access() when file system corrupted
Date: Wed, 10 Dec 2025 16:30:12 +0900
Message-ID: <20251210072944.435115763@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Bin <yebin10@huawei.com>

commit 986835bf4d11032bba4ab8414d18fce038c61bb4 upstream.

There's issue when file system corrupted:
------------[ cut here ]------------
kernel BUG at fs/jbd2/transaction.c:1289!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 5 UID: 0 PID: 2031 Comm: mkdir Not tainted 6.18.0-rc1-next
RIP: 0010:jbd2_journal_get_create_access+0x3b6/0x4d0
RSP: 0018:ffff888117aafa30 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88811a86b000 RCX: ffffffff89a63534
RDX: 1ffff110200ec602 RSI: 0000000000000004 RDI: ffff888100763010
RBP: ffff888100763000 R08: 0000000000000001 R09: ffff888100763028
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88812c432000 R14: ffff88812c608000 R15: ffff888120bfc000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f91d6970c99 CR3: 00000001159c4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __ext4_journal_get_create_access+0x42/0x170
 ext4_getblk+0x319/0x6f0
 ext4_bread+0x11/0x100
 ext4_append+0x1e6/0x4a0
 ext4_init_new_dir+0x145/0x1d0
 ext4_mkdir+0x326/0x920
 vfs_mkdir+0x45c/0x740
 do_mkdirat+0x234/0x2f0
 __x64_sys_mkdir+0xd6/0x120
 do_syscall_64+0x5f/0xfa0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

The above issue occurs with us in errors=continue mode when accompanied by
storage failures. There have been many inconsistencies in the file system
data.
In the case of file system data inconsistency, for example, if the block
bitmap of a referenced block is not set, it can lead to the situation where
a block being committed is allocated and used again. As a result, the
following condition will not be satisfied then trigger BUG_ON. Of course,
it is entirely possible to construct a problematic image that can trigger
this BUG_ON through specific operations. In fact, I have constructed such
an image and easily reproduced this issue.
Therefore, J_ASSERT() holds true only under ideal conditions, but it may
not necessarily be satisfied in exceptional scenarios. Using J_ASSERT()
directly in abnormal situations would cause the system to crash, which is
clearly not what we want. So here we directly trigger a JBD abort instead
of immediately invoking BUG_ON.

Fixes: 470decc613ab ("[PATCH] jbd2: initial copy of files from jbd")
Signed-off-by: Ye Bin <yebin10@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Message-ID: <20251025072657.307851-1-yebin@huaweicloud.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/jbd2/transaction.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1284,14 +1284,23 @@ int jbd2_journal_get_create_access(handl
 	 * committing transaction's lists, but it HAS to be in Forget state in
 	 * that case: the transaction must have deleted the buffer for it to be
 	 * reused here.
+	 * In the case of file system data inconsistency, for example, if the
+	 * block bitmap of a referenced block is not set, it can lead to the
+	 * situation where a block being committed is allocated and used again.
+	 * As a result, the following condition will not be satisfied, so here
+	 * we directly trigger a JBD abort instead of immediately invoking
+	 * bugon.
 	 */
 	spin_lock(&jh->b_state_lock);
-	J_ASSERT_JH(jh, (jh->b_transaction == transaction ||
-		jh->b_transaction == NULL ||
-		(jh->b_transaction == journal->j_committing_transaction &&
-			  jh->b_jlist == BJ_Forget)));
+	if (!(jh->b_transaction == transaction || jh->b_transaction == NULL ||
+	      (jh->b_transaction == journal->j_committing_transaction &&
+	       jh->b_jlist == BJ_Forget)) || jh->b_next_transaction != NULL) {
+		err = -EROFS;
+		spin_unlock(&jh->b_state_lock);
+		jbd2_journal_abort(journal, err);
+		goto out;
+	}
 
-	J_ASSERT_JH(jh, jh->b_next_transaction == NULL);
 	J_ASSERT_JH(jh, buffer_locked(jh2bh(jh)));
 
 	if (jh->b_transaction == NULL) {


