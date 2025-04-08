Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB13266583;
	Tue,  8 Apr 2025 11:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110978; cv=none; b=T56HTtz74PC+Am3sUdxy+53gcywh01GVG4tw8/ofsz/BFVouAzgPBKhmkPSYhAwrH3oXmr/2/J/bq/PEiSNmH9lIELAGfHUWlhEHBF2dxhWIklsyzAuvP6CbmUYONJOWYfvwA66+yFKyYVSkSjL1cwejaU+Mr+pJfPoGD8fKYSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110978; c=relaxed/simple;
	bh=qcaR/XolJUT++KnECSEer+pVxBlVa0O9BeivsU1D6ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XmO/kd8mnsPAjU//ydaa3J+WoRys/UvGDnrUNT1dT0E+/zwKtr0d9PQNIrASWQEao0ZfCp70j53RLAzSmTnuq9otYN/7Pj33gfTQ25vlB7FztvvzDI4OtCIWKBIx8xz7rK9rmSOJCivw0LRGoNpTVbYWttkkpsf/SnTdFmTOmTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHn8QeU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHn8QeU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FAD6C4CEE7;
	Tue,  8 Apr 2025 11:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110978;
	bh=qcaR/XolJUT++KnECSEer+pVxBlVa0O9BeivsU1D6ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHn8QeU1oNvLssUYq0pyxsie++dhEClA82imE9I/Ahy5IVdyYlLem9c64dE+BuhGF
	 RAgGaraUo+gDMHTAR9i0DnZaUsRJ5I9AsNBr8TxCL/jGM35Awx4Q6NUZRNxFzK3JMO
	 /UhIxeJ3NClM+OXUxItbhNMPPLaAYpISmRe4VX7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 265/731] rwonce: fix crash by removing READ_ONCE() for unaligned read
Date: Tue,  8 Apr 2025 12:42:42 +0200
Message-ID: <20250408104920.444579869@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Jann Horn <jannh@google.com>

[ Upstream commit 47a60391ae0ed04ffbb9bd8dcd94ad9d08b41288 ]

When arm64 is built with LTO, it upgrades READ_ONCE() to ldar / ldapr
(load-acquire) to avoid issues that can be caused by the compiler
optimizing away implicit address dependencies.

Unlike plain loads, these load-acquire instructions actually require an
aligned address.

For now, fix it by removing the READ_ONCE() that the buggy commit
introduced.

Fixes: ece69af2ede1 ("rwonce: handle KCSAN like KASAN in read_word_at_a_time()")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/r/20250326203926.GA10484@ax162
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/rwonce.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/rwonce.h b/include/asm-generic/rwonce.h
index e9f2b84d2338c..52b969c7cef93 100644
--- a/include/asm-generic/rwonce.h
+++ b/include/asm-generic/rwonce.h
@@ -86,7 +86,12 @@ unsigned long read_word_at_a_time(const void *addr)
 	kasan_check_read(addr, 1);
 	kcsan_check_read(addr, 1);
 
-	return READ_ONCE(*(unsigned long *)addr);
+	/*
+	 * This load can race with concurrent stores to out-of-bounds memory,
+	 * but READ_ONCE() can't be used because it requires higher alignment
+	 * than plain loads in arm64 builds with LTO.
+	 */
+	return *(unsigned long *)addr;
 }
 
 #endif /* __ASSEMBLY__ */
-- 
2.39.5



