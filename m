Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2E383594E;
	Tue, 12 Aug 2025 19:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026199; cv=none; b=FsUiB7NTQo4B6G5Ru8xiOEi0H0WOro0/CYveb9HtMbOJm7mrtXvV1uezlY297+2IxOAFbbCyVD4A6hmNP/D/Me+LFhkDxFzAHAH9PvfuUwdlL/AWEfOUS8XvhEV4OSyku2SwC2JTXc3S1C2QHSL7A9Nth8edcQeZhSDs39yIBbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026199; c=relaxed/simple;
	bh=18TZplVBfaWbPENfVQiG8RkmdgU1zuxHhvMMGwpq1x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jK2gUlkShl4hGr3swNEdiq0SPIvz4UeU97R9Bmr/MAjcbuUk96zbA8dOu0iV4ThVS8aTwun/A3kj8JR/fiKpilKxgMh9lWQsvAm+FlXYQY5YJDedqt37H/vlYPiS5oJlgZUCyOzBUBXXu9ryVPqXunuyEKIuu8kqyy2cIR7qD2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I8r+ODNa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I8r+ODNa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40A38C4CEF0;
	Tue, 12 Aug 2025 19:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026199;
	bh=18TZplVBfaWbPENfVQiG8RkmdgU1zuxHhvMMGwpq1x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I8r+ODNa4UFsbk2DmYMjICSRRjPYM/MjjwjvnFoYCmZK6g8hd0I5DSgmiH7O6zkpR
	 ZzKKQJohFHu4HELnctHRaSDQ48/NV7G5MO+sqn06gUUHtYWX55wOxChTZRq5FA1aWt
	 AM9CbfmhWqKGBwvJ+YrDNAgYLBGplrAP8wNTd+h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 267/480] crypto: ccp - Fix locking on alloc failure handling
Date: Tue, 12 Aug 2025 19:47:55 +0200
Message-ID: <20250812174408.455003443@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2e87ca0e292a..4d790837af22 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -424,7 +424,7 @@ static int rmp_mark_pages_firmware(unsigned long paddr, unsigned int npages, boo
 	return rc;
 }
 
-static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
+static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order, bool locked)
 {
 	unsigned long npages = 1ul << order, paddr;
 	struct sev_device *sev;
@@ -443,7 +443,7 @@ static struct page *__snp_alloc_firmware_pages(gfp_t gfp_mask, int order)
 		return page;
 
 	paddr = __pa((unsigned long)page_address(page));
-	if (rmp_mark_pages_firmware(paddr, npages, false))
+	if (rmp_mark_pages_firmware(paddr, npages, locked))
 		return NULL;
 
 	return page;
@@ -453,7 +453,7 @@ void *snp_alloc_firmware_page(gfp_t gfp_mask)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(gfp_mask, 0);
+	page = __snp_alloc_firmware_pages(gfp_mask, 0, false);
 
 	return page ? page_address(page) : NULL;
 }
@@ -488,7 +488,7 @@ static void *sev_fw_alloc(unsigned long len)
 {
 	struct page *page;
 
-	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len));
+	page = __snp_alloc_firmware_pages(GFP_KERNEL, get_order(len), true);
 	if (!page)
 		return NULL;
 
-- 
2.39.5



