Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B699C2BE100;
	Wed, 23 Apr 2025 15:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422388; cv=none; b=QywK1mr6A6b5B3fw/fbI0F0QGNb+R1jGVAqXtviliYutMCCWZ75dNtjQt3DEDDbP73u+4PYVDv9zn5VlUvoPPhCW6eY94qJEaLyVjbuFVTeee3usuf95VL7WosEW7uTpJbwaWgqie0iMbmeCm9rVK20q5ApbzqYCAp+gfLoLypg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422388; c=relaxed/simple;
	bh=fLZaofdbRjVEQ2zpn1aNyXzzbiwq8zdKMO0o5gv6Isw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f3pGvP8YfNwroFflru5b35Tv6F6tnzcv/Kb9d0My0VkMOvTC2IKY7WCpD4xqsEqOmHVV0H13h5nTceEk4GbRWIv8V8Y8dAtpdaXW7/5bPP54WiylgOPs4s62OXlfjaZRcp8lOqXqULsqqZKRaukDrH5KYgPbzVe0iyPMqq5krpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABdhQdo0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABdhQdo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45DD5C4CEE2;
	Wed, 23 Apr 2025 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422388;
	bh=fLZaofdbRjVEQ2zpn1aNyXzzbiwq8zdKMO0o5gv6Isw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABdhQdo069vRuwC3NGrn2uIzL0zuwFB1c3tsyhqcZo3scJahmYNPeLWAAlUXKjxv5
	 Llfq8/MPpgVEh1iwgQD5sUMJD8Fc9bykr1Z0zOusqJDMDyX8fGJHxn+pqPIvsWEP98
	 WdPkAhnu6ZjaPs9TtcprNKP+9AWQPdO/ViIhbljM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Collingbourne <pcc@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.6 333/393] string: Add load_unaligned_zeropad() code path to sized_strscpy()
Date: Wed, 23 Apr 2025 16:43:49 +0200
Message-ID: <20250423142657.094509335@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -128,6 +128,7 @@ ssize_t strscpy(char *dest, const char *
 	if (count == 0 || WARN_ON_ONCE(count > INT_MAX))
 		return -E2BIG;
 
+#ifndef CONFIG_DCACHE_WORD_ACCESS
 #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 	/*
 	 * If src is unaligned, don't cross a page boundary,
@@ -143,11 +144,13 @@ ssize_t strscpy(char *dest, const char *
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
@@ -155,7 +158,11 @@ ssize_t strscpy(char *dest, const char *
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


