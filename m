Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C511344DAC;
	Thu, 28 May 2026 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998248; cv=none; b=r+ZobdxSwnDjBV4OsDfotUNljwzkW9oM0bJKdRWrQ8B1TvpGA2i9LqxNJcsIIprqZSx4XEfNB3SWIF0q6qDQKtuPeZdQif/lK+LNiPgNubR66OUOS5HoWqoSF020xM+uqOnCjbDLLmzzMWkDMhw6+hIo4qOwxfSxlthBMB4etm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998248; c=relaxed/simple;
	bh=Lcj2NSEhUnkPzpEJekIKt9IAzEdhwRDVPxQjHhMvYmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JjH/0sBN85dz7JMXvftvRLGZ17TFuIsqVo1uK8bwR8oONYR/NMHzAWDIXDrP7jaf1GX0w1xj07cVI0xqlRzxfcoY9t67T0PPrDPXx8kdD/GnBM6vEhjnOel+P9RO1qrOvxLt5J/5Fy2f3mWeK8mqxcCLrthbfYBpq+fmjEPujrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZgI+hCQx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZgI+hCQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7391F000E9;
	Thu, 28 May 2026 19:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998247;
	bh=nrjoH7seBVwOPjXLFf3J1IJhEIDC5w1f9dTIC3u8MPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgI+hCQxlQaXFwiJs9OopaJdD3EoNXJSuFutHtkh5Fvh0F+kXes7wFWtzREX+warI
	 PDOHDzPpXU3weaQYvym3/Aes2EHh2sTEHv5ugHAV1hXIFABRHTF1xO2ZJruMtTvopw
	 wFyspKFnA1ojU8nismWfeCJC0XH931NaBhL3d5tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	stable@kernel.org
Subject: [PATCH 7.0 105/461] virt: sev-guest: Explicitly leak pages in unknown state
Date: Thu, 28 May 2026 21:43:54 +0200
Message-ID: <20260528194650.002311892@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

commit fd948c3f96b18ff9ba7d3e8eae13d196593e1aaf upstream.

When set_memory_{encrypted,decrypted}() fail, the user cannot know at which
point the function failed, meaning that the pages are left in an unknown state
from the point of view of the caller.

Since the pages may be left in an unencrypted state, they are not suitable for
general use, and cannot be returned safely to the buddy allocator. Avoid the
issue by never freeing the pages, and then do the proper accounting by calling
snp_leak_pages().

Fixes: 3e385c0d6ce8 ("virt: sev-guest: Move SNP Guest Request data pages handling under snp_cmd_mutex")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virt/coco/sev-guest/sev-guest.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/virt/coco/sev-guest/sev-guest.c
+++ b/drivers/virt/coco/sev-guest/sev-guest.c
@@ -176,6 +176,7 @@ static int get_ext_report(struct snp_gue
 	struct snp_guest_req req = {};
 	int ret, npages = 0, resp_len;
 	sockptr_t certs_address;
+	u64 pfn;
 
 	if (sockptr_is_null(io->req_data) || sockptr_is_null(io->resp_data))
 		return -EINVAL;
@@ -215,10 +216,11 @@ static int get_ext_report(struct snp_gue
 	if (!req.certs_data)
 		return -ENOMEM;
 
+	pfn = PHYS_PFN(virt_to_phys(req.certs_data));
 	ret = set_memory_decrypted((unsigned long)req.certs_data, npages);
 	if (ret) {
 		pr_err("failed to mark page shared, ret=%d\n", ret);
-		free_pages_exact(req.certs_data, npages << PAGE_SHIFT);
+		snp_leak_pages(pfn, npages);
 		return -EFAULT;
 	}
 
@@ -272,10 +274,12 @@ e_free:
 	kfree(report_resp);
 e_free_data:
 	if (npages) {
-		if (set_memory_encrypted((unsigned long)req.certs_data, npages))
+		if (set_memory_encrypted((unsigned long)req.certs_data, npages)) {
 			WARN_ONCE(ret, "failed to restore encryption mask (leak it)\n");
-		else
+			snp_leak_pages(pfn, npages);
+		} else {
 			free_pages_exact(req.certs_data, npages << PAGE_SHIFT);
+		}
 	}
 	return ret;
 }


