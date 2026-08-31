Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A741F486653;
	Mon, 31 Aug 2026 13:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183488; cv=none; b=uOoslcRk7c6hu/oAmTGUdVcg4I8r93wpB0ijvvRFJ7Cmn9PQoky8ZJuSYXrFZ4ncp/NeUOl6yDcyJHl+adYJ1SjlJfBK0dSEnS5JWS1VnGaIDtai+tS5snmxU1ufaPmoCwnkl6tdeYzVw+lsFVD5t1oFzSBnlnLJeqy3o5UzJBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183488; c=relaxed/simple;
	bh=kDixYL/jLdSxqsRQgcXoGN3FePzD4sapyGT9KMU0Aa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VyUhXzgRRBm2o9znFkI+P01fBPZLFwJ34imG3D7AVb1IesOPJ0pg/JhfXuRo6FwT45JRYIbS/wK0D1ekrg1mYdqWbmlyqUp5nODDXJzgko87nkXdw590DNi4SPmHPRENlu+duNCekJRoFaYzmqZSKx872vUVbCainPEulbicxYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgej8baK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgej8baK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3C2C1F000E9;
	Mon, 31 Aug 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183486;
	bh=WrTMFQSXb3YvyMU+3mdGvFBfs0QI5+eV8hFQEepqNpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgej8baKV3CwzZ7Y5ZPQ0mG5fhXmBbRW7D+sQ1vl/q5Ph6PiOiywh9HG1sinpTqME
	 q5s87ZLmA3nHAFCnjJP0+o5uBlfCMxW9ZFBv9TzkQqIbMo+YyNUAi8U5EZv2GjneT8
	 KvsA3VPTUA6J55pwWLZomaVA59lN5Hd2Uc7LZTS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baokun Li <libaokun@linux.alibaba.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.2 16/71] fuse: fix invalidate lock leak on setattr writeback failure
Date: Mon, 31 Aug 2026 15:33:41 +0200
Message-ID: <20260831133359.829459791@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2161,10 +2161,8 @@ int fuse_do_setattr(struct mnt_idmap *id
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
@@ -2191,7 +2189,7 @@ int fuse_do_setattr(struct mnt_idmap *id
 			 ATTR_TIMES_SET)) {
 		err = write_inode_now(inode, true);
 		if (err)
-			return err;
+			goto unlock;
 
 		fuse_set_nowrite(inode);
 		fuse_release_nowrite(inode);
@@ -2299,6 +2297,7 @@ error:
 
 	clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
 
+unlock:
 	if (fault_blocked)
 		filemap_invalidate_unlock(mapping);
 	return err;


