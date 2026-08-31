Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2B45287FC;
	Mon, 31 Aug 2026 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183873; cv=none; b=Z4AVWY49H6AJ502ETMBw/kPzBWpETgBu0vuZrVyf+DcL6BL5alOePiqlNvMzmvMc2w9hkiSSUWkXkuw76DzSbAqOhWz3mnSZ5fJuTIQlJ3mn7La5+3ekGQxMNFymlessZArle4Ymsu43AXycMPZ9bPd24gE8xOnZw0xwz+q/MFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183873; c=relaxed/simple;
	bh=sEhmJ+yBdXxMfH0R+Xjk7E+RWNjfk2kKCXvMmMK+LtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+OXEpudw94Ql+OWNnuu4Zt4jr8iSzIxUON3x8dNbuLh46RTWQ4m3Kws/1vvRxaNPJ/SbT1Kh7f2+V/t/1WloMB28nY25VGKWboOT3qdIT8Alnofx2RHp8lRQUp/2/4OT4LC7w1wA9zt+6yj7ur8B7EAFeO84JYgURCcH9BnggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irPwt20d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irPwt20d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4130A1F00A3D;
	Mon, 31 Aug 2026 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183870;
	bh=noUndHNF+sY+FtdgdCBJxKA4yExBbmMuzwgt/GFVqus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irPwt20dRoKxIBzf7AbOe9DFvILscbuVE4Tje1kZEgYK3uC6etxtnDVdzH7ChoXmM
	 Zs73HA+nVNj0ydAl73ip9h9QEGpXyq1F6H7XqAAy9PeENTUBtVn27fjmdwaqa0WjtQ
	 nhxesfoLRM+W/Z2R4PdAZUnFJTCTA62+lp3QuV7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.1 25/76] fuse: fix invalidate lock leak on setattr writeback failure
Date: Mon, 31 Aug 2026 15:33:57 +0200
Message-ID: <20260831133400.573464690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baokun Li <libaokun@linux.alibaba.com>

commit 9afeca0d569c9fc89d758fe7a9339d1e8afb1546 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dir.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -2163,10 +2163,8 @@ int fuse_do_setattr(struct mnt_idmap *id
 		filemap_invalidate_lock(mapping);
 		fault_blocked = true;
 		err = fuse_dax_break_layouts(inode, 0, -1);
-		if (err) {
-			filemap_invalidate_unlock(mapping);
-			return err;
-		}
+		if (err)
+			goto unlock;
 	}
 
 	if (attr->ia_valid & ATTR_OPEN) {
@@ -2193,7 +2191,7 @@ int fuse_do_setattr(struct mnt_idmap *id
 			 ATTR_TIMES_SET)) {
 		err = write_inode_now(inode, true);
 		if (err)
-			return err;
+			goto unlock;
 
 		fuse_set_nowrite(inode);
 		fuse_release_nowrite(inode);
@@ -2301,6 +2299,7 @@ error:
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
+unlock:
 	if (fault_blocked)
 		filemap_invalidate_unlock(mapping);
 	return err;


