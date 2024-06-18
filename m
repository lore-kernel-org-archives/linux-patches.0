Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7079013C667;
	Tue, 18 Jun 2024 13:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716035; cv=none; b=tcMAdh6aBNN8J0UUO5AHQZPYBuzr1zKw6D5fP8VhXKJiyP7glUOqp086dAGrNDfGiSvy4qZCFhvx1ydWRt/+KzxWY68oeErVBw0U1SM+kM7fmAZZ/dcP83LLcBKKg55vSkDgrISJHhuhCGICs3bXT4nGBxqr3oYoYfEYj6+tpR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716035; c=relaxed/simple;
	bh=L2VtXvFLEg4GpV0gmhZq2RSVaA9LgyA1rjJrOwHq9w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQHJ0xWgHDppv5rD/hlJmeecsmuaFPeOYKYUlwtGQB7eaMMqacoz5JkOV9AUwTtnUfCBNRqNDvodoyclYaG+ZsG4XNRVLxqajatyX6V2EATW2ceZRDOfOAH1vm2mKC4ypAR2FjgNuUn0Nhcd7Xt60Oh1qDTkOP1BFHY+g7KYieQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wvly/Js5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wvly/Js5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB973C3277B;
	Tue, 18 Jun 2024 13:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716035;
	bh=L2VtXvFLEg4GpV0gmhZq2RSVaA9LgyA1rjJrOwHq9w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wvly/Js57pVBF5QxB8572WMeJ9azv7cXl9Qtz+58GwiG01NbnaT223S3hcdQYng9+
	 wiMs9JRp8dWfHbJM9c+DdVsgYykEyU5GuQvkDRy/F9CEYT2rlx68BPNHaqSQY8JeZ7
	 IqD9SdlYtREIQuN7bbszZUaOq3XtsM55l2kJe5qE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 509/770] NFSD: Clean up nfsd_splice_actor()
Date: Tue, 18 Jun 2024 14:36:02 +0200
Message-ID: <20240618123426.959604213@linuxfoundation.org>
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

[ Upstream commit 91e23b1c39820bfed642119ff6b6ef9f43cf09ce ]

nfsd_splice_actor() checks that the page being spliced does not
match the previous element in the svc_rqst::rq_pages array. We
believe this is to prevent a double put_page() in cases where the
READ payload is partially contained in the xdr_buf's head buffer.

However, the NFSD READ proc functions no longer place any part of
the READ payload in the head buffer, in order to properly support
NFS/RDMA READ with Write chunks. Therefore, simplify the logic in
nfsd_splice_actor() to remove this unnecessary check.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/vfs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 86584e727ce09..0968eaf735c85 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -874,17 +874,11 @@ nfsd_splice_actor(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
 		  struct splice_desc *sd)
 {
 	struct svc_rqst *rqstp = sd->u.data;
-	struct page **pp = rqstp->rq_next_page;
-	struct page *page = buf->page;
 
-	if (rqstp->rq_res.page_len == 0) {
-		svc_rqst_replace_page(rqstp, page);
+	svc_rqst_replace_page(rqstp, buf->page);
+	if (rqstp->rq_res.page_len == 0)
 		rqstp->rq_res.page_base = buf->offset;
-	} else if (page != pp[-1]) {
-		svc_rqst_replace_page(rqstp, page);
-	}
 	rqstp->rq_res.page_len += sd->len;
-
 	return sd->len;
 }
 
-- 
2.43.0



