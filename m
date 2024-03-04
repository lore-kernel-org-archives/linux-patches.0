Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5CB91F92C;
	Mon,  4 Mar 2024 21:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588996; cv=none; b=F4fHrW1mI6b6AhudkTvPXUnYaMTPgAlqhT+zEUdWxS6sdRlNM70GYd/XBS0ypUhaCIHzQ2Ymw3Cv6OFMT6UojSr3UF4nPJzrpDx2JA+hiCm7tbFANg/u+/4VD/VN6VzflYo3SFGOrlY0K5wGHWAZKn2gnZvASpsT3JxHZYhvOQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588996; c=relaxed/simple;
	bh=4Dd9LU8IVJqn8BvE6RFUfl5HRUHJz9raapn/k0wVohk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TXODuVNvzv6OMU4dy0nI+oScDSOfyrMDi/1Y9VSLEa7mKLCuju8KpApPHukDa2LZz8dm53ueMieRM5jWEp04x27R7zr6aecs4zzCgryXNz8oOE58KfEVNQYYDbP8VYWCHIjW2vaGTkLLzKdVOmjF1Zi6rXf3zMSGzAKTWLp9Ns0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjbMp4Vj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjbMp4Vj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45295C433F1;
	Mon,  4 Mar 2024 21:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588996;
	bh=4Dd9LU8IVJqn8BvE6RFUfl5HRUHJz9raapn/k0wVohk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjbMp4VjAU2OHoB19wBAujJUp8GrS31tvyk0WAQw+R8ShOH51oxB0Veo8K3+I0dMU
	 3N8xJ2XGNFUI747uJB2MWR6mN7w1/fdrdh0S3nkDTQy3khlowizYeM+DO5nwTcL0Q2
	 634LyS+QQ+gKhypWEWkjvXiveJhO+Ozb9kS9bIrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 6.1 162/215] lockd: use locks_inode_context helper
Date: Mon,  4 Mar 2024 21:23:45 +0000
Message-ID: <20240304211602.120739071@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/lockd/svcsubs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -210,7 +210,7 @@ nlm_traverse_locks(struct nlm_host *host
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


