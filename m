Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BEE3E1D01;
	Mon,  4 May 2026 14:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904828; cv=none; b=J6zPI3MyJfl1GSEe1lq+ftOMc0dXYDieKT6RegFASHs9zuG15/pq/DEDYgcb2MwTb+NjJo3RM4HhEfZsZAZspcLFrRfgTf4ph9BJM7LjYnXePq/jyrKIUOcGZP1B2AxzVJwN3AJqzfgOKXtId2QTD010M7sArykt8EoUS5nY2IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904828; c=relaxed/simple;
	bh=PEYXvB8qIkcH0xE+lkb8P9tlsyZgfdet8PU/UKbSH3A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5hr0WKaAhQGlmGBX/RjMOapU5FeXVZoLqCxwYHFjFMCH8RTD+jLPrlRvv4Qfp/NlQFkKs3dAYSHNl8t5UeSJHgrLeUMMgZBPXHiatMTK7lzr0pQH6ogge0xnuzFw1PgapW4YyoHCNeNjEUFceaIlqBKyN+69zv+4x8zx+K0W9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUywYJZd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUywYJZd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4085CC2BCF4;
	Mon,  4 May 2026 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904827;
	bh=PEYXvB8qIkcH0xE+lkb8P9tlsyZgfdet8PU/UKbSH3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUywYJZdz/Y/xZ5frgNOYYUkTP7V23zVu2Dztb4HeVNNV5oZ1uH3LzILC6A1hGWMZ
	 ZuTLV4x5LEyy73QXrBLtvGu21Tg2l2oudSK0J4qi8xJbR7Y0/0Cb1tpP5d2QK1vaCD
	 XO+2dMv9JUMKZuEQH4sZqyA4CmOf4Qdzg9LMMz94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 189/215] mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
Date: Mon,  4 May 2026 15:53:28 +0200
Message-ID: <20260504135137.264461319@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 4fb61d95ad21c3b6f1c09f357ff49d70abb0535e ]

zs_page_migrate() uses copy_page() to copy the contents of a zspage page
during migration.  However, copy_page() is not instrumented by KMSAN, so
the shadow and origin metadata of the destination page are not updated.

As a result, subsequent accesses to the migrated page are reported as
use-after-free by KMSAN, despite the data being correctly copied.

Add a kmsan_copy_page_meta() call after copy_page() to propagate the KMSAN
metadata to the new page, matching what copy_highpage() does internally.

Link: https://lkml.kernel.org/r/20260321132912.93434-1-syoshida@redhat.com
Fixes: afb2d666d025 ("zsmalloc: use copy_page for full page copy")
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ translated zpdesc_page(newzpdesc/zpdesc) arguments to newpage/page ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1808,6 +1808,7 @@ static int zs_page_migrate(struct page *
 	 */
 	d_addr = kmap_atomic(newpage);
 	copy_page(d_addr, s_addr);
+	kmsan_copy_page_meta(newpage, page);
 	kunmap_atomic(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;


