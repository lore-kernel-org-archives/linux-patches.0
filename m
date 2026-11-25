Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622072;
	b=mugt3wWpq2+of66QRQ2xPwM6liZgB+9AcjWp+HccXvXUQTM/cDsAjLHPhNCv+8TC+R5s
	 W7UFkJnwWlhRXeUlm9CSdf0s5sQr24zSfKPC7tr+4qOO9+sPk3yEqmLSMFCpGOUt42u1q
	 M4fCmZAGuSr32m/wgx2tQd6MIZHYrHOVVZwQR8zlMw7ofNCatFqT9s3mC3nyhhhUkNR9l
	 GdBiA71vws64bAQVjjQNTxK+ulKmIN8o/yx4JKxfvu5MHRlgLOWNBT+62KLBKoYpe8b2e
	 fAm5hBbXIo9U/4qPL9I0l09Ma/vau/DGLP74OHm+gU/6nNyljfpBoAUFbFVHkvrQPmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Rp3ZACmNw48zHE6lGFRMag2CxBRPXmCftaa5hVCrAjI=;
	b=WxBa52VACNtBkr0K6jucbCKuD1GxmfdzCve0AnY+466xL9LYA/f7ywGm7vBTv/Ge4tJ8
	 yrEykaJamuGDMEfaeOMnh/0ib//IkvXxclsYpvTWRXzjyKYNrLoOSBW6RQMrNfS4C5E/X
	 mYiYP0cKoHmEIm428+dES4JUmdeaMUOQfN1VS8LeWXiSXTaEneEijrr3Twm4OEzlTQ6kw
	 0RCGTjjWiEquBeX4I8cY4G6+yhhl0K1ad80ikE+vCHqb+KY4fx6ySHfJCbWKYNDEIF+7O
	 LyLamE3exVM5r4mWkxwowiP+1Z2/8evE6mbJfvlIM7D/hO7q7nlP1I11pJrfib+PUcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToWzbBf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46308606A32C;
	Wed, 25 Nov 2026 15:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToWzbBf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 470CD1F000C4;
	Wed, 25 Nov 2026 15:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622071;
	bh=Rp3ZACmNw48zHE6lGFRMag2CxBRPXmCftaa5hVCrAjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToWzbBf9e7vkRpJ2Y/UIEyNkfH2wJfHpexFY8/C58TWelMiGgH0kXeoa2mdzXriTu
	 WpGaM0jYk69f6/1qzKHl6SAXoyjVQl8h/Mcx0Hn+Ukykv2A2vydsfXMyiQRQRDmriO
	 dvN1lh1Pqxhy2eya3FZXTFVUBIfooZI6gabEkA4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/990] NFSv4: wake blocking lock waiters when a delegated lock is released
Date: Wed, 25 Nov 2026 15:29:48 +0100
Message-ID: <20261125143831.960113276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olga Kornievskaia <okorniev@redhat.com>

[ Upstream commit e8433473eca284bc561373d0a0fff632f76aa594 ]

When the client holds a delegation, _nfs4_proc_setlk() caches POSIX
locks locally and never sends a LOCK to the server. It has to strip
FL_SLEEP to do so, since that branch runs holding
sp->so_delegreturn_mutex and nfsi->rwsem and F_SETLKW can block
indefinitely. A contending waiter is therefore never placed on the VFS
blocked-lock list, and locks_wake_up_blocks() does not reach it when the
holder releases.

The waiter blocks in nfs4_retry_setlk() on clp->cl_lock_waitq instead,
whose only waker is nfs4_callback_notify_lock(). The server never saw a
LOCK for a cached lock, so it does not know anyone is waiting and will
never send a CB_NOTIFY_LOCK; nfs4_proc_unlck() returns early without
sending LOCKU for the same reason. The waiter sleeps out the full
NFS4_LOCK_MAXTIMEOUT of 30s before retrying a lock that is long free.

Wake cl_lock_waitq when releasing a cached lock. The releasing thread
cannot tell which waiter wants the lock, so the wakeup names only the
inode; make the owner comparison in nfs4_wake_lock_waiter() conditional
on cbnl_valid so that a CB_NOTIFY_LOCK still wakes exactly the owner it
names. The inode restriction matters: without it every blocked locker
for the server is woken, and those on non-delegated state each retry
with a LOCK RPC.

Fixes: a1d617d8f134 ("nfs: allow blocking locks to be awoken by lock callbacks")
Assisted-by: Claude Opus 5
Signed-off-by: Olga Kornievskaia <okorniev@redhat.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1e8c1fe993aaf..f37f71226d0ea 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7323,8 +7323,15 @@ static int nfs4_proc_unlck(struct nfs4_state *state, int cmd, struct file_lock *
 	if (status != 0)
 		goto out;
 	/* Is this a delegated lock? */
-	if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) == 0)
+	if (test_bit(NFS_LOCK_INITIALIZED, &lsp->ls_flags) == 0) {
+		struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+		struct cb_notify_lock_args cbnl = { .cbnl_valid = false };
+
+		/* The server never saw it, so it will not notify waiters */
+		nfs_copy_fh(&cbnl.cbnl_fh, NFS_FH(inode));
+		__wake_up(&clp->cl_lock_waitq, TASK_NORMAL, 0, &cbnl);
 		goto out;
+	}
 	alloc_seqid = NFS_SERVER(inode)->nfs_client->cl_mvops->alloc_seqid;
 	seqid = alloc_seqid(&lsp->ls_seqid, GFP_KERNEL);
 	status = -ENOMEM;
@@ -7746,8 +7753,14 @@ nfs4_wake_lock_waiter(wait_queue_entry_t *wait, unsigned int mode, int flags, vo
 		struct nfs_lowner		*lowner = &cbnl->cbnl_owner,
 						*wowner = &waiter->owner;
 
-		/* Only wake if the callback was for the same owner. */
-		if (lowner->id != wowner->id || lowner->s_dev != wowner->s_dev)
+		/*
+		 * Only wake the owner a CB_NOTIFY_LOCK names. A lock cached
+		 * under a delegation is released locally, and the releasing
+		 * thread cannot tell which waiter wants it, so those wakeups
+		 * (cbnl_valid false) name only the inode and wake them all.
+		 */
+		if (cbnl->cbnl_valid &&
+		    (lowner->id != wowner->id || lowner->s_dev != wowner->s_dev))
 			return 0;
 
 		/* Make sure it's for the right inode */
-- 
2.53.0



