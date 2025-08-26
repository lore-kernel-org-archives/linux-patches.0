Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90310350D65;
	Tue, 26 Aug 2025 14:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219146; cv=none; b=HTiuhb/ICt88wuiSaUbOkUSO+pAyYCFmLaxNDjwX0QqFRzc8OCHof6HvZIsn4mS3pgseEe4wDkvOap6VOojXF2WuXf7e/GCotHRzzExrlOsvJP66DudTNnGQ2nxxEvcJ5fNPrGQ6Xn7s4SrHdNLmI0ecf+RXGg6HLp2h/7qD5Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219146; c=relaxed/simple;
	bh=DaApaJf1H6jGMEE09npt9b8N7gWMEf47GJvLzE6zQzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hd8WjkgqwqBwk5enNgg0ycA5P/bigP9ZtAu9h+lU5TV7mDsGH8aHvFCX9r3qQNKF6EeysLmXcZRPre50lRRyNSLFDssxDvY/lxR2MZ/3og6D26vs6Xs30TygNUM6Yl4+FL/VPxaXNVgtMOQ9uaqqhhJgPNQ2xd2i08gVQoELkyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtP2A16J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtP2A16J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242B0C4CEF1;
	Tue, 26 Aug 2025 14:39:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219146;
	bh=DaApaJf1H6jGMEE09npt9b8N7gWMEf47GJvLzE6zQzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LtP2A16JNZ5t5ocBSbEZg6qsP81OyXwYwak75ELtDvVkl+M9VJGrkzwyqIO460EN2
	 aozhkgj9gflD/qDPZKDS+JtHH90i7JvBlDgmi/aF92EeuzheSYvkDCH8rXeemXj73I
	 ssRb73W3+2cV/EU6uXtkzNU9lz6UwH7WCkNUstis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Evtushenko <koevtushenko@yandex.com>,
	Sergey Bashirov <sergeybashirov@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 270/403] pNFS: Fix uninited ptr deref in block/scsi layout
Date: Tue, 26 Aug 2025 13:09:56 +0200
Message-ID: <20250826110914.261726197@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 7a57ff2528af..055ec818eaaa 100644
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



