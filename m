Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD9DB34B40F;
	Wed, 20 May 2026 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297232; cv=none; b=KqeqQu0dCvuXNbAHB0NFvoAyzKJWUKE6Q7Tg3O2F9zrXPkygOq7HYMoaSnM/UM2Q9g4k6G3h7erM/5PXl/UNX9BREdt7bOSPtRHVZB/TP6Y8poKD6Z79Dpo4V62dwQ13lPXO7vgL+p+97iIj7VzMv1yluXmZty1iT+P1EsYvGN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297232; c=relaxed/simple;
	bh=aSlhtTFE8I7S4QNC+xz1r5JvxdzjZd+HX+RIMmOVMQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dLQDSHyj8ZHjz1l8tqIS1zqorDK02wKnjruP7q1nhyTQcwbS21cN+7922Rcae0vg9ZCsxJSuWE71kS6d7b1YV4nm61VEkvBCd/UV0qJlZOquxIH3VHj+yfVlccPLz2DZcIMoaQIbJMQLdP2Egrm1PPYywgqi3WKtZvu3al5Jm6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KwYr5VVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KwYr5VVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8FA1F000E9;
	Wed, 20 May 2026 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297230;
	bh=pTrliAw0GzlEC2KfD1P5UR8DCA1LLYlGobcgWykHtTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwYr5VVoAO8th1vDSgcV0hvqn1RKlWjuS1Y10qfy2KnKVvnSiAG2W5DxXhCYH1ujw
	 yx9joYm5zTWKUDKA1Pr7pHquWlpQA/ezk6NJ+O3MI2kNF5rl8GDIIf0bBSz8BUoktO
	 SL2mQf8XFjeDiHPIqy6a3h8oisJM0Ib20c7WwoJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Michael Roth <michael.roth@amd.com>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 7.0 1101/1146] virt: sev-guest: Do not use host-controlled page order in cleanup path
Date: Wed, 20 May 2026 18:22:31 +0200
Message-ID: <20260520162213.161445810@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

commit 23e6a1ca04ae44806439a5a446e62e4d42e80bb4 upstream.

When issuing an extended guest request (SVM_VMGEXIT_EXT_GUEST_REQUEST),
get_ext_report() allocates a buffer to retrieve a certificate blob from the
host, keeping track of its size in report_req->certs_len.

However, the host may return SNP_GUEST_VMM_ERR_INVALID_LEN, indicating
an invalid buffer size, as well as the expected length of such buffer.
get_ext_report() subsequently updates report_req->certs_len with the
host-controlled value, and cleans up the buffer by computing a page order
from such value. This is incorrect, as the host-provided length may not
match the page order of the original allocation, potentially resulting
in corruption in the page allocator.

Fix this by using alloc_pages_exact() instead, and reusing @npages to
compute the size passed to free_pages_exact(). For consistency, also
use @npages to compute the size when allocating the pages, even though
this last change has no functional effect.

Fixes: 3e385c0d6ce8 ("virt: sev-guest: Move SNP Guest Request data pages handling under snp_cmd_mutex")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Tested-by: Michael Roth <michael.roth@amd.com>
Cc: stable@kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -176,7 +176,6 @@ static int get_ext_report(struct snp_gue
 	struct snp_guest_req req = {};
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
-	struct page *page;
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
@@ -211,16 +210,15 @@ static int get_ext_report(struct snp_gue
 	 * zeros to indicate that certificate data was not provided.
 	 */
 	npages = report_req->certs_len >> PAGE_SHIFT;
-	page = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
-			   get_order(report_req->certs_len));
-	if (!page)
+	req.certs_data = alloc_pages_exact(npages << PAGE_SHIFT,
+					   GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (!req.certs_data)
 		return -ENOMEM;
 
-	req.certs_data = page_address(page);
 	ret = set_memory_decrypted((unsigned long)req.certs_data, npages);
 	if (ret) {
 		pr_err("failed to mark page shared, ret=%d\n", ret);
-		__free_pages(page, get_order(report_req->certs_len));
+		free_pages_exact(req.certs_data, npages << PAGE_SHIFT);
 		return -EFAULT;
 	}
 
@@ -277,7 +275,7 @@ e_free_data:
 		if (set_memory_encrypted((unsigned long)req.certs_data, npages))
 			WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
 		else
-			__free_pages(page, get_order(report_req->certs_len));
+			free_pages_exact(req.certs_data, npages << PAGE_SHIFT);
 	}
 	return ret;
 }


