Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6697913C807;
	Tue, 18 Jun 2024 13:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716228; cv=none; b=YY2geQtLlnDfa0bG3tAsaGO5WAsC8mx0M5TT+/7f2552WRksj9i34HwPPeODdvk9hgZRECT8quCfrGfBZocMQWtqN+1f87kTKuqzm5NxWTBq4kAfsjo47bskklj/bqbhJ+okCusV4y7J17z6wPz16Dc8+jonjCUmL+bKlLbj0QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716228; c=relaxed/simple;
	bh=7QqFkBA1Sw2Usl54IHW6p3mUTudhvENHN4JY+kc55J0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RfDpj9BTHTnnAGYOiujovGQhr7XeXubk4+E1JqsI1qdLirQTMRe2SjVZcqjlp3/0TzsDxh9WPB6JqiVYGSPuUXIixxbsYFSJTfpqrqtAf5mHRlZxJ5Gq8/PmvmRzvWpk0pnKZta/KfWkvPlmvhVo4fbMqmuhEkFQsz/+CSdUR0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2UikVGh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2UikVGh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A8DFC3277B;
	Tue, 18 Jun 2024 13:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716227;
	bh=7QqFkBA1Sw2Usl54IHW6p3mUTudhvENHN4JY+kc55J0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h2UikVGh0hoy3CjI1FxXNLEafTNnr3kJIY5SWkxfZ8aSo+pxuuOgwuVB+EG9tK7yM
	 RB+yHu3zf1w+o2I8vRQq6EoLZeFSpWcyOE8hP1lccAlsmFUqP9PbN8hKxoTj9wEEF6
	 1+3C1UlXl2+lk9p52KjNs1Y59n1ZQpNGKsNFfJfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 575/770] NFSD: nfsd_file_hash_remove can compute hashval
Date: Tue, 18 Jun 2024 14:37:08 +0200
Message-ID: <20240618123429.490089142@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit cb7ec76e73ff6640241c8f1f2f35c81d4005a2d6 ]

Remove an unnecessary use of nf_hashval.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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



