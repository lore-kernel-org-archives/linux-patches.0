Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5F23ACA5C;
	Mon, 23 Mar 2026 14:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274783; cv=none; b=PPOWQIiT/bJpWP1Bhquw2nH2cyio9+CSaNh7DCw69E6gcM9qcrFxzCYq2zmMs8rnV2uEyM1B8c/UJ5TpBMtqnELvINuYHc1gNKAFH2kEZfxSwhJcKc/UQl/5uiuhxeEQixUdCLO6g7lavBmn/wX6hvqi2GPksBRA9ugHHqNqtVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274783; c=relaxed/simple;
	bh=8HaIQ+C+Yzl0fibUvLZWatnIPOdh9cWE0xRURsf3e1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9hqs/51qJIuBlQQ2oDOKnfoFsoaCZGpa9e2lP7o5llWe7EF9vIaIJNidfwPX591W9JBJ/1m7Ep7PQDs0G4uCpPDOEuu/p3dog9Kuff9D9NikPShWwweCA1kMMAeXQANj56E0F8OXnJI+aROAGS2tkOaOfbvRDxFLJN/MVcvH74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rnpiAYuQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rnpiAYuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 790C7C4CEF7;
	Mon, 23 Mar 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274783;
	bh=8HaIQ+C+Yzl0fibUvLZWatnIPOdh9cWE0xRURsf3e1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rnpiAYuQilfBuGBjpmkMeii2W0JmE78WTk8s5pc2+7UgzYd6feLwKaaMcW5C32W3T
	 I89JTACASd46t9qyUg6y1nwYAyL8bjZshxVxpFDHT+T95eJ5M5WeE9XxdVdxbXK/Ph
	 I0b9LV1AIRY/g2iP6aLeGKPbVsYLlBDd98N8SI9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Felsch <m.felsch@pengutronix.de>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Matthew Wilcox <willy@infradead.org>,
	Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Jens Wiklander <jens.wiklander@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/212] tee: shm: Remove refcounting of kernel pages
Date: Mon, 23 Mar 2026 14:45:28 +0100
Message-ID: <20260323134507.163387288@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Matthew Wilcox <willy@infradead.org>

[ Upstream commit 08d9a4580f71120be3c5b221af32dca00a48ceb0 ]

Earlier TEE subsystem assumed to refcount all the memory pages to be
shared with TEE implementation to be refcounted. However, the slab
allocations within the kernel don't allow refcounting kernel pages.

It is rather better to trust the kernel clients to not free pages while
being shared with TEE implementation. Hence, remove refcounting of kernel
pages from register_shm_helper() API.

Fixes: b9c0e49abfca ("mm: decline to manipulate the refcount on a slab page")
Reported-by: Marco Felsch <m.felsch@pengutronix.de>
Reported-by: Sven Püschel <s.pueschel@pengutronix.de>
Signed-off-by: Matthew Wilcox <willy@infradead.org>
Co-developed-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Signed-off-by: Sumit Garg <sumit.garg@oss.qualcomm.com>
Tested-by: Sven Püschel <s.pueschel@pengutronix.de>
Signed-off-by: Jens Wiklander <jens.wiklander@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tee/tee_shm.c | 27 ---------------------------
 1 file changed, 27 deletions(-)

diff --git a/drivers/tee/tee_shm.c b/drivers/tee/tee_shm.c
index 4a47de4bb2e5c..898707ca21a8e 100644
--- a/drivers/tee/tee_shm.c
+++ b/drivers/tee/tee_shm.c
@@ -23,29 +23,11 @@ struct tee_shm_dma_mem {
 	struct page *page;
 };
 
-static void shm_put_kernel_pages(struct page **pages, size_t page_count)
-{
-	size_t n;
-
-	for (n = 0; n < page_count; n++)
-		put_page(pages[n]);
-}
-
-static void shm_get_kernel_pages(struct page **pages, size_t page_count)
-{
-	size_t n;
-
-	for (n = 0; n < page_count; n++)
-		get_page(pages[n]);
-}
-
 static void release_registered_pages(struct tee_shm *shm)
 {
 	if (shm->pages) {
 		if (shm->flags & TEE_SHM_USER_MAPPED)
 			unpin_user_pages(shm->pages, shm->num_pages);
-		else
-			shm_put_kernel_pages(shm->pages, shm->num_pages);
 
 		kfree(shm->pages);
 	}
@@ -477,13 +459,6 @@ register_shm_helper(struct tee_context *ctx, struct iov_iter *iter, u32 flags,
 		goto err_put_shm_pages;
 	}
 
-	/*
-	 * iov_iter_extract_kvec_pages does not get reference on the pages,
-	 * get a reference on them.
-	 */
-	if (iov_iter_is_kvec(iter))
-		shm_get_kernel_pages(shm->pages, num_pages);
-
 	shm->offset = off;
 	shm->size = len;
 	shm->num_pages = num_pages;
@@ -499,8 +474,6 @@ register_shm_helper(struct tee_context *ctx, struct iov_iter *iter, u32 flags,
 err_put_shm_pages:
 	if (!iov_iter_is_kvec(iter))
 		unpin_user_pages(shm->pages, shm->num_pages);
-	else
-		shm_put_kernel_pages(shm->pages, shm->num_pages);
 err_free_shm_pages:
 	kfree(shm->pages);
 err_free_shm:
-- 
2.51.0



