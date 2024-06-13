Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4A7144D13;
	Thu, 13 Jun 2024 11:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279596; cv=none; b=KjQah1HtwndYojIaHADX76mWLk4yO7qaUSvRv41tTBK981FS8XpRqfCbGJ1S/hf9a6OCOA+JpIK9wIvdRWoUEZUFwyDpFrMM9+5D4MTgjTuWDL5uBXE7Z+JcZBDJPU7uaACxuBOuji+nBgGyAyNxFdIFEGaYzbn6ZoMFammNfC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279596; c=relaxed/simple;
	bh=+tRkizIQ7IoUJCjZYMX38b1fgXWcRTkGPbH/mNOsa3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7JvSMfiGygfuMTDz4Q8VMFJ6GSPF3xm0pB+sdFWqF1ycelWB3G+1VG1a5RsdIIuWDhfD9vxkrGm7BjzSvlLWzEGJg8HZuKmQwVPJIGZVZeuGsRxIn+HMwssJQNiYyws0Q5rJBzWYWcmDh0n/5YTHgBVaghZp64wek7iaC8saiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9urhJUp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9urhJUp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FA8C2BBFC;
	Thu, 13 Jun 2024 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279596;
	bh=+tRkizIQ7IoUJCjZYMX38b1fgXWcRTkGPbH/mNOsa3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I9urhJUp3VjjsAZryVrrhL3TUFdBxkMX/+NsJMX69MSkoocqmyvOCeOiswVOzM63p
	 E+GZDhLxSAci/RGjkjW2SArWap+s0HTF8N4f6FD6iWgGsX/ewyLyK6NgSEBFoaLtkB
	 Ghs8jY3wyY6E88eniXwf2Qkuxi0tFQB3pH/so0vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Potapenko <glider@google.com>,
	Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Kees Cook <keescook@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.9 089/157] kmsan: do not wipe out origin when doing partial unpoisoning
Date: Thu, 13 Jun 2024 13:33:34 +0200
Message-ID: <20240613113230.869262393@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Potapenko <glider@google.com>

commit 2ef3cec44c60ae171b287db7fc2aa341586d65ba upstream.

As noticed by Brian, KMSAN should not be zeroing the origin when
unpoisoning parts of a four-byte uninitialized value, e.g.:

    char a[4];
    kmsan_unpoison_memory(a, 1);

This led to false negatives, as certain poisoned values could receive zero
origins, preventing those values from being reported.

To fix the problem, check that kmsan_internal_set_shadow_origin() writes
zero origins only to slots which have zero shadow.

Link: https://lkml.kernel.org/r/20240528104807.738758-1-glider@google.com
Fixes: f80be4571b19 ("kmsan: add KMSAN runtime core")
Signed-off-by: Alexander Potapenko <glider@google.com>
Reported-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
  Link: https://lore.kernel.org/lkml/20240524232804.1984355-1-bjohannesmeyer@gmail.com/T/
Reviewed-by: Marco Elver <elver@google.com>
Tested-by: Brian Johannesmeyer <bjohannesmeyer@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmsan/core.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/mm/kmsan/core.c
+++ b/mm/kmsan/core.c
@@ -196,8 +196,7 @@ void kmsan_internal_set_shadow_origin(vo
 				      u32 origin, bool checked)
 {
 	u64 address = (u64)addr;
-	void *shadow_start;
-	u32 *origin_start;
+	u32 *shadow_start, *origin_start;
 	size_t pad = 0;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(addr, size));
@@ -225,8 +224,16 @@ void kmsan_internal_set_shadow_origin(vo
 	origin_start =
 		(u32 *)kmsan_get_metadata((void *)address, KMSAN_META_ORIGIN);
 
-	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++)
-		origin_start[i] = origin;
+	/*
+	 * If the new origin is non-zero, assume that the shadow byte is also non-zero,
+	 * and unconditionally overwrite the old origin slot.
+	 * If the new origin is zero, overwrite the old origin slot iff the
+	 * corresponding shadow slot is zero.
+	 */
+	for (int i = 0; i < size / KMSAN_ORIGIN_SIZE; i++) {
+		if (origin || !shadow_start[i])
+			origin_start[i] = origin;
+	}
 }
 
 struct page *kmsan_vmalloc_to_page_or_null(void *vaddr)


