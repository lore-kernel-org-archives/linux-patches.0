Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99187E588;
	Mon,  8 Apr 2024 13:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582247; cv=none; b=qy/D6DqC/oV9XU90524nE5WS4+Z+RQdvoacbZvSdLfXbULhDTcRTfJmxqOYVn6NeRbTLLsTUxwQjQ2gcSPlWY2K4aGToWd/sBz3aihB3kwU+pgqmZiwktlIban6S6Ae1BcIbDB2/AOEYsvma5P3juuX3/SpExD/B6H9xzikGVpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582247; c=relaxed/simple;
	bh=Hcf2t+J+S9Uj6ACJMjrAGZY98CO1YxmXgfvKvtvR5IU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BhG4SlxAbL4iXX7SevlNCiA947ljGihJs6KFAL838dtsANiog33ag8sbunrMab0PeFgkHaOZ38camvqQoqwRVGT/uhIzysfp9Z+BUh6v864Ud0Y79luMsOTp75f23yPnFO1Vvv40sQrE9EdfmvmX5O4p5iUuosEa4C8D2dKO6tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KiRe7u4K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KiRe7u4K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64446C433C7;
	Mon,  8 Apr 2024 13:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582246;
	bh=Hcf2t+J+S9Uj6ACJMjrAGZY98CO1YxmXgfvKvtvR5IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KiRe7u4KRWiSpZcs4QT5TT2WbETyqzHH44PEwjZoyREt01qulMfJKt0pI2SDnVoui
	 NWM5jpaYjo9r7eSdX8wIG7Sb2bajmV3ACfdhEZc6QN92/mlb6iBT/QiqflJEn0YH8Z
	 Oz5cm0Ve6G/oPSu/v+kohM4HQsKbLV7EKqtGcfWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominique Martinet <asmadeus@codewreck.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 090/138] 9p: Fix read/write debug statements to report server reply
Date: Mon,  8 Apr 2024 14:58:24 +0200
Message-ID: <20240408125259.024071909@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dominique Martinet <asmadeus@codewreck.org>

[ Upstream commit be3193e58ec210b2a72fb1134c2a0695088a911d ]

Previous conversion to iov missed these debug statements which would now
always print the requested size instead of the actual server reply.

Write also added a loop in a much older commit but we didn't report
these, while reads do report each iteration -- it's more coherent to
keep reporting all requests to server so move that at the same time.

Fixes: 7f02464739da ("9p: convert to advancing variant of iov_iter_get_pages_alloc()")
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Message-ID: <20240109-9p-rw-trace-v1-1-327178114257@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/client.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/9p/client.c b/net/9p/client.c
index 84b93b04d0f06..1d9a8a1f3f107 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1581,7 +1581,7 @@ p9_client_read_once(struct p9_fid *fid, u64 offset, struct iov_iter *to,
 		received = rsize;
 	}
 
-	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", count);
+	p9_debug(P9_DEBUG_9P, "<<< RREAD count %d\n", received);
 
 	if (non_zc) {
 		int n = copy_to_iter(dataptr, received, to);
@@ -1607,9 +1607,6 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 	int total = 0;
 	*err = 0;
 
-	p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %zd\n",
-		 fid->fid, offset, iov_iter_count(from));
-
 	while (iov_iter_count(from)) {
 		int count = iov_iter_count(from);
 		int rsize = fid->iounit;
@@ -1621,6 +1618,9 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 		if (count < rsize)
 			rsize = count;
 
+		p9_debug(P9_DEBUG_9P, ">>> TWRITE fid %d offset %llu count %d (/%d)\n",
+			 fid->fid, offset, rsize, count);
+
 		/* Don't bother zerocopy for small IO (< 1024) */
 		if (clnt->trans_mod->zc_request && rsize > 1024) {
 			req = p9_client_zc_rpc(clnt, P9_TWRITE, NULL, from, 0,
@@ -1648,7 +1648,7 @@ p9_client_write(struct p9_fid *fid, u64 offset, struct iov_iter *from, int *err)
 			written = rsize;
 		}
 
-		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", count);
+		p9_debug(P9_DEBUG_9P, "<<< RWRITE count %d\n", written);
 
 		p9_req_put(clnt, req);
 		iov_iter_revert(from, count - written - iov_iter_count(from));
-- 
2.43.0



