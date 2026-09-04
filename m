Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A727080D;
	Fri,  4 Sep 2026 05:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498932; cv=none; b=nv93jUXjTkOXYaWpyh0w1ORsgin6ldCOO+icOqxPOjdfobUwYSriZpJ+ltQPGnisBQAgGHNDM2+9/X+avF1ViuupYxB/JcT7259EYcfIY247WTm6jFClq0HheoKo7aZqOK1eL5rgH+G72Us91MM05vij1yD4JPxGOZ4Z587vRRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498932; c=relaxed/simple;
	bh=LsEQEDN2GvSaPRlWyqi50+OyGnVBNUzKb57ZngX9IPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoBRhtx952CYpdi5SmslfP8ngHHl4c06f0ehLE1hJcXJJVwPprXKbuovpopkem2vNaW5G1DZQflJbn097EaANxS5taQm8ZSDPWIBZRLlZLi4qqa8PBjuv6YqtgANLjfR87sCHOIvLeHbIIrNrmGMfOpcO8eOoeMDSAWAgkcEA+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Yzs9Vtk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Yzs9Vtk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2D71F00A3D;
	Fri,  4 Sep 2026 05:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498931;
	bh=U29PQTRTaWQcVIgSSflarkmgrtxvS7i+8Kk+c3RbQnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Yzs9VtkH0ry1BAC6B3exl8R5at5OXf/f62Y6qroQHyxLqvZThakddzTymeTBCRnk
	 lJ6iSgmnUyjQDkXxNJVmjqvdQ8Thm84XDhYK0c5P2r1t316fm+Ygo3fW7RC/ZNXyaz
	 dj5YpoV0SPAc4oLRpeknkmP051azPcdBWwwdj+hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Ariel Panzardo <qwe.aldo@gmail.com>,
	ChenXiaoSong <chenxiaosong@kylinos.cn>,
	Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 7.2 238/713] ksmbd: only rebind the reopened files own oplock on durable reconnect
Date: Fri,  4 Sep 2026 06:53:26 +0200
Message-ID: <20260904045809.160769889@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Aldo Ariel Panzardo <qwe.aldo@gmail.com>

commit 3f220a0a62e6b9b391c9d1f0e6580b05173cc7f7 upstream.

ksmbd_reopen_durable_fd() walks the inode's m_op_list and rebinds every
detached oplock to the reconnecting session:

	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
				lockdep_is_held(&ci->m_lock)) {
		if (op->conn)
			continue;
		op->conn = ksmbd_conn_get(fp->conn);
		op->sess = work->sess;
	}

The only key is op->conn == NULL, which every detached durable handle on
that inode matches, not just the one owned by fp.  When two sessions hold
durable handles on the same file and both disconnect, reconnecting one of
them adopts the other session's oplock: op->sess is overwritten with the
reconnecting session without taking a reference on it, while op->conn
pins the connection.

The sibling teardown path, session_fd_check(), keys on the identity of
the connection being torn down (op->conn == conn) rather than on shared
state, and so does not have this problem.

Once the adopting session is destroyed, ksmbd_session_destroy() frees it
while the foreign oplock still points at it.  The reader in
ksmbd_close_fd_app_instance_id() validates only opinfo->conn, which is
still live thanks to the reference taken above, and then dereferences the
stale session:

	if (!opinfo->conn) {
		up_read(&fp->f_ci->m_lock);
		goto out;
	}

	ft = &opinfo->sess->file_table;
	write_lock(&ft->lock);

  BUG: KASAN: slab-use-after-free in _raw_write_lock+0x74/0xd0
  Write of size 4 at addr ffff88810a970528 by task kworker/0:0/9
  Workqueue: ksmbd-io handle_ksmbd_work
  Call Trace:
   _raw_write_lock+0x74/0xd0
   ksmbd_close_fd_app_instance_id+0x183/0x410
   smb2_open+0x1346/0x4430
   handle_ksmbd_work+0x2bb/0x7b0

Reached from an authenticated session against a share with the default
durable-handle and oplock configuration: two sessions open the same file
with a durable-v2 handle and an RH lease under distinct AppInstanceIds,
both log off, one reconnects with DH2C, and a later durable-v2 create
carrying the other AppInstanceId walks into the freed session.

Constrain the loop to the oplock owned by the file being reopened.

Fixes: f363a0fb134a ("ksmbd: fix app-instance durable supersede session UAF")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Ariel Panzardo <qwe.aldo@gmail.com>
Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/vfs_cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1722,7 +1722,7 @@ int ksmbd_reopen_durable_fd(struct ksmbd
 	down_write(&ci->m_lock);
 	list_for_each_entry_rcu(op, &ci->m_op_list, op_entry,
 				lockdep_is_held(&ci->m_lock)) {
-		if (op->conn)
+		if (op->conn || op->o_fp != fp)
 			continue;
 		op->conn = ksmbd_conn_get(fp->conn);
 		op->sess = work->sess;


