Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AB82EBBBC;
	Wed, 28 Jan 2026 15:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614770; cv=none; b=PDD2cHnaFHu1EonKOfV3MwWtbrNzjQfA09vLTc6/PKVCnTKtRj7p+2PbmHFbUSDwhRyhDnhMAGOqET5vcgnEds/mm0xtdUNSXzQQoTxeAhBwXVZAyKC4hPxcNZPkXEH8SrRRhOZqpD0bhMlolEAKPqc6ju1yiwc1XIlxu95Yzwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614770; c=relaxed/simple;
	bh=J+yXDa7sZc6r0ZNng0KspDXxLnkFy7OqPkH06HqZ4kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pPiEnhYBREIRdvESf2zQYpwqSXeJ4inijxiK6BhPQ5Fw5K6JQuFbg9LP2dIry+8vwut6pRJqNbgb+tkAHtVWf2/nnkcCAbrDM5xZQCAFuPTp+GwC60C2RUsNi0oCkV7XwPoYERz2Ep72KLgVpeg5TSbyiJuSmygzHbvxSsFVcCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MU+0Sjb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MU+0Sjb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87D1FC4CEF1;
	Wed, 28 Jan 2026 15:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614769;
	bh=J+yXDa7sZc6r0ZNng0KspDXxLnkFy7OqPkH06HqZ4kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MU+0Sjb2fHqJE8UYnLCgrN/1TBqM4pzY9m1bGzS5jPgVWD68T3U+3EjYUVpqsMbFE
	 GcMsjfV4tRLeYxd4thE3A6tuVTmEGysv6dGvWFrGZkb9q++jS1OhmQBZHK/2smYwH3
	 6ZVe8Pi6eb9/vuUSH0W0Hk1fPUmJTROb4qk0Fxd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/254] mm: kmsan: fix poisoning of high-order non-compound pages
Date: Wed, 28 Jan 2026 16:23:32 +0100
Message-ID: <20260128145353.285804773@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit 4795d205d78690a46b60164f44b8bb7b3e800865 ]

kmsan_free_page() is called by the page allocator's free_pages_prepare()
during page freeing.  Its job is to poison all the memory covered by the
page.  It can be called with an order-0 page, a compound high-order page
or a non-compound high-order page.  But page_size() only works for order-0
and compound pages.  For a non-compound high-order page it will
incorrectly return PAGE_SIZE.

The implication is that the tail pages of a high-order non-compound page
do not get poisoned at free, so any invalid access while they are free
could go unnoticed.  It looks like the pages will be poisoned again at
allocation time, so that would bookend the window.

Fix this by using the order parameter to calculate the size.

Link: https://lkml.kernel.org/r/20260104134348.3544298-1-ryan.roberts@arm.com
Fixes: b073d7f8aee4 ("mm: kmsan: maintain KMSAN metadata for page operations")
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Tested-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/shadow.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -210,7 +210,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page),
-				     page_size(page),
+				     PAGE_SIZE << order,
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();


