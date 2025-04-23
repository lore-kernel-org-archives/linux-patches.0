Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1EF280A2C;
	Wed, 23 Apr 2025 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421126; cv=none; b=Tu1rnuDHVtG+gVJOo39fHF/cyDe07Yi6xkasN589o0m1KZpl+3eelqAGZtJ+fTBCms4t0eThcFAxKhKvJnRaBvGENLYgoVqB7ENMe2zJafP5HkOe1CJAcDFTXBd7VByF8CThFMcjo0F6kwNodcOFxxwqNsbpjQjbZGIiScRgHHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421126; c=relaxed/simple;
	bh=AT95jeqUBhDkHbvLBUAAmdnc1kFlarCgEELczmOem6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izgZ0hC6AycklEUvdm/n4KhydCM9YCh7UTlYBmdRkhc3WEq1DYgV4//URZykJsQBFFEQbnUzIGhixgyFbxQUAavnLEegxHbNnqwPlWxngQ21k6qlBORNq4iWXjPa3UH8ly5K2vrya7aA82xkdP8gqTLT+TK/1nRn1CzzIvdKgs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wbjE0Iyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wbjE0Iyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B304BC4CEE3;
	Wed, 23 Apr 2025 15:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421126;
	bh=AT95jeqUBhDkHbvLBUAAmdnc1kFlarCgEELczmOem6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wbjE0Iyqh0HJo7uLgQAPfcB5Xveg0G8cLOCpZ6tlZKCWuCiaLtE6uixVXmCOUMlQ8
	 Drk6ri5VRyUV1KigqVYzAuZZgiiUkoGhWIMy7x1jm7vtS3IKZiATG22KsAfqVYiNFW
	 uQzX+2ulo+E+wO3QZ0DDGIrmOWuwviSFhbPeNV5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.14 154/241] string: Add load_unaligned_zeropad() code path to sized_strscpy()
Date: Wed, 23 Apr 2025 16:43:38 +0200
Message-ID: <20250423142626.832456989@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

commit d94c12bd97d567de342fd32599e7cd9e50bfa140 upstream.

The call to read_word_at_a_time() in sized_strscpy() is problematic
with MTE because it may trigger a tag check fault when reading
across a tag granule (16 bytes) boundary. To make this code
MTE compatible, let's start using load_unaligned_zeropad()
on architectures where it is available (i.e. architectures that
define CONFIG_DCACHE_WORD_ACCESS). Because load_unaligned_zeropad()
takes care of page boundaries as well as tag granule boundaries,
also disable the code preventing crossing page boundaries when using
load_unaligned_zeropad().

Signed-off-by: Peter Collingbourne <pcc@google.com>
Link: https://linux-review.googlesource.com/id/If4b22e43b5a4ca49726b4bf98ada827fdf755548
Fixes: 94ab5b61ee16 ("kasan, arm64: enable CONFIG_KASAN_HW_TAGS")
Cc: stable@vger.kernel.org
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20250403000703.2584581-2-pcc@google.com
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/lib/string.c
+++ b/lib/string.c
@@ -119,6 +119,7 @@ ssize_t sized_strscpy(char *dest, const
 	if (count == 0 || WARN_ON_ONCE(count > INT_MAX))
 		return -E2BIG;
 
+#ifndef CONFIG_DCACHE_WORD_ACCESS
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	/*
 	 * If src is unaligned, don't cross a page boundary,
@@ -134,11 +135,13 @@ ssize_t sized_strscpy(char *dest, const
 	if (((long) dest | (long) src) & (sizeof(long) - 1))
 		max = 0;
 #endif
+#endif
 
 	/*
-	 * read_word_at_a_time() below may read uninitialized bytes after the
-	 * trailing zero and use them in comparisons. Disable this optimization
-	 * under KMSAN to prevent false positive reports.
+	 * load_unaligned_zeropad() or read_word_at_a_time() below may read
+	 * uninitialized bytes after the trailing zero and use them in
+	 * comparisons. Disable this optimization under KMSAN to prevent
+	 * false positive reports.
 	 */
 	if (IS_ENABLED(CONFIG_KMSAN))
 		max = 0;
@@ -146,7 +149,11 @@ ssize_t sized_strscpy(char *dest, const
 	while (max >= sizeof(unsigned long)) {
 		unsigned long c, data;
 
+#ifdef CONFIG_DCACHE_WORD_ACCESS
+		c = load_unaligned_zeropad(src+res);
+#else
 		c = read_word_at_a_time(src+res);
+#endif
 		if (has_zero(c, &data, &constants)) {
 			data = prep_zero_mask(c, data, &constants);
 			data = create_zero_mask(data);


