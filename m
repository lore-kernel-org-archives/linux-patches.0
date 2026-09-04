Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 408B53B2FE4;
	Fri,  4 Sep 2026 05:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498639; cv=none; b=jVvlTSqGkZGX0FsY874euHA7KFT9vLYbEOqxgOXe83xftUzwxlxUjM2nGzJzzULvg0lMnCF7fjJTQrWlO65axafAo22nTu207gEuvM848JaQVpUJIG+rUWnj1BxsBybeR2pdl9ZoFYxYCQH7LYgXs4ebkIeQnKK96qtktDAnE0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498639; c=relaxed/simple;
	bh=CE/sqIyqbofbxVSU3j6OSk49CagMjrcLfxiNSjzI3tY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hlai+hDi7Xpj8/C84hbY6B6G9IY31tk5JmGhRXz4wu+HnSeaqThN0ztJhBGYOAmsxy/yQpqtuZ/r9vkT+zFvyqo/Dttnuh08Fh7URr1Wu6FtDSW0nl2nSrSaOvAwZa3e3Ih+JCOgtIoIcMugPvh4OvW82/NpqQNrZ47uKXViT4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMJdweO2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMJdweO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C541F00A3D;
	Fri,  4 Sep 2026 05:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498638;
	bh=0tJOJiup0JSttXzEsDgU0CXZL1G9/08asVoOdU0mxik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMJdweO2hJMOtaTS0iV933cTU043Yx8ipkPIozxJy9eHuHmk6De6WDNYY6/MHVzlI
	 EkmveVHtUWHa3wqWbfghhn3uvxRT6MfeIGVjmQdx6DD0YogoMslQXVgGkt2OqKbvcQ
	 upKeYt8nasSPQzX0tMX9rghFrRlcbNVGb/F3Rbfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longlong Xia <xialonglong@kylinos.cn>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.2 135/713] zsmalloc: account for handle size in class lookup
Date: Fri,  4 Sep 2026 06:51:43 +0200
Message-ID: <20260904045806.856998416@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Longlong Xia <xialonglong@kylinos.cn>

commit f7bf5cd5b5f2b13fe2361860880c4e214c08b440 upstream.

zs_lookup_class_index() lets zram recompression decide whether a newly
compressed object would use a smaller size class.  It currently classifies
the payload size directly, while zs_malloc() adds ZS_HANDLE_SIZE before
selecting the class.

This makes lookup disagree with allocation near size-class boundaries.
With 4 KiB pages, CONFIG_ZSMALLOC_CHAIN_SIZE=8, and 64-bit handles, a
1025-to-1024-byte recompression appears to move from class 64 to class 62
although both allocations use class 64.  Conversely, a 1049-to-1025-byte
recompression appears to stay in class 64 although the allocations move
from class 65 to class 64.

As a result, zram can accept replacements with no allocation benefit or
reject ones that would save memory, potentially marking the object
incompressible.

Factor size-class selection into lookup_size_class(), account for the
handle there, and use the helper for both lookup and allocation.

Link: https://lore.kernel.org/20260809115518.3791787-1-xialonglong2025@163.com
Fixes: 7c2af309abd2 ("zram: add size class equals check into recompression")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/zsmalloc.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -478,6 +478,11 @@ static int get_size_class_index(int size
 	return min_t(int, ZS_SIZE_CLASSES - 1, idx);
 }
 
+static struct size_class *lookup_size_class(struct zs_pool *pool, size_t size)
+{
+	return pool->size_class[get_size_class_index(size + ZS_HANDLE_SIZE)];
+}
+
 static inline void class_stat_add(struct size_class *class, int type,
 				  unsigned long cnt)
 {
@@ -1021,7 +1026,7 @@ unsigned int zs_lookup_class_index(struc
 {
 	struct size_class *class;
 
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	return class->index;
 }
@@ -1311,9 +1316,7 @@ unsigned long zs_malloc(struct zs_pool *
 	if (!handle)
 		return (unsigned long)ERR_PTR(-ENOMEM);
 
-	/* extra space in chunk to keep the handle */
-	size += ZS_HANDLE_SIZE;
-	class = pool->size_class[get_size_class_index(size)];
+	class = lookup_size_class(pool, size);
 
 	/* class->lock effectively protects the zpage migration */
 	spin_lock(&class->lock);


