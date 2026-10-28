Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216387;
	b=oWnBsWnV9uPfBjIoUfpl4enJtkUPwpeIFsnZy1Y1SFVKl38q0WWL3VemHgM/WjdjN5k6
	 XNVPX1sTSCETScLxd+Q7ebQCxkv/H+BjW1KCSNxXRpLtQ1rnKDJtWn60QHCTt+YvXF4Z9
	 s+qsnpmgLe4ZZW0UzgoiLgOkt994AzPS1xjdoIFGT9yBM7YjIKCZCjSD3+KQ9DGnKG6Wx
	 OCqGHd5Y09ZpdRc6UAgoGZ82wxTQpBnAq5rLx4BkHUE32wUJG2wCKNZPrDAlwZPPD18ci
	 XJCPF7vo3B/bf6/JAYyx3TJszmI2qLO4L2rJhPENBEvXeH9Ud1TeSDHQqA4aKJdT9ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216387;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XUbc5lqRDBNtyftuXEN/glzxFsJFIXiPfgxknnBjZJ8=;
	b=rC3DZgow9L8mTKCT4JPSHXmDH1X97Q2NoCtMu9PsyKlGTD47xBgZGFjZBL6akTkm4woX
	 IV2Q/3sow4cQS+AGFx8uFB3lRajl0E9KlZFa6xiQ2UQNzR3DnCIDBGVYf1pPtmbX4f/Sz
	 jYftphGGZ21zdF5UoiW3Ub2S8wnZdq1JgsxIRu6J/OjSDRDbJlwtJesd+TEJ8dMMim0XW
	 bizfzAmRkMv8bKrY1jQI5Jybr5yM7Ckk7cdCOB0lFS/elPp0KKH4V1vWYTEJrbPaSA4AT
	 R0w/HbumWaLHlg0N71a/Sy8ciwbdatnq/UJh955k0zy24/rqldl1Wlj6Vp+d8CrGUAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7AQhmrL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE6B606A31A;
	Wed, 28 Oct 2026 19:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=M7AQhmrL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F981F01825;
	Wed, 28 Oct 2026 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216387;
	bh=XUbc5lqRDBNtyftuXEN/glzxFsJFIXiPfgxknnBjZJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M7AQhmrLmMNCa2y+9fTIhre8UGT4G6k1VeU3XDTzUk70wmdDPAt+7fUpUbpIY4fFP
	 M1Pbq7PwtRIE0AuYbYeeuJ95fJb+EaS/yK68xee4B1hyiMNSBzSPmmOrbqRgtC1U2h
	 /NQkMOD4Zww9sGrXoAI5UqLa/8Dle42fkLSzRQBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1538/1887] ksmbd: safely discard unregistered deferred locks
Date: Wed, 28 Oct 2026 18:00:34 +0100
Message-ID: <20261028170534.466225634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f89b90eb9bf31..5acfa540f8f9b 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7087,6 +7087,13 @@ static void smb2_free_lock(struct file_lock *flock)
 	locks_free_lock(flock);
 }
 
+static void smb2_free_blocked_lock(struct file_lock *flock)
+{
+	ksmbd_vfs_posix_lock_unblock(flock);
+	wake_up(&flock->fl_wait);
+	locks_free_lock(flock);
+}
+
 static inline bool lock_defer_pending(struct file_lock *fl)
 {
 	/* check pending lock waiters */
@@ -7329,11 +7336,12 @@ int smb2_lock(struct ksmbd_work *work)
 
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
@@ -7344,8 +7352,11 @@ int smb2_lock(struct ksmbd_work *work)
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



