Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5244436D4E1;
	Wed, 20 May 2026 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299890; cv=none; b=CB1dAjAmrmhPPWPdgtN/YyPIKPn16NJEpxuHeOeTxWtIXqh7xfTYc6+hlDb5rPub1nX21Phv+p2/7vHpZHpk7NuvV1lHrX7w3pN/qyZmYy0r4RRgoarWjnaN6h0gV9ZRLcu6iP+bzTY3LbOwzOYxeXN3+27G/6W2WAghHtj1Y+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299890; c=relaxed/simple;
	bh=agUVXx+OUDTQSGTqZ5D4/OLR1URsxN4z6aHK7gLl3oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rR+Bz6gDKTYatcxl0/k3CsNqJ3DlE/VjluMsSNq47uoAjyBRSQRPSGPDMS50yRjqVHYvc4emjiMKqf1Ib+BW6vmCEmxEVfLmA4nmZ4fnbStEblSG6Mrb147eqyx/6LkInfVCE0ck0Aev/WZDquBGI7B0Er772nl+jkYRvPGaaVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DrjHltmW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DrjHltmW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B76CD1F000E9;
	Wed, 20 May 2026 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299889;
	bh=We8F32634B0WzSyJ5CJwCtqHSEPiY1GraLdImPjFTac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DrjHltmW2JfDxjnOKy9IfSAsR0pmDsVKoV5hFY5Azh+CoyJsChTmYX7PfvyYlkwEU
	 rydc+MH6uAeQPgXdFejfPSDYnqYsOcbuKnwTt6rBeifD/Fuzkqtsndbhv/iiOxc/zx
	 jIpt54Zn0TdIOPEKMdsfkib6vRN/TnCrUNVjUodk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Michael Roth <michael.roth@amd.com>,
	stable@kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.18 923/957] virt: sev-guest: Do not use host-controlled page order in cleanup path
Date: Wed, 20 May 2026 18:23:26 +0200
Message-ID: <20260520162154.597667481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


