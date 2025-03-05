Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3783678F3A;
	Wed,  5 Mar 2025 18:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198393; cv=none; b=huenFvG2IxlDGuEg+ip9wWlNY3YZwsIUVcsvmCNPUjXoKchzqRE1Mz7m8QQy3AfWyS0V+p1fXCSDtx1xxlo0tkViTMfOrSM5EiHlOntP8EHaG6r35asuOWTprXBf0wx/FuQq47IhFJKFRpVC16eNQQSrwjjkUslmgm8f0qwmcqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198393; c=relaxed/simple;
	bh=8bWcm94E2memMbaZZKS35c8PeZYPZ+v0LpgtU8iqWpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shgb72uAmbG3U9qtO+PpV5aBxT53GJ3vfwYxFhSNXMdJvPndGE4eqAUrIhu8FGGWjMOQ3AhqSCkvIw/7D94iQI8WqVk1BuCsk9j59wo9nOzeWchnduPAy8BG0abCNUQuaeefCn8k7GQTcg0RoxZ3DB0JnHaY/DJ9m4YaCuU/lok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=evpz9e91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="evpz9e91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B312FC4CED1;
	Wed,  5 Mar 2025 18:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198393;
	bh=8bWcm94E2memMbaZZKS35c8PeZYPZ+v0LpgtU8iqWpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=evpz9e91pGmFGTt8gc6VpgweuRZUNXB9uHYZpOk0hVQfHakhfba5N6cyOnZPKxKv2
	 AAtAt7D3iuVaPa1MQBT1m8+ay8cSTj1uX38sT104PmaXRgCzB8NkrvsUNH49k/wjA4
	 9HVF3WTL/zfxjY9WGMSabwNjR/Xn/PAuUZi3POAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 013/157] NFS: O_DIRECT writes must check and adjust the file length
Date: Wed,  5 Mar 2025 18:47:29 +0100
Message-ID: <20250305174505.816324359@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit fcf857ee1958e9247298251f7615d0c76f1e9b38 ]

While it is uncommon for delegations to be held while O_DIRECT writes
are in progress, it is possible. The xfstests generic/647 and
generic/729 both end up triggering that state, and end up failing due to
the fact that the file size is not adjusted.

Reported-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219738
Cc: stable@vger.kernel.org
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <anna.schumaker@oracle.com>
Stable-dep-of: 88025c67fe3c ("NFS: Adjust delegated timestamps for O_DIRECT reads and writes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index b08dbe96bc579..8f2aa2bf45659 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -130,6 +130,20 @@ static void nfs_direct_truncate_request(struct nfs_direct_req *dreq,
 		dreq->count = req_start;
 }
 
+static void nfs_direct_file_adjust_size_locked(struct inode *inode,
+					       loff_t offset, size_t count)
+{
+	loff_t newsize = offset + (loff_t)count;
+	loff_t oldsize = i_size_read(inode);
+
+	if (newsize > oldsize) {
+		i_size_write(inode, newsize);
+		NFS_I(inode)->cache_validity &= ~NFS_INO_INVALID_SIZE;
+		trace_nfs_size_grow(inode, newsize);
+		nfs_inc_stats(inode, NFSIOS_EXTENDWRITE);
+	}
+}
+
 /**
  * nfs_swap_rw - NFS address space operation for swap I/O
  * @iocb: target I/O control block
@@ -740,6 +754,7 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	struct nfs_direct_req *dreq = hdr->dreq;
 	struct nfs_commit_info cinfo;
 	struct nfs_page *req = nfs_list_entry(hdr->pages.next);
+	struct inode *inode = dreq->inode;
 	int flags = NFS_ODIRECT_DONE;
 
 	trace_nfs_direct_write_completion(dreq);
@@ -761,6 +776,10 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	}
 	spin_unlock(&dreq->lock);
 
+	spin_lock(&inode->i_lock);
+	nfs_direct_file_adjust_size_locked(inode, dreq->io_start, dreq->count);
+	spin_unlock(&inode->i_lock);
+
 	while (!list_empty(&hdr->pages)) {
 
 		req = nfs_list_entry(hdr->pages.next);
-- 
2.39.5



