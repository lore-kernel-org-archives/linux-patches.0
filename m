Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA2E6EB72;
	Mon,  8 Apr 2024 13:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584489; cv=none; b=XXVyI1xVZUkll9OPrnz3oALSyDWQBgO5mSSZlmEDzAirIjRdYrjBijCMLtwFSv3yuFKx7jbEzf/4fgfqa0BfTqvUBrBBtpECc9WdWydHc32Dds7SvkTQpy3lq2yzkVW3dH9i0MJlFX73hLLBLswNTP0vE9N0M/klFnRpBoC8U7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584489; c=relaxed/simple;
	bh=zrEmmviOT6firgP2LkwLtHxP+4U8auWJkgeMtdFqELg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1YGoe9WdhVfKzY4kK2QiofKh4kHkjHc8wHM+wAiVlF8uMu4aG5YKBMBFuY9hPvPSoFrpk/0jvIKR4vG/U4UL0X3XBWdaYY/WljMcnGCkMld8q/KUqmp1HOjZHi94kmq9/gQX+EZbNoKz3WQ+VpEONyiDnF1OTHnyyDL/Waj5UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yYMOrb1A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yYMOrb1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D2DC433F1;
	Mon,  8 Apr 2024 13:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584489;
	bh=zrEmmviOT6firgP2LkwLtHxP+4U8auWJkgeMtdFqELg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yYMOrb1AHaF4IXViq1KAQL8ej4qorpbp9MCl17fN6/1HN24HP1/SENBYGr/Yvfj0D
	 v8kKZw/bN2Sh0h1h4PY1fIE5fAMe+2sYk1pMQnmB0az1r/Ime1fL99vm3yaf64gfBu
	 knNTK7aVIJFKMMoMom2cEGGAgdcuHJPnEo5iraDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Benjamin Coddington <bcodding@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 5.15 415/690] nfsd_splice_actor(): handle compound pages
Date: Mon,  8 Apr 2024 14:54:41 +0200
Message-ID: <20240408125414.625567765@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit bfbfb6182ad1d7d184b16f25165faad879147f79 ]

pipe_buffer might refer to a compound page (and contain more than a PAGE_SIZE
worth of data).  Theoretically it had been possible since way back, but
nfsd_splice_actor() hadn't run into that until copy_page_to_iter() change.
Fortunately, the only thing that changes for compound pages is that we
need to stuff each relevant subpage in and convert the offset into offset
in the first subpage.

Acked-by: Chuck Lever <chuck.lever@oracle.com>
Tested-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: f0f6b614f83d "copy_page_to_iter(): don't split high-order page in case of ITER_PIPE"
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index ad689215b1f37..343af6341e5e1 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -846,10 +846,15 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		  struct splice_desc *sd)
 {
 	struct svc_rqst *rqstp = sd->u.data;
-
-	svc_rqst_replace_page(rqstp, buf->page);
-	if (rqstp->rq_res.page_len == 0)
-		rqstp->rq_res.page_base = buf->offset;
+	struct page *page = buf->page;	// may be a compound one
+	unsigned offset = buf->offset;
+	int i;
+
+	page += offset / PAGE_SIZE;
+	for (i = sd->len; i > 0; i -= PAGE_SIZE)
+		svc_rqst_replace_page(rqstp, page++);
+	if (rqstp->rq_res.page_len == 0)	// first call
+		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
 	return sd->len;
 }
-- 
2.43.0



