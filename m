Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7071A4AD7F8;
	Mon, 31 Aug 2026 13:48:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184101; cv=none; b=qISR2NUIv2XPXv+DB1MjcaH34ZY6Gop0ZDmxyRi+uSbgSkb9/fezORU0yhFnE+Ur+FarPSFmlXxjaXKocCT0L/O62nP2tBZtsDu/qEqJw0IzzKFbtOlTmjpvC0wQT0dwh/iKrwSeBmYOw03m7kB3S++VhD6fAQPjRn+B48c2z0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184101; c=relaxed/simple;
	bh=RZwf2q0/Wigb0o1qiVc5kPF0VfsyM99L1ILOsrswS0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OhI41B4V8OGiXnhLZsOlqeie+C/+Z0s/AxOPqcILKmVtRzUxMVV2s/yd+iQqY1jOA+6NkDtNuxLh4WnV7JDjfV4dI9zabNFRvFjjovx04KqeoJ3whaV+shvg2F5Piw/Fjow6G8rxKUHYMcsV8G8dyHpGOrlQWaIezuWmHB5c2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l6l6wETF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l6l6wETF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FE811F000E9;
	Mon, 31 Aug 2026 13:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184099;
	bh=mQWSafQ6Dm6zqXUmqWiFqDKhPgXyQbacZlHmy3k147M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l6l6wETFjCifBP8cmGpF32f/CJU6bloUAeKHd4kxDwE7VCMupCJOeFawoJLf2BsCG
	 xsYLtjAJKh1PQghIkNseN6BrH4DLacbWtCMbOvEMAX/kQbt7lxtOmm3UjrIw2BUkKc
	 DhAjm+kdNscvO/KQGCAXU/lklCiIDcU3xyxq09sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 36/83] fuse: fix invalidate lock leak on setattr writeback failure
Date: Mon, 31 Aug 2026 15:34:12 +0200
Message-ID: <20260831133401.323470212@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1976,10 +1976,8 @@ int fuse_do_setattr(struct mnt_idmap *id
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
@@ -2006,7 +2004,7 @@ int fuse_do_setattr(struct mnt_idmap *id
 			 ATTR_TIMES_SET)) {
 		err = write_inode_now(inode, true);
 		if (err)
-			return err;
+			goto unlock;
 
 		fuse_set_nowrite(inode);
 		fuse_release_nowrite(inode);
@@ -2114,6 +2112,7 @@ error:
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
+unlock:
 	if (fault_blocked)
 		filemap_invalidate_unlock(mapping);
 	return err;


