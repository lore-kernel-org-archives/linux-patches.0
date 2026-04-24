Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 280A278F4A;
	Fri, 24 Apr 2026 13:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037536; cv=none; b=BxfjkZ/A8CT7UFta8NN8KaxsjD3OFzM9hBBXMDhbTUkwQFvivz4NHOz3dd4PRFiUSdUkBLN20tTzcm4y6WcGM9oBXOIDRFgxUQ6hgyz9QeHSXJYNBU0gDZM1z8HGUPiErvUK8v/VxlglWsO5xWazjgcWZ+eGVEw0OdIDowPhwd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037536; c=relaxed/simple;
	bh=uzvo215ifA5yqH1rkgOix5sNjyKTe9JmQbivE5O3+nQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GscupQrsOBjHCoTIY3BKaeiijOAB5mipvXc79EdMVKt+h05WEwrtixhTy+K/oICByaGfSxB3Udgj3wAJmCit8cuR3bA6235DE3iZ3s+wYHOf41mTNC7ulq8KzcK6W3rEFYxPwBi9aTbFFlYao7NEYnge8mRRae+99ubdQcxJ6qI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6SHkzAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6SHkzAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0F8C19425;
	Fri, 24 Apr 2026 13:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037536;
	bh=uzvo215ifA5yqH1rkgOix5sNjyKTe9JmQbivE5O3+nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6SHkzALCOVtAtz6F4QweG9MskBQt1PDxspNuHL/yBEmP5JNY75J4pzeQ//UsJKTw
	 1KdjTc+qjs0JWY1jU6itwqTQgaSVSD3DGdPoji34jkEY4db38+8WUq2FQDhZBCEOAG
	 t4AeOinYbL1/gdcE6l33MmIMYnt/eaMnib8uruUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 7.0 16/42] fuse: abort on fatal signal during sync init
Date: Fri, 24 Apr 2026 15:30:41 +0200
Message-ID: <20260424132423.900357915@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 204aa22a686bfee48daca7db620c1e017615f2ff upstream.

When sync init is used and the server exits for some reason (error, crash)
while processing FUSE_INIT, the filesystem creation will hang.  The reason
is that while all other threads will exit, the mounting thread (or process)
will keep the device fd open, which will prevent an abort from happening.

This is a regression from the async mount case, where the mount was done
first, and the FUSE_INIT processing afterwards, in which case there's no
such recursive syscall keeping the fd open.

Fixes: dfb84c330794 ("fuse: allow synchronous FUSE_INIT")
Cc: stable@vger.kernel.org # v6.18
Reviewed-by: Joanne Koong <joannelkoong@gmail.com>
Reviewed-by: Bernd Schubert <bernd@bsbernd.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/dev.c    |    8 +++++++-
 fs/fuse/fuse_i.h |    1 +
 fs/fuse/inode.c  |    1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -570,6 +570,11 @@ static void request_wait_answer(struct f
 		if (!err)
 			return;
 
+		if (req->args->abort_on_kill) {
+			fuse_abort_conn(fc);
+			return;
+		}
+
 		if (test_bit(FR_URING, &req->flags))
 			removed = fuse_uring_remove_pending_req(req);
 		else
@@ -676,7 +681,8 @@ ssize_t __fuse_simple_request(struct mnt
 			fuse_force_creds(req);
 
 		__set_bit(FR_WAITING, &req->flags);
-		__set_bit(FR_FORCE, &req->flags);
+		if (!args->abort_on_kill)
+			__set_bit(FR_FORCE, &req->flags);
 	} else {
 		WARN_ON(args->nocreds);
 		req = fuse_get_req(idmap, fm, false);
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -345,6 +345,7 @@ struct fuse_args {
 	bool is_ext:1;
 	bool is_pinned:1;
 	bool invalidate_vmap:1;
+	bool abort_on_kill:1;
 	struct fuse_in_arg in_args[4];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1551,6 +1551,7 @@ int fuse_send_init(struct fuse_mount *fm
 	int err;
 
 	if (fm->fc->sync_init) {
+		ia->args.abort_on_kill = true;
 		err = fuse_simple_request(fm, &ia->args);
 		/* Ignore size of init reply */
 		if (err > 0)


