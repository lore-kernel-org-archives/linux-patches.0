Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C26156C6D;
	Tue, 18 Jun 2024 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715644; cv=none; b=s/WwBdiSBzdb2oFYZm5o9Hi1YZMjd1sOmrw0PxHhaV1X0sIbkmPT7XA2PJV87PnA88P2o86NbOEqslMMldKI8NshhfWu8WHD1wU9Y4pwXBE133HLzxgvg7xLgj5OczDpz4xn14JDFg725gq1OQm+TMKjXW9cpe3LEoLyjtnVHUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715644; c=relaxed/simple;
	bh=mgy6wk/Ir0CMeXc7gJWeIAS/W0PZW+i8nMU6E6fhpTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEQ+KATHLxq/WANjBdNu1aYQB5UHcj16uu6po+1gaeAtXkmveB7/ivoYufzNxYRqii8haBHgNK4HKtT7278zTrpj3XekRmFh9o8XMh2vgidQrDTjz0loth/rUyvaphiSA9mOZbPA1pCaR6jN83ed0ngRqxKUQO9eBXTnh45FP/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W7BqW1W/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W7BqW1W/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092BDC3277B;
	Tue, 18 Jun 2024 13:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715644;
	bh=mgy6wk/Ir0CMeXc7gJWeIAS/W0PZW+i8nMU6E6fhpTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W7BqW1W/+gLGiqChkt6SgALTu+szGI7Wd5mfaEioV5f47UCZJoXXz+fOLhzjBRRzn
	 A0h7ZzoCPhI9dDCLvCfUYSxHYHlG9KL3WVIRRubC9jUYXJP02YnQ4qkJ/aHRyNFfA9
	 m3wbV5APUtPbjMhivPykB2aGKXaKWYroRIUPmfD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"J. Bruce Fields" <bfields@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 347/770] nlm: minor refactoring
Date: Tue, 18 Jun 2024 14:33:20 +0200
Message-ID: <20240618123420.657044995@linuxfoundation.org>
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

[ Upstream commit a81041b7d8f08c4e1014173c5483a0f18724a576 ]

Make this lookup slightly more concise, and prepare for changing how we
look this up in a following patch.

Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/svclock.c | 16 ++++++++--------
 fs/lockd/svcsubs.c |  4 ++--
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/lockd/svclock.c b/fs/lockd/svclock.c
index 273a81971ed57..bcd180ba99576 100644
--- a/fs/lockd/svclock.c
+++ b/fs/lockd/svclock.c
@@ -474,8 +474,8 @@ nlmsvc_lock(struct svc_rqst *rqstp, struct nlm_file *file,
 	__be32			ret;
 
 	dprintk("lockd: nlmsvc_lock(%s/%ld, ty=%d, pi=%d, %Ld-%Ld, bl=%d)\n",
-				locks_inode(file->f_file)->i_sb->s_id,
-				locks_inode(file->f_file)->i_ino,
+				nlmsvc_file_inode(file)->i_sb->s_id,
+				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.fl_type, lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end,
@@ -581,8 +581,8 @@ nlmsvc_testlock(struct svc_rqst *rqstp, struct nlm_file *file,
 	struct nlm_lockowner	*test_owner;
 
 	dprintk("lockd: nlmsvc_testlock(%s/%ld, ty=%d, %Ld-%Ld)\n",
-				locks_inode(file->f_file)->i_sb->s_id,
-				locks_inode(file->f_file)->i_ino,
+				nlmsvc_file_inode(file)->i_sb->s_id,
+				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.fl_type,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
@@ -644,8 +644,8 @@ nlmsvc_unlock(struct net *net, struct nlm_file *file, struct nlm_lock *lock)
 	int	error;
 
 	dprintk("lockd: nlmsvc_unlock(%s/%ld, pi=%d, %Ld-%Ld)\n",
-				locks_inode(file->f_file)->i_sb->s_id,
-				locks_inode(file->f_file)->i_ino,
+				nlmsvc_file_inode(file)->i_sb->s_id,
+				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
@@ -673,8 +673,8 @@ nlmsvc_cancel_blocked(struct net *net, struct nlm_file *file, struct nlm_lock *l
 	int status = 0;
 
 	dprintk("lockd: nlmsvc_cancel(%s/%ld, pi=%d, %Ld-%Ld)\n",
-				locks_inode(file->f_file)->i_sb->s_id,
-				locks_inode(file->f_file)->i_ino,
+				nlmsvc_file_inode(file)->i_sb->s_id,
+				nlmsvc_file_inode(file)->i_ino,
 				lock->fl.fl_pid,
 				(long long)lock->fl.fl_start,
 				(long long)lock->fl.fl_end);
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 2d62633b39e51..e02951f8a28f5 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -45,7 +45,7 @@ static inline void nlm_debug_print_fh(char *msg, struct nfs_fh *f)
 
 static inline void nlm_debug_print_file(char *msg, struct nlm_file *file)
 {
-	struct inode *inode = locks_inode(file->f_file);
+	struct inode *inode = nlmsvc_file_inode(file);
 
 	dprintk("lockd: %s %s/%ld\n",
 		msg, inode->i_sb->s_id, inode->i_ino);
@@ -416,7 +416,7 @@ nlmsvc_match_sb(void *datap, struct nlm_file *file)
 {
 	struct super_block *sb = datap;
 
-	return sb == locks_inode(file->f_file)->i_sb;
+	return sb == nlmsvc_file_inode(file)->i_sb;
 }
 
 /**
-- 
2.43.0



