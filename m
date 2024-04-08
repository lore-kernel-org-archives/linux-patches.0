Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 672456EB72;
	Mon,  8 Apr 2024 13:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584527; cv=none; b=cVeduN17KchQh5VoETNqbSYVKsmtVCZF6YJBucuJhyumEqy7+nJyClADF3+lXeZy8d7HyVU3re49/J7xEdHCD3tWTJn2ljqfDLQsT26bsIrn876OABKBobnJB+PUTtdJuW5RehX0diLxkOw/Z++JhVVyfE518Zharbek9glumig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584527; c=relaxed/simple;
	bh=SyHEGmNRf8YRDqn3YzeLS/3ww9sZqwrsWpiGV2+XlIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf0N72KzqI23xwSS0pZeteqcu6EcS9vf+R2mfkKqXHwNxlYNu5zOaiHjBHCv4EwNhRmeuISn0pTt/iWPVurOeR4qN1wmZc1Uc667jGX9QKht6XaIJhqep+yaeYBFFwj1pTBM92yBTR/1YJoZDgixTb+NEZ6GM36Mb7xqLgt4BXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cGOQxJZ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cGOQxJZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9887C433F1;
	Mon,  8 Apr 2024 13:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584527;
	bh=SyHEGmNRf8YRDqn3YzeLS/3ww9sZqwrsWpiGV2+XlIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cGOQxJZ5o18eLs3zydLD3tnOHgU56aTFMJRYA4xo7r8NVUNGSa22qBYEbYobYcgps
	 Zv3Sx/WQjhOPk0JLrG+ceopT0MbcMTuqlr8AihEcw9GGBQLrLui7gZ1I5oE1+67SDd
	 SdpAHzOrJo11UoySSg6cci6tRdwKJ5EQP3b16ro8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 468/690] lockd: use locks_inode_context helper
Date: Mon,  8 Apr 2024 14:55:34 +0200
Message-ID: <20240408125416.564811863@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 98b41ffe0afdfeaa1439a5d6bd2db4a94277e31b ]

lockd currently doesn't access i_flctx safely. This requires a
smp_load_acquire, as the pointer is set via cmpxchg (a release
operation).

Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <anna@kernel.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/lockd/svcsubs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 3515f17eaf3fb..e3b6229e7ae5c 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -210,7 +210,7 @@ nlm_traverse_locks(struct nlm_host *host, struct nlm_file *file,
 {
 	struct inode	 *inode = nlmsvc_file_inode(file);
 	struct file_lock *fl;
-	struct file_lock_context *flctx = inode->i_flctx;
+	struct file_lock_context *flctx = locks_inode_context(inode);
 	struct nlm_host	 *lockhost;
 
 	if (!flctx || list_empty_careful(&flctx->flc_posix))
@@ -265,7 +265,7 @@ nlm_file_inuse(struct nlm_file *file)
 {
 	struct inode	 *inode = nlmsvc_file_inode(file);
 	struct file_lock *fl;
-	struct file_lock_context *flctx = inode->i_flctx;
+	struct file_lock_context *flctx = locks_inode_context(inode);
 
 	if (file->f_count || !list_empty(&file->f_blocks) || file->f_shares)
 		return 1;
-- 
2.43.0



