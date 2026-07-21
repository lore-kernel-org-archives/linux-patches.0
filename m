Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9F842DFEC;
	Tue, 21 Jul 2026 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670187; cv=none; b=lmg4dZbb30p4w64aUfpVA7viiGmPRSnBR8wNI4C6HVvHYucFGLtFVtptw5DZzT/QU8iv1kUbVojPf3XIA9pgIFqkEiaycG/SYJemPrbQfhoqv5P2fANfJKI7bvLW0PpL5D60SuvWv+HqJx7yNFgbSe+dP5QncI9WdmhVnuMFb5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670187; c=relaxed/simple;
	bh=r+XfbYHRVeelcEJjSDUq6vJDP05Y52FbHUFFYW+VXZo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JCpkeeqp5JSa//Jgia4BT8dApTvBrwI6XrNxr9bwFIi8RGQ8pPbjVYN2ln5KAei758YS2YKAaTp0bRiIgz6dywwnDXIAJ+6uY/iD2w4GvZhbVkcoAwPtRbpb4IQ77iDDBR3lSnQwypqz6M9zpaGO1/iNEc+woVCfyq1tHQ04h2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH6LtL1Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH6LtL1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A7F1F000E9;
	Tue, 21 Jul 2026 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670182;
	bh=51w3VAFe6c2Ds7a3+G3OmNOxtyohDzU+9RwGQEihwBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wH6LtL1ZnNQWZ7Op4W3WhtTKibmul0MrE0PU5uN7njU1B4vKrWF+g7zLgwNsCCINs
	 +vBfUcLSx2bbectuxz6tE6rYGhDUFp5MJTZh9cojVfzlcwKEkZ1JG8oC+1Kh1lGURs
	 zpuPwZrL+/Kmg5xnSiALI9gjMeBJg5I+PJJTjAlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 6.1 0834/1067] nvmet-rdma: handle inline data with a nonzero offset
Date: Tue, 21 Jul 2026 17:23:55 +0200
Message-ID: <20260721152443.207230604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bryam Vargas <hexlabsecurity@proton.me>

commit 48c0162f647bb47e6084ffbc71b8f213f5e2f4f8 upstream.

nvmet_rdma_use_inline_sg() maps the host-controlled inline data offset
into the per-command inline scatterlist.  The bounds check admits any
offset with off + len <= inline_data_size, but the mapping still assumes
the data begins in the first inline page:

	sg->offset = off;
	sg->length = min_t(int, len, PAGE_SIZE - off);

When a port is configured with inline_data_size > PAGE_SIZE (settable up
to max(SZ_16K, PAGE_SIZE)), an offset in (PAGE_SIZE, inline_data_size]
makes "PAGE_SIZE - off" underflow, so sg->length is set to ~4 GiB and
the block backend reads far past the first inline page.  num_pages(len)
also ignores the offset, so an in-bounds offset whose [off, off+len)
span crosses a page boundary under-counts the scatterlist.

Map the offset properly: split it into a page index and an in-page
offset, start the scatterlist at that page, and size the page count from
page_off + len.  Because the request scatterlist may now start at
inline_sg[page_idx] rather than inline_sg[0], generalize the inline-SGL
identity test in nvmet_rdma_release_rsp() to a range test; otherwise the
persistent inline scatterlist is mistaken for an allocated one and
nvmet_req_free_sgls() frees an inline page (and warns in
free_large_kmalloc()).

Fixes: 0d5ee2b2ab4f ("nvmet-rdma: support max(16KB, PAGE_SIZE) inline data")
Cc: stable@vger.kernel.org
Suggested-by: Keith Busch <kbusch@kernel.org>
Reported-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/rdma.c |   18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -666,7 +666,8 @@ static void nvmet_rdma_release_rsp(struc
 	if (rsp->n_rdma)
 		nvmet_rdma_rw_ctx_destroy(rsp);
 
-	if (rsp->req.sg != rsp->cmd->inline_sg)
+	if (rsp->req.sg < rsp->cmd->inline_sg ||
+	    rsp->req.sg >= rsp->cmd->inline_sg + queue->dev->inline_page_count)
 		nvmet_req_free_sgls(&rsp->req);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
@@ -821,24 +822,25 @@ static void nvmet_rdma_write_data_done(s
 static void nvmet_rdma_use_inline_sg(struct nvmet_rdma_rsp *rsp, u32 len,
 		u64 off)
 {
-	int sg_count = num_pages(len);
+	u64 page_off = off % PAGE_SIZE;
+	u64 page_idx = off / PAGE_SIZE;
+	int sg_count = num_pages(page_off + len);
 	struct scatterlist *sg;
 	int i;
 
-	sg = rsp->cmd->inline_sg;
+	sg = &rsp->cmd->inline_sg[page_idx];
 	for (i = 0; i < sg_count; i++, sg++) {
 		if (i < sg_count - 1)
 			sg_unmark_end(sg);
 		else
 			sg_mark_end(sg);
-		sg->offset = off;
-		sg->length = min_t(int, len, PAGE_SIZE - off);
+		sg->offset = page_off;
+		sg->length = min_t(u64, len, PAGE_SIZE - page_off);
 		len -= sg->length;
-		if (!i)
-			off = 0;
+		page_off = 0;
 	}
 
-	rsp->req.sg = rsp->cmd->inline_sg;
+	rsp->req.sg = &rsp->cmd->inline_sg[page_idx];
 	rsp->req.sg_cnt = sg_count;
 }
 


