Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F1429A9C3;
	Mon,  9 Feb 2026 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648816; cv=none; b=ohwIExMAHU4BcqEGGfXARy6z3A5Km7C081pSflNktUbCsYtRSVxoG82pCJm71tA4+7obBzC6u9d7X+cFV/Y0FPgwVWK2BeA7DwrYHGGTk/ibid3W27lAyB8KabZWq+uY6H9I0gWl1mG2Hrqlw/n0Rj9Q3vwgmhp1xIiJDZjpffM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648816; c=relaxed/simple;
	bh=3YY0RVhr5UVX+qo0HnJVq/DA/kS3IgIW1UYRuP1hZiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A5mgZh1NMN2x5LC+r/C3eBWNNF4mKls9swjj7QmsycOL0IReHGCZfUwAaJOHKVIwv7jQaSolvZq+5RvOkhFtTqqr1ZlqY+exiC54+u0tN7DcHvwvJf3TTk89jIsJakcg+2G/46850QeYynlxVX//jGO/oVf4TwQhFdeggZelrY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hrw0vZFO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hrw0vZFO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E03C19422;
	Mon,  9 Feb 2026 14:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648816;
	bh=3YY0RVhr5UVX+qo0HnJVq/DA/kS3IgIW1UYRuP1hZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hrw0vZFOsBeU7wgCoh6tqF7rWdGxtQ/8u+WgsHE/zz8iwkkGipAy9ygsvnFtRbLcx
	 Tuo8KiOOn6L+ZY/ypUkjp+rE4zY2DzSQfGGBxxvAWuNXaiCY7HP/bdLnWOhFWKRyyJ
	 2PNMi3V26SeZMsGZxuj2W8O6tEVscxvpLSHk5GCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 04/75] ARM: 9468/1: fix memset64() on big-endian
Date: Mon,  9 Feb 2026 15:24:01 +0100
Message-ID: <20260209142301.996785796@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
References: <20260209142301.830618238@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weissschuh <thomas.weissschuh@linutronix.de>

commit 23ea2a4c72323feb6e3e025e8a6f18336513d5ad upstream.

On big-endian systems the 32-bit low and high halves need to be swapped
for the underlying assembly implementation to work correctly.

Fixes: fd1d362600e2 ("ARM: implement memset32 & memset64")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/string.h |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/arch/arm/include/asm/string.h
+++ b/arch/arm/include/asm/string.h
@@ -42,7 +42,10 @@ static inline void *memset32(uint32_t *p
 extern void *__memset64(uint64_t *, uint32_t low, __kernel_size_t, uint32_t hi);
 static inline void *memset64(uint64_t *p, uint64_t v, __kernel_size_t n)
 {
-	return __memset64(p, v, n * 8, v >> 32);
+	if (IS_ENABLED(CONFIG_CPU_LITTLE_ENDIAN))
+		return __memset64(p, v, n * 8, v >> 32);
+	else
+		return __memset64(p, v >> 32, n * 8, v);
 }
 
 /*


