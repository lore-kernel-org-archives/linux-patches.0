Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 080FC16DEAC;
	Wed,  3 Jul 2024 11:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006235; cv=none; b=G9MYG/S/7F2lzPKuCG0xiEGKy8rxorMOqKA3qUaq7s71wZJ9T5pLXcuJeY6XcNZbfDaXjQiZfsknpFg+lI45MNvsqPn5ms/b7UqbNbRqIK/WuIUO1BPMMzU8AHCm+FX84BAYIGNOh6+hWUxyMkbZsWJk64UfSoOff1SNzvM9eRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006235; c=relaxed/simple;
	bh=7eKVGKkTht9AgLTeicPj+N+ZwjyS0AobKoTrYhQG0OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTJTP9PgSGCrc8lh7bilVUJSadFwR2tbdTyMgv/DuTmSa9VlH9i0f+5XG2U24OsqrfIN5GUCY79RFBt5JlLnLMW9pP3c9ou0LQdrn0hT5VCVCxXb6E26ATMF37N3dn0TkRkxZ86KO9x3yAVH+mHA5JKDaLzCy/QfQLpbRp5j5gQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KaOusqP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KaOusqP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8705DC2BD10;
	Wed,  3 Jul 2024 11:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006234;
	bh=7eKVGKkTht9AgLTeicPj+N+ZwjyS0AobKoTrYhQG0OM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KaOusqP+f3KY2k0Nuvfth3/maT+bkBDc8w5K884QDB/HHYSqtP9PrjjnYGnolWCC
	 x4I7h+Yp0CoTIjypNU1d1VNCbsGJRyJUKtv+OlUBIbXqHvEcy72WVUKFU/So87DJcQ
	 6tas2nDGNj3prjkXOaeAye0WpeeVrFq+oYG+yVDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>
Subject: [PATCH 5.15 344/356] nfs: Leave pages in the pagecache if readpage failed
Date: Wed,  3 Jul 2024 12:41:20 +0200
Message-ID: <20240703102926.126745655@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 0b768a9610c6de9811c6d33900bebfb665192ee1 upstream.

The pagecache handles readpage failing by itself; it doesn't want
filesystems to remove pages from under it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/read.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -120,12 +120,8 @@ static void nfs_readpage_release(struct
 	if (nfs_error_is_fatal_on_server(error) && error != -ETIMEDOUT)
 		SetPageError(page);
 	if (nfs_page_group_sync_on_bit(req, PG_UNLOCKPAGE)) {
-		struct address_space *mapping = page_file_mapping(page);
-
 		if (PageUptodate(page))
 			nfs_readpage_to_fscache(inode, page, 0);
-		else if (!PageError(page) && !PagePrivate(page))
-			generic_error_remove_page(mapping, page);
 		unlock_page(page);
 	}
 	nfs_release_request(req);


