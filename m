Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8799F1ABCD3;
	Tue, 18 Jun 2024 13:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716628; cv=none; b=AunppqAD+e/Mjk7hr3KpA4qrbUoOlW+/nJIfTWZGaXb0mOoo7gnsVTx2IQ8DSlCtpe8RXUjZeEDqU53FazEXOLZoTIXS2CEnT1TwCWTz22fOqL5U373PloXpkCnNfV8TISpyjgBmicrU6rwj3TewS/pNXx05Hx7nHxlMJvXgasg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716628; c=relaxed/simple;
	bh=kHWVFF6sGM+Bume04SYhPWboxJ1ZcYe5qc0Xzxqs5ws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fqV4e9CZw/kYlQNN9jsDe1C8Cuf78e64BDt171yB/vpHfAF0g2r3ege2LeOhd18BIMn/O/JtIxyx5hbLGNdMh9241TETCzeVzB3kSlVeqLmjC+lnFYTnx6KnwmQYSikB3gyVBkOVXOQc7waMf7G/TOP67yq8/ran6n7K+Pt3PWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh6fb/br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh6fb/br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13815C3277B;
	Tue, 18 Jun 2024 13:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716628;
	bh=kHWVFF6sGM+Bume04SYhPWboxJ1ZcYe5qc0Xzxqs5ws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mh6fb/brg5BvYWtQ7dPIW7DS+if9kk8U9CbHzmlQ54/1TKAs2UkRIqxJEiWDf6xBy
	 E1h5wFJllKhqNxM6h75Wx6+wcQB+XYs/iWpe+qF2f8R5q6EqDR5GqM9/1B67P6oggM
	 N8nHbM3PSorZ4UTzE9VGj+syxNyE4vgn67ObKuLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 709/770] lockd: set other missing fields when unlocking files
Date: Tue, 18 Jun 2024 14:39:22 +0200
Message-ID: <20240618123434.640131297@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 18ebd35b61b4693a0ddc270b6d4f18def232e770 ]

vfs_lock_file() expects the struct file_lock to be fully initialised by
the caller. Re-exported NFSv3 has been seen to Oops if the fl_file field
is NULL.

Fixes: aec158242b87 ("lockd: set fl_owner when unlocking files")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216582
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svcsubs.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 720684345817c..e3b6229e7ae5c 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -176,7 +176,7 @@ nlm_delete_file(struct nlm_file *file)
 	}
 }
 
-static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
+static int nlm_unlock_files(struct nlm_file *file, const struct file_lock *fl)
 {
 	struct file_lock lock;
 
@@ -184,12 +184,15 @@ static int nlm_unlock_files(struct nlm_file *file, fl_owner_t owner)
 	lock.fl_type  = F_UNLCK;
 	lock.fl_start = 0;
 	lock.fl_end   = OFFSET_MAX;
-	lock.fl_owner = owner;
-	if (file->f_file[O_RDONLY] &&
-	    vfs_lock_file(file->f_file[O_RDONLY], F_SETLK, &lock, NULL))
+	lock.fl_owner = fl->fl_owner;
+	lock.fl_pid   = fl->fl_pid;
+	lock.fl_flags = FL_POSIX;
+
+	lock.fl_file = file->f_file[O_RDONLY];
+	if (lock.fl_file && vfs_lock_file(lock.fl_file, F_SETLK, &lock, NULL))
 		goto out_err;
-	if (file->f_file[O_WRONLY] &&
-	    vfs_lock_file(file->f_file[O_WRONLY], F_SETLK, &lock, NULL))
+	lock.fl_file = file->f_file[O_WRONLY];
+	if (lock.fl_file && vfs_lock_file(lock.fl_file, F_SETLK, &lock, NULL))
 		goto out_err;
 	return 0;
 out_err:
@@ -226,7 +229,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 		if (match(lockhost, host)) {
 
 			spin_unlock(&flctx->flc_lock);
-			if (nlm_unlock_files(file, fl->fl_owner))
+			if (nlm_unlock_files(file, fl))
 				return 1;
 			goto again;
 		}
-- 
2.43.0



