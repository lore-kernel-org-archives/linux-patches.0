Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E28269953;
	Wed, 21 Feb 2024 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522259; cv=none; b=b+0IFWNAC21hp9A9m9MaIFDozpH5hkUHI2PBwgZjMBOVI6tZrvtZoY4pYpPblvAW/1g5d2EG8JUHEL5OdfHmaeTBrMSjOZttPYmd9+IugPcAFoQBkB9QpL30IfwIkNq0cgYSt8Zhn3dD7TaW/6ORBxRz+lxOwkCVJSHM9l7nJwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522259; c=relaxed/simple;
	bh=S0PpHGkLDUmlozxSpRD0yBkZrgSYsPFcvfXKijJTjV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=miOL9X49jhiV9l509hXyfLwmiOOmMPaKI+c0hWWOWFTb3ft9OmwAJNldE/2wY7TZBvgNxOn+HITbhU6wUcmftSDdukogm+vJetvLZ+AmejJhypX2uQHxh95s1QWYS2p2PEo0Z+OKkvuqcQwFXKlNH9p0yZz+qesyzUL+0g45zOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bCXheu+i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bCXheu+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3B9C433C7;
	Wed, 21 Feb 2024 13:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522258;
	bh=S0PpHGkLDUmlozxSpRD0yBkZrgSYsPFcvfXKijJTjV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bCXheu+ifzcuiT9YRSCelNfcSUx4kjN9zsmoX2YVk4B/5SbBB1+Pp1LuJUVcEkNMT
	 m7Gp+hRzXSwOq/pqKN5f+zV8tv1AlpWSY4tNY6IznWegHylPwiGGofTnYnmjLsxp8L
	 q1Y8ktoXMCSJBrH/HIUUy6KDXAY8ONJ95olrWivo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <dchinner@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Chandan Babu R <chandanbabu@kernel.org>
Subject: [PATCH 5.15 089/476] xfs: read only mounts with fsopen mount API are busted
Date: Wed, 21 Feb 2024 14:02:20 +0100
Message-ID: <20240221130011.273463078@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Chinner <dchinner@redhat.com>

commit d8d222e09dab84a17bb65dda4b94d01c565f5327 upstream.

Recently xfs/513 started failing on my test machines testing "-o
ro,norecovery" mount options. This was being emitted in dmesg:

[ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.

Turns out, readonly mounts with the fsopen()/fsconfig() mount API
have been busted since day zero. It's only taken 5 years for debian
unstable to start using this "new" mount API, and shortly after this
I noticed xfs/513 had started to fail as per above.

The syscall trace is:

fsopen("xfs", FSOPEN_CLOEXEC)           = 3
mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
.....
fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
close(3)                                = 0

Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
what threw out the error.

During mount instantiation, we call xfs_fs_validate_params() which
does:

        /* No recovery flag requires a read-only mount */
        if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
                xfs_warn(mp, "no-recovery mounts must be read-only.");
                return -EINVAL;
        }

and xfs_is_readonly() checks internal mount flags for read only
state. This state is set in xfs_init_fs_context() from the
context superblock flag state:

        /*
         * Copy binary VFS mount flags we are interested in.
         */
        if (fc->sb_flags & SB_RDONLY)
                set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);

With the old mount API, all of the VFS specific superblock flags
had already been parsed and set before xfs_init_fs_context() is
called, so this all works fine.

However, in the brave new fsopen/fsconfig world,
xfs_init_fs_context() is called from fsopen() context, before any
VFS superblock have been set or parsed. Hence if we use fsopen(),
the internal XFS readonly state is *never set*. Hence anything that
depends on xfs_is_readonly() actually returning true for read only
mounts is broken if fsopen() has been used to mount the filesystem.

Fix this by moving this internal state initialisation to
xfs_fs_fill_super() before we attempt to validate the parameters
that have been set prior to the FSCONFIG_CMD_CREATE call being made.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Fixes: 73e5fff98b64 ("xfs: switch to use the new mount-api")
cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_super.c |   27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1436,6 +1436,18 @@ xfs_fs_fill_super(
 
 	mp->m_super = sb;
 
+	/*
+	 * Copy VFS mount flags from the context now that all parameter parsing
+	 * is guaranteed to have been completed by either the old mount API or
+	 * the newer fsopen/fsconfig API.
+	 */
+	if (fc->sb_flags & SB_RDONLY)
+		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
+	if (fc->sb_flags & SB_DIRSYNC)
+		mp->m_features |= XFS_FEAT_DIRSYNC;
+	if (fc->sb_flags & SB_SYNCHRONOUS)
+		mp->m_features |= XFS_FEAT_WSYNC;
+
 	error = xfs_fs_validate_params(mp);
 	if (error)
 		goto out_free_names;
@@ -1910,6 +1922,11 @@ static const struct fs_context_operation
 	.free        = xfs_fs_free,
 };
 
+/*
+ * WARNING: do not initialise any parameters in this function that depend on
+ * mount option parsing having already been performed as this can be called from
+ * fsopen() before any parameters have been set.
+ */
 static int xfs_init_fs_context(
 	struct fs_context	*fc)
 {
@@ -1942,16 +1959,6 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
-	/*
-	 * Copy binary VFS mount flags we are interested in.
-	 */
-	if (fc->sb_flags & SB_RDONLY)
-		set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
-	if (fc->sb_flags & SB_DIRSYNC)
-		mp->m_features |= XFS_FEAT_DIRSYNC;
-	if (fc->sb_flags & SB_SYNCHRONOUS)
-		mp->m_features |= XFS_FEAT_WSYNC;
-
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
 


