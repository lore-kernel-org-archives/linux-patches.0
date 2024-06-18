Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECB81581EF;
	Tue, 18 Jun 2024 13:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715974; cv=none; b=KHWFDwDH1bNF+u4yK77scLuSIzt7hUgqzDF3lka73/5SyO1EW6bXbxlZYkgw2WK6W3pqY2GojWth4+3M+CvIVJuDD5p+wXIYIjRZM/CVelqMNlNl6eQaVqfmO/Pv9htKs1sRiu9bPwybiE0ibzDIImlGatoZWN6ORKKbFCHNNY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715974; c=relaxed/simple;
	bh=WEEzqg7IRTO4zlGA4HEL2BzOC32poY4g93HK+EoNLlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CXvNUvynEwCggqev9A3oN+hyxWTuO0Sb78xXCY9+ilLDZPIkXwSbfS7hkt8+6Oq52x+yPpMNm0G40IDcZmY3+EG5nSFtowQMOS6bHDuJ1YxnQIHwEkLbeywcT0sNN6JTyf1/yE9DnjJtXB/J4IAq9h+2v4DO/3QjOIiNqtkH04Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUe2eerb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUe2eerb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743F2C3277B;
	Tue, 18 Jun 2024 13:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715973;
	bh=WEEzqg7IRTO4zlGA4HEL2BzOC32poY4g93HK+EoNLlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUe2eerbaSv96Tjp9XTd2Y8rN5KY3srGZ5eOAlM2wFj1NIutfdG45FkqGOpws0ZlG
	 M+kuFeX43TZW2eQHDyvGVJCb5bdqnCCFlwFU5a4l+MpiAyl+c6XmM0crSqO4JxNSXT
	 rArh8k6mlIOxYNweR8Uzj8bg+kfNnk0vNQOi9Tps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 490/770] nfsd: Clean up nfsd_file_put()
Date: Tue, 18 Jun 2024 14:35:43 +0200
Message-ID: <20240618123426.230872996@linuxfoundation.org>
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 999397926ab3f78c7d1235cc4ca6e3c89d2769bf ]

Make it a little less racy, by removing the refcount_read() test. Then
remove the redundant 'is_hashed' variable.

Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/filecache.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 496f7b3f75237..8f7ed5dbb0031 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -301,21 +301,14 @@ nfsd_file_put_noref(struct nfsd_file *nf)
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



