Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4CD43E08B;
	Tue, 21 Jul 2026 22:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672496; cv=none; b=pT3ccOgIlt2HMU8irDVYMqbnOlHTwHj5UGtK0Iqgdg9zf7TV496wOFkEJlnd5cOEs11v5Ph+Pmez+SxSeXaIQjmRv1hLn6aEuJOy37eyok3kMkynCWrffKlKnZ4uCG334CpWu0yZukk0yEpj1RqcCYa3DgMyIU402zygAlnAPk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672496; c=relaxed/simple;
	bh=f/aXJH7l68s23bxyQxs4EymWA+Fi7exMp3EQRvtaspM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LsXwRGO7LUV1oxPoY13tU9vQs0ZewV3zDm+mKSZUngvtZRt4fa9VHRdgOYWIFUYkqdz0FVvpP3ymiuNu5yfeSOFqgb3Iu7O4T3kGQ/7WFKBdrAcTfRrAh3/iajFM61tIl22GXE/96/wrN/B2GpPL70Bal0Mv9jmKSBOqGDV5OGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0sCwdHM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0sCwdHM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D651F000E9;
	Tue, 21 Jul 2026 22:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672491;
	bh=/G7+mD5kjMUmUA0/hWDsFp6WkJYzQhDCclqT312doPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0sCwdHMJ+k2rmClxPIemDRDu5PJWlEEsBduMpHUHkG/DI3o043xQTrt8cSEDJpin
	 AQH+8T2fBz9SDxHTEAHUCtu/L6H+bfez8KgMEZ29/G450/U8A9WqAHdxLrZDfqkXe8
	 0Ni0PCSE0M4gIOJhzcZQcpVH+JV7siMMWNMcFEUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Bryam Vargas <hexlabsecurity@proton.me>
Subject: [PATCH 5.15 646/843] nvmet-rdma: handle inline data with a nonzero offset
Date: Tue, 21 Jul 2026 17:24:41 +0200
Message-ID: <20260721152420.599256530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -665,7 +665,8 @@ static void nvmet_rdma_release_rsp(struc
 	if (rsp->n_rdma)
 		nvmet_rdma_rw_ctx_destroy(rsp);
 
-	if (rsp->req.sg != rsp->cmd->inline_sg)
+	if (rsp->req.sg < rsp->cmd->inline_sg ||
+	    rsp->req.sg >= rsp->cmd->inline_sg + queue->dev->inline_page_count)
 		nvmet_req_free_sgls(&rsp->req);
 
 	if (unlikely(!list_empty_careful(&queue->rsp_wr_wait_list)))
@@ -820,24 +821,25 @@ static void nvmet_rdma_write_data_done(s
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
 


