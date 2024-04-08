Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212816FE35;
	Mon,  8 Apr 2024 13:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584207; cv=none; b=Uk+MDcxquI9Ebd8ZhUwuGvq3TQbVMIUXpuc1A+SLXWSlnLT1fSM2PYwmQ2kQcBx2GfLNmgHzs8gG3RoK56TpufWmQM2FAAD4KeOTM2dvDV6u4lPUQdeHKubrHXnMFSgi/I02ErdrLQj/ZWwQJwrjtToHhOrwmNGMZyYvyXApVFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584207; c=relaxed/simple;
	bh=vBDt/P5m4IzSZtKtEiYQ+N216Vz51eN1Wrwo5JJhjSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jFp4WYyqZ6pLMXsaP/UBS8ztqZkdl1YwQE1Edc4PfBzyKhbEFFoWaG6DscuhBWxUjOgSO1A8j8iv0cNKhrBZK62ennpICXUfNw2um7j1Kqk1bfWeJaLyTH+2QuRfU17SohMIgD6ZKvBdnuLP88/OD3rZs99xcDM20YonwmbGYZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OBCPqgZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OBCPqgZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E6C43390;
	Mon,  8 Apr 2024 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584206;
	bh=vBDt/P5m4IzSZtKtEiYQ+N216Vz51eN1Wrwo5JJhjSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OBCPqgZ0gyETzofMlHhn4VTj4ndQENl3vRoIGVBz5/pNeyPUvY9LdX7r+ohjmPGwL
	 aV45jB2Dgvx0n3jb10vyG2V05FtgNNanlqvMQr9ZFLemWJXBu8wi4wWuzZgUAAnvCu
	 u8EaU4dND+D3KwhzPiEjoEaIZPD27MWXuay9yK2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Chinner <david@fromorbit.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 360/690] NFSD: Fix the filecache LRU shrinker
Date: Mon,  8 Apr 2024 14:53:46 +0200
Message-ID: <20240408125412.634174201@linuxfoundation.org>
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

[ Upstream commit edead3a55804739b2e4af0f35e9c7326264e7b22 ]

Without LRU item rotation, the shrinker visits only a few items on
the end of the LRU list, and those would always be long-term OPEN
files for NFSv4 workloads. That makes the filecache shrinker
completely ineffective.

Adopt the same strategy as the inode LRU by using LRU_ROTATE.

Suggested-by: Dave Chinner <david@fromorbit.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 5c9e3ff6397b0..849c010c6ef61 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -445,6 +445,7 @@ nfsd_file_dispose_list_delayed(struct list_head *dispose)
  *
  * Return values:
  *   %LRU_REMOVED: @item was removed from the LRU
+ *   %LRU_ROTATE: @item is to be moved to the LRU tail
  *   %LRU_SKIP: @item cannot be evicted
  */
 static enum lru_status
@@ -483,7 +484,7 @@ nfsd_file_lru_cb(struct list_head *item, struct list_lru_one *lru,
 
 	if (test_and_clear_bit(NFSD_FILE_REFERENCED, &nf->nf_flags)) {
 		trace_nfsd_file_gc_referenced(nf);
-		return LRU_SKIP;
+		return LRU_ROTATE;
 	}
 
 	if (!test_and_clear_bit(NFSD_FILE_HASHED, &nf->nf_flags)) {
@@ -525,7 +526,7 @@ nfsd_file_gc(void)
 	unsigned long ret;
 
 	ret = list_lru_walk(&nfsd_file_lru, nfsd_file_lru_cb,
-			    &dispose, LONG_MAX);
+			    &dispose, list_lru_count(&nfsd_file_lru));
 	trace_nfsd_file_gc_removed(ret, list_lru_count(&nfsd_file_lru));
 	nfsd_file_gc_dispose_list(&dispose);
 }
-- 
2.43.0



