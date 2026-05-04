Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BD03DD519;
	Mon,  4 May 2026 13:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903087; cv=none; b=WwcLzQTWQXKTcP2ASj3J43cUscpsE6pUoHaK+WJhxbcdqAAZQeMlGBbhJ+ajTIHzRJqvaIjwAZcS9eHu06G8jVcynJyILOr9/3DaVAb5Ix+FumGfnxBQcPS5++T5se/R3UXeanN0nNrLWzPs08LDDFgHNAAJKB/nAqH2gSjNYtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903087; c=relaxed/simple;
	bh=7H6b5X9AOtKx1FiwwJJEBPmlGPlNAyi9faVwwQ6upIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bvd5FKWcTrTSNQv2Z50aOZZO9+KYTmxsjHwdNk2jGny2RrEhxCrR7WCikDoL6JCkQrw1DFOD2BWpdgERWl1Muitgv4bSn2UvgumGTCJkxnRYXFsrVtLUn3o9NB1XQkoRgm09ygIArGSXhZGz82VAOEpVMTeUsPQHF3Nil2BhjLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NVpvgb5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NVpvgb5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B07C2BCC4;
	Mon,  4 May 2026 13:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903087;
	bh=7H6b5X9AOtKx1FiwwJJEBPmlGPlNAyi9faVwwQ6upIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NVpvgb5erNgfrGXF73W12+/NvMRVkNsCTeQo1qjqXze4pVOEKgPOW1GRNGu0s+hq7
	 cZAywJlI/v7GNialH7T3SxzpQw3tqbL9nXHvdYRd/aLL5isDslZhEv4PkD6GtUWBCo
	 CrduBy4tUALu36BlhFW5eXAWbFkSurFNsh/PzFJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.0 066/307] mm/zsmalloc: copy KMSAN metadata in zs_page_migrate()
Date: Mon,  4 May 2026 15:49:11 +0200
Message-ID: <20260504135145.299464148@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

commit 4fb61d95ad21c3b6f1c09f357ff49d70abb0535e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -1741,6 +1741,7 @@ static int zs_page_migrate(struct page *
 	 */
 	d_addr = kmap_local_zpdesc(newzpdesc);
 	copy_page(d_addr, s_addr);
+	kmsan_copy_page_meta(zpdesc_page(newzpdesc), zpdesc_page(zpdesc));
 	kunmap_local(d_addr);
 
 	for (addr = s_addr + offset; addr < s_addr + PAGE_SIZE;


