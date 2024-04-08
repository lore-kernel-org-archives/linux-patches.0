Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3E57C0B0;
	Mon,  8 Apr 2024 13:43:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583809; cv=none; b=nXHlkqCjxo80JMBhC+PznbGHPZlSQEU5wpqjWaSPu9HipMLW1omfYs3w2mI9bt9JXXZsEdGMZIl7qeFP5wb7R12J5odsw1GaBNUuOisUy9BZSBKSV2A13MBFU5byhEllBWEzFbLcwKw0g3uLno/l0jT7vXGp6/QN5aRCoLm3ZFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583809; c=relaxed/simple;
	bh=5D1xEOOqAN7IdB7DLnxxW/HbUvltzSU2hzR5bhVXro8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sf2jeBUD5hmyxjMlr0rcaktj0zM8gKDtS8yg6TVtsoi8Rqm6v04AbSWHyILh00PTEx/pE13zekWDcxQReLG54XlX/HkN0cCYPEiyVcVjDuecPC2AaMml6xIe+PH3dAnRVBWBekrRphsyLOULpZ/+cNonxMJpdXECMzaocZ8f0r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Miyr1Ubi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Miyr1Ubi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB21C433F1;
	Mon,  8 Apr 2024 13:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583809;
	bh=5D1xEOOqAN7IdB7DLnxxW/HbUvltzSU2hzR5bhVXro8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Miyr1UbixpAh5g3Ty7hQLSzVnD6OPIrQgG1YYdh/gKR0DcJZY422WWelWUkzd9X27
	 NGtQKjSkjFvGr1AwHs+Mzyk/zViTDj2fAiCUlCwXFoFw1EDodIxdVzkO1wlKEWYu9n
	 /zyvPV/YwjqKVmc2K7Ug4oyBUMzDO2YRwO1zx8B4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 287/690] nfsd: Clean up nfsd_file_put()
Date: Mon,  8 Apr 2024 14:52:33 +0200
Message-ID: <20240408125410.007964787@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 999397926ab3f78c7d1235cc4ca6e3c89d2769bf ]

Make it a little less racy, by removing the refcount_read() test. Then
remove the redundant 'is_hashed' variable.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 6cde6ef68996e..429ae485ebbbe 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -295,21 +295,14 @@ nfsd_file_put_noref(struct nfsd_file *nf)
 void
 nfsd_file_put(struct nfsd_file *nf)
 {
-	bool is_hashed;
-
 	set_bit(NFSD_FILE_REFERENCED, &nf->nf_flags);
-	if (refcount_read(&nf->nf_ref) > 2 || !nf->nf_file) {
-		nfsd_file_put_noref(nf);
-		return;
-	}
-
-	is_hashed = test_bit(NFSD_FILE_HASHED, &nf->nf_flags) != 0;
-	if (!is_hashed) {
+	if (test_bit(NFSD_FILE_HASHED, &nf->nf_flags) == 0) {
 		nfsd_file_flush(nf);
 		nfsd_file_put_noref(nf);
 	} else {
 		nfsd_file_put_noref(nf);
-		nfsd_file_schedule_laundrette();
+		if (nf->nf_file)
+			nfsd_file_schedule_laundrette();
 	}
 	if (atomic_long_read(&nfsd_filecache_count) >= NFSD_FILE_LRU_LIMIT)
 		nfsd_file_gc();
-- 
2.43.0



