Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42534F85CB;
	Tue, 13 Oct 2026 12:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893994; cv=none; b=OY3E3IOVSQmgb2CDvarGqfqqWyqGkQBdBWVc4XGlMZdVCMU8SZC3vL/rlLN26MRvy7vfWWA3IYD7zSyCk/SEbp+/+v3bYayUEK/orQtTKjIxCONilVQL1Pvk6rE0kCrbq54UkAaXDo2hOekthxY/18I6zW5yQWSs0B4wx8TMulQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893994; c=relaxed/simple;
	bh=FlOZXIXNCnC3j2TDupJCVIydOtsNlKohoEdidlyqhJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGXw58Us3W123CRMjnTNFq27otMoKapKeIXyjBzpm8i9VtxmyrG09r5JRzTpkjBycOSP4YZCiPy3pa1rvIfhQsQrMGlwnjXGSsQFl/VdvL1lRvdPgUBBPiIdONBRT0TrILGJU4KHYcWW3kAm3EQps38VNEyQIH160q1rZFdnnnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSbjWi8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSbjWi8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FF51F000FF;
	Tue, 13 Oct 2026 12:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893992;
	bh=qrgJKWIB/hDQAWLS7BLMoqpeh3i/UeS+OFeXE5ZR3jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LSbjWi8DWS8z3TrDNadlVj0UtmrJoH7BxO8OGupoQMwft6S10PXUSYFwFpcqX7KYU
	 RZ7ovcy2gIB1y/puIqep5ct1eHRbGV3t9fS8nyUUZFHIweuBwwH2dVA1mnBe79wNth
	 w9MHf+FpfVFq1Tl+RxKX4Sl/ZhuGQO4OUw47sbvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/621] ksmbd: safely discard unregistered deferred locks
Date: Tue, 13 Oct 2026 13:36:46 +0200
Message-ID: <20261013112930.590102148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 5e303942a7510..6860d5229e1a9 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7562,6 +7562,13 @@ static void smb2_free_lock(struct file_lock *flock)
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
@@ -7804,11 +7811,12 @@ int smb2_lock(struct ksmbd_work *work)
 
 				ksmbd_debug(SMB,
 					    "would have to wait for getting lock\n");
-				list_add(&smb_lock->llist, &rollback_list);
 
 				argv = kmalloc(sizeof(void *), KSMBD_DEFAULT_GFP);
 				if (!argv) {
 					err = -ENOMEM;
+					smb2_free_blocked_lock(flock);
+					kfree(smb_lock);
 					goto out;
 				}
 				argv[0] = flock;
@@ -7819,8 +7827,11 @@ int smb2_lock(struct ksmbd_work *work)
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



