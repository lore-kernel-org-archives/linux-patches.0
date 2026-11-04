Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826919;
	b=UGLsVen9HdZyRjH2hS7/JPXFxKQq0bJHAf4eQRM5pe1+n40J8MOCLWVdLH7PMtFP8qR6
	 rsS0g6DL3eYhMMpeFp7rSRBIi4EYetXMMS6uQ2qY5nff/2INL+YXZ+bUQ2JUmHdbfSHkb
	 zWDsWu/Y9Qe51XKBp68xUKQu7mzGIzgjEzIC/5tfNBEltoXbgq4FJM9LdDL/ajkHjjr6B
	 9cDcz8bn4D+Bl6lzd89MgK6R8eliIO+C24qwk2e582uq5Lo1oMV22LiMK9zRyhTJV7293
	 T1ADLOuqo/5pLLlXbdzdVhw7gaAPLMpv4ptUgyClNddIA7JYnU5jKBwCozWmcgH1fkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dVtFgunb6R8/DNmYd2c9RcX5/oSG7uxMZaj/z0WzXik=;
	b=FC2FldFlQHpR7yRnkfTa/wMK5cPHGtJvud1KQLyyXneoU5grNm0e8IeRRyyBCk4WZuLa
	 rJzS3WVTxdOEkTmSr8EBZDce73xD+cS52FmMjYLpCUROW/NCPCnp4Ixv+793ST2viDtgz
	 faS0cZ5/s3jMStMmRxitljtcESbQaq8gDR7cdl0YUL7lmR88/Wja2uALcVOrQK+OQ6RGf
	 JoI4fTSGklfDeK0tDNIDwWjh+kD6v8DgklnY3fqxEk4E3eXQoA9tIvL2XLVLQBSN9hev7
	 jKg2VbggIGNeGWSwgikC2G7IQwzBZYUeaD1CKsOAELxXLLD7rCBF396PrAQS69aRhJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQguIky1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520A56070318;
	Wed,  4 Nov 2026 21:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQguIky1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27BA1F00919;
	Wed,  4 Nov 2026 21:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826919;
	bh=dVtFgunb6R8/DNmYd2c9RcX5/oSG7uxMZaj/z0WzXik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQguIky1XAxE7jRjAJ+wzZuITd8veEqtBqNMdlhLol8+jgVutKaF6VDe6sNhapwq/
	 SsiCzDoCpBj51lFfhhqALg9P0qVe88XYey2Z692N1+8sPQhQZ4oD4xvEPXOsWDGkWg
	 VknsBGV1boXVoRz/aLd7Jt+gzyVrns9Tm8I08JnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Wolff <nicholas.wolff@truenas.com>,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 7.3 084/547] nfsd: fix race between client_info_show() and free_client()
Date: Wed,  4 Nov 2026 16:04:28 -0500
Message-ID: <20261104211040.626140958@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ameer Hamza <ameer.hamza@truenas.com>

commit ee62dc03a69ee57855de35da1a8ab53b51d30b32 upstream.

client_info_show() renders /proc/fs/nfsd/clients/<id>/info and walks
clp->cl_sessions under clp->cl_lock to print each session's slot
counts.  free_client() tears down the same list without taking
cl_lock, and is the only unlocked mutator of cl_sessions.  A reader
can observe a client mid-teardown because get_nfsdfs_clp() pins the
nfs4_client but not its sessions: free_client() frees every session
before calling nfsd_client_rmdir(), so an in-flight seq_file reader
can follow a list_del()'d node whose ->next now holds LIST_POISON1
and take a general protection fault:

  Oops: general protection fault, probably for non-canonical address
        0xdead00000000014c
  CPU: 1 UID: 0 PID: 132488 Comm: cat
  RIP: 0010:client_info_show+0x2bf/0x3d0
  RAX: dead000000000100
  Call Trace:
   seq_read_iter+0x12a/0x4b0
   seq_read+0xf1/0x130
   vfs_read+0xbf/0x350
   ksys_read+0x6f/0xf0
   do_syscall_64+0x8b/0xcb0
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  Kernel panic - not syncing: Fatal exception

Detach cl_sessions onto a local reaplist under cl_lock, then free the
sessions after dropping the lock.  Removing entries from cl_sessions
under cl_lock matches unhash_session(), and the detach-then-reap shape
matches how __destroy_client() reaps cl_delegations.  The sessions
cannot be freed while cl_lock is held, since free_session() calls
nfsd4_del_conns(), which re-acquires it.

Reported-by: Nicholas Wolff <nicholas.wolff@truenas.com>
Fixes: 601c8cb349c2 ("nfsd: add session slot count to /proc/fs/nfsd/clients/*/info")
Cc: stable@vger.kernel.org
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Link: https://patch.msgid.link/20260726124658.1715711-1-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4state.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -2789,10 +2789,16 @@ void nfsd4_put_client(struct nfs4_client
 static void
 free_client(struct nfs4_client *clp)
 {
-	while (!list_empty(&clp->cl_sessions)) {
+	LIST_HEAD(reaplist);
+
+	/* client_info_show() walks cl_sessions under cl_lock */
+	spin_lock(&clp->cl_lock);
+	list_splice_init(&clp->cl_sessions, &reaplist);
+	spin_unlock(&clp->cl_lock);
+	while (!list_empty(&reaplist)) {
 		struct nfsd4_session *ses;
-		ses = list_entry(clp->cl_sessions.next, struct nfsd4_session,
-				se_perclnt);
+		ses = list_entry(reaplist.next, struct nfsd4_session,
+				 se_perclnt);
 		list_del(&ses->se_perclnt);
 		WARN_ON_ONCE(atomic_read(&ses->se_ref));
 		free_session(ses);


