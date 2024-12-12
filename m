Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6E521578A;
	Thu, 12 Dec 2024 15:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016462; cv=none; b=MCekFJd8SVBuEpMRbjt1xdv4YMTr+aTn3ExDKTuUOjzVEcZaapvGg3aH3/zhmg6IRGkDzG5KZkFPLR+EWVNEHml0VrbRJt1CAudbf2rcfL06yUx4AFsBvd9gc0WVP9Iwx+gep3C2v4WmI0sy+m+Mrs0DC8ClJF55kn6w3UWJ/IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016462; c=relaxed/simple;
	bh=zi8WT2vabOuRNRm1boKTAJgyRzDaBU3gDzjk8reKEZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjzPo7XwhuhIY4qSg2l4fdStSwYkQqeQC7pz8+bznBjg6NrT2KDBTXC+uqQjBj46FstdMudQyU/NM2NEuvNyorIEDcPA6M+dfSXoCLKhXGG5QvdDPYwamcpeGkNQcE8Ovf7qMkn5IDb4LmsS6evo7d8VLJIGXm9yTdBatx4IPw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMfx8LuW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMfx8LuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC682C4CED4;
	Thu, 12 Dec 2024 15:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016462;
	bh=zi8WT2vabOuRNRm1boKTAJgyRzDaBU3gDzjk8reKEZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMfx8LuWRi58n0S1uxqVJcIGPbuoAGm/++U5RY5WgrX6gxsodPsWgVrLRUBVs6GNm
	 FDoSxF1721CJIOM4N0DVWYYakQzH4n50zf20beZsFSz9y1nzpYFyZtwifh3JoJq657
	 bhIuotFQzookHi8jSiiQlTy72lafuubyax7S5XUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 206/466] mm: open-code page_folio() in dump_page()
Date: Thu, 12 Dec 2024 15:56:15 +0100
Message-ID: <20241212144314.926072325@linuxfoundation.org>
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

commit 6a7de1bf218d75f27f68d6a3f5ae1eb7332b941e upstream.

page_folio() calls page_fixed_fake_head() which will misidentify this page
as being a fake head and load off the end of 'precise'.  We may have a
pointer to a fake head, but that's OK because it contains the right
information for dump_page().

gcc-15 is smart enough to catch this with -Warray-bounds:

In function 'page_fixed_fake_head',
    inlined from '_compound_head' at ../include/linux/page-flags.h:251:24,
    inlined from '__dump_page' at ../mm/debug.c:123:11:
../include/asm-generic/rwonce.h:44:26: warning: array subscript 9 is outside
+array bounds of 'struct page[1]' [-Warray-bounds=]

Link: https://lkml.kernel.org/r/20241125201721.2963278-2-willy@infradead.org
Fixes: fae7d834c43c ("mm: add __dump_folio()")
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reported-by: Kees Cook <kees@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/debug.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/mm/debug.c
+++ b/mm/debug.c
@@ -124,19 +124,22 @@ static void __dump_page(const struct pag
 {
 	struct folio *foliop, folio;
 	struct page precise;
+	unsigned long head;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long idx, nr_pages = 1;
 	int loops = 5;
 
 again:
 	memcpy(&precise, page, sizeof(*page));
-	foliop = page_folio(&precise);
-	if (foliop == (struct folio *)&precise) {
+	head = precise.compound_head;
+	if ((head & 1) == 0) {
+		foliop = (struct folio *)&precise;
 		idx = 0;
 		if (!folio_test_large(foliop))
 			goto dump;
 		foliop = (struct folio *)page;
 	} else {
+		foliop = (struct folio *)(head - 1);
 		idx = folio_page_idx(foliop, page);
 	}
 


