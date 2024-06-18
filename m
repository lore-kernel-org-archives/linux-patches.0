Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 609C013BC35;
	Tue, 18 Jun 2024 12:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715565; cv=none; b=q3CsbfQntLGWI1uvtztmVTnWu6OsGly/XARvP2RBr/ZaoHSVg7U3YHoHfDWZe0ojX+DbCD0dN/DQA1TO0TM2vGnfqBOEV0ZtSPlmTIU7tTIryjfpQ0xHXBKqOTdOhA1fR50plLamSgqkUwNzpspTcpVo0YjzVPpKQkRthBDI64I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715565; c=relaxed/simple;
	bh=0E9ySLGQ6tre/qlDY9ajrY7DyOIIItCKbVax+i+uljo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ED14yh+4n7QyeFZGmxkVuLRm6lIkgraa+UDPKu5tU+0ttjbzueHhKRpCBSltwbQWnkpN7bjdHFzp+qUwrSjqZJ+/qSYOvpkluOrDjgQ5u21vFENOIMvZYtxIqkuD3irxooRP00YhjrvmVtEUuB7Di+T+XqZbtDUAAhBcoSkru74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jB6Ic1ZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jB6Ic1ZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE55DC3277B;
	Tue, 18 Jun 2024 12:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715565;
	bh=0E9ySLGQ6tre/qlDY9ajrY7DyOIIItCKbVax+i+uljo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jB6Ic1ZJAV4VJt4KCGyX/kha2SHq7X1TVk1DxsgNhpWTlWhLW1eLBuK1MAuAw6lQ/
	 26/Mg7GR9m+/xRxmHC9Hm6GA9T7XDOFS6Q6mCB112MRSvwUMdWkU79PPcRqbQMxFdo
	 rQhqp6RkWj3VzgBdMuWKxHTDe359So2qpjen8rhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 352/770] nfs: dont allow reexport reclaims
Date: Tue, 18 Jun 2024 14:33:25 +0200
Message-ID: <20240618123420.857536594@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit bb0a55bb7148a49e549ee992200860e7a040d3a5 ]

In the reexport case, nfsd is currently passing along locks with the
reclaim bit set.  The client sends a new lock request, which is granted
if there's currently no conflict--even if it's possible a conflicting
lock could have been briefly held in the interim.

We don't currently have any way to safely grant reclaim, so for now
let's just deny them all.

I'm doing this by passing the reclaim bit to nfs and letting it fail the
call, with the idea that eventually the client might be able to do
something more forgiving here.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/file.c         | 3 +++
 fs/nfsd/nfs4state.c   | 3 +++
 fs/nfsd/nfsproc.c     | 1 +
 include/linux/errno.h | 1 +
 include/linux/fs.h    | 1 +
 5 files changed, 9 insertions(+)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 7be1a7f7fcb2a..d35aae47b062b 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -798,6 +798,9 @@ int nfs_lock(struct file *filp, int cmd, struct file_lock *fl)
 
 	nfs_inc_stats(inode, NFSIOS_VFSLOCK);
 
+	if (fl->fl_flags & FL_RECLAIM)
+		return -ENOGRACE;
+
 	/* No mandatory locks over NFS */
 	if (__mandatory_lock(inode) && fl->fl_type != F_UNLCK)
 		goto out_err;
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index fd3bdf0bf0052..e9ac77c28741e 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -6946,6 +6946,9 @@ nfsd4_lock(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	if (!locks_in_grace(net) && lock->lk_reclaim)
 		goto out;
 
+	if (lock->lk_reclaim)
+		fl_flags |= FL_RECLAIM;
+
 	fp = lock_stp->st_stid.sc_file;
 	switch (lock->lk_type) {
 		case NFS4_READW_LT:
diff --git a/fs/nfsd/nfsproc.c b/fs/nfsd/nfsproc.c
index 72f8bc4a7ea48..78bdfdc253fd3 100644
--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -881,6 +881,7 @@ nfserrno (int errno)
 		{ nfserr_serverfault, -ENFILE },
 		{ nfserr_io, -EUCLEAN },
 		{ nfserr_perm, -ENOKEY },
+		{ nfserr_no_grace, -ENOGRACE},
 	};
 	int	i;
 
diff --git a/include/linux/errno.h b/include/linux/errno.h
index d73f597a24849..8b0c754bab025 100644
--- a/include/linux/errno.h
+++ b/include/linux/errno.h
@@ -31,5 +31,6 @@
 #define EJUKEBOX	528	/* Request initiated, but will not complete before timeout */
 #define EIOCBQUEUED	529	/* iocb queued, will get completion event */
 #define ERECALLCONFLICT	530	/* conflict with recalled state */
+#define ENOGRACE	531	/* NFS file lock reclaim refused */
 
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a9ac60d3be1d6..c0459446e1440 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -996,6 +996,7 @@ static inline struct file *get_file(struct file *f)
 #define FL_UNLOCK_PENDING	512 /* Lease is being broken */
 #define FL_OFDLCK	1024	/* lock is "owned" by struct file */
 #define FL_LAYOUT	2048	/* outstanding pNFS layout */
+#define FL_RECLAIM	4096	/* reclaiming from a reboot server */
 
 #define FL_CLOSE_POSIX (FL_POSIX | FL_CLOSE)
 
-- 
2.43.0



