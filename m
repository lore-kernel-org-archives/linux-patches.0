Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418CF3E1723;
	Tue, 21 Jul 2026 17:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653561; cv=none; b=BzuZEZJ3kaZ2v49CdrHlTtdwk7oq6eoTlQx5IrWSObjHLcyWxL1SX0JGBB0rVdzQLCHNUq57oDe+SAsM4WBL4ROFJwIoYRkn/95J5SXz10DhqGQZgLB6d7DxjM5tNgZnvA19wkyty3wzwtDiV0DgRzVUuP+m6pm+sMSmblWAISQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653561; c=relaxed/simple;
	bh=kSer2nXJDU2k/2dTRdUUa+EsSQQemcs9x1J+jrBw+Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0HxabOPjonvOw3y7jx41/27MZZnSyxhb+zkqm4VhyxPCra8XQv0SSa7UIclmWv3AcPmwYxAukdAnGIkmt3bzo8Otk9uzAwxdPJ+uO0I/Z8PfaXQKlLX2Ka/JlA/awVp+/UxjhtEZ0lcrmhBuYCX0jR0VEMKLIAbGYLova67hdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhMxAeOM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhMxAeOM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87811F000E9;
	Tue, 21 Jul 2026 17:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653560;
	bh=Bpv+VYvZrlJgTRHnnOnTkwOS2CSbQ+E7sDGyE1rBTHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhMxAeOM4TAMwMRYwPCsC5LSdius41ElIiBXtGUMBm71YB+fOvQuIMsDVWrePYsHG
	 wXVvEw52327VXsJIl7/9RC+aePoDtlckEfsdDPajr+FKv971Wye6xU2z5TyeA13Su2
	 hylwzjW4mUV5eJSiaqlLAT9RRUBXWbxoq+offYxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepakkumar Karn <dkarn@redhat.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1372/2077] afs: Remove setting of AS_RELEASE_ALWAYS for symlinks and mountpoints
Date: Tue, 21 Jul 2026 17:17:25 +0200
Message-ID: <20260721152625.176061809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 81e985b4c3a6cbcc443fcdcd3ebda7fcc845d459 ]

Regular AFS files correctly use afs_file_aops which have release_folio
set as netfs_release_folio, so AS_RELEASE_ALWAYS is valid for them
when fscache is enabled (set via afs_vnode_set_cache()).
Symlinks and mountpoints in AFS use afs_dir_aops, which does not provide
a release_folio callback. However, afs_apply_status() unconditionally
calls mapping_set_release_always() for these.

In such case when memory management code attempts to release folios,
filemap_release_folio() checks folio_needs_release() which
returns true due to AS_RELEASE_ALWAYS being set. Since there is no
release_folio callback, it falls through to try_to_free_buffers(),
which at present expects buffer_heads to be not null. For symlinks
and mountpoints without buffer_heads, this causes pointer dereference.

[dh: Added more bits that were missed]

Fixes: eae9e78951bb ("afs: Use netfslib for symlinks, allowing them to be cached")
Signed-off-by: Deepakkumar Karn <dkarn@redhat.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260622090856.2746629-6-dhowells@redhat.com
cc: Marc Dionne <marc.dionne@auristor.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/afs/inode.c    | 7 +++----
 fs/afs/internal.h | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/afs/inode.c b/fs/afs/inode.c
index a88995629d728e..54ac6ec21daf48 100644
--- a/fs/afs/inode.c
+++ b/fs/afs/inode.c
@@ -52,9 +52,9 @@ static noinline void dump_vnode(struct afs_vnode *vnode, struct afs_vnode *paren
 /*
  * Set parameters for the netfs library
  */
-static void afs_set_netfs_context(struct afs_vnode *vnode)
+static void afs_set_netfs_context(struct afs_vnode *vnode, bool is_file)
 {
-	netfs_inode_init(&vnode->netfs, &afs_req_ops, true);
+	netfs_inode_init(&vnode->netfs, &afs_req_ops, is_file);
 }
 
 /*
@@ -126,7 +126,6 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 		}
 		inode->i_mapping->a_ops	= &afs_symlink_aops;
 		inode_nohighmem(inode);
-		mapping_set_release_always(inode->i_mapping);
 		break;
 	default:
 		dump_vnode(vnode, op->file[0].vnode != vnode ? op->file[0].vnode : NULL);
@@ -136,7 +135,7 @@ static int afs_inode_init_from_status(struct afs_operation *op,
 
 	i_size_write(inode, status->size);
 	inode_set_bytes(inode, status->size);
-	afs_set_netfs_context(vnode);
+	afs_set_netfs_context(vnode, status->type == AFS_FTYPE_FILE);
 
 	vnode->invalid_before	= status->data_version;
 	trace_afs_set_dv(vnode, status->data_version);
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 0b72a856629992..785c646856d7f5 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -750,8 +750,6 @@ static inline void afs_vnode_set_cache(struct afs_vnode *vnode,
 {
 #ifdef CONFIG_AFS_FSCACHE
 	vnode->netfs.cache = cookie;
-	if (cookie)
-		mapping_set_release_always(vnode->netfs.inode.i_mapping);
 #endif
 }
 
-- 
2.53.0



