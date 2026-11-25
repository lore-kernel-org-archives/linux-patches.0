Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624959;
	b=GTgSKA+boSgkJdMq0uuJVIo8j670v+6OXqv7cKAJSWb/RDRpDm7Scd6fPYq883YJD5bt
	 2XlwztOO4z29kMFvQCkdrixkKNaboSxxjIhcNGx4BQm/Iivl8Z94nN3hSH3/VClC/tbmG
	 OVvOQ+4DptcE9mZ/wsxEmHGSaH9v05tH3xTRraTpp3P7SrT7T+pU+b1dutuHJGXdQfqxF
	 Gr2v9x9f2ndXuhiTVKeFWCITeZCh+nb6icy39qnhkG8p3S0TdJU2DOnFXciKZWQQ+0wWj
	 1RqcNjTv3DozPEgwls+XthbIDBQifwX7ksUTekdao65N3s4ddpFCXm28++whUo3N2NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T+Am2kJFdQS4H+I6aV5AGcZ+c/OFdN4qG583x6xoZTA=;
	b=0fhStCMQWbBMg9M3zwIWLY148IA2gXTlXnmVNfewz1u2SOY+/o/YfMX97KQNN9d+G5KF
	 5zlwBbo4tDZv4XGB/uRIbFlQ6bVyiLUr9a5rxCNrp7D1izRaH/WLd0BpVPxiKheRbkHF3
	 ENKN+wTuwAJi+AsqbbcNluJ80CQ0f1LV9vDZln+8KWjBk2MCL/amCqieywwp6kIRXDoUM
	 mEE0qdkA2RVO2e53yHmqZVnpA1DffF57nZAqLxLTPqj5os+IKZnVZW3z9OMxrgcp7ABQ+
	 +ykSx9hu1KEu5U4YC6dsFROEo5GX+4MTZJfjqgorkhAOrLif1P0TTMNAd4nhAyrnUaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuj5z5tS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6248B606A323;
	Wed, 25 Nov 2026 16:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fuj5z5tS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8461F000C6;
	Wed, 25 Nov 2026 16:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624958;
	bh=T+Am2kJFdQS4H+I6aV5AGcZ+c/OFdN4qG583x6xoZTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fuj5z5tS1X5P8KqIQ1t6nA0wK3x53zxTYq/jaohTEIJqTV1uvFgme1vymWXF5QnAV
	 QLk0RHc669sHohiA5+QsIgIsw0iI30A/PoAiNvWqPiqIMH3GDf+KAENSwz773fQws3
	 dvauPRuCCFA/Y2qrEP3xMXd7keuroqY5R4pD8fDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olga Kornievskaia <okorniev@redhat.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/816] NFSv4: wake blocking lock waiters when a delegated lock is released
Date: Wed, 25 Nov 2026 15:31:11 +0100
Message-ID: <20261125143856.678873315@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cc14a62a23d74..32a129d86925d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -7273,8 +7273,15 @@ static int nfs4_proc_unlck(struct nfs4_state *state, int cmd, struct file_lock *
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
@@ -7696,8 +7703,14 @@ nfs4_wake_lock_waiter(wait_queue_entry_t *wait, unsigned int mode, int flags, vo
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



