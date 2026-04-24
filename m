Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 262EC3D75A5;
	Fri, 24 Apr 2026 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038120; cv=none; b=VPPQaNMHEl/oNESg3Y6r662fQMAhbohasCWcVwf6+uHPWx2Hg7sSvHMPNwB6woaNk01h3BNyJ2Pp2XAxG23Tlz1VhzdQnlIuHiN9mpxqYMVECGDBD1d8VRQfqI3eb2xZ8IU8IPKEu0Hwy4tqdN1vgMOvrCA27Chw2CUJJmfwCfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038120; c=relaxed/simple;
	bh=DRXe4mKAeP/BGxr5PKD4VPlPEkh/AqJQqoHom4NGan8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uUsoCoUYjaByJmZB92Ypy4Y9gEDBbLMATuQnMlY7lGheoJtSwtuVduQ5PsCpoehEYihzYacBvPvYgLxtrMJIebhR0tLcDCWUFxv1vJ1UGybeHCOWNh8p5z7sJHTzQw4pcoAwgWBTKIRTpg3hLAN+A6E2eEt15xxnYWRAFrZcYWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PcbPS6xH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PcbPS6xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63D7C2BCB2;
	Fri, 24 Apr 2026 13:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038120;
	bh=DRXe4mKAeP/BGxr5PKD4VPlPEkh/AqJQqoHom4NGan8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PcbPS6xHLkaFWhMbLvGP5pcXzrYyfhZAfcwqF82KbfuYi4rVDmtm5PuuzgV+UkC1K
	 KVnAGu0/fayy9QbGDS/9jOOCMuM/loaZD1O2CKyLvSsyZHXj9kCvAaCXKTdYaUTRtS
	 necuJJ6cpfa7/kufIMAog5LymENE53LBr1hFjJW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joanne Koong <joannelkoong@gmail.com>,
	Bernd Schubert <bernd@bsbernd.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 32/55] fuse: abort on fatal signal during sync init
Date: Fri, 24 Apr 2026 15:31:11 +0200
Message-ID: <20260424132436.693789698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -333,6 +333,7 @@ struct fuse_args {
 	bool is_ext:1;
 	bool is_pinned:1;
 	bool invalidate_vmap:1;
+	bool abort_on_kill:1;
 	struct fuse_in_arg in_args[4];
 	struct fuse_arg out_args[2];
 	void (*end)(struct fuse_mount *fm, struct fuse_args *args, int error);
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1548,6 +1548,7 @@ int fuse_send_init(struct fuse_mount *fm
 	int err;
 
 	if (fm->fc->sync_init) {
+		ia->args.abort_on_kill = true;
 		err = fuse_simple_request(fm, &ia->args);
 		/* Ignore size of init reply */
 		if (err > 0)


