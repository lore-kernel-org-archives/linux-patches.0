Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB4A2EAE6;
	Mon, 23 Dec 2024 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969911; cv=none; b=XNKA3zr+NkFftGB50mLONdsAtfS/BpsQorTU/7D+ZUD+CGYLUSIkmTrJeGqJunVCD9QfU+FVktUmBBvZurH6h2x/jm3E29TlBm0i3Oaks9UWNEgRw2U00XS9MoDXk3KUFmbRLlCLDs2jUj6oImpCTrhlHsKd4xxAJ1+rCTnjn34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969911; c=relaxed/simple;
	bh=RJVpjGZ6/esfnwT3TKX9S4z8CbocJlLSW54rARIByJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KjifyF8FO4dBX3oIhE3rTY13MCaKIV/7+WdJ4d7wskdquyYDUodhCJf1zo7Pnnh9UnggS7dcI6xNmmfCFPDK0Q9ajEbex/HVhHSMRaggap2xaYm3oRCd7hm92HkBqlctA4qIcWXaKCpOpDCcIzU7kc/i/hwXRJjIVwJ11+2XTco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0JGLVYv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0JGLVYv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CBC7C4CED3;
	Mon, 23 Dec 2024 16:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969911;
	bh=RJVpjGZ6/esfnwT3TKX9S4z8CbocJlLSW54rARIByJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0JGLVYv4I3Vmem5rhUGPFvsXntg/Ky5qP1sasyjjFBB53uqmkDNSuSI1SBi1xb9Cn
	 hLixi52inYtFfNxUUSe9xOJps/eYftZztWo5b2lw6elaF9/5h9jo4K0r0W1HNvNc6E
	 kjU+hDEgXhnxIbnHgJZz4eMbA/hd2PYrKLT7tXo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Huan Yang <link@vivo.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 090/160] udmabuf: udmabuf_create pin folio codestyle cleanup
Date: Mon, 23 Dec 2024 16:58:21 +0100
Message-ID: <20241223155412.170983053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huan Yang <link@vivo.com>

[ Upstream commit 164fd9efd46531fddfaa933d394569259896642b ]

This patch aim to simplify the memfd folio pin during the udmabuf
create. No functional changes.

This patch create a udmabuf_pin_folios function, in this, do the memfd
pin folio and then record each pinned folio, offset.

This patch simplify the pinned folio record, iter by each pinned folio,
and then record each offset in it.

Compare to iter by pgcnt, more readable.

Suggested-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Huan Yang <link@vivo.com>
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Signed-off-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240918025238.2957823-5-link@vivo.com
Stable-dep-of: f49856f525ac ("udmabuf: fix memory leak on last export_udmabuf() error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma-buf/udmabuf.c | 137 +++++++++++++++++++++-----------------
 1 file changed, 76 insertions(+), 61 deletions(-)

diff --git a/drivers/dma-buf/udmabuf.c b/drivers/dma-buf/udmabuf.c
index a3638ccc15f5..970e08a95dc0 100644
--- a/drivers/dma-buf/udmabuf.c
+++ b/drivers/dma-buf/udmabuf.c
@@ -262,9 +262,6 @@ static int check_memfd_seals(struct file *memfd)
 {
 	int seals;
 
-	if (!memfd)
-		return -EBADFD;
-
 	if (!shmem_file(memfd) && !is_file_hugepages(memfd))
 		return -EBADFD;
 
@@ -299,17 +296,68 @@ static int export_udmabuf(struct udmabuf *ubuf,
 	return dma_buf_fd(buf, flags);
 }
 
+static long udmabuf_pin_folios(struct udmabuf *ubuf, struct file *memfd,
+			       loff_t start, loff_t size)
+{
+	pgoff_t pgoff, pgcnt, upgcnt = ubuf->pagecount;
+	struct folio **folios = NULL;
+	u32 cur_folio, cur_pgcnt;
+	long nr_folios;
+	long ret = 0;
+	loff_t end;
+
+	pgcnt = size >> PAGE_SHIFT;
+	folios = kvmalloc_array(pgcnt, sizeof(*folios), GFP_KERNEL);
+	if (!folios)
+		return -ENOMEM;
+
+	end = start + (pgcnt << PAGE_SHIFT) - 1;
+	nr_folios = memfd_pin_folios(memfd, start, end, folios, pgcnt, &pgoff);
+	if (nr_folios <= 0) {
+		ret = nr_folios ? nr_folios : -EINVAL;
+		goto end;
+	}
+
+	cur_pgcnt = 0;
+	for (cur_folio = 0; cur_folio < nr_folios; ++cur_folio) {
+		pgoff_t subpgoff = pgoff;
+		size_t fsize = folio_size(folios[cur_folio]);
+
+		ret = add_to_unpin_list(&ubuf->unpin_list, folios[cur_folio]);
+		if (ret < 0)
+			goto end;
+
+		for (; subpgoff < fsize; subpgoff += PAGE_SIZE) {
+			ubuf->folios[upgcnt] = folios[cur_folio];
+			ubuf->offsets[upgcnt] = subpgoff;
+			++upgcnt;
+
+			if (++cur_pgcnt >= pgcnt)
+				goto end;
+		}
+
+		/**
+		 * In a given range, only the first subpage of the first folio
+		 * has an offset, that is returned by memfd_pin_folios().
+		 * The first subpages of other folios (in the range) have an
+		 * offset of 0.
+		 */
+		pgoff = 0;
+	}
+end:
+	ubuf->pagecount = upgcnt;
+	kvfree(folios);
+	return ret;
+}
+
 static long udmabuf_create(struct miscdevice *device,
 			   struct udmabuf_create_list *head,
 			   struct udmabuf_create_item *list)
 {
-	pgoff_t pgoff, pgcnt, pglimit, pgbuf = 0;
-	long nr_folios, ret = -EINVAL;
-	struct file *memfd = NULL;
-	struct folio **folios;
+	pgoff_t pgcnt = 0, pglimit;
 	struct udmabuf *ubuf;
-	u32 i, j, k, flags;
-	loff_t end;
+	long ret = -EINVAL;
+	u32 i, flags;
 
 	ubuf = kzalloc(sizeof(*ubuf), GFP_KERNEL);
 	if (!ubuf)
@@ -318,81 +366,50 @@ static long udmabuf_create(struct miscdevice *device,
 	INIT_LIST_HEAD(&ubuf->unpin_list);
 	pglimit = (size_limit_mb * 1024 * 1024) >> PAGE_SHIFT;
 	for (i = 0; i < head->count; i++) {
-		if (!IS_ALIGNED(list[i].offset, PAGE_SIZE))
+		if (!PAGE_ALIGNED(list[i].offset))
 			goto err;
-		if (!IS_ALIGNED(list[i].size, PAGE_SIZE))
+		if (!PAGE_ALIGNED(list[i].size))
 			goto err;
-		ubuf->pagecount += list[i].size >> PAGE_SHIFT;
-		if (ubuf->pagecount > pglimit)
+
+		pgcnt += list[i].size >> PAGE_SHIFT;
+		if (pgcnt > pglimit)
 			goto err;
 	}
 
-	if (!ubuf->pagecount)
+	if (!pgcnt)
 		goto err;
 
-	ubuf->folios = kvmalloc_array(ubuf->pagecount, sizeof(*ubuf->folios),
-				      GFP_KERNEL);
+	ubuf->folios = kvmalloc_array(pgcnt, sizeof(*ubuf->folios), GFP_KERNEL);
 	if (!ubuf->folios) {
 		ret = -ENOMEM;
 		goto err;
 	}
-	ubuf->offsets = kvcalloc(ubuf->pagecount, sizeof(*ubuf->offsets),
-				 GFP_KERNEL);
+
+	ubuf->offsets = kvcalloc(pgcnt, sizeof(*ubuf->offsets), GFP_KERNEL);
 	if (!ubuf->offsets) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	pgbuf = 0;
 	for (i = 0; i < head->count; i++) {
-		memfd = fget(list[i].memfd);
-		ret = check_memfd_seals(memfd);
-		if (ret < 0)
-			goto err;
+		struct file *memfd = fget(list[i].memfd);
 
-		pgcnt = list[i].size >> PAGE_SHIFT;
-		folios = kvmalloc_array(pgcnt, sizeof(*folios), GFP_KERNEL);
-		if (!folios) {
-			ret = -ENOMEM;
+		if (!memfd) {
+			ret = -EBADFD;
 			goto err;
 		}
 
-		end = list[i].offset + (pgcnt << PAGE_SHIFT) - 1;
-		ret = memfd_pin_folios(memfd, list[i].offset, end,
-				       folios, pgcnt, &pgoff);
-		if (ret <= 0) {
-			kvfree(folios);
-			if (!ret)
-				ret = -EINVAL;
+		ret = check_memfd_seals(memfd);
+		if (ret < 0) {
+			fput(memfd);
 			goto err;
 		}
 
-		nr_folios = ret;
-		pgoff >>= PAGE_SHIFT;
-		for (j = 0, k = 0; j < pgcnt; j++) {
-			ubuf->folios[pgbuf] = folios[k];
-			ubuf->offsets[pgbuf] = pgoff << PAGE_SHIFT;
-
-			if (j == 0 || ubuf->folios[pgbuf-1] != folios[k]) {
-				ret = add_to_unpin_list(&ubuf->unpin_list,
-							folios[k]);
-				if (ret < 0) {
-					kfree(folios);
-					goto err;
-				}
-			}
-
-			pgbuf++;
-			if (++pgoff == folio_nr_pages(folios[k])) {
-				pgoff = 0;
-				if (++k == nr_folios)
-					break;
-			}
-		}
-
-		kvfree(folios);
+		ret = udmabuf_pin_folios(ubuf, memfd, list[i].offset,
+					 list[i].size);
 		fput(memfd);
-		memfd = NULL;
+		if (ret)
+			goto err;
 	}
 
 	flags = head->flags & UDMABUF_FLAGS_CLOEXEC ? O_CLOEXEC : 0;
@@ -403,8 +420,6 @@ static long udmabuf_create(struct miscdevice *device,
 	return ret;
 
 err:
-	if (memfd)
-		fput(memfd);
 	unpin_all_folios(&ubuf->unpin_list);
 	kvfree(ubuf->offsets);
 	kvfree(ubuf->folios);
-- 
2.39.5



