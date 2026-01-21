Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF05356A27;
	Wed, 21 Jan 2026 18:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019900; cv=none; b=Eh+w75Vnvqt2RnmmnlFw4VF03xAA1zgaKHFqZc58FuUNlBvWTAJcqM1EgITZDLGmBw1cjR6bU7lPZv86EevVb4YvgfsTn7zyh+zS/Ky1V5bCbDrBYNVo4xpvdbM1DOQmOHLERqcMmAT1JF7uMuWxVoKzxJxZT9L1HLpSpGmVGv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019900; c=relaxed/simple;
	bh=fjl62f9KzVuXkH7GbWSzctrYJFLn+EAI9Z/AhjE+tPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EnBjp0N1/lOqitdW092bgshN5oXAIDDUVxtQZzKWZA4ihPoMK2zoU/tdZbD3LyDGoW7+FWWTbtKBZnEytRnlGQKrscU3zZsWyMWkZijlQZ6ZFBSUz6bpMTXko5nuJMljpD4GFVOKGeKZvf9batBwiWbBUn/E29UhaPgQqgo2Y6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nyw0S0Dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nyw0S0Dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E22DC4CEF1;
	Wed, 21 Jan 2026 18:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019899;
	bh=fjl62f9KzVuXkH7GbWSzctrYJFLn+EAI9Z/AhjE+tPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nyw0S0Dv/PZzS/jIK9AR3A1PJimvBKjk+U/Fq8+NMvZXgWK6+bCs4Esy8iIf2F7N6
	 iLNZ+BIAwmIYOCTRn1WvN9Bjh7H8c8YuqgnHo2hf9bwcPEeNCKSH5w5UJAUrA7XgaH
	 7gZax1At+Ul7ywFgP/US+dhtsWDF5rI8g8OkFwjE=
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
Subject: [PATCH 6.12 130/139] mm: kmsan: fix poisoning of high-order non-compound pages
Date: Wed, 21 Jan 2026 19:16:18 +0100
Message-ID: <20260121181416.130430870@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -208,7 +208,7 @@ void kmsan_free_page(struct page *page,
 		return;
 	kmsan_enter_runtime();
 	kmsan_internal_poison_memory(page_address(page),
-				     page_size(page),
+				     PAGE_SIZE << order,
 				     GFP_KERNEL,
 				     KMSAN_POISON_CHECK | KMSAN_POISON_FREE);
 	kmsan_leave_runtime();


