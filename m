Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA91A158A18;
	Tue, 18 Jun 2024 13:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716132; cv=none; b=ZyqPSUfLVYbfOArwByacT63wuXaiR34j6Q1iOiE79lpVI5NP1HtbAbH5H3EejUR05Aw1S6FTAjmtNcfEEX0zFJ1ErvmvzBqL82V+2P2X3jQaLuaEE4qkUZglbTdkF+axaAujpx9+IYZYi8+15k+4NktVvoXcpoypC9U0gLfLMlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716132; c=relaxed/simple;
	bh=P4bHEXghaxFysP0uZqrGNzveXaXVmj4KF1xf1WmQ42E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jChcNekh7Jk9RBo6vmAB0AOM44Egb9pE36di32rBdwFbe2ZellsgHILNr6zhMbpGCwlONOsMkMlZunbK8t+e7QhDHLaacSEZM+REiWJYLBt7stLtjLsl4udJkOsCplVe5j1IHWdl4sKiMjSrTOHf3rn5D4mPhS9yrlrGzjZnsPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Lp6O+sT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Lp6O+sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318ABC3277B;
	Tue, 18 Jun 2024 13:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716132;
	bh=P4bHEXghaxFysP0uZqrGNzveXaXVmj4KF1xf1WmQ42E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Lp6O+sTtK++gLclu1/WQBBI/uQIMN7jwOZBt6CmYS7DC5uwi7pEWXFkiGozRq4Br
	 a8JIGMA/j0y8s00OCAYGVZ+A9xzBTNFKgTiMnv0W45PHa2dqLsm9ch5KJnNSc/mu34
	 euyBCXiDp1c8uAa+NbAkvKnzEzBelUW4krp5mknE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 542/770] lockd: set fl_owner when unlocking files
Date: Tue, 18 Jun 2024 14:36:35 +0200
Message-ID: <20240618123428.231333808@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit aec158242b87a43d83322e99bc71ab4428e5ab79 ]

Unlocking a POSIX lock on an inode with vfs_lock_file only works if
the owner matches. Ensure we set it in the request.

Cc: J. Bruce Fields <bfields@fieldses.org>
Fixes: 7f024fcd5c97 ("Keep read and write fds with each nlm_file")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 0a22a2faf5522..b2f277727469c 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -176,7 +176,7 @@ nlm_delete_file(struct nlm_file *file)
 	}
 }
 
-static int nlm_unlock_files(struct nlm_file *file)
+static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
 {
 	struct file_lock lock;
 
@@ -184,6 +184,7 @@ static int nlm_unlock_files(struct nlm_file *file)
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
+	lock.fl_owner = owner;
 	if (file->f_file[O_RDONLY] &&
 	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
 		goto out_err;
@@ -225,7 +226,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 		if (match(lockhost, host)) {
 
 			spin_unlock(&flctx->flc_lock);
-			if (nlm_unlock_files(file))
+			if (nlm_unlock_files(file, fl->fl_owner))
 				return 1;
 			goto again;
 		}
-- 
2.43.0



