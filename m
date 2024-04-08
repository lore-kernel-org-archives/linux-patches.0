Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FB37C085;
	Mon,  8 Apr 2024 13:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584697; cv=none; b=Siqkd0l429QWCGcnn8qXWFiwQtGQ8BqQ+DV1fUJznMrOEAAZoSGM8BEUffJzhIHVZB1nnsDzOUvA0q0yleA4x0d8Y/1JGalfptdolmURyE4SYeDQL6e40YWZ/kZLpJrFAPjd5ohmMiebesXA3zgMjI2fqgCoMdeuKmG5ZYoA4wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584697; c=relaxed/simple;
	bh=Q8UQSgsKKjEaPM//4mxazwFHJ+BbaDOsrEYV6zjivSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFP4F7m/g5SnCisrAK77bEK6LXLwqMMvCfpRHWZISaaqH2AFYOQvwUnMO6JWIaMMdrU8694KmUrSTKT0pEPS6qIihOQDpVKBkue9frTRyKrF1hMBpyw4pS0ryesL38x66VPU/n1TyXckSbufFANi4ls+r9OpJY/MGv/v3ibohtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eUqYFAGR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eUqYFAGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2303BC433F1;
	Mon,  8 Apr 2024 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584697;
	bh=Q8UQSgsKKjEaPM//4mxazwFHJ+BbaDOsrEYV6zjivSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUqYFAGR+xvk39oNAdCjoqf0YLmw0r7ZJkXZunAdfS2lSRNKNrSdyY9h7jCp/vIIM
	 nek0Yhh/NHIbtVFKPzAdFRIpcst9dyJkOwgKT6dNzqYEp56dJtAC4809DG4luuZ8Hl
	 9lAAps+v87Kr8aaPxJoGJBAJgonmhMN+m898Lt7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Dario Lesca <d.lesca@solinos.it>,
	David Critch <dcritch@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 527/690] nfsd: dont replace page in rq_pages if its a continuation of last page
Date: Mon,  8 Apr 2024 14:56:33 +0200
Message-ID: <20240408125418.744324107@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 27c934dd8832dd40fd34776f916dc201e18b319b ]

The splice read calls nfsd_splice_actor to put the pages containing file
data into the svc_rqst->rq_pages array. It's possible however to get a
splice result that only has a partial page at the end, if (e.g.) the
filesystem hands back a short read that doesn't cover the whole page.

nfsd_splice_actor will plop the partial page into its rq_pages array and
return. Then later, when nfsd_splice_actor is called again, the
remainder of the page may end up being filled out. At this point,
nfsd_splice_actor will put the page into the array _again_ corrupting
the reply. If this is done enough times, rq_next_page will overrun the
array and corrupt the trailing fields -- the rq_respages and
rq_next_page pointers themselves.

If we've already added the page to the array in the last pass, don't add
it to the array a second time when dealing with a splice continuation.
This was originally handled properly in nfsd_splice_actor, but commit
91e23b1c3982 ("NFSD: Clean up nfsd_splice_actor()") removed the check
for it.

Fixes: 91e23b1c3982 ("NFSD: Clean up nfsd_splice_actor()")
Cc: Al Viro <viro@zeniv.linux.org.uk>
Reported-by: Dario Lesca <d.lesca@solinos.it>
Tested-by: David Critch <dcritch@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2150630
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/vfs.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 690191b3d997c..71788a5e4a55c 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -938,8 +938,15 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct page *last_page;
 
 	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
-	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+	for (page += offset / PAGE_SIZE; page <= last_page; page++) {
+		/*
+		 * Skip page replacement when extending the contents
+		 * of the current page.
+		 */
+		if (page == *(rqstp->rq_next_page - 1))
+			continue;
 		svc_rqst_replace_page(rqstp, page);
+	}
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.43.0



