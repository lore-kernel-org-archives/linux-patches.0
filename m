Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1349F768F0;
	Mon,  8 Apr 2024 13:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584674; cv=none; b=MLM4ZGcxgEHX1kYhUsy2v2EYhKxHgaboeKbSek5IXR8zHlXa2/rE3ztVs3oorOACKnBqYxG8u2E3MwV1HOHhCvZ1GqzsjSBHXfi+iwuZL/32Qp4k1fBz1lo1dwIw7nUQskwAOp2q74ds/fCofbrD9iV3qyWc04x9KxTigAS6+OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584674; c=relaxed/simple;
	bh=7xOOP2cNNiXWloZFhSQ0+5u3ZY24cWV9SbyWOCdX1Gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3JJ4QuajISVU3r5CLW47sbIXa61nfpfhjs+6fCVPJnczrgBtM3af16tJ4ZOq5cC1G89sg4+Lurj7b8t+H0YdNEh8dB5vbhNvo3HEM9QBRPi7rt0YVaOzn9C1QCFVXW099C8tdnrHx9ajKfYNLg3Y5W5/wHFe1e5T14otf4z3Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0bpV8D5G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0bpV8D5G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA8DC433F1;
	Mon,  8 Apr 2024 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584673;
	bh=7xOOP2cNNiXWloZFhSQ0+5u3ZY24cWV9SbyWOCdX1Gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0bpV8D5GPjIOtwFT8+Df+zkaEyRaO22gyE2p4WRRwQNP69zr35VN1sn3CjgdCZ4WP
	 Fm+sXbTKKD+d+Fu8BWr2hVA0/gicrRRNUnsh0bNTKkMdGB51mhYYY75Z7kGjWxSQl0
	 7FbjsIrD8UsDdJNjy1DeaM5OZtliGNeifQGXS2UI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH 5.15 489/690] NFSD: Refactor find_file()
Date: Mon,  8 Apr 2024 14:55:55 +0200
Message-ID: <20240408125417.354004756@linuxfoundation.org>
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

[ Upstream commit 15424748001a9b5ea62b3e6ad45f0a8b27f01df9 ]

find_file() is now the only caller of find_file_locked(), so just
fold these two together.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4state.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 192e721525665..4f2ad5bf1f1b8 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -4682,31 +4682,24 @@ move_to_close_lru(struct nfs4_ol_stateid *s, struct net *net)
 		nfs4_put_stid(&last->st_stid);
 }
 
-/* search file_hashtbl[] for file */
-static struct nfs4_file *
-find_file_locked(const struct svc_fh *fh, unsigned int hashval)
+static noinline_for_stack struct nfs4_file *
+nfsd4_file_hash_lookup(const struct svc_fh *fhp)
 {
-	struct nfs4_file *fp;
+	unsigned int hashval = file_hashval(fhp);
+	struct nfs4_file *fi;
 
-	hlist_for_each_entry_rcu(fp, &file_hashtbl[hashval], fi_hash,
-				lockdep_is_held(&state_lock)) {
-		if (fh_match(&fp->fi_fhandle, &fh->fh_handle)) {
-			if (refcount_inc_not_zero(&fp->fi_ref))
-				return fp;
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(fi, &file_hashtbl[hashval], fi_hash,
+				 lockdep_is_held(&state_lock)) {
+		if (fh_match(&fi->fi_fhandle, &fhp->fh_handle)) {
+			if (refcount_inc_not_zero(&fi->fi_ref)) {
+				rcu_read_unlock();
+				return fi;
+			}
 		}
 	}
-	return NULL;
-}
-
-static struct nfs4_file * find_file(struct svc_fh *fh)
-{
-	struct nfs4_file *fp;
-	unsigned int hashval = file_hashval(fh);
-
-	rcu_read_lock();
-	fp = find_file_locked(fh, hashval);
 	rcu_read_unlock();
-	return fp;
+	return NULL;
 }
 
 /*
@@ -4757,9 +4750,10 @@ nfs4_share_conflict(struct svc_fh *current_fh, unsigned int deny_type)
 	struct nfs4_file *fp;
 	__be32 ret = nfs_ok;
 
-	fp = find_file(current_fh);
+	fp = nfsd4_file_hash_lookup(current_fh);
 	if (!fp)
 		return ret;
+
 	/* Check for conflicting share reservations */
 	spin_lock(&fp->fi_lock);
 	if (fp->fi_share_deny & deny_type)
-- 
2.43.0



