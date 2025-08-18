Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A331E115;
	Mon, 18 Aug 2025 13:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524671; cv=none; b=nqYM/O/OxW+0snedjFu8uAy9HWICB/D5CXUn7AzUzXC+9cppqW3C1tm9GoxulONLBzoqenivgo/2FTiRFJLUKe4Qqycad7qdxk0OwHx7THiCO35xOiEgXFS1H/6WP5LkrunOB6ufD50M8SxbbBC8X8X8qxes+rjeQE1KWC/0dqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524671; c=relaxed/simple;
	bh=8DkM58UlPEA+XF6JtQRZY/tzFiw8QQpePFSgBX4WjFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1Fwo/1NUdLWbSfNjbFQ223QAOEaFlNw2RQqrwkLEXfhHZ1IdBOYqf057+f6tYTDSJ9NYBa98q8sZxEvQTP5CmQRJilQquc7/EN2OzLkO8/z4UNrVU6vPAOjuwLnw3g/HHLN2K3PwMa+RqnPaiLFLkxN9u5QMmB9ax58nenPkcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gm11qY8v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gm11qY8v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462F9C4CEF1;
	Mon, 18 Aug 2025 13:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524671;
	bh=8DkM58UlPEA+XF6JtQRZY/tzFiw8QQpePFSgBX4WjFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gm11qY8vEQFFUlec1j13KcLa6Ul6znPrk1z17MSUf6S6Jb4J+xBe8e4HzwC9yM7iS
	 OkLC/c+NtOxpPxHPrEtCeB08OAoJu0UutuG0hamVvxJjtzPSUneKfEanjN79d4d7IH
	 v5hf2YlT4MwlOciz/QO09FDMKiJ4PyOfpEDc0L7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.16 003/570] io_uring/zcrx: account area memory
Date: Mon, 18 Aug 2025 14:39:50 +0200
Message-ID: <20250818124505.921589170@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 262ab205180d2ba3ab6110899a4dbe439c51dfaa upstream.

zcrx areas can be quite large and need to be accounted and checked
against RLIMIT_MEMLOCK. In practise it shouldn't be a big issue as
the inteface already requires cap_net_admin.

Cc: stable@vger.kernel.org
Fixes: cf96310c5f9a0 ("io_uring/zcrx: add io_zcrx_area")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/4b53f0c575bd062f63d12bec6cac98037fc66aeb.1752699568.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/zcrx.c |   29 ++++++++++++++++++++++++++++-
 io_uring/zcrx.h |    1 +
 2 files changed, 29 insertions(+), 1 deletion(-)

--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -152,12 +152,29 @@ static int io_zcrx_map_area_dmabuf(struc
 	return niov_idx;
 }
 
+static unsigned long io_count_account_pages(struct page **pages, unsigned nr_pages)
+{
+	struct folio *last_folio = NULL;
+	unsigned long res = 0;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct folio *folio = page_folio(pages[i]);
+
+		if (folio == last_folio)
+			continue;
+		last_folio = folio;
+		res += 1UL << folio_order(folio);
+	}
+	return res;
+}
+
 static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct page **pages;
-	int nr_pages;
+	int nr_pages, ret;
 
 	if (area_reg->dmabuf_fd)
 		return -EINVAL;
@@ -168,6 +185,13 @@ static int io_import_umem(struct io_zcrx
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
+	mem->account_pages = io_count_account_pages(pages, nr_pages);
+	ret = io_account_mem(ifq->ctx, mem->account_pages);
+	if (ret < 0) {
+		mem->account_pages = 0;
+		return ret;
+	}
+
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -374,6 +398,9 @@ static void io_zcrx_free_area(struct io_
 		io_zcrx_unmap_area(area->ifq, area);
 	io_release_area_mem(&area->mem);
 
+	if (area->mem.account_pages)
+		io_unaccount_mem(area->ifq->ctx, area->mem.account_pages);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -14,6 +14,7 @@ struct io_zcrx_mem {
 
 	struct page			**pages;
 	unsigned long			nr_folios;
+	unsigned long			account_pages;
 
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;


