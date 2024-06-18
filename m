Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6F315217A;
	Tue, 18 Jun 2024 12:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715165; cv=none; b=RDuDK3leL7DYHzMCGpiPT3aJ+HipRnJvfNt7bMepMw/eXCnRZ8Meyss0OJ5nksJpRyooF7Vex510kEe25Byyw/a1r/bgsZ16MNbqwXiEtU9qiag95o4IRXcVJpScSTZnbwIHoRUXQEy4IY1TVRYIPUfufOQ6MHgyaavd2+v8knc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715165; c=relaxed/simple;
	bh=VvY5sFSmLoOz2rJ1YW7PvRBivLUKY/D/hgx1DOopqlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EzgoB5bx+T+TTgjLUx5/WuUJPTkBhByGLa0p2sU0RncqCjJyqRcgcwaKW5fuqL3H8IHzQ11QzUF6JrJEZohwA7eSXFZDTMf/NMdg8YHlUKib9i1jC5Gcn8dkWDoqhflyWXe+QmnS8xXsIsPIxIot6n5d0tf6jqXj67zrei0IgcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUGSmZMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUGSmZMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6230C3277B;
	Tue, 18 Jun 2024 12:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715165;
	bh=VvY5sFSmLoOz2rJ1YW7PvRBivLUKY/D/hgx1DOopqlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUGSmZMZ7iAqZuGsn2fFDqANcJR9vGUfzFuu2fQtDxvWyH85ZIRebfvMURoq20ke2
	 wDPasDi9iobMswpRlOkWqoY6hbKWXBHgwBc6cNoDyAuYRqIBYD68gIL3y42/kVXCGB
	 +1S7h/T3WBUIGl1J47+bfJLuUUdUv7vNIOoSuNds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 217/770] NFSD: Reduce svc_rqst::rq_pages churn during READDIR operations
Date: Tue, 18 Jun 2024 14:31:10 +0200
Message-ID: <20240618123415.657580290@linuxfoundation.org>
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

[ Upstream commit 76ed0dd96eeb2771b21bf5dcbd88326ef89ee0ed ]

During NFSv2 and NFSv3 READDIR/PLUS operations, NFSD advances
rq_next_page to the full size of the client-requested buffer, then
releases all those pages at the end of the request. The next request
to use that nfsd thread has to refill the pages.

NFSD does this even when the dirlist in the reply is small. With
NFSv3 clients that send READDIR operations with large buffer sizes,
that can be 256 put_page/alloc_page pairs per READDIR request, even
though those pages often remain unused.

We can save some work by not releasing dirlist buffer pages that
were not used to form the READDIR Reply. I've left the NFSv2 code
alone since there are never more than three pages involved in an
NFSv2 READDIR Reply.

Eventually we should nail down why these pages need to be released
at all in order to avoid allocating and releasing pages
unnecessarily.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3proc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/nfsd/nfs3proc.c b/fs/nfsd/nfs3proc.c
index 781bb2b115e74..be1ed33e424e0 100644
--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -498,6 +498,9 @@ nfsd3_proc_readdir(struct svc_rqst *rqstp)
 	memcpy(resp->verf, argp->verf, 8);
 	nfs3svc_encode_cookie3(resp, offset);
 
+	/* Recycle only pages that were part of the reply */
+	rqstp->rq_next_page = resp->xdr.page_ptr + 1;
+
 	return rpc_success;
 }
 
@@ -538,6 +541,9 @@ nfsd3_proc_readdirplus(struct svc_rqst *rqstp)
 	memcpy(resp->verf, argp->verf, 8);
 	nfs3svc_encode_cookie3(resp, offset);
 
+	/* Recycle only pages that were part of the reply */
+	rqstp->rq_next_page = resp->xdr.page_ptr + 1;
+
 out:
 	return rpc_success;
 }
-- 
2.43.0



