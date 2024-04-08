Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 748ED6EB72;
	Mon,  8 Apr 2024 13:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584559; cv=none; b=kU8k4DD1aKfQbx0wA92R8M2BvJ80fz0YSOyfsGEqdapSq4CDgPvHT8GZAMSUoeVnej78uBFRkji9RyQeoNqyPHokjjr9+UIbTYjN1Ekc+9byrBq99IWjTfujgcPNIjZIhrvIk7S0rzu2UFS7EduENlQQyUzx6RMTmsTrwnyLzd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584559; c=relaxed/simple;
	bh=MQNNo8B1jHFeYH4wulUKN6Jtvi4nY/B38fNToLK74Y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyG5M+SxdjA35fDIVXjNdoQg2128hEPRq5r+jNkIW3+p5L+CyQ7+zdsPivAJfDnsW3+Ykx8u/OwWvWdJiwXzv/KSjMCudfqmayhUErywy2ZByk4Aj7dMKez18mMBREJeglI/4AX8bFk44u3zTSMym5HvYN5ByJ9Ld26CzMFaFdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kW0fP3Tb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kW0fP3Tb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF6D6C433F1;
	Mon,  8 Apr 2024 13:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584559;
	bh=MQNNo8B1jHFeYH4wulUKN6Jtvi4nY/B38fNToLK74Y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kW0fP3TbjruJX2mVoEYw5i/yAvPp8d93yBxPYyeAbyfvHO5z3VbWuJkDHaY407/xh
	 3nxAiGqf5KMfT6WQpCiAEw525CL7cwGPbVt8AfSgkWX4VGIL8DyosAyr/3ftgS/8d0
	 QqSqqz2E1u0M8kj3Hy6vU1LFLzkeit8tyK18NfCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>
Subject: [PATCH 5.15 478/690] NFSD: Revert "NFSD: NFSv4 CLOSE should release an nfsd_file immediately"
Date: Mon,  8 Apr 2024 14:55:44 +0200
Message-ID: <20240408125416.937137682@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit dcf3f80965ca787c70def402cdf1553c93c75529 ]

This reverts commit 5e138c4a750dc140d881dab4a8804b094bbc08d2.

That commit attempted to make files available to other users as soon
as all NFSv4 clients were done with them, rather than waiting until
the filecache LRU had garbage collected them.

It gets the reference counting wrong, for one thing.

But it also misses that DELEGRETURN should release a file in the
same fashion. In fact, any nfsd_file_put() on an file held open
by an NFSv4 client needs potentially to release the file
immediately...

Clear the way for implementing that idea.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 18 ------------------
 fs/nfsd/filecache.h |  1 -
 fs/nfsd/nfs4state.c |  4 ++--
 3 files changed, 2 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index dceb522f5cee9..e429fce894316 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -443,24 +443,6 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_put_noref(nf);
 }
 
-/**
- * nfsd_file_close - Close an nfsd_file
- * @nf: nfsd_file to close
- *
- * If this is the final reference for @nf, free it immediately.
- * This reflects an on-the-wire CLOSE or DELEGRETURN into the
- * VFS and exported filesystem.
- */
-void nfsd_file_close(struct nfsd_file *nf)
-{
-	nfsd_file_put(nf);
-	if (refcount_dec_if_one(&nf->nf_ref)) {
-		nfsd_file_unhash(nf);
-		nfsd_file_lru_remove(nf);
-		nfsd_file_free(nf);
-	}
-}
-
 struct nfsd_file *
 nfsd_file_get(struct nfsd_file *nf)
 {
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index 357832bac736b..6b012ea4bd9da 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -52,7 +52,6 @@ void nfsd_file_cache_shutdown(void);
 int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
-void nfsd_file_close(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index dbcdb74e9ff6f..2f720433632b8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -842,9 +842,9 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 			swap(f2, fp->fi_fds[O_RDWR]);
 		spin_unlock(&fp->fi_lock);
 		if (f1)
-			nfsd_file_close(f1);
+			nfsd_file_put(f1);
 		if (f2)
-			nfsd_file_close(f2);
+			nfsd_file_put(f2);
 	}
 }
 
-- 
2.43.0



