Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831921;
	b=fZ6nAWFXR1gUBtXpjUjOP8e5Jzj8hUL3uksuwpct6v4L+iJm+dNr7f+3siHbKoC9jVzG
	 TsQ1t68DEM9awUn1XK3qyK0nZ7FC5diobXg9hF1ZBgU0StJTv/m0u2KIzzCgXaOAXFu4l
	 MRWAUy4/LwD/2bTyR4V9gpq20KRuTXr9GOGvYgfFqnoFIbr/5Ncyn0L8HqWLuoVGcbXDy
	 63TUZJZYIA5C4ZJnVznUS3CdHVbuSITx5WXcdADZGs6aHJLUv5j/5+vBtbK32ntmMuemD
	 klhfc+bU5XGb61z9JMuql/BkKOnR9yEy6MruVFJr2K+82IsH12LZic54+nC7pKGpuvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Oc2EnMbM9gcVPSf9eIJWSidhy7OF8EGuZ+DyAF8wn5Q=;
	b=0J+5lsPgeu5zs5KedaT8KR9utIzHw2xRsXAS4RDimVIHNYPVBSnfmmLDL91wbvOeiTci
	 J7U2QKGbnh3GvDHWiTkh20w29srdbJdxlTpwhdTZSgyTBjIiPGn+ZW/BJI52l8lRJ5Ltx
	 h6KOcoqk+VpDx2S0d/6qdhCBpQ9IIp+J/X66U/nNDYL2IGi2xfBxfGNbJrLayzmf3yN6t
	 cpozT7VL+o6/twT3oO+Ro/bvX49L0eaQ1HwHapzw4xomItECl3Op6udwIEMKd00cPvEmF
	 DZ6RL3cSK3aYCHwFzBZ6bvIuGrZ3sAVcARtBGIFsLSROsW3hMKeZWSQgRkrx0/HgNTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdLsa5Gw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B28D606A328;
	Wed,  4 Nov 2026 22:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdLsa5Gw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148D31F000C1;
	Wed,  4 Nov 2026 22:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831921;
	bh=Oc2EnMbM9gcVPSf9eIJWSidhy7OF8EGuZ+DyAF8wn5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdLsa5GwGmBY0mA3EH95644MjBfe+cqVF6uIz1ErSJ/Iglo9VsZ9CHjKSCUeTrv/N
	 C3GOnI9SdP0ePj++QriREhwyKDAeFbXXUirSwySHDHucqcvEu9XXXD9GOIVt7pfS2U
	 JGP5T5dA1/Vw5b0Wj3ao/EJShiCjlTAPq3QlxP1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Bridges <icb@fastmail.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0995/1005] ksmbd: fix use-after-free after a failed durable reconnect
Date: Wed,  4 Nov 2026 16:12:08 -0500
Message-ID: <20261104211110.904812605@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Ian Bridges <icb@fastmail.org>

[ Upstream commit 248b5819591c577727930e4e255a455235fab50a ]

ksmbd_reopen_durable_fd() republishes a detached durable handle in the
reconnecting session's file table and takes no reference for that entry.
If smb2_open() then fails, cleanup relies on the final ksmbd_fd_put() to
remove the volatile id.

Two reconnects of the same handle can both take a lookup reference before
either attaches it. If the one that reopens first then fails and drops
its references first, the other request makes the final put through
ksmbd_put_durable_fd(). That frees the handle without removing the first
session's table entry, so tearing that session down writes to freed
memory.

  BUG: KASAN: slab-use-after-free in __close_file_table_ids+0x14d/0x740 [ksmbd]
  Call Trace:
   __close_file_table_ids+0x14d/0x740 [ksmbd]
   ksmbd_destroy_file_table+0x76/0x100 [ksmbd]
   ksmbd_session_destroy+0xf8/0x480 [ksmbd]
   ksmbd_dispose_sessions+0x13e/0x200 [ksmbd]
   ksmbd_conn_sessions_cleanup+0x4c3/0x6d0 [ksmbd]
  Freed by task 1030:
   __ksmbd_close_fd+0x97d/0x1000 [ksmbd]
   smb2_open+0x14eb/0xd9f0 [ksmbd]

Commit 3515503322f4 ("ksmbd: fix durable reconnect error path file
lifetime") handles a final put made by the reconnecting request, but not
one made by another holder.

Remove the volatile id under the file-table lock on this error path,
before the references are dropped, as ksmbd_close_fd() does on the
request_open path just above. Removal then no longer depends on which
holder makes the final put. The stale comment in the reconnect cleanup
is updated to match. A successful reconnect is unchanged.

Fixes: c8efcc786146 ("ksmbd: add support for durable handles v1/v2")
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
[ sashal: Adapted the cleanup call to a braced if (fp) block because the replay and request-open cleanup branches are absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c   |   12 +++++++-----
 fs/smb/server/vfs_cache.c |   28 ++++++++++++++++++++++++++++
 fs/smb/server/vfs_cache.h |    2 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -3933,8 +3933,11 @@ err_out2:
 		if (!rsp->hdr.Status)
 			rsp->hdr.Status = STATUS_UNEXPECTED_IO_ERROR;
 
-		if (fp)
+		if (fp) {
+			if (dh_info.reconnected && fp == dh_info.fp)
+				ksmbd_unpublish_reopened_fd(work, fp);
 			ksmbd_fd_put(work, fp);
+		}
 		smb2_set_err_rsp(work);
 		ksmbd_debug(SMB, "Error response: %x\n", rsp->hdr.Status);
 	}
@@ -3942,10 +3945,9 @@ err_out2:
 	if (dh_info.reconnected) {
 		/*
 		 * If reconnect succeeded, fp was republished in the
-		 * session file table.  On a later error, ksmbd_fd_put()
-		 * above drops the session reference; drop the durable
-		 * lookup reference through the same session-aware path so
-		 * final close removes the volatile id before freeing fp.
+		 * session file table, and the error path above has
+		 * already removed its volatile id.  Drop the durable
+		 * lookup reference through the same session-aware path.
 		 */
 		if (rc && fp == dh_info.fp)
 			ksmbd_fd_put(work, dh_info.fp);
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -486,6 +486,34 @@ static void set_close_state_blocked_work
 	spin_unlock(&fp->f_lock);
 }
 
+/**
+ * ksmbd_unpublish_reopened_fd() - remove a reopened durable handle from the
+ *	session file table after its CREATE failed
+ * @work:	smb work of the failed CREATE
+ * @fp:		durable handle republished by ksmbd_reopen_durable_fd()
+ *
+ * The reopen publishes @fp in this session's table without taking a reference
+ * for the entry, so the CREATE error path's puts need not be the last ones.
+ * Another holder of a global-table reference, such as a concurrent reconnect
+ * of the same handle, can drop the last one through ksmbd_put_durable_fd(),
+ * which frees @fp without touching this table.  Remove the id here, while
+ * the caller still holds its references.
+ *
+ * Every path that removes the id before the final put also clears
+ * @fp->volatile_id under ft->lock, so a valid id is still @fp's entry.
+ */
+void ksmbd_unpublish_reopened_fd(struct ksmbd_work *work, struct ksmbd_file *fp)
+{
+	struct ksmbd_file_table *ft = &work->sess->file_table;
+
+	write_lock(&ft->lock);
+	if (has_file_id(fp->volatile_id)) {
+		idr_remove(ft->idr, fp->volatile_id);
+		fp->volatile_id = KSMBD_NO_FID;
+	}
+	write_unlock(&ft->lock);
+}
+
 int ksmbd_close_fd(struct ksmbd_work *work, u64 id)
 {
 	struct ksmbd_file	*fp;
--- a/fs/smb/server/vfs_cache.h
+++ b/fs/smb/server/vfs_cache.h
@@ -158,6 +158,8 @@ static inline bool ksmbd_stream_fd(struc
 int ksmbd_init_file_table(struct ksmbd_file_table *ft);
 void ksmbd_destroy_file_table(struct ksmbd_session *sess);
 int ksmbd_close_fd(struct ksmbd_work *work, u64 id);
+void ksmbd_unpublish_reopened_fd(struct ksmbd_work *work,
+				 struct ksmbd_file *fp);
 struct ksmbd_file *ksmbd_lookup_fd_fast(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_foreign_fd(struct ksmbd_work *work, u64 id);
 struct ksmbd_file *ksmbd_lookup_fd_slow(struct ksmbd_work *work, u64 id,


