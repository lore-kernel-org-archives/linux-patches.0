Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DFF5768F0;
	Mon,  8 Apr 2024 13:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584665; cv=none; b=se+fLrws6SAuzEuSdEle6iIQXZao666ydioaQX1ymdMpw+9iH32oWgdQIaWk2Gwad6qSSKo/tdNFPpVuGsZjpMW11w4wYRZ8zMk4o/R5zXgZxRed6WXNMFRaTY+9PWoZNff25JC2WMJXj+elng9LP5V2q6LHyOjcq4hFW5Au5v0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584665; c=relaxed/simple;
	bh=FZ37+8H9VoHUmUYwJgytdPd0nwxy5/UD6AwVi28Qj8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlhzlFTV2zZUtaZTypldTnqUqKwc55DK642Ubu3fLboyFZcuygUI3LHz83iZoEbAHpX2trXvCVYcqoSvqtm4nBBZtmtl7+CfnJWnYdO81IUdzLfOzVS6WCTukoVb/6OguR1gQYMjNTNWtXnosauyWYF9ocn8Up2aWSiOys/5thY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjgpUhSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjgpUhSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79119C433F1;
	Mon,  8 Apr 2024 13:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584664;
	bh=FZ37+8H9VoHUmUYwJgytdPd0nwxy5/UD6AwVi28Qj8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjgpUhSI+xU7CRbGS3+U4smTD7JTdTAvjNmf0UzyVdTi4OEJBPztKLOUaPfj1jbXp
	 ig4kuEJ+m8DiZ7Dnypka243pcNQXSbEZlFG9rJRwvXyhT73tZiIzAwKdUWMBKAkKwA
	 6ytggQFLnvbIopieWkc9zWqDMpmvNQ61sksp7800=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 486/690] NFSD: Clean up nfsd4_init_file()
Date: Mon,  8 Apr 2024 14:55:52 +0200
Message-ID: <20240408125417.245233094@linuxfoundation.org>
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

[ Upstream commit 81a21fa3e7fdecb3c5b97014f0fc5a17d5806cae ]

Name this function more consistently. I'm going to use nfsd4_file_
and nfsd4_file_hash_ for these helpers.

Change the @fh parameter to be const pointer for better type safety.

Finally, move the hash insertion operation to the caller. This is
typical for most other "init_object" type helpers, and it is where
most of the other nfs4_file hash table operations are located.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index aa7374933de77..1cb3ea90eb4ca 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4277,11 +4277,9 @@ static struct nfs4_file *nfsd4_alloc_file(void)
 }
 
 /* OPEN Share state helper functions */
-static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
-				struct nfs4_file *fp)
-{
-	lockdep_assert_held(&state_lock);
 
+static void nfsd4_file_init(const struct svc_fh *fh, struct nfs4_file *fp)
+{
 	refcount_set(&fp->fi_ref, 1);
 	spin_lock_init(&fp->fi_lock);
 	INIT_LIST_HEAD(&fp->fi_stateids);
@@ -4299,7 +4297,6 @@ static void nfsd4_init_file(struct svc_fh *fh, unsigned int hashval,
 	INIT_LIST_HEAD(&fp->fi_lo_states);
 	atomic_set(&fp->fi_lo_recalls, 0);
 #endif
-	hlist_add_head_rcu(&fp->fi_hash, &file_hashtbl[hashval]);
 }
 
 void
@@ -4717,7 +4714,8 @@ static struct nfs4_file *insert_file(struct nfs4_file *new, struct svc_fh *fh,
 			fp->fi_aliased = alias_found = true;
 	}
 	if (likely(ret == NULL)) {
-		nfsd4_init_file(fh, hashval, new);
+		nfsd4_file_init(fh, new);
+		hlist_add_head_rcu(&new->fi_hash, &file_hashtbl[hashval]);
 		new->fi_aliased = alias_found;
 		ret = new;
 	}
-- 
2.43.0



