Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81F253952;
	Tue, 29 Apr 2025 17:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949373; cv=none; b=pAzJ12eyL3XAS1XwRb+WK/VWt/dYQIISwOXzpknE1h/55wh2WAy2rjkUOcvJFKIHiAEetUvVC+kD7824UeU6QEFpD/YZ7I2KScxmuuLLUyc+bFLRTVsmwgmQq+IdYVa6593Fi2wQPHop+EXGkMyLoLOqAevobyaUJY9hh+U7ci0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949373; c=relaxed/simple;
	bh=ngIuoiTSg1qODhi6V60qIoCXOWSqjjGR6uzB3zKlTnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bRuiSUFOPnZWVUHmWnBMpKuRmXQ5OQPNUbvaVB/1MKjDpe5R1Z42xHfKapYyICjApusCV9xXWQiN4rqk7sl3PPzswu1X2h3JeUQTQ2t4+bzEftA2htXDWOcVGbstMBk3Na4ygy6q0/vEs0m+ohr4fqWAsp9dR6H2dhgfPehIRuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1+oJOpj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1+oJOpj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B65C4CEEA;
	Tue, 29 Apr 2025 17:56:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949372;
	bh=ngIuoiTSg1qODhi6V60qIoCXOWSqjjGR6uzB3zKlTnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1+oJOpjWxHksDQxcudMgifQa/OWvLrmX5Uj7dMRBBnRuOYKQcHoYrH26TLbs44ty
	 DMizEns68lrkRJp37k30HMH6VyhbiGH27JJ9cO7gb/+NuO0Ckd7rNE8hACbZcGg2CW
	 50LtgDXi02qvS/t/efgEsfPUT/Ei1+RWG/uq46RA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 281/373] string: Add load_unaligned_zeropad() code path to sized_strscpy()
Date: Tue, 29 Apr 2025 18:42:38 +0200
Message-ID: <20250429161134.674478467@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Collingbourne <pcc@google.com>

[ Upstream commit d94c12bd97d567de342fd32599e7cd9e50bfa140 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/string.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/lib/string.c b/lib/string.c
index 9fb9be19a95d7..7c0c69bb5b689 100644
--- a/lib/string.c
+++ b/lib/string.c
@@ -186,6 +186,7 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	if (count == 0 || WARN_ON_ONCE(count > INT_MAX))
 		return -E2BIG;
 
+#ifndef CONFIG_DCACHE_WORD_ACCESS
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	/*
 	 * If src is unaligned, don't cross a page boundary,
@@ -200,12 +201,14 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
 	/* If src or dest is unaligned, don't do word-at-a-time. */
 	if (((long) dest | (long) src) & (sizeof(long) - 1))
 		max = 0;
+#endif
 #endif
 
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
@@ -213,7 +216,11 @@ ssize_t strscpy(char *dest, const char *src, size_t count)
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
-- 
2.39.5



