Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1F4488233;
	Wed, 23 Sep 2026 14:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174908; cv=none; b=ifb8R8beMg6DHgPk9UtmdKmY9KCFapNLSlRZqfFI/Knb31kiNT/baUjsjAHWSxL1uJ6+hz7DtJufdV/8VBwDttwjIph7J4316xH+6KF1oAHcBelP9aD4Ld3LCXboET62E1ZHDFGUv12JNJ9puLZ/EgDwd5GSQi0ewSjbS8TmwEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174908; c=relaxed/simple;
	bh=AXQkVREnyABKAphF2G/SvRq9a19I+00SgQBJEZGq4ac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YNJrNSRVBaMfS+vrJnYafoABMlbav2nxZv9wWszmS17kDK4B4VOIgGpPfKXXD2dLYdji3yFchwVedJXwyVmAmC1cfaHUzc928O4Vf8MnDIGon30muJBeQ7JGbYhYTQJUKwwOXPeUvFif/Dl1euCiyGcvTEMcaH0uLhV/d0ZVrwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ox1RFp2F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox1RFp2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DCF1F000FF;
	Wed, 23 Sep 2026 14:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174907;
	bh=VumIY5HJYGbUwHFseUCF4MlQNCad7I/KJykJRntYmPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ox1RFp2FtlkII4863jKzfSxBJFnmL1wVs8C/mix7UU92y6uoShNB6tqEAq/fmrFvX
	 cFC2aHUYDmFvDZ0xblr7OLVRVFbxz6OzJCucM8FyjQqkgzylbOzBOtU8NmbbSi1W4u
	 jQ09p+00uPDp1CFyukKHVmkr301EElnt8IudBSas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Tal Zussman <tz2294@columbia.edu>,
	Barry Song <baohua@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jens Axboe <axboe@kernel.dk>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 262/398] mm: filemap: retain mapped dropbehind folios
Date: Wed, 23 Sep 2026 16:05:36 +0200
Message-ID: <20260923140650.203587627@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wenjie Qi <qiwenjie@xiaomi.com>

commit 848d2ce2fce15fbdc083fbf9691bfa72911033c4 upstream.

Fault-around can map ready dropbehind folios without going through the
normal page-cache lookup that clears dropbehind.  A mapping represents a
competing cached user, so retain the folio instead of forcibly unmapping
it when writeback completes.

For a mapped folio, folio_unmap_invalidate() can call
unmap_mapping_folio(), which takes i_mmap_rwsem and may sleep.  Retaining
mapped folios avoids this path when folio_end_dropbehind() runs in
non-preemptible task context.

Tal was able to trigger a sleeping-in-atomic warning due to this [1].

Unmapped dropbehind folios continue through the existing invalidation path.

Link: https://lore.kernel.org/4aba05e1a2c3b61cb337d373eb9b7a8db4ddd822.1788024049.git.qiwenjie@xiaomi.com
Link: https://lore.kernel.org/076bb01b-6fcf-4691-be8c-0e8507c9fe64@columbia.edu [1]
Fixes: fb7d3bc41493 ("mm/filemap: drop streaming/uncached pages when writeback completes")
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Tal Zussman <tz2294@columbia.edu>
Tested-by: Tal Zussman <tz2294@columbia.edu>
Cc: Barry Song <baohua@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1624,7 +1624,7 @@ static void filemap_end_dropbehind(struc
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 


