Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA691A2562;
	Tue, 18 Jun 2024 13:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716332; cv=none; b=E1Axp1QuYUjFs3Jxo41B0453r9DmFNPmUaQ/lq3xw8U01cx3b23OjIQqvQjWkLGx6MkUZxp0kHTQL7/WcNWk9zbXqWoku9hkw7io7Dv1zyk1NhSqcglxLGT0YCu1BoG7Cs/ipJqZmq0XnHxfGNjrHCaP3zoDBmLXYLK6E41SKIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716332; c=relaxed/simple;
	bh=xPDMHWJ/EjV45g/NeoUbX8in671YiM4xL40u66FpwHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHbLBX0izjdMnjLpUOlBEPkloxSmo875KemcGL6zwgRF8DrlbvIgCN5vVHTJ3HU5jaP8vW+2983gMHsW2w1e9wdo57rQ42P82TUgWRSXL5BfUYsQxhqIytf+nu6wU9wmwPnlouTF6MYxlEAyi8P/rkjzPE7tnu78VEVB2V2aznQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2oIswrDl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2oIswrDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D45C3277B;
	Tue, 18 Jun 2024 13:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716331;
	bh=xPDMHWJ/EjV45g/NeoUbX8in671YiM4xL40u66FpwHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2oIswrDl/5f2HMEC+/xmrCJ6gYhYFpAbJtHlKQLRQIDf6bA8dIiRpzLKls+4cfaly
	 WU+hMBROPyegtQlPR13dw6gm8nXwYN25cMHqAHNJEmtZtnfdKSZ1lMHCVH1HDxR7HF
	 DJg8g/76jTYr/NjM81sw1//bl/8pZmYnY3ZIq434=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang Yugui <wangyugui@e16-tech.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 583/770] NFSD: NFSv4 CLOSE should release an nfsd_file immediately
Date: Tue, 18 Jun 2024 14:37:16 +0200
Message-ID: <20240618123429.797314047@linuxfoundation.org>
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

[ Upstream commit 5e138c4a750dc140d881dab4a8804b094bbc08d2 ]

The last close of a file should enable other accessors to open and
use that file immediately. Leaving the file open in the filecache
prevents other users from accessing that file until the filecache
garbage-collects the file -- sometimes that takes several seconds.

Reported-by: Wang Yugui <wangyugui@e16-tech.com>
Link: https://bugzilla.linux-nfs.org/show_bug.cgi?387
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
index 587e792346579..c4c1e35d3eb7a 100644
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



