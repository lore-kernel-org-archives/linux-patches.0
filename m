Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D016E18873F;
	Fri, 15 Nov 2024 06:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653508; cv=none; b=kir4lQPR5n3nTKmjIobIhSDDa06u8JemaB6W4hlS8qznSCszq2nRqlvZUja5OkblTAGw5szZl+zmQQ0lIG1YDsWLdgrxRa+WTKw/M3ayAYzleIJjdXGmy+CrxDrAg1Ik2Xu2PKBH61jkGVAbaH3Pm+PaOqFTv++UmbIBoFL8kGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653508; c=relaxed/simple;
	bh=NLbKiu4vbOcrRQIcZeZvGuZy60mGIpmeo3SzNBeL3VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oGxs43vvP98fb4Aj3HZFyFLKCTnMtR+lJGcAqViOy0T9F0+JB9+Bm5t2C58HSb4iEiGgdNc7Dot/hmvIDkidbRrf36LPoYgwIk2EXDBc1pRCC5SbeJtARlM9zzFW64VROqqFdqipV5qkgQOnoprDwI3Cge0PgEdU7OzLE4FLah0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u4ijoW/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u4ijoW/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0811C4CED2;
	Fri, 15 Nov 2024 06:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653508;
	bh=NLbKiu4vbOcrRQIcZeZvGuZy60mGIpmeo3SzNBeL3VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4ijoW/t8xEn6FYu3zN0UK04apTnO+U/CBJ0oq/fXVN+0i1E7nw2CYV0KYAIsVJTp
	 WiWG0zAM5Y+leCnqV/Xt4fzTA5puxZO1/CKwLsFbT1dL7lEa2upoEoJmoI2lGA2Anl
	 1G3SCW53xXjdrr304CoSa4uJaiqWw1gi+pLw/hSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Roberts <ryan.roberts@arm.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH 6.6 43/48] mm/readahead: do not allow order-1 folio
Date: Fri, 15 Nov 2024 07:38:32 +0100
Message-ID: <20241115063724.516433548@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.962047137@linuxfoundation.org>
References: <20241115063722.962047137@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryan Roberts <ryan.roberts@arm.com>

commit ec056cef76a525706601b32048f174f9bea72c7c upstream.

The THP machinery does not support order-1 folios because it requires meta
data spanning the first 3 `struct page`s.  So order-2 is the smallest
large folio that we can safely create.

There was a theoretical bug whereby if ra->size was 2 or 3 pages (due to
the device-specific bdi->ra_pages being set that way), we could end up
with order = 1.  Fix this by unconditionally checking if the preferred
order is 1 and if so, set it to 0.  Previously this was done in a few
specific places, but with this refactoring it is done just once,
unconditionally, at the end of the calculation.

This is a theoretical bug found during review of the code; I have no
evidence to suggest this manifests in the real world (I expect all
device-specific ra_pages values are much bigger than 3).

Link: https://lkml.kernel.org/r/20231201161045.3962614-1-ryan.roberts@arm.com
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/readahead.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -514,16 +514,14 @@ void page_cache_ra_order(struct readahea
 		unsigned int order = new_order;
 
 		/* Align with smaller pages if needed */
-		if (index & ((1UL << order) - 1)) {
+		if (index & ((1UL << order) - 1))
 			order = __ffs(index);
-			if (order == 1)
-				order = 0;
-		}
 		/* Don't allocate pages past EOF */
-		while (index + (1UL << order) - 1 > limit) {
-			if (--order == 1)
-				order = 0;
-		}
+		while (index + (1UL << order) - 1 > limit)
+			order--;
+		/* THP machinery does not support order-1 */
+		if (order == 1)
+			order = 0;
 		err = ra_alloc_folio(ractl, index, mark, order, gfp);
 		if (err)
 			break;


