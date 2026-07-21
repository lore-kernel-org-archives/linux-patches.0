Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA15446AA82;
	Tue, 21 Jul 2026 15:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648345; cv=none; b=MkYgoIVWap4dB6MowljkIU0CPBAEJF+1GT5YYuBLX8Tg4bpvAQmhSKZUD0+/RukGQV+3XYb8sTcuf2kQUYjOomN5eCM0S6p0JAjVDOVM2jc0kH4/uRqPNEGffs0L5wEtJRkStn1wJPR04MOoWmHnj63bpSZPt7eF0MARt6IlEAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648345; c=relaxed/simple;
	bh=1M2lbsf/Jaspse5XWAphvbRNcTiChjPyQcnPxFSNwtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sdURFdQ2UF98ig1aE5+bE4IKqZUPjAxznav/ztG+Z8s9v6Q4C+7y87Z1M6kgLRQwgHvxN3zNAg0smCc8ih+ZHli6uUng7+zxwZGWYxJGw1dG+OhtygvK0ALo1PAutCeQxaGt3vLQ5z3ZdAXLuWmx6QNvaDVaBpMbbxdVUxSaHi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qtH0Jsmu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qtH0Jsmu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C76341F000E9;
	Tue, 21 Jul 2026 15:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648344;
	bh=6UdncqtCZYoRC4sv5lS1BZbOKaZHJGq5bEFtrsvymQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qtH0Jsmu/D+QioHb9Oi5ivroQd01a3VlCHWFRUaoLY/2hzj4TaTXyCK0DQE0sJ+8u
	 FZVamYJ+b6FoWr0rSUihptrtRy749uBywEZ6iAZKe9vXV8B2lU9XWepqZjWxSzF6Fl
	 RSQPgYnrQFZ9uHyEAEPQVtVgb5MSNYqw904suv9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tycho Andersen (AMD)" <tycho@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0163/2077] crypto: ccp - Check for page allocation failure correctly in TIO
Date: Tue, 21 Jul 2026 16:57:16 +0200
Message-ID: <20260721152556.530616442@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tycho Andersen (AMD) <tycho@kernel.org>

[ Upstream commit a8d5370eef00eca132a292b1901c9914c817e385 ]

Sashiko notes:

> if __snp_alloc_firmware_pages() returns NULL under memory pressure, is it
> safe to pass it directly to page_address()?
>
> On architectures without HASHED_PAGE_VIRTUAL, page_address(NULL) might
> compute a deterministic but invalid, non-zero virtual address. The
> subsequent if (tio_status) check would then evaluate to true, and
> sev_tsm_init_locked() would dereference the invalid pointer.

Indeed, page_address(NULL) will return non-NULL garbage here. Fix this by
checking the page allocation itself for NULL, not the resulting virtual
address.

Fixes: 4be423572da1 ("crypto/ccp: Implement SEV-TIO PCIe IDE (phase1)")
Reported-by: Sashiko
Assisted-by: Gemini:gemini-3.1-pro-preview
Link: https://sashiko.dev/#/patchset/20260324161301.1353976-1-tycho%40kernel.org
Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index b0290f8491f59a..3991d4b355e606 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -1488,6 +1488,8 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 				       &snp_panic_notifier);
 
 	if (data.tio_en) {
+		struct page *page;
+
 		/*
 		 * This executes with the sev_cmd_mutex held so down the stack
 		 * snp_reclaim_pages(locked=false) might be needed (which is extremely
@@ -1495,12 +1497,14 @@ static int __sev_snp_init_locked(int *error, unsigned int max_snp_asid)
 		 * Instead of exporting __snp_alloc_firmware_pages(), allocate a page
 		 * for this one call here.
 		 */
-		void *tio_status = page_address(__snp_alloc_firmware_pages(
-			GFP_KERNEL_ACCOUNT | __GFP_ZERO, 0, true));
+		page = __snp_alloc_firmware_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO,
+						  0, true);
+		if (page) {
+			void *tio_status = page_address(page);
 
-		if (tio_status) {
 			sev_tsm_init_locked(sev, tio_status);
-			__snp_free_firmware_pages(virt_to_page(tio_status), 0, true);
+
+			__snp_free_firmware_pages(page, 0, true);
 		}
 	}
 
-- 
2.53.0



