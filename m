Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3071A3BFE3B;
	Mon, 23 Mar 2026 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283500; cv=none; b=qvQjwlXRrgEitxvMpz/k9HDIkJwKvdXJTBuWLZjPyuDbAq0mBhUI5WZY1zTzUBfqdr9b3OCv/0GR5Iv3Nyg8zfR/wqcW1LPM3rINHqZ5DssfvMW5+mVmK/uCXdX08sOH9qbs5q1spqqbvuLPeCqBKNgDAVndjTLOh2kMAmjw2LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283500; c=relaxed/simple;
	bh=XJhXavlSGodC2PfnDnMg9VkfdmP1exLI5DjZ48recXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mUB04C6TsizSHaRo2Z4xzY1TeLeJqieHZ+fA9lAVYYXo7ZEB0+bSJgKMmgZrddmLrYbU5NxbOKFwqvxs1KqGNv1f2FOgTzNTizwCPxFvsYb6KwK3eA39TWABK2h68fyntF231icS3CdVo1nXfV8UVEClK1VTZnNrr9UjD7w/AWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYyWOQiP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYyWOQiP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EEFFC2BCB0;
	Mon, 23 Mar 2026 16:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774283499;
	bh=XJhXavlSGodC2PfnDnMg9VkfdmP1exLI5DjZ48recXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYyWOQiPkJ9WdexYcsH5VGpOai/8sb0Ny6V5kpyO1lX1YoltGlA7+vdwzywAzIwYS
	 p+3YI7PTjoyEgye+svWfrrjCCJc71+IX/gLlD0PFir3qIkSnrbmRB3Y+B3O5MEXUDR
	 ICa4KdlGu57KBX6wToyGTMf853fW2iakKt/5dyio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.1 096/481] ARM: clean up the memset64() C wrapper
Date: Mon, 23 Mar 2026 14:41:18 +0100
Message-ID: <20260323134527.620916475@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit b52343d1cb47bb27ca32a3f4952cc2fd3cd165bf upstream.

The current logic to split the 64-bit argument into its 32-bit halves is
byte-order specific and a bit clunky.  Use a union instead which is
easier to read and works in all cases.

GCC still generates the same machine code.

While at it, rename the arguments of the __memset64() prototype to
actually reflect their semantics.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Ben Hutchings <ben@decadent.org.uk> # for -stable
Link: https://lore.kernel.org/all/1a11526ae3d8664f705b541b8d6ea57b847b49a8.camel@decadent.org.uk/
Suggested-by: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/ # for -stable
Link: https://lore.kernel.org/all/aZonkWMwpbFhzDJq@casper.infradead.org/
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/string.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -39,13 +39,17 @@ static inline void *memset32(uint32_t *p
 }
 
 #define __HAVE_ARCH_MEMSET64
-extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
+extern void *__memset64(uint64_t *, uint32_t first, __kernel_size_t, uint32_t second);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
-		return __memset64(p, v, n * 8, v >> 32);
-	else
-		return __memset64(p, v >> 32, n * 8, v);
+	union {
+		uint64_t val;
+		struct {
+			uint32_t first, second;
+		};
+	} word = { .val = v };
+
+	return __memset64(p, word.first, n * 8, word.second);
 }
 
 /*


