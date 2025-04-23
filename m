Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A7BE2F2E;
	Wed, 23 Apr 2025 15:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420445; cv=none; b=L+OmbADbOKkmcbTiaue6PT8xbblODQuwvcRVGHJWcMZrhSQ8ivl1JHGZQXj+cayrIp1+6zRzxV49J1LulAMef++XTP18CqFBu9WPkaQAqwp64hyD4Lhil6jZUDFQYVzDey+h/UUmU7SHpJ01/NulovTZDWc/B4x8FWXxfXWvx1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420445; c=relaxed/simple;
	bh=zJam47IZXdD1LlLyIiAd1raicCt/BNMFp6WjP5qEMYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4eV1/iUQtTcQuIQGPxItzo6ZXQzrxXGs78UAetct2YmB6wy6Mto09lO3ovKfT/6n+n6i1soeVgrDN/ubZDqpIuRVG8F5gJqMMjUZMIf8CvIIjenau2mb2wtuB2RjiaT0Hk+Vn1OMqK/kUJaB3H73U+JtEDKWCmFw9zNqoHpG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XhL5RIYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XhL5RIYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC89C4CEED;
	Wed, 23 Apr 2025 15:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420445;
	bh=zJam47IZXdD1LlLyIiAd1raicCt/BNMFp6WjP5qEMYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XhL5RIYYcfQSYP0Rtpt7BReV+3WyCnsIcUEvEH/C3QvjVArTZtJoh2Px5/F0P1MWT
	 kvp6ObMjyH5PnQ9MLPayE8U0zUYdFF+zUZTFF2a2CRme47grAIef95zjyC2oYZ/Aw1
	 j4Ip3VceW3Cg/ODY4FqDR2umVgx4XNGW/YhmdYpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.12 132/223] string: Add load_unaligned_zeropad() code path to sized_strscpy()
Date: Wed, 23 Apr 2025 16:43:24 +0200
Message-ID: <20250423142622.469328139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -113,6 +113,7 @@ ssize_t sized_strscpy(char *dest, const
 	if (count == 0 || WARN_ON_ONCE(count > INT_MAX))
 		return -E2BIG;
 
+#ifndef CONFIG_DCACHE_WORD_ACCESS
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	/*
 	 * If src is unaligned, don't cross a page boundary,
@@ -128,11 +129,13 @@ ssize_t sized_strscpy(char *dest, const
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
@@ -140,7 +143,11 @@ ssize_t sized_strscpy(char *dest, const
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


