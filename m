Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F5B37701A;
	Sat, 17 Oct 2026 17:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259996; cv=none; b=cM3yM9Bv9GFAOc/AQRAdR7qh3+u2xrIPu5vgEeO9lFPPh0BRh3gKGvIsEnYe6n6cPcsmfWw6Aq3xsEQWu000JOhC1yamRTklGrAACNtTCkM/xgCoMyfCqVNIQ/RjvRNnlrjxqu251iJBdbrXeo7yk5/uUZb5Khh/ZyWtSYSDKaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259996; c=relaxed/simple;
	bh=tGcbkbeDM/6X+KyiKPsnKfQSAO4egpKNGtNzHBbCQOA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rE9tkDsvx4pGulR65/X9tJ8kRFiyyzQVoCBHE9nhRg84ZED758lqSNPdUPrMFtvtlFlbob5O6dSbUtTtr+tnoT6yEBXOPZtx0DcE1A161tfJxqoQqtLoUpT8LlYa+tAgwJzJonYWgHOqWRj+pIB0vvtmh3A9AdZhNtKOFkNDv8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQmBSYSu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQmBSYSu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD451F000C4;
	Sat, 17 Oct 2026 17:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259994;
	bh=f76qm9qt+hqjsr4n3TSAinpQ2xDSFqra0h920ig0EcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQmBSYSuyru5yygHfmCrbfy4yTxQA16BC3EeEXZz3k2A/7ujKqb1rbUOlAYTUiTJF
	 MA4D5nHxdj52NSpHprvCiNxyqRUCaBg98cKXiF/RRV+yD0D0cOT59tl68FjKuV/X64
	 E3RwrgFne9hwluDbVIvaCOtR1o9Tfs8Ydw3np3W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1397/1674] ksmbd: safely discard unregistered deferred locks
Date: Sat, 17 Oct 2026 18:01:09 +0200
Message-ID: <20261017160507.036107542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 054bcca4cd9f00719b01f7108b51a2168fb94f15 ]

When vfs_lock_file() defers a lock, smb2_lock() puts its ksmbd_lock on
rollback_list before allocating and registering the asynchronous work.
If either operation fails, rollback assumes that smb_lock->conn is
initialized and dereferences NULL. The deferred file_lock also remains
linked into the VFS blocked-lock state while it is freed.

Keep the lock off rollback_list until async setup succeeds. On setup
failures, explicitly unblock and wake the deferred lock before freeing it
and its ksmbd wrapper.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 602b170c4bb5b..ac0cb1df9f440 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7512,6 +7512,13 @@ static void smb2_free_lock(struct file_lock *flock)
 	locks_free_lock(flock);
 }
 
+static void smb2_free_blocked_lock(struct file_lock *flock)
+{
+	ksmbd_vfs_posix_lock_unblock(flock);
+	locks_wake_up(flock);
+	locks_free_lock(flock);
+}
+
 static inline bool lock_defer_pending(struct file_lock *fl)
 {
 	/* check pending lock waiters */
@@ -7754,11 +7761,12 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_debug(SMB,
 					    "would have to wait for getting lock\n");
-				list_add(&smb_lock->llist, &rollback_list);
 
 				argv = kmalloc(sizeof(void *), GFP_KERNEL);
 				if (!argv) {
 					err = -ENOMEM;
+					smb2_free_blocked_lock(flock);
+					kfree(smb_lock);
 					goto out;
 				}
 				argv[0] = flock;
@@ -7769,8 +7777,11 @@ int smb2_lock(struct ksmbd_work *work)
 				if (rc) {
 					kfree(argv);
 					err = -ENOMEM;
+					smb2_free_blocked_lock(flock);
+					kfree(smb_lock);
 					goto out;
 				}
+				list_add(&smb_lock->llist, &rollback_list);
 				spin_lock(&fp->f_lock);
 				list_add(&work->fp_entry, &fp->blocked_works);
 				spin_unlock(&fp->f_lock);
-- 
2.53.0



