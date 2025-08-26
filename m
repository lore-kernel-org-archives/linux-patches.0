Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F412EE296;
	Tue, 26 Aug 2025 11:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207743; cv=none; b=FUGG8+HP0UwJ0n9wPVdxnOi801MfKwzd3OOULV7x1bnIByIAuG2Rysz50fYGYgwy7jSXYxdqR4j0RS1XtGTDmgvimpLsI6zC8Vey4SwvdMev2V6ZjYwwLzlT0KBREkdbVFpA5as/a2G4cVq91YHoUjt3gl3YmS4e2XJkG2qy4MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207743; c=relaxed/simple;
	bh=eW5NcjwySMxWCfGZB8lbt6mzMWDn4XxexbFxEsrDhlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XWecOzIPsl1zND9OHdn+icFvWkfR2ehLhj5w/NxnMkGIWkEAFvh5l5UQ69FGYNcTMUWeBFtO7S2eDBhHZrxthbvXyb9BnC4pBEXGXYYS7kBJIRYJ6r2hUvhdjonas60DvRknRkKaI5uwI4ABuRQeCOb2ek6HcQh/M68tVvTWJcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atBaEe5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atBaEe5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50333C4CEF1;
	Tue, 26 Aug 2025 11:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207742;
	bh=eW5NcjwySMxWCfGZB8lbt6mzMWDn4XxexbFxEsrDhlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atBaEe5BMwM5Q/FzGSMu4/6wZ4G9KtxgQKcverEfnsaIKLBWS2pHzi6zZd+vK2Yog
	 +XIYsIddz9o3//OPlkEjraHUzxE+KSFR+KzVthp7s5UJUeH7VTz94VuFFszhitCrTy
	 8zFAWjvCQlzzQl9NjRsK3UJ+VmE2vfYXf3T1OH2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuntao Wang <yuntao.wang@linux.dev>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 282/457] fs: fix incorrect lflags value in the move_mount syscall
Date: Tue, 26 Aug 2025 13:09:26 +0200
Message-ID: <20250826110944.347678980@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuntao Wang <yuntao.wang@linux.dev>

[ Upstream commit 593d9e4c3d634c370f226f55453c376bf43b3684 ]

The lflags value used to look up from_path was overwritten by the one used
to look up to_path.

In other words, from_path was looked up with the wrong lflags value. Fix it.

Fixes: f9fde814de37 ("fs: support getname_maybe_null() in move_mount()")
Signed-off-by: Yuntao Wang <yuntao.wang@linux.dev>
Link: https://lore.kernel.org/20250811052426.129188-1-yuntao.wang@linux.dev
[Christian Brauner <brauner@kernel.org>: massage patch]
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ea724ad3d113..49d016711469 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4657,20 +4657,10 @@ SYSCALL_DEFINE5(move_mount,
 	if (flags & MOVE_MOUNT_SET_GROUP)	mflags |= MNT_TREE_PROPAGATION;
 	if (flags & MOVE_MOUNT_BENEATH)		mflags |= MNT_TREE_BENEATH;
 
-	lflags = 0;
-	if (flags & MOVE_MOUNT_F_SYMLINKS)	lflags |= LOOKUP_FOLLOW;
-	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)	lflags |= LOOKUP_AUTOMOUNT;
 	uflags = 0;
-	if (flags & MOVE_MOUNT_F_EMPTY_PATH)	uflags = AT_EMPTY_PATH;
-	from_name = getname_maybe_null(from_pathname, uflags);
-	if (IS_ERR(from_name))
-		return PTR_ERR(from_name);
+	if (flags & MOVE_MOUNT_T_EMPTY_PATH)
+		uflags = AT_EMPTY_PATH;
 
-	lflags = 0;
-	if (flags & MOVE_MOUNT_T_SYMLINKS)	lflags |= LOOKUP_FOLLOW;
-	if (flags & MOVE_MOUNT_T_AUTOMOUNTS)	lflags |= LOOKUP_AUTOMOUNT;
-	uflags = 0;
-	if (flags & MOVE_MOUNT_T_EMPTY_PATH)	uflags = AT_EMPTY_PATH;
 	to_name = getname_maybe_null(to_pathname, uflags);
 	if (IS_ERR(to_name))
 		return PTR_ERR(to_name);
@@ -4683,11 +4673,24 @@ SYSCALL_DEFINE5(move_mount,
 		to_path = fd_file(f_to)->f_path;
 		path_get(&to_path);
 	} else {
+		lflags = 0;
+		if (flags & MOVE_MOUNT_T_SYMLINKS)
+			lflags |= LOOKUP_FOLLOW;
+		if (flags & MOVE_MOUNT_T_AUTOMOUNTS)
+			lflags |= LOOKUP_AUTOMOUNT;
 		ret = filename_lookup(to_dfd, to_name, lflags, &to_path, NULL);
 		if (ret)
 			return ret;
 	}
 
+	uflags = 0;
+	if (flags & MOVE_MOUNT_F_EMPTY_PATH)
+		uflags = AT_EMPTY_PATH;
+
+	from_name = getname_maybe_null(from_pathname, uflags);
+	if (IS_ERR(from_name))
+		return PTR_ERR(from_name);
+
 	if (!from_name && from_dfd >= 0) {
 		CLASS(fd_raw, f_from)(from_dfd);
 		if (fd_empty(f_from))
@@ -4696,6 +4699,11 @@ SYSCALL_DEFINE5(move_mount,
 		return vfs_move_mount(&fd_file(f_from)->f_path, &to_path, mflags);
 	}
 
+	lflags = 0;
+	if (flags & MOVE_MOUNT_F_SYMLINKS)
+		lflags |= LOOKUP_FOLLOW;
+	if (flags & MOVE_MOUNT_F_AUTOMOUNTS)
+		lflags |= LOOKUP_AUTOMOUNT;
 	ret = filename_lookup(from_dfd, from_name, lflags, &from_path, NULL);
 	if (ret)
 		return ret;
-- 
2.50.1



