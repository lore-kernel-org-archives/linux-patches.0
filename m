Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9602524AF;
	Mon,  8 Apr 2024 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584253; cv=none; b=npNPp2Q7FVFHMZkRGXP6fCRA1ik6gmYkykbCMOyR1MUj5zLLTqRhTFEThEIV3uFhYy4X5v1bE5LXSKoucOpdDRzqSrofifdzDPJlOEnLpdo+x7cNMhBuXkLQ6JT/m+cqmF3ECLdTbq8TCOAqf/7Nw1QRxrCeDtkVVdR3JDXRGeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584253; c=relaxed/simple;
	bh=gTK9A8kyEKQcZR+ZPvjN2WY/5hBqwgm9Pj7BBLvSiAg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xx+8jQleUoUqmp8MPpKgHVaLbjmgbw43zdLcoOybs8x2aJ7NIdX9Vmk58GBxzFYjopRzwe8pjaRaXbjVZejzQ3avlsW/zm9cQU14B+qLV6mUDy99HIlbeR7UiATwOpcob0YDHqYUH9L8HWiNAihAEB+x9GnV158ZeSNUcFOlddo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+SBsnxi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+SBsnxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED3BC433F1;
	Mon,  8 Apr 2024 13:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584253;
	bh=gTK9A8kyEKQcZR+ZPvjN2WY/5hBqwgm9Pj7BBLvSiAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+SBsnxiEE8FZDsjPaQKlxjbmxWIxFe/0u6/HIF6+c3RY69ZZr7Rzm6pkPjre6Huk
	 EJKKSlUq3Etz6WMzv2Vya3rxbyRnjptou1Bo2osTgdrEN1gFoxbbQvvhyDPmz2NW5G
	 nv8iyla9fHqv+db3mdtlhvxGxngCmSUCUIIgpIoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yugui <wangyugui@e16-tech.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 374/690] NFSD: NFSv4 CLOSE should release an nfsd_file immediately
Date: Mon,  8 Apr 2024 14:54:00 +0200
Message-ID: <20240408125413.111543038@linuxfoundation.org>
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

[ Upstream commit 5e138c4a750dc140d881dab4a8804b094bbc08d2 ]

The last close of a file should enable other accessors to open and
use that file immediately. Leaving the file open in the filecache
prevents other users from accessing that file until the filecache
garbage-collects the file -- sometimes that takes several seconds.

Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Link: https://bugzilla.linux-nfs.org/show_bug.cgi?387
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 18 ++++++++++++++++++
 fs/nfsd/filecache.h |  1 +
 fs/nfsd/nfs4state.c |  4 ++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 26cfae138b906..7ad27655db699 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -451,6 +451,24 @@ nfsd_file_put(struct nfsd_file *nf)
 		nfsd_file_put_noref(nf);
 }
 
+/**
+ * nfsd_file_close - Close an nfsd_file
+ * @nf: nfsd_file to close
+ *
+ * If this is the final reference for @nf, free it immediately.
+ * This reflects an on-the-wire CLOSE or DELEGRETURN into the
+ * VFS and exported filesystem.
+ */
+void nfsd_file_close(struct nfsd_file *nf)
+{
+	nfsd_file_put(nf);
+	if (refcount_dec_if_one(&nf->nf_ref)) {
+		nfsd_file_unhash(nf);
+		nfsd_file_lru_remove(nf);
+		nfsd_file_free(nf);
+	}
+}
+
 struct nfsd_file *
 nfsd_file_get(struct nfsd_file *nf)
 {
diff --git a/fs/nfsd/filecache.h b/fs/nfsd/filecache.h
index ee9ed99d8b8fa..28145f1628923 100644
--- a/fs/nfsd/filecache.h
+++ b/fs/nfsd/filecache.h
@@ -52,6 +52,7 @@ void nfsd_file_cache_shutdown(void);
 int nfsd_file_cache_start_net(struct net *net);
 void nfsd_file_cache_shutdown_net(struct net *net);
 void nfsd_file_put(struct nfsd_file *nf);
+void nfsd_file_close(struct nfsd_file *nf);
 struct nfsd_file *nfsd_file_get(struct nfsd_file *nf);
 void nfsd_file_close_inode_sync(struct inode *inode);
 bool nfsd_file_is_cached(struct inode *inode);
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index d349abf0821d6..923eec2716d75 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -831,9 +831,9 @@ static void __nfs4_file_put_access(struct nfs4_file *fp, int oflag)
 			swap(f2, fp->fi_fds[O_RDWR]);
 		spin_unlock(&fp->fi_lock);
 		if (f1)
-			nfsd_file_put(f1);
+			nfsd_file_close(f1);
 		if (f2)
-			nfsd_file_put(f2);
+			nfsd_file_close(f2);
 	}
 }
 
-- 
2.43.0



