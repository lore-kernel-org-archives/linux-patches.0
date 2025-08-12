Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1602E285E;
	Tue, 12 Aug 2025 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022541; cv=none; b=sWxgnfsv2MxY41pumVI+cahNZ1MwpI3HkD3xSAghMNC66zcBOKw+U9ia8h3dsmuR5FMvS5UZadMqZ96cGvUH6tfBg7We2lvRPDnoxrd9olX42eat+gVybHELAioNebhk3Jay4gOlTLlQWj4/6YV05eWXMo5MK9yYLJMBxozfN2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022541; c=relaxed/simple;
	bh=nkLQBrVWsLE6kLQq5idVa2D1EM5vi/ShpWaxeKexYjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=spinLUW7CxXayMbdPhQaf3VYZ67+O0ackUfJWcOfUi6atRBzVjV0szxNniSAcoLf/sKyCBeFGagQks/A/U96Kdfh1igbHXcL7LCAJo2ymyfvnBbQ9tEcrL/zbUl6rNNlwP28lZp6xUNJM9qFgoyie9BqdR9RGG9nVzFQQz8TseQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uWMwu4Tx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uWMwu4Tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A810C4CEF0;
	Tue, 12 Aug 2025 18:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022541;
	bh=nkLQBrVWsLE6kLQq5idVa2D1EM5vi/ShpWaxeKexYjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uWMwu4TxUBwG00+s/4IZQeVSy5KtZXed6nNi4nJrZ/FNAhyyM0tlKD7F4Kn0qHGSV
	 KVA406hLC/JmJKI1fS6aKXx0HiQZ1eRK0S/9CtXtiOKbjNHWFfGHO1/5vqVnJt9Jzx
	 qPYbt/cen1MAqedomd6IKHNDK19PrQ+LR0rj5C4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Kardashevskiy <aik@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Pratik R. Sampat" <prsampat@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 186/369] crypto: ccp - Fix locking on alloc failure handling
Date: Tue, 12 Aug 2025 19:28:03 +0200
Message-ID: <20250812173021.768508221@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index af018afd9cd7..4d072c084d7b 100644
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



