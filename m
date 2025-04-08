Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2340B224F6;
	Tue,  8 Apr 2025 11:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111066; cv=none; b=M6KXdeOcHIyMz20iXU803aMHYjqavyxihN2x1Gj+fmqrnNueUT7RVtAo3lxGkKMrI1d0EuuKx247eB+1yVrXwzaTulZPYFwT942IfRLvHTuUKjoOaE0yrco0ZxzA5pe4t9KipoUyQ9zlRMZ6Q1yzUtBZ3Q+v9DsJPy+WDFVgm8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111066; c=relaxed/simple;
	bh=x/6WOaeNFIH93mxiF9L3ZRSgWx45ukcAu7BP4Z0VVlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+jdskvh/nNBU5a0rhFBCmgB4YxvV1ZN7DqJzhEKIIkyzWgIAFEbIIAhquBOd6Exh84ZENHcc5H0m+5nNcgsTaTNSd1Nfh8N1mNrLUtr8JSI5ezMml5Y8MY6lFldvuwPZV1PjWS0HSGqYO6gYLo7OD/6SKtGkx37pjVTubQiS2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZUpT5Ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZUpT5Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7EDFC4CEE5;
	Tue,  8 Apr 2025 11:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111066;
	bh=x/6WOaeNFIH93mxiF9L3ZRSgWx45ukcAu7BP4Z0VVlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BZUpT5GaCbaVdGc7+8sYiqcSt1YPk+E5gbM4jY9RUAVrj6Fg3DgqSoFwdQoU/cqZK
	 vGh4dJdSPzWsWLBojs82m9OQ3Dmlgh56gAe5k4SwCtwrMlBts3kEl/pyTUC0y2Wlm7
	 Tlflnl+BvvxDfnZIpfOqkLBt+wybDeFYUhgfptpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Marco Elver <elver@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 258/731] rwonce: handle KCSAN like KASAN in read_word_at_a_time()
Date: Tue,  8 Apr 2025 12:42:35 +0200
Message-ID: <20250408104920.284641762@linuxfoundation.org>
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

[ Upstream commit ece69af2ede103e190ffdfccd9f9ec850606ab5e ]

read_word_at_a_time() is allowed to read out of bounds by straddling the
end of an allocation (and the caller is expected to then mask off
out-of-bounds data). This works as long as the caller guarantees that the
access won't hit a pagefault (either by ensuring that addr is aligned or by
explicitly checking where the next page boundary is).

Such out-of-bounds data could include things like KASAN redzones, adjacent
allocations that are concurrently written to, or simply an adjacent struct
field that is concurrently updated. KCSAN should ignore racy reads of OOB
data that is not actually used, just like KASAN, so (similar to the code
above) change read_word_at_a_time() to use __no_sanitize_or_inline instead
of __no_kasan_or_inline, and explicitly inform KCSAN that we're reading
the first byte.

We do have an instrument_read() helper that calls into both KASAN and
KCSAN, but I'm instead open-coding that here to avoid having to pull the
entire instrumented.h header into rwonce.h.

Also, since this read can be racy by design, we should technically do
READ_ONCE(), so add that.

Fixes: dfd402a4c4ba ("kcsan: Add Kernel Concurrency Sanitizer infrastructure")
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Marco Elver <elver@google.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/asm-generic/rwonce.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/asm-generic/rwonce.h b/include/asm-generic/rwonce.h
index 8d0a6280e9824..e9f2b84d2338c 100644
--- a/include/asm-generic/rwonce.h
+++ b/include/asm-generic/rwonce.h
@@ -79,11 +79,14 @@ unsigned long __read_once_word_nocheck(const void *addr)
 	(typeof(x))__read_once_word_nocheck(&(x));			\
 })
 
-static __no_kasan_or_inline
+static __no_sanitize_or_inline
 unsigned long read_word_at_a_time(const void *addr)
 {
+	/* open-coded instrument_read(addr, 1) */
 	kasan_check_read(addr, 1);
-	return *(unsigned long *)addr;
+	kcsan_check_read(addr, 1);
+
+	return READ_ONCE(*(unsigned long *)addr);
 }
 
 #endif /* __ASSEMBLY__ */
-- 
2.39.5



