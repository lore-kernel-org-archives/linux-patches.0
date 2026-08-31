Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C44243F4A8;
	Mon, 31 Aug 2026 14:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185081; cv=none; b=LaNORRJDI8kVTWpKre5OKJMy8ORBi9tnO2/gl9NQJTplLIHZkEQqtEfAi3HUbTNubrqSRArYEAOm1uZgWDVJhAS/XiQR+MjfuQylrmnImEos99sHmAqoWtN4ROveCeoqZjslBUKD1PcOdk/ewXjz/C3bwUDlk461dH4KZiiD+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185081; c=relaxed/simple;
	bh=NHXVIqnWIOlARXVQkp6LFwcPEF0jkBMfzTmyZ70l04Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gNtRB1bd37ltlHl0BKsXkGRZj+AjLT0aY30wr3A4yNJiWVOioRGLk4jun4hgbj6Rf6PYewFzIsY72rIpT66DVvMKypLJNqvnz2f3HrRv2BzXJdnRQFD3vp5DdRH6YuIluc3kw+aqjdWYYyJxPfMVX+sN/EMGW+nUd9haUFEDraA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ylecn1qy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ylecn1qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9161F000E9;
	Mon, 31 Aug 2026 14:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185078;
	bh=gvqJxqVBOB2D4FHAUDXQopHSzJQFylz8/ufP8qs5kQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ylecn1qycpvY6UX2v06+MiJUC3NvNvIwAPXqFWTAksoh4uF91W3vQ93/0EesMkRBT
	 4jYKOvRT3TCRgHZrC+hJroqm0LmiScdC7X+mzyr09WsKUz+d0VUiXDAwQ8fEbidYJT
	 Mhg2B4qtIjBve7ul5ixA8diSHsfAyZxxupFEVY4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 46/69] fuse: fix invalidate lock leak on setattr writeback failure
Date: Mon, 31 Aug 2026 15:35:19 +0200
Message-ID: <20260831133400.909652772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1601,10 +1601,8 @@ int fuse_do_setattr(struct dentry *dentr
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
@@ -1631,7 +1629,7 @@ int fuse_do_setattr(struct dentry *dentr
 			 ATTR_TIMES_SET)) {
 		err = write_inode_now(inode, true);
 		if (err)
-			return err;
+			goto unlock;
 
 		fuse_set_nowrite(inode);
 		fuse_release_nowrite(inode);
@@ -1728,6 +1726,7 @@ error:
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
+unlock:
 	if (fault_blocked)
 		filemap_invalidate_unlock(mapping);
 	return err;


