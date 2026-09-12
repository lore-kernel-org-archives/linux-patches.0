Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5EEA373BF3;
	Sat, 12 Sep 2026 09:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204036; cv=none; b=o5Jg0m52UHZMCAR18XlC/olsOkJSzIWsHQjop5aLWRZo3hIBU0WSqX13aVhZpMSx0v6g5K3Dqi/qBnVsJYfa1EGFHIASn3h06yiTUXwyjCcqyIBe/pkNrS3YMcycvCbHkg0OGOgBH0BWTSaicuI5MBoJMiRPhoRxTUhj4RgcA8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204036; c=relaxed/simple;
	bh=KvcO8WIw/G6HcrDVP8RJgKi4Th3B74oOkyjrK2/9Gmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mZcU5FpilEl3NCLiNQpYN8o8x8+FCkz4grao3n2z1WrHBXDMf2jb41VljiJxYtl21nwo+X4xm+U+BbTQ6NE3d1lWUp5COS0MoCA/fDY4wDat9gfd3zQ/CI/nMDifCATPUFoilOaiwi0pb3Pd5WwQhIPEPaWfN6+1F+xdvsGdci8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kmlYu5Te; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kmlYu5Te"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BF01F000FF;
	Sat, 12 Sep 2026 09:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204034;
	bh=q5Uk0VMu4GjfGea7BuWPpeLXaAdy/+82c/ff/jmcNUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmlYu5TeVUPZuGGQyLpDAMZX8ktjEwP9sA6+OS1tMXjt6tnmi5gtAOnJQWd1fa+KZ
	 8IVFAjdWuCZzkR2+mNmZLR4FL6qv7rLBkuCixuPc4RfrkwGLRtoiE4HgSmxXiSjGOS
	 9UR6rSfEQQHumVRq1pg63TlM3l3FgCwVIZN/NSVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1530/1815] ksmbd: safely discard unregistered deferred locks
Date: Sat, 12 Sep 2026 08:54:40 +0200
Message-ID: <20260912065724.924749914@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 215e8816b1ac ("ksmbd: detach blocked lock requests before freeing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/server/smb2pdu.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 5e99c48fa0dc4..42ca6125a510c 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -8522,6 +8522,13 @@ static void smb2_remove_blocked_lock(void **argv)
 	locks_wake_up(flock);
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
@@ -8796,11 +8803,12 @@ int smb2_lock(struct ksmbd_work *work)
 
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
@@ -8811,8 +8819,11 @@ int smb2_lock(struct ksmbd_work *work)
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



