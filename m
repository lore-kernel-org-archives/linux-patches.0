Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C02A523645D;
	Fri, 24 Apr 2026 13:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037618; cv=none; b=SjVzqdOaibXadpwg/wKRxyYpdgZ7orIR9bt91fb1MVuBqhrjgSi9ZPq4/FHTzw+1PtwxLx9DZdm28Y5051r50bYVS+K4MJfIYGPNnIxwiV3SH3v9L7iTJ/3NoMT/XjcWC4/1L0oKT1j7R9OG4pQPnUuc0+fyY+4H6OXeCnTPyJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037618; c=relaxed/simple;
	bh=m4bDnZOFTIiUNZRQ7gSfCW2a29M6CeP8nAWKjD59vlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E7KFjc14TCzKt2TqRUPsPSaQNBPylIBjaD8T6sudzXbPjbjQzTifNdQW9N2+nDFAS7uAYx6iZoFS2n7ejd5rDwiLjRHPKKMMedKqnSix8LeNHMlAulJ7Bs7BHTDu4w+RcQHPsWTIhAQGDrkq3K7Ib4uHjRaxCs8DTb6rFkVrwJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftD6ZId5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftD6ZId5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57821C19425;
	Fri, 24 Apr 2026 13:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037618;
	bh=m4bDnZOFTIiUNZRQ7gSfCW2a29M6CeP8nAWKjD59vlY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftD6ZId5E3RT0HHRYOBf6Xgc1c6rvevxodbvYB161mfZGRRCgPJ2T7ZJJG08C6ZW/
	 PDqLZ9F4kg6o8gAgymX/tH9geYeVLdaWIO/hxbe2bCxQBArZHkvE+1pk9jUtLMPe/+
	 bv5FnC139oLUnmIjRmqTvviqARdwF052SJ3BzTkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	George Saad <geoo115@gmail.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.0 33/42] f2fs: fix use-after-free of sbi in f2fs_compress_write_end_io()
Date: Fri, 24 Apr 2026 15:30:58 +0200
Message-ID: <20260424132427.350024901@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
References: <20260424132420.410310336@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George Saad <geoo115@gmail.com>

commit 39d4ee19c1e7d753dd655aebee632271b171f43a upstream.

In f2fs_compress_write_end_io(), dec_page_count(sbi, type) can bring
the F2FS_WB_CP_DATA counter to zero, unblocking
f2fs_wait_on_all_pages() in f2fs_put_super() on a concurrent unmount
CPU. The unmount path then proceeds to call
f2fs_destroy_page_array_cache(sbi), which destroys
sbi->page_array_slab via kmem_cache_destroy(), and eventually
kfree(sbi). Meanwhile, the bio completion callback is still executing:
when it reaches page_array_free(sbi, ...), it dereferences
sbi->page_array_slab — a destroyed slab cache — to call
kmem_cache_free(), causing a use-after-free.

This is the same class of bug as CVE-2026-23234 (which fixed the
equivalent race in f2fs_write_end_io() in data.c), but in the
compressed writeback completion path that was not covered by that fix.

Fix this by moving dec_page_count() to after page_array_free(), so
that all sbi accesses complete before the counter decrement that can
unblock unmount. For non-last folios (where atomic_dec_return on
cic->pending_pages is nonzero), dec_page_count is called immediately
before returning — page_array_free is not reached on this path, so
there is no post-decrement sbi access. For the last folio,
page_array_free runs while the F2FS_WB_CP_DATA counter is still
nonzero (this folio has not yet decremented it), keeping sbi alive,
and dec_page_count runs as the final operation.

Fixes: 4c8ff7095bef ("f2fs: support data compression")
Cc: stable@vger.kernel.org
Signed-off-by: George Saad <geoo115@gmail.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/compress.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1491,10 +1491,10 @@ void f2fs_compress_write_end_io(struct b
 
 	f2fs_compress_free_page(page);
 
-	dec_page_count(sbi, type);
-
-	if (atomic_dec_return(&cic->pending_pages))
+	if (atomic_dec_return(&cic->pending_pages)) {
+		dec_page_count(sbi, type);
 		return;
+	}
 
 	for (i = 0; i < cic->nr_rpages; i++) {
 		WARN_ON(!cic->rpages[i]);
@@ -1504,6 +1504,14 @@ void f2fs_compress_write_end_io(struct b
 
 	page_array_free(sbi, cic->rpages, cic->nr_rpages);
 	kmem_cache_free(cic_entry_slab, cic);
+
+	/*
+	 * Make sure dec_page_count() is the last access to sbi.
+	 * Once it drops the F2FS_WB_CP_DATA counter to zero, the
+	 * unmount thread can proceed to destroy sbi and
+	 * sbi->page_array_slab.
+	 */
+	dec_page_count(sbi, type);
 }
 
 static int f2fs_write_raw_pages(struct compress_ctx *cc,


