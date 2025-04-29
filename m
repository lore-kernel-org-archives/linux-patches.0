Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F132459FE;
	Tue, 29 Apr 2025 17:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948120; cv=none; b=LSbQbbqwIFJIgkS3J39GfqZe0lBQTRwNSeqQV/NAnyqq7BzNEu9zyPgcz7h3A3kMrQSgDWuKp+kiZtqmGedkyU3zOSMBgYjCdkxHIdgzpfexQTn5WdMIfLwhKEP8Cv3sR90sP5d+j5dTkWlDaInOhxNRvdHvA09/l8c1mh8hG1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948120; c=relaxed/simple;
	bh=jgg2Dx1LGrwpU2DMkxgoOLZ7LJnKiE9E7QbWwRyV0AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hyWyWyE6LZyL1/YuDMT2dmLNeCzPdAjYQp4dJ7Go6HfgJs1UMG0790ApxJXQfzTwl3vp+X0+k6TV+av5PWRBeDo6Qi19juOm4KNvPuFdJkeYtx0WJ1aPNo3ki3k8wm/cBJni6MU74MVm+Y7Q/UqbZjU/Ej6ObikPKQN07PLSoq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L1rn9FQ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L1rn9FQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE010C4CEE3;
	Tue, 29 Apr 2025 17:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948120;
	bh=jgg2Dx1LGrwpU2DMkxgoOLZ7LJnKiE9E7QbWwRyV0AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1rn9FQ0wLEidnLlajxawFF5+Ss4hQgLQ+z691XbHNQ881zTnwFJQb+PnV62uyllK
	 3tTqiEK0XlLsKLeJuP9usFOmjQWCV0RDyJfvNdDqnaOyLxXhUFOs7xLTl5Lh2d5wbp
	 YQ85r+sc9sVBAWMp8Dvne36hS4pDeAZ51v7nxL3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Morris <rtm@mit.edu>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/280] 9p/net: fix improper handling of bogus negative read/write replies
Date: Tue, 29 Apr 2025 18:42:16 +0200
Message-ID: <20250429161123.087989182@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit d0259a856afca31d699b706ed5e2adf11086c73b ]

In p9_client_write() and p9_client_read_once(), if the server
incorrectly replies with success but a negative write/read count then we
would consider written (negative) <= rsize (positive) because both
variables were signed.

Make variables unsigned to avoid this problem.

The reproducer linked below now fails with the following error instead
of a null pointer deref:
9pnet: bogus RWRITE count (4294967295 > 3)

Reported-by: Robert Morris <rtm@mit.edu>
Closes: https://lore.kernel.org/16271.1734448631@26-5-164.dynamic.csail.mit.edu
Message-ID: <20250319-9p_unsigned_rw-v3-1-71327f1503d0@codewreck.org>
Reviewed-by: Christian Schoenebeck <linux_oss@crudebyte.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 09f8ced9f8bb7..52a5497cfca79 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1548,7 +1548,8 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 	struct p9_client *clnt = fid->clnt;
 	struct p9_req_t *req;
 	int count = iov_iter_count(to);
-	int rsize, received, non_zc = 0;
+	u32 rsize, received;
+	bool non_zc = false;
 	char *dataptr;
 
 	*err = 0;
@@ -1571,7 +1572,7 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 				       0, 11, "dqd", fid->fid,
 				       offset, rsize);
 	} else {
-		non_zc = 1;
+		non_zc = true;
 		req = p9_client_rpc(clnt, P9_TREAD, "dqd", fid->fid, offset,
 				    rsize);
 	}
@@ -1592,11 +1593,11 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 		return 0;
 	}
 	if (rsize < received) {
-		pr_err("bogus RREAD count (%d > %d)\n", received, rsize);
+		pr_err("bogus RREAD count (%u > %u)\n", received, rsize);
 		received = rsize;
 	}
 
-	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", received);
+	p9_debug(P9_DEBUG_9P, "<<< RREAD count %u\n", received);
 
 	if (non_zc) {
 		int n = copy_to_iter(dataptr, received, to);
@@ -1623,9 +1624,9 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 	*err = 0;
 
 	while (iov_iter_count(from)) {
-		int count = iov_iter_count(from);
-		int rsize = fid->iounit;
-		int written;
+		size_t count = iov_iter_count(from);
+		u32 rsize = fid->iounit;
+		u32 written;
 
 		if (!rsize || rsize > clnt->msize - P9_IOHDRSZ)
 			rsize = clnt->msize - P9_IOHDRSZ;
@@ -1633,7 +1634,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 		if (count < rsize)
 			rsize = count;
 
-		p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %d (/%d)\n",
+		p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %u (/%zu)\n",
 			 fid->fid, offset, rsize, count);
 
 		/* Don't bother zerocopy for small IO (< 1024) */
@@ -1659,11 +1660,11 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 			break;
 		}
 		if (rsize < written) {
-			pr_err("bogus RWRITE count (%d > %d)\n", written, rsize);
+			pr_err("bogus RWRITE count (%u > %u)\n", written, rsize);
 			written = rsize;
 		}
 
-		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", written);
+		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %u\n", written);
 
 		p9_req_put(clnt, req);
 		iov_iter_revert(from, count - written - iov_iter_count(from));
@@ -2098,7 +2099,8 @@ EXPORT_SYMBOL_GPL(p9_client_xattrcreate);
 
 int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 {
-	int err, rsize, non_zc = 0;
+	int err, non_zc = 0;
+	u32 rsize;
 	struct p9_client *clnt;
 	struct p9_req_t *req;
 	char *dataptr;
@@ -2107,7 +2109,7 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 
 	iov_iter_kvec(&to, ITER_DEST, &kv, 1, count);
 
-	p9_debug(P9_DEBUG_9P, ">>> TREADDIR fid %d offset %llu count %d\n",
+	p9_debug(P9_DEBUG_9P, ">>> TREADDIR fid %d offset %llu count %u\n",
 		 fid->fid, offset, count);
 
 	clnt = fid->clnt;
@@ -2142,11 +2144,11 @@ int p9_client_readdir(struct p9_fid *fid, char *data, u32 count, u64 offset)
 		goto free_and_error;
 	}
 	if (rsize < count) {
-		pr_err("bogus RREADDIR count (%d > %d)\n", count, rsize);
+		pr_err("bogus RREADDIR count (%u > %u)\n", count, rsize);
 		count = rsize;
 	}
 
-	p9_debug(P9_DEBUG_9P, "<<< RREADDIR count %d\n", count);
+	p9_debug(P9_DEBUG_9P, "<<< RREADDIR count %u\n", count);
 
 	if (non_zc)
 		memmove(data, dataptr, count);
-- 
2.39.5



