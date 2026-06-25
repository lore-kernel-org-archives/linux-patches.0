Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7E65283FFB;
	Thu, 25 Jun 2026 13:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782392949; cv=none; b=cpQlutXYFWmr31pGzDTpjkxUMEc5a7cqNclo6Ye0QeciLYWIdOisi0sxzjqca1TjLS+HYCKSLVCzyF03yiEzKE187dvKjVgiCglRjjxeFlnO0/kL4/i27l8Qxt9yh70BabkmYswwNEaqkNuFOpaLRwaBf6CKyhDv6X6Iy6zP+AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782392949; c=relaxed/simple;
	bh=3SZ10oLc6h4hBuPPozX8c+tWFUrq8wFZnZwVyQ1wwM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=shoWpDzacXN7c475z6/77AxqoEghZk6j35AL+2MlmXVtV8wN3GrM6D2Wt2ewnouQByZcsXxw0Z4a25r77XtRzqrG8QJ1KMWGDQhF18SboRNQ7YfvT6MQFWxSpxC8ODH8UBmgdVuzLLFoIIsq2SXDtCYix7OG27lh3oeM1KM3HqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfmcfP91; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfmcfP91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28CFC1F000E9;
	Thu, 25 Jun 2026 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782392948;
	bh=G3i7Fp9zGOQjdu7Za2K440rnR2QjEDUIQGt5RMGfLtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfmcfP912f1GFtBiVtDm9h+u73gQ1BqD7v7JUEhKT5AG3+6eH19lO76UQqDlXbFm1
	 5nUY9g9C6ALRNMice4otPMFosgYpGB/enJaaYclZ+Blc0TkA5q7fcneifc9KkYjyPW
	 nKWvKlo1FuXArKx4A6SSghWWsFfXzOrRFHhwqMls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 7.0 11/49] RDMA/bnxt_re: zero shared page before exposing to userspace
Date: Thu, 25 Jun 2026 14:03:23 +0100
Message-ID: <20260625125639.122142854@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125637.527552689@linuxfoundation.org>
References: <20260625125637.527552689@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>

commit f6b079629becfa977f9c51fe53ad2e6dcc55ef44 upstream.

bnxt_re_alloc_ucontext() allocates uctx->shpg via
__get_free_page(GFP_KERNEL). The buddy allocator does not zero pages
without __GFP_ZERO, so the page contains stale kernel data from
whatever object most recently freed it.

The page is then mapped into userspace via vm_insert_page() under
BNXT_RE_MMAP_SH_PAGE in bnxt_re_mmap(). The driver only ever writes
4 bytes (a u32 AVID) at offset BNXT_RE_AVID_OFFT (0x10) inside
bnxt_re_create_ah(); the remaining 4092 bytes of the page are exposed
to userspace unsanitised, leaking kernel memory contents.

Any user with access to /dev/infiniband/uverbsX on a host with a
bnxt_re device (typically rdma group membership) can read this data
via a single mmap() at pgoff 0 after IB_USER_VERBS_CMD_GET_CONTEXT.

Other shared pages in the same file already use get_zeroed_page()
correctly:

  drivers/infiniband/hw/bnxt_re/ib_verbs.c
      srq->uctx_srq_page = (void *)get_zeroed_page(GFP_KERNEL);
      cq->uctx_cq_page  = (void *)get_zeroed_page(GFP_KERNEL);

uctx->shpg is the only outlier. Bring it in line with the existing
convention by switching to get_zeroed_page().

Fixes: 1ac5a4047975 ("RDMA/bnxt_re: Add bnxt_re RoCE driver")
Signed-off-by: Lord Ulf Henrik Holmberg <henrik.holmberg@defensify.se>
Link: https://patch.msgid.link/20260509084011.11971-1-pomzm67@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -4375,7 +4375,7 @@ int bnxt_re_alloc_ucontext(struct ib_uco
 
 	uctx->rdev = rdev;
 
-	uctx->shpg = (void *)__get_free_page(GFP_KERNEL);
+	uctx->shpg = (void *)get_zeroed_page(GFP_KERNEL);
 	if (!uctx->shpg) {
 		rc = -ENOMEM;
 		goto fail;


