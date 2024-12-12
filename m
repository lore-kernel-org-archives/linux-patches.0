Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669A421504F;
	Thu, 12 Dec 2024 15:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016458; cv=none; b=d0jCh5M2p5re+ff6DvV+0sn7OkNqZ/NxUxe5F5QJMDsr/lpEL89VHaNb8RzGpHGnenNfX82W3/Q2Qje65336MUpDL5RCweaiYuGolpvngXkh+wJSAzBY0r5l0Ry966q72K43a4FjU/F6FC1dX+0CxCF+APdAFJ5fzZzqFcC0AT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016458; c=relaxed/simple;
	bh=XlFwrZGGrpOebLfzA3FuPrPmPZEnPVlu5vnyQi9NGwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Twy/7shcYsCHgZ1EwNnzSMORehfDyfwIaJbo7nkK6Uyzm8acp8NG0AL4A1f3mDzmSL3sw7Hq5qq3Z8tKDiHTRyUQsyhN2I/B8MHWFsNMoMi2kvIMisWARi9hNxfPhjvJcem9pVk+QEbHEdVIFslpX7WUH+eCdZGBSzFVskAIU/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hS4hoB2D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hS4hoB2D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C603BC4CED0;
	Thu, 12 Dec 2024 15:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016458;
	bh=XlFwrZGGrpOebLfzA3FuPrPmPZEnPVlu5vnyQi9NGwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hS4hoB2DeyLRABR3MaoER2PfNaEzAQmiZoTaZYDB7n+JRygvfGdHcvH+A7k0gJxv3
	 XnDdMLKIJfsMQC47Aiw/hf5Zxq5p1jo64F5ObG+iUAaMEreN8QD53QtR+wStV4pwnd
	 94qGwzLEuu9hkICvGvemTqt/B53lUGwUHQVWDwCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 205/466] mm: open-code PageTail in folio_flags() and const_folio_flags()
Date: Thu, 12 Dec 2024 15:56:14 +0100
Message-ID: <20241212144314.888291794@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 4de22b2a6a7477d84d9a01eb6b62a9117309d722 upstream.

It is unsafe to call PageTail() in dump_page() as page_is_fake_head() will
almost certainly return true when called on a head page that is copied to
the stack.  That will cause the VM_BUG_ON_PGFLAGS() in const_folio_flags()
to trigger when it shouldn't.  Fortunately, we don't need to call
PageTail() here; it's fine to have a pointer to a virtual alias of the
page's flag word rather than the real page's flag word.

Link: https://lkml.kernel.org/r/20241125201721.2963278-1-willy@infradead.org
Fixes: fae7d834c43c ("mm: add __dump_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/page-flags.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -306,7 +306,7 @@ static const unsigned long *const_folio_
 {
 	const struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
 	return &page[n].flags;
 }
@@ -315,7 +315,7 @@ static unsigned long *folio_flags(struct
 {
 	struct page *page = &folio->page;
 
-	VM_BUG_ON_PGFLAGS(PageTail(page), page);
+	VM_BUG_ON_PGFLAGS(page->compound_head & 1, page);
 	VM_BUG_ON_PGFLAGS(n > 0 && !test_bit(PG_head, &page->flags), page);
 	return &page[n].flags;
 }


