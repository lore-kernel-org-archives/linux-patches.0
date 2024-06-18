Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36187156898;
	Tue, 18 Jun 2024 12:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715535; cv=none; b=o06qHGFGDy6AI7qI9UV+PRwc/H4JQskRCGseHk24UjIqbExyyNDzX2fhP4fPAlkrqPOaPDjp/vhZ8+JkdxK2Q9Nf9xBdJ63zeqyFlUXFa42Hfsy3g/JT0gbJq5FyveJ9r5e/05DkBQJnh70XPnKItQVZ4P31HJMJ93xWtG7pkYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715535; c=relaxed/simple;
	bh=o73E/ioA+1lctdTKQfCVKWG5/4xvopQY0ULeLZa5N78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hx1BCLdNVn+1fR08wQS9mQAd4ra/q6BHpjPdJfnfspLVrxV7B74VBv4r1+ZGANQ+mdQeZ8yn6jmxUY5cYVqQ+qYgYT+nvVSHEJz6NbYckBNhWea/IkVMHhrnX69gFwA6s7x0XFz34LShRkWmJgwwrF4l7pFU89yKvl6Z5qLQkS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FP7j3v5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FP7j3v5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39B0C3277B;
	Tue, 18 Jun 2024 12:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715535;
	bh=o73E/ioA+1lctdTKQfCVKWG5/4xvopQY0ULeLZa5N78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FP7j3v5bxH8+h9iV6klLyLevfqVX3r/AmJQfP/iHNEtBjCDpsqQDPO5KHvnic2dGZ
	 OdLXfX4X/nf/vqcBo8ZmWcDbgzUStJL1CSGtoitFGo5xjULtZqyUDZdEplbulgCrpY
	 QH6OQ26v0yrm7bW0n4n3veofsw9Eo8iBYrfg1RvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	NeilBrown <neilb@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 340/770] NFSD: Clean up splice actor
Date: Tue, 18 Jun 2024 14:33:13 +0200
Message-ID: <20240618123420.391610091@linuxfoundation.org>
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

[ Upstream commit c7e0b781b73c2e26e442ed71397cc2bc5945a732 ]

A few useful observations:

 - The value in @size is never modified.

 - splice_desc.len is an unsigned int, and so is xdr_buf.page_len.
   An implicit cast to size_t is unnecessary.

 - The computation of .page_len is the same in all three arms
   of the "if" statement, so hoist it out to make it clear that
   the operation is an unconditional invariant.

The resulting function is 18 bytes shorter on my system (-Os).

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 74b2c6c5ad0b9..8520a2fc92dee 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -854,26 +854,21 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct svc_rqst *rqstp = sd->u.data;
 	struct page **pp = rqstp->rq_next_page;
 	struct page *page = buf->page;
-	size_t size;
-
-	size = sd->len;
 
 	if (rqstp->rq_res.page_len == 0) {
 		get_page(page);
 		put_page(*rqstp->rq_next_page);
 		*(rqstp->rq_next_page++) = page;
 		rqstp->rq_res.page_base = buf->offset;
-		rqstp->rq_res.page_len = size;
 	} else if (page != pp[-1]) {
 		get_page(page);
 		if (*rqstp->rq_next_page)
 			put_page(*rqstp->rq_next_page);
 		*(rqstp->rq_next_page++) = page;
-		rqstp->rq_res.page_len += size;
-	} else
-		rqstp->rq_res.page_len += size;
+	}
+	rqstp->rq_res.page_len += sd->len;
 
-	return size;
+	return sd->len;
 }
 
 static int nfsd_direct_splice_actor(struct pipe_inode_info *pipe,
-- 
2.43.0



