Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDD1891D3;
	Tue, 18 Jun 2024 13:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715656; cv=none; b=BsyxWLZ9kTufOHhX0K9GU38tSrsSMYxWe4rTpuXd2JFdYrL5qo2wsthrW1gDqD/aqGOH0uz7HjuSPk+d1J3+CxTm9UHHQaAY6hLG6mnrTn+vWkTDYzDHH0nrS3ZSJIoZupUAcL1FloelPQWddNoa4MNVXjUED82VTQjTar8deUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715656; c=relaxed/simple;
	bh=i46mA2bv5UOey4HwLi/q6/ZTyu9m8u4k6grLVkZlvcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvuAqBE78Y3krEs8sKj58ie5kD9FCmBfspyRyrmRITUrVZd6AuN98l5/OwGEeFzZTipLR4RIiQ8VC7GG6OIXViciSm0SlJo73VqvwodpqVlAlZcg5x31BUbhj6K9aD7mGJnO2JLZ158fnxNgV1pYGriOFfDYhQOLHb1aD5PgFo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZovTtvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZovTtvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBB47C3277B;
	Tue, 18 Jun 2024 13:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715656;
	bh=i46mA2bv5UOey4HwLi/q6/ZTyu9m8u4k6grLVkZlvcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZovTtvPNq7Tu4Yu8K7e8qgnsetFBXsJT5jenGbIdaUJurJpUNqJKqvZWI0/i4DWg
	 W64dwWtqEhegJJqfXovnXweZJIoVkCbLQP57SgNHuChfhVzG1cZoCYj8q2An7gwt+s
	 lrMtseD9gQf0BxSp5S37+iByDBlKfjXE59U054a4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/770] lockd: dont attempt blocking locks on nfs reexports
Date: Tue, 18 Jun 2024 14:33:24 +0200
Message-ID: <20240618123420.815279637@linuxfoundation.org>
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

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit b840be2f00c0bc00d993f8f76e251052b83e4382 ]

As in the v4 case, it doesn't work well to block waiting for a lock on
an nfs filesystem.

As in the v4 case, that means we're depending on the client to poll.
It's probably incorrect to depend on that, but I *think* clients do poll
in practice.  In any case, it's an improvement over hanging the lockd
thread indefinitely as we currently are.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Acked-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index a7b4c51667ada..e9b85d8fd5fe7 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -31,6 +31,7 @@
 #include <linux/lockd/nlm.h>
 #include <linux/lockd/lockd.h>
 #include <linux/kthread.h>
+#include <linux/exportfs.h>
 
 #define NLMDBG_FACILITY		NLMDBG_SVCLOCK
 
@@ -470,18 +471,24 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	    struct nlm_cookie *cookie, int reclaim)
 {
 	struct nlm_block	*block = NULL;
+	struct inode		*inode = nlmsvc_file_inode(file);
 	int			error;
 	int			mode;
+	int			async_block = 0;
 	__be32			ret;
 
 	dprintk("lockd: nlmsvc_lock(%s/%ld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
-				nlmsvc_file_inode(file)->i_sb->s_id,
-				nlmsvc_file_inode(file)->i_ino,
+				inode->i_sb->s_id, inode->i_ino,
 				lock->fl.fl_type, lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end,
 				wait);
 
+	if (inode->i_sb->s_export_op->flags & EXPORT_OP_SYNC_LOCKS) {
+		async_block = wait;
+		wait = 0;
+	}
+
 	/* Lock file against concurrent access */
 	mutex_lock(&file->f_mutex);
 	/* Get existing block (in case client is busy-waiting)
@@ -542,7 +549,7 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 			 */
 			if (wait)
 				break;
-			ret = nlm_lck_denied;
+			ret = async_block ? nlm_lck_blocked : nlm_lck_denied;
 			goto out;
 		case FILE_LOCK_DEFERRED:
 			if (wait)
-- 
2.43.0



