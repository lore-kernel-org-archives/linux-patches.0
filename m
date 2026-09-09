Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52EF2353A82;
	Wed,  9 Sep 2026 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962895; cv=none; b=ZhYQeLVTF8ZuHbfTzivr7WNwfzOMwiczRvza1Dd42zdAJL6hgdN/rdkzM7y4XNc892WXV2bGDQ7MSwtYlXlHnVeJhNnEy/QQB6jaFN3+Rxts2nOY9F1pwWqI2zdHfYjwdA4HRP7PPbIBnimpmUATE9u2fcR9WWa0bKsvgB3tDmg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962895; c=relaxed/simple;
	bh=gGJ2njGOfsxGWynjmu/f0pKG26N7W9cTrx+13OWgYlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRCezVemK//SNDO9OLQKN9rlyo1SHYXyeVSG230VNF60qmA3dtGsswWEpjRkN2LE9lKVt6kmx7liaojpKl3KMp2hjZm8xwlUU3+bBFnzJYK7g+giByKmh0UlEOjVrB4Qiqou9uAWpbUBTsBdtQxKvt0ACRjcQuLcI/pF9uRgXjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUDm6al+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUDm6al+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A94F51F00A3A;
	Wed,  9 Sep 2026 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962894;
	bh=MG4cPxMZPp7yvPWOb2hgcy1bdCB/K6RYaa0q/twHz7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LUDm6al+fLss3C5db8B3JumpcK+9mswT1/gREL4ruPqVqPwexw2wL8CPzIS8Ek2MQ
	 jcCPveZY0w5u+iWw4OnfCAq0IMEgKNYk1agLg8eGIIW+X5zK9adj/38GBAL0B9KNw/
	 NfHpJ72QwpD6LEDSamV1D0U3iY3eDLEQgsYQeFig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wenjie Qi <qiwenjie@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 7.2 448/556] f2fs: only redirty pinned folios in redirty_blocks
Date: Wed,  9 Sep 2026 15:42:08 +0200
Message-ID: <20260909134246.350258507@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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
@@ -4473,7 +4473,7 @@ static int redirty_blocks(struct inode *
 		page_idx = folio_next_index(folio);
 	} while (page_len < len);
 
-	do {
+	while (redirty_idx < page_idx) {
 		folio = filemap_lock_folio(mapping, redirty_idx);
 
 		/* It will never fail, when folio has pinned above */
@@ -4486,7 +4486,7 @@ static int redirty_blocks(struct inode *
 		redirty_idx = folio_next_index(folio);
 		folio_unlock(folio);
 		folio_put_refs(folio, 2);
-	} while (redirty_idx < page_idx);
+	}
 
 	return ret;
 }


