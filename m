Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C3D79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DAEC433C1;
	Wed, 30 Nov 2022 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834248;
	bh=tVYiFKwPcnQUHJ1gwGc/18utRcHek+UArW1VjVo3Gow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XblllFjsTPYKos0aqpaw1fp7jed7T5tinNEvXrjYfDxxcJyjVnOTfHYrFCaXyKbID
	 b5KKOMECA4osxlnqqoczQ3Es6dK8n6h1wocyhl0kZS4DX44hj42rk4cUuX+cjmikRs
	 jbFsw/YtZ2WFUf50dq7s3tczC8plK4DiiS4tmLrw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anders Blomdell <anders.blomdell@control.lth.se>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 184/289] NFSD: Fix reads with a non-zero offset that dont end on a page boundary
Date: Wed, 30 Nov 2022 19:22:49 +0100
Message-Id: <20221130180548.297228210@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit ac8db824ead0de2e9111337c401409d010fba2f0 ]

This was found when virtual machines with nfs-mounted qcow2 disks
failed to boot properly.

Reported-by: Anders Blomdell <anders.blomdell@control.lth.se>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2142132
Fixes: bfbfb6182ad1 ("nfsd_splice_actor(): handle compound pages")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index fc17b0ac8729..f3cd614e1f1e 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -847,10 +847,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 	struct svc_rqst *rqstp = sd->u.data;
 	struct page *page = buf->page;	// may be a compound one
 	unsigned offset = buf->offset;
+	struct page *last_page;
 
-	page += offset / PAGE_SIZE;
-	for (int i = sd->len; i > 0; i -= PAGE_SIZE)
-		svc_rqst_replace_page(rqstp, page++);
+	last_page = page + (offset + sd->len - 1) / PAGE_SIZE;
+	for (page += offset / PAGE_SIZE; page <= last_page; page++)
+		svc_rqst_replace_page(rqstp, page);
 	if (rqstp->rq_res.page_len == 0)	// first call
 		rqstp->rq_res.page_base = offset % PAGE_SIZE;
 	rqstp->rq_res.page_len += sd->len;
-- 
2.35.1



