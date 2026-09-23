Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7A43AEF24;
	Wed, 23 Sep 2026 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173673; cv=none; b=MRW2PNoEsIHA+0MDsLpaXUoBeH1CrVtc+AXJXRFw2093ywkUx6BIsOvVKt9xzH7HX5TwtyIo4WOq4rmi5/YWMAI57YK/ZSwVCD46CMtQAQ/gZpJAmmQjk/weFJo5srE0LJm9CEB6aypB2uhlEv6/dLRS+3jg6TF5CrSjUCG3y/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173673; c=relaxed/simple;
	bh=mpRrL+sh4Qin8pV19pyvvdiVPd2czDjpLvKqHsVh3j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cAwONXDCpi+vxjBwUoTUCOTKitv6KQMVaLAtU/RWbBx+xGGx9DJE15J7gBvJxaBRch8e0BUmhMl6sCfOtJA49WGOq4k2OAqAzPzQ7fE2cB4+/7WMkrkDJYcLDJrDCI1RyYLC0qdPvvB+OEyys+wZNsALrHcGMEW1fQhhTnhDXLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li29M8VI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li29M8VI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7541D1F000FF;
	Wed, 23 Sep 2026 14:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173672;
	bh=X4n0fNQZ7gqR12Jeo7xvYAQK3/kDxBGklqfd+/Nf46I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=li29M8VIXNMezoMr8+O3s8yG2eCkJcMjnGpOMM8+AIP4/33hxnUBQzdPnlpRJ57os
	 zTUNqrzmyVFrMZeubmoO2chUNmOV2fxRoMm3b3j6Wy0t1kaQyDgkMX2EwKDLsXpx6b
	 PxVc1xnRczpmBlj7Jjd4aQ+vGp0w92uDhVUTiUDU=
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
Subject: [PATCH 7.2 319/438] mm: filemap: retain mapped dropbehind folios
Date: Wed, 23 Sep 2026 16:05:40 +0200
Message-ID: <20260923140653.060402083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1616,7 +1616,7 @@ static void filemap_end_dropbehind(struc
 		return;
 	if (!folio_test_clear_dropbehind(folio))
 		return;
-	if (mapping)
+	if (mapping && !folio_mapped(folio))
 		folio_unmap_invalidate(mapping, folio, 0);
 }
 


