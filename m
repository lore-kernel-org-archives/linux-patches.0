Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208218;
	b=4hLQIjvw0hf8fCb4LqG1kgcJUNegMhCKwUP9YeARb1USiIt25+D2suPmt2sIEkdxjvTZ
	 B7k8G2RrcDaSUAG6CW+f0fImO4BfsjhZbXOGhK4mmz1CKdBuvppd+7l4IKyX1lOSMChUd
	 8apzlJixvRX5NO/dblJh2AvaXoqmupb7ek2DhObobwtR+Zs05NwbrLstK91JtMSeQPZAl
	 Jjxgu8vL/rrBqwMh2SUc6QrRntgPYAospmilARKSvQbZLQBFlCFMgzgqpRHZGGz0rNnXG
	 XbYwESVglFPUCFdbxKacTwK5V9dUUCi67iLZJLcvKb+qO1HY5YsE72V6wcrN3DdPDdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hct9jtJiQ65kOrJ64FCtGavtPlhMpi0vNgs7OuKkQdg=;
	b=P/VcGEnrG8gbVrrnCZ5r2JA170W3q5KUx/RpeZA9FK5yn8ViqecdozXgU3iiRdJEJZLF
	 niLANaHIGlDLyndeCs4cq1tvKDpdMBXUBz99e7tujGuI/xf/5yNUlXnXs9qt8HR2FPW+P
	 cdzy00DoHZZScpWs+8BClR4FCxfLYUFEIB1PhwN9MJORiWsxA3B2Mz1YKeTumlbgKg7yL
	 S8KL8grJzk45wz8vrPbSDMKSxnvBO88WfZcRw8AX8emwjh0BGR4WvMRPDb2Qdr0mo6ewZ
	 J+BGcuswY/J4gWoz1y+9ChJZK6AY+gnvZTrkWDDaFy1O9Un9f59ZKf79u1ZKt9jZoTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="K8vV1/OO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFBFB606A31D;
	Wed, 28 Oct 2026 17:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K8vV1/OO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1061F01829;
	Wed, 28 Oct 2026 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208217;
	bh=hct9jtJiQ65kOrJ64FCtGavtPlhMpi0vNgs7OuKkQdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K8vV1/OOrKuLPzlJnupE4yu1Pe3BGL+d6YccKIgwdtU+SzCh3g5DhGjKIB8e6IUbN
	 hq4Z0zMWjUSWKswnFve90ogjy9DNUFHCsXZlSWWxiHasIPmXU548cx0co1U+nOXsz/
	 yH7kEa5I5L1Ow0BBbiYcRp9XOqm3IY1qMDB1xdRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/516] fuse: fix invalidate lock leak on setattr writeback failure
Date: Wed, 28 Oct 2026 17:53:13 +0100
Message-ID: <20261028170004.505231967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

[ Upstream commit 9afeca0d569c9fc89d758fe7a9339d1e8afb1546 ]

fuse_do_setattr() takes filemap_invalidate_lock() for a DAX truncate
(fault_blocked = true) and releases it at the out:/error: labels.  But
when a writeback flush is also needed, a write_inode_now() failure
returns directly and leaks the lock, so any later fault or truncate on
the file stalls on the stale rwsem.

For example, truncate(2) on a setuid file reaches fuse_do_setattr()
with both ATTR_SIZE and ATTR_MODE set:

  truncate(2)
  └─ do_truncate()
     ├─ dentry_needs_remove_privs()         # S_ISUID
     └─ notify_change()                     # KILL_SUID -> ATTR_MODE
        └─ fuse_setattr()                   # no killpriv:
           │                                #   ia_valid |= ATTR_MODE
           └─ fuse_do_setattr()
              ├─ filemap_invalidate_lock()  # IS_DAX && is_truncate
              └─ write_inode_now()          # is_wb && ATTR_MODE
                 └─ if (err)                # e.g. daemon -> -EIO
                    return err              # <- lock leaked

Fix this by adding an unlock label that releases the lock before
returning the error, and use it for the fuse_dax_break_layouts()
failure path as well.

Fixes: 6ae330cad6ef ("virtiofs: serialize truncate/punch_hole and dax fault path")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Baokun Li <libaokun@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
[ replaced up_write(&fi->i_mmap_sem) locking and (inode, 0, 0) call site instead of the mainline filemap_invalidate_lock/(inode, 0, -1) forms ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dir.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index 4488a53a192dc..d475d19193848 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1651,10 +1651,8 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 		down_write(&fi->i_mmap_sem);
 		fault_blocked = true;
 		err = fuse_dax_break_layouts(inode, 0, 0);
-		if (err) {
-			up_write(&fi->i_mmap_sem);
-			return err;
-		}
+		if (err)
+			goto unlock;
 	}
 
 	if (attr->ia_valid & ATTR_OPEN) {
@@ -1681,7 +1679,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 			 ATTR_TIMES_SET)) {
 		err = write_inode_now(inode, true);
 		if (err)
-			return err;
+			goto unlock;
 
 		fuse_set_nowrite(inode);
 		fuse_release_nowrite(inode);
@@ -1768,6 +1766,7 @@ int fuse_do_setattr(struct dentry *dentry, struct iattr *attr,
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
+unlock:
 	if (fault_blocked)
 		up_write(&fi->i_mmap_sem);
 	return err;
-- 
2.53.0



