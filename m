Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5680291C1F;
	Tue, 12 Aug 2025 18:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024417; cv=none; b=ngAJLx1YBBQLkiiy2s2i72fQJof+Vi52eTlsqW8bpTArnF/i8Rr8CWKcTtQ7KLr8j86JvyAGQ6nFZCZo0/bJBr8fAb1vgAeSsU14YfH5/ZUh+APonmxJGcym7lmnkR9KjBx/JtkvPSDVYIQbKu18Xlgay/FNvnSfHJigaBy1BG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024417; c=relaxed/simple;
	bh=TR/wjBKtaYDCZygkWLKauHeaK2OprRzjJ3FRM4ho1jg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqi4hQ/8wy1XXSvYVXuygvwR1QIANXTUOddsOpJUOx1qmjsKFxqIwpv0Ccva1mm4o9d/xKTWegNZs29Zze//OHcxSZNwfDP6rTg9wXotW/k63jVArrD/tdgJ2qwJwRB0yccgDoyrQrqL1K7RpjFxWSd7blEbcfYsJB59liPMXCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OufEnu9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OufEnu9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10815C4CEF0;
	Tue, 12 Aug 2025 18:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024417;
	bh=TR/wjBKtaYDCZygkWLKauHeaK2OprRzjJ3FRM4ho1jg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OufEnu9E34Rhn4ELk+bZY+Q+1iypQPOJIZwGX7vf2YjoSy6f+J6/TgBJevyZUJ9P0
	 Vm0URMUKu8g/nvaAx0JwT1N7sOsIcR/6HZlUVUP1g+FD7zlOZ2D0hTjRPPMlqAx6R6
	 UG22xMoGr9pDCGQWNAS3mv487QVVgvgVvQIHpsms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 367/627] crypto: ccp - Fix locking on alloc failure handling
Date: Tue, 12 Aug 2025 19:31:02 +0200
Message-ID: <20250812173433.263723268@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Alexey Kardashevskiy <aik@amd.com>

[ Upstream commit b4abeccb8d39db7d9b51cb0098d6458760b30a75 ]

The __snp_alloc_firmware_pages() helper allocates pages in the firmware
state (alloc + rmpupdate). In case of failed rmpupdate, it tries
reclaiming pages with already changed state. This requires calling
the PSP firmware and since there is sev_cmd_mutex to guard such calls,
the helper takes a "locked" parameter so specify if the lock needs to
be held.

Most calls happen from snp_alloc_firmware_page() which executes without
the lock. However

commit 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")

switched sev_fw_alloc() from alloc_pages() (which does not call the PSP) to
__snp_alloc_firmware_pages() (which does) but did not account for the fact
that sev_fw_alloc() is called from __sev_platform_init_locked()
(via __sev_platform_init_handle_tmr()) and executes with the lock held.

Add a "locked" parameter to __snp_alloc_firmware_pages().
Make sev_fw_alloc() use the new parameter to prevent potential deadlock in
rmp_mark_pages_firmware() if rmpupdate() failed.

Fixes: 24512afa4336 ("crypto: ccp: Handle the legacy TMR allocation when SNP is enabled")
Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Pratik R. Sampat <prsampat@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 8fb94c5f006a..539c303beb3a 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -434,7 +434,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
 	return rc;
 }
 
-static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
 {
 	unsigned long npages = 1ul << order, paddr;
 	struct sev_device *sev;
@@ -453,7 +453,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
 		return page;
 
 	paddr = __pa((unsigned long)page_address(page));
-	if (rmp_mark_pages_firmware(paddr, npages, false))
+	if (rmp_mark_pages_firmware(paddr, npages, locked))
 		return NULL;
 
 	return page;
@@ -463,7 +463,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(gfp_mask, 0);
+	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
 
 	return page ? page_address(page) : NULL;
 }
@@ -498,7 +498,7 @@ static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
 	if (!page)
 		return NULL;
 
-- 
2.39.5



