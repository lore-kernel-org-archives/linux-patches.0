Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238A1868
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE86FC433F0;
	Wed, 28 Dec 2022 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239114;
	bh=Jd8K+jkkZkbgbn3LMA0FQ8m7KSnhp/xrdIKxgjwQKow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s0UaTpgKrTqdm8Kzb9T7GFMES4RkZvSuF73MbL13JclgKCeBarMDm0X9E/a4rC5TK
	 lppyiKJVaY3JT2y7CLKVYrX7JmnfTSonXFT5bYk7AJ34vVSyfcdvQHat1breJWZ9JL
	 U8ifkRxQZEemQrbZrqCqfxoG3guz04vzwcN4GabI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/731] lockd: set other missing fields when unlocking files
Date: Wed, 28 Dec 2022 15:34:00 +0100
Message-Id: <20221228144300.403145935@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
index e1c4617de771..3515f17eaf3f 100644
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
2.35.1



