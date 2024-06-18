Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD2D1A08B5;
	Tue, 18 Jun 2024 13:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716222; cv=none; b=qJsM8rzOtaxlxBN4i9egEk4ohQhk2UDx/U4rRKOe3aP8aqukxXWhNifDKItagBq7y8dFjEva7l9uTW+PJkdBlfJHCDd57rKuHRd9DGLPmAg+Y3o4UF5SUbkXI2RvKCT96JilxVWOpMxOyRJzPGPOJXD7e2NE7jf5WoD5VMIwMr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716222; c=relaxed/simple;
	bh=5zJ9fNDBzopFuHZdLnO4NfJVumnjkasSLICrCtMbACk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BegRUYZl1qlSpW8BXbJjvol6IrgADvyf3e62dgOXGPnq3yBcIUZk+iUrUUi3DyQ7PuQxiZNrOxi8xOIgGgO1cXWTgNgN0++wKng/o/q9iNr65idZmrP8r7GyhKZqMKG5gKXUmjKuHq65YjV+V8btMx1uG7koA5G6Xtj26tifj+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYemKENh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYemKENh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71092C3277B;
	Tue, 18 Jun 2024 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716222;
	bh=5zJ9fNDBzopFuHZdLnO4NfJVumnjkasSLICrCtMbACk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYemKENhbumolQYDyv6LEMDxEENwZV+vkYTBGJT14my9ihXhR6oJhTAVd9O5G6QgC
	 y9H2jovNQTMdBS7FOK+IlHDKoehLjEmUJxEq9C1irC7c30MxNP+EfezVIZcgT/lx+g
	 9J81bOsFeaqmJuCQ+3lBeUWI2XuS7FSUAc879maQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 573/770] NFSD: nfsd_file_unhash can compute hashval from nf->nf_inode
Date: Tue, 18 Jun 2024 14:37:06 +0200
Message-ID: <20240618123429.413302255@linuxfoundation.org>
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

[ Upstream commit 8755326399f471ec3b31e2ab8c5074c0d28a0fb5 ]

Remove an unnecessary usage of nf_hashval.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6a01de8677959..d7c74b51eabf3 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -272,13 +272,17 @@ static void nfsd_file_lru_remove(struct nfsd_file *nf)
 static void
 nfsd_file_do_unhash(struct nfsd_file *nf)
 {
-	lockdep_assert_held(&nfsd_file_hashtbl[nf->nf_hashval].nfb_lock);
+	struct inode *inode = nf->nf_inode;
+	unsigned int hashval = (unsigned int)hash_long(inode->i_ino,
+				NFSD_FILE_HASH_BITS);
+
+	lockdep_assert_held(&nfsd_file_hashtbl[hashval].nfb_lock);
 
 	trace_nfsd_file_unhash(nf);
 
 	if (nfsd_file_check_write_error(nf))
 		nfsd_reset_write_verifier(net_generic(nf->nf_net, nfsd_net_id));
-	--nfsd_file_hashtbl[nf->nf_hashval].nfb_count;
+	--nfsd_file_hashtbl[hashval].nfb_count;
 	hlist_del_rcu(&nf->nf_node);
 	atomic_long_dec(&nfsd_filecache_count);
 }
-- 
2.43.0



