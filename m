Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B9C6A342;
	Mon,  8 Apr 2024 13:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584227; cv=none; b=ux0phvULp2uN9ltdnFjxITy9m7UVcGSLk6Cw7W3yOGvpzxD7uCJDudH4u/yCGm21L0he8b5a/TxJM6ct2ZrZIs/w8QY8EvJVXDdHVXhtgQp+LJlWM9MFgTkgf9fbkApJIoRKTIhv1CHeJtJmUqCUSCNtqmVHbjPWLupXHtNf2ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584227; c=relaxed/simple;
	bh=z06lginm4i8B1bJKIUz9+0C7f76JKkCK7h+hoSEqQ/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZrf6LJVC8g3NYJpLp6sCKtikMzbqrf8qgWbUkFH7He5Nk+G32ol5IYhYdWuwOOC9zLdSaLkRIwRZj4Bi0B/se2Qe85iCt/8G1E4LAGW0/EVvzsbFcoDiHhBn6WNBpQuJ2C+r0rzgovyvPXqGwol45Y6s5RyPrBmid48ytLZsGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keejCift; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keejCift"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D51C433C7;
	Mon,  8 Apr 2024 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584227;
	bh=z06lginm4i8B1bJKIUz9+0C7f76JKkCK7h+hoSEqQ/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keejCiftInToGymtBWbLRmIKTE1d7rrWZTwP9ClT5jItVgXk2DY5m5AWS1FWr7vCH
	 25ES+B0ggEAcqPK3bjkx1pjabHf4JcZkVzrCH7MVjwYpy2chYWjLinF8mCWzVlgiH+
	 +ZvlYJDOMsuEnE/SIiXUq2EsvRwz23DSadn54XqI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 366/690] NFSD: nfsd_file_hash_remove can compute hashval
Date: Mon,  8 Apr 2024 14:53:52 +0200
Message-ID: <20240408125412.832434419@linuxfoundation.org>
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

[ Upstream commit cb7ec76e73ff6640241c8f1f2f35c81d4005a2d6 ]

Remove an unnecessary use of nf_hashval.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 3925df9124c39..dd59deec8b011 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -287,6 +287,18 @@ nfsd_file_do_unhash(struct nfsd_file *nf)
 	atomic_long_dec(&nfsd_filecache_count);
 }
 
+static void
+nfsd_file_hash_remove(struct nfsd_file *nf)
+{
+	struct inode *inode = nf->nf_inode;
+	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
+				NFSD_FILE_HASH_BITS);
+
+	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
+	nfsd_file_do_unhash(nf);
+	spin_unlock(&nfsd_file_hashtbl[hashval].nfb_lock);
+}
+
 static bool
 nfsd_file_unhash(struct nfsd_file *nf)
 {
@@ -506,11 +518,8 @@ static void nfsd_file_gc_dispose_list(struct list_head *dispose)
 {
 	struct nfsd_file *nf;
 
-	list_for_each_entry(nf, dispose, nf_lru) {
-		spin_lock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-		nfsd_file_do_unhash(nf);
-		spin_unlock(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
-	}
+	list_for_each_entry(nf, dispose, nf_lru)
+		nfsd_file_hash_remove(nf);
 	nfsd_file_dispose_list_delayed(dispose);
 }
 
-- 
2.43.0



