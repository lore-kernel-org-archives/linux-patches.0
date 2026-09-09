Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37856E060;
	Wed,  9 Sep 2026 14:30:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964239; cv=none; b=V4vFGkYYKK+/duJQoGJxHJlNe1VsUC9VDRaED/VS0AmhNI92NjCTUu1un9g38hF1FYU5uL+dnhMDw0TFhMhZ+eqa8eBNhylX//e2ZLRRSMqAnTrXHStrwTvsWRICd06Bb2B4dEwBkgBnNTscAWUnoPz4RwefWYKTpAJC7IfHB5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964239; c=relaxed/simple;
	bh=N98bNZ48VS4MpvAk3CxZA5vTjoZuo6FyVBkVrqGgYiI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSsOf5FtvB5gqW0vHEUKg1sEwIAx1i8KfHEwckyzuDCA2+01Of3jl4dkdppvrkxQhj/cVKraGaByPieZ/Yr6Vy94HpVx6qb7YoWrkqAUqkfBoUQKTGICwkn+I8EJwh43mNQMAn3BjwfitsJg37pBS0zpofbHdFu/GXoX0KMZuiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSG6RthX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSG6RthX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30C8B1F00A3A;
	Wed,  9 Sep 2026 14:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964237;
	bh=ZxjmK6gBwhF2KcrbwvDmPjoay7RBLymhaFMd+bMi0VE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MSG6RthXIt96+LgsSkkgwJMGWZUM7MK3H9po+qMKVaROGVgwpd5J22QlgVOkrAow9
	 H/4w5ay0AtLA68uRRZLqiP+dNHJXXd5/tjQphEWRw6oEBBFQg8jcLi/aed4iX/9BxD
	 hkyRqWcrcSf4XUcOyfIHOrbg0a0vhTcBKorKCwzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.18 353/583] f2fs: only redirty pinned folios in redirty_blocks
Date: Wed,  9 Sep 2026 15:40:38 +0200
Message-ID: <20260909134250.228046923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: Wenjie Qi <qwjhust@gmail.com>

commit 85171332742e741ccd6f401c69b6e0d698119e72 upstream.

redirty_blocks() pins folios with read_cache_folio() and then walks the
same range again with filemap_lock_folio() to redirty them and drop the
references it took.

Commit 5951fee46bef ("f2fs: Use a folio in redirty_blocks()") changed
the second pass to a do/while loop. If read_cache_folio() fails before
anything is pinned, page_idx does not advance but the cleanup loop still
runs once.

If readahead has already populated the failed folio in page cache, that
extra iteration finds it and folio_put_refs(folio, 2) drops one
reference too many. Later drop_caches or reclaim can then report
"BUG: Bad page state".

Only redirty the range that was pinned successfully.

Fixes: 5951fee46bef ("f2fs: Use a folio in redirty_blocks()")
Cc: stable@kernel.org
Assisted-by: Codex:gpt-5.5
Signed-off-by: Wenjie Qi <qiwenjie@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -4441,7 +4441,7 @@ static int redirty_blocks(struct inode *
 		page_idx = folio_next_index(folio);
 	} while (page_len < len);
 
-	do {
+	while (redirty_idx < page_idx) {
 		folio = filemap_lock_folio(mapping, redirty_idx);
 
 		/* It will never fail, when folio has pinned above */
@@ -4454,7 +4454,7 @@ static int redirty_blocks(struct inode *
 		redirty_idx = folio_next_index(folio);
 		folio_unlock(folio);
 		folio_put_refs(folio, 2);
-	} while (redirty_idx < page_idx);
+	}
 
 	return ret;
 }


