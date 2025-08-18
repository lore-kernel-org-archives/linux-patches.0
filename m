Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B63DE20010A;
	Mon, 18 Aug 2025 14:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526132; cv=none; b=fWLDVSnyPMCGXQu/3qQobjf5tQyd6q93pCDuyl6DOZaVwFPhV7u55+op2++vv3ehw4J7tGy+aRS4btk3G5/bmqt5RwfnGt/CdqXed4dTZ8MJVS2NnI0g5nvoweX/ch+2Qp0joy99QIIEY6fTd5hC5IPz9wYN/RPAqaKuGhEVoMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526132; c=relaxed/simple;
	bh=wFkRHHsfDEX6zMc7ZIui19n/as6m2KjzroRiwA+y6jU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCLB1ODdl7qlzFeqskKDg/fVKfm/ZK4ahTpX01GeXhglgU66oX1XbthawgCoNPOeMVFlGwdKVKhJPZFrj5wKni/pUI86KEqkE4OLnxZSKglNvbRVNXvIOuLL1NHQ58ChscBvzGFi+SQbQ7Ig+s/LzHsLuo8VAmcR+Xz/2PBlNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8s2WgR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8s2WgR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0815C4CEF1;
	Mon, 18 Aug 2025 14:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526132;
	bh=wFkRHHsfDEX6zMc7ZIui19n/as6m2KjzroRiwA+y6jU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8s2WgR5pN/rzkNIQuJA10vvLrKPSTXMwsFxwBRsFqUHEkdkeFw+SSkXE6+DGkFNd
	 ummJMsfdbYPSvhmBDyYW7C2d1az/2DQhldSpUG0hVqhhUvOhI/xVlqwGiSaU3POJq4
	 IcrNcA3VellLZEl90fOEO0heVTygNmIhmoRsVtWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 467/570] pNFS: Fix uninited ptr deref in block/scsi layout
Date: Mon, 18 Aug 2025 14:47:34 +0200
Message-ID: <20250818124523.866760355@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Bashirov <sergeybashirov@gmail.com>

[ Upstream commit 9768797c219326699778fba9cd3b607b2f1e7950 ]

The error occurs on the third attempt to encode extents. When function
ext_tree_prepare_commit() reallocates a larger buffer to retry encoding
extents, the "layoutupdate_pages" page array is initialized only after the
retry loop. But ext_tree_free_commitdata() is called on every iteration
and tries to put pages in the array, thus dereferencing uninitialized
pointers.

An additional problem is that there is no limit on the maximum possible
buffer_size. When there are too many extents, the client may create a
layoutcommit that is larger than the maximum possible RPC size accepted
by the server.

During testing, we observed two typical scenarios. First, one memory page
for extents is enough when we work with small files, append data to the
end of the file, or preallocate extents before writing. But when we fill
a new large file without preallocating, the number of extents can be huge,
and counting the number of written extents in ext_tree_encode_commit()
does not help much. Since this number increases even more between
unlocking and locking of ext_tree, the reallocated buffer may not be
large enough again and again.

Co-developed-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Konstantin Evtushenko <koevtushenko@yandex.com>
Signed-off-by: Sergey Bashirov <sergeybashirov@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20250630183537.196479-2-sergeybashirov@gmail.com
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/extent_tree.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/blocklayout/extent_tree.c b/fs/nfs/blocklayout/extent_tree.c
index 8f7cff7a4293..0add0f329816 100644
--- a/fs/nfs/blocklayout/extent_tree.c
+++ b/fs/nfs/blocklayout/extent_tree.c
@@ -552,6 +552,15 @@ static int ext_tree_encode_commit(struct pnfs_block_layout *bl, __be32 *p,
 	return ret;
 }
 
+/**
+ * ext_tree_prepare_commit - encode extents that need to be committed
+ * @arg: layout commit data
+ *
+ * Return values:
+ *   %0: Success, all required extents are encoded
+ *   %-ENOSPC: Some extents are encoded, but not all, due to RPC size limit
+ *   %-ENOMEM: Out of memory, extents not encoded
+ */
 int
 ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 {
@@ -568,12 +577,12 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 	start_p = page_address(arg->layoutupdate_page);
 	arg->layoutupdate_pages = &arg->layoutupdate_page;
 
-retry:
-	ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size, &count, &arg->lastbytewritten);
+	ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size,
+			&count, &arg->lastbytewritten);
 	if (unlikely(ret)) {
 		ext_tree_free_commitdata(arg, buffer_size);
 
-		buffer_size = ext_tree_layoutupdate_size(bl, count);
+		buffer_size = NFS_SERVER(arg->inode)->wsize;
 		count = 0;
 
 		arg->layoutupdate_pages =
@@ -588,7 +597,8 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 			return -ENOMEM;
 		}
 
-		goto retry;
+		ret = ext_tree_encode_commit(bl, start_p + 1, buffer_size,
+				&count, &arg->lastbytewritten);
 	}
 
 	*start_p = cpu_to_be32(count);
@@ -608,7 +618,7 @@ ext_tree_prepare_commit(struct nfs4_layoutcommit_args *arg)
 	}
 
 	dprintk("%s found %zu ranges\n", __func__, count);
-	return 0;
+	return ret;
 }
 
 void
-- 
2.39.5



