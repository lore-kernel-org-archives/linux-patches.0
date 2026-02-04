Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3E718859B;
	Wed,  4 Feb 2026 15:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218156; cv=none; b=IPiZBSBb/6m2y0acNMYt4TZ6oxfLdstg+H+bpYfnxYTlkIJh4Ze88pR7YDQ0+4su3mS+MXtS3okTBf+eI7psvTLwYMnEAsU5BqGZeUpqaeNWztNhOWUj9RmU0wEqzatohVyu3wpnuZy3tnSTGtt5KOPyWM2+rbRTtMXUCD3Hj34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218156; c=relaxed/simple;
	bh=IrsmqFrraKSC5+OAk0m4y9OWJp6nWwP/qcax3bD/5fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=huKBHxyX3PXdrcli4KDBmOvmmdJXVlvLPDy9qQwqVTYwtCXpxAY2aY7KhLhpJ2NUPdRxasyBZVT6qQKCNU2tTnE1inUpj6GeyKFzu2LGfVyGqdSXuG2jjmnqwscXhaSJeH7OluBNSGHVg/YZsPXD1iVVdqoSD6TcTb7uNuiFH70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q8kOdxB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q8kOdxB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A351EC4CEF7;
	Wed,  4 Feb 2026 15:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218156;
	bh=IrsmqFrraKSC5+OAk0m4y9OWJp6nWwP/qcax3bD/5fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8kOdxB2phNdipHpgnvYqW/0t7CczURfmcgaYDOo+kR2LAj0bayLXgJjlJXTlqx0d
	 B99dV/nTq4LM2bjxet5Q/VJy1dDxhFXJ7UMrhKBsCKEdBj8JBSEPVG/vix1xzfA92J
	 zgHzYDD8Ej/6OQqo2F8Yf56WfCQyrjsou8KZAbg4=
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
Subject: [PATCH 6.1 227/280] mm: kmsan: fix poisoning of high-order non-compound pages
Date: Wed,  4 Feb 2026 15:40:01 +0100
Message-ID: <20260204143917.784992942@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/shadow.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -209,8 +209,7 @@ void kmsan_free_page(struct page *page,
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
 	kmsan_enter_runtime();
-	kmsan_internal_poison_memory(page_address(page),
-				     PAGE_SIZE << compound_order(page),
+	kmsan_internal_poison_memory(page_address(page), PAGE_SIZE << order,
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();


