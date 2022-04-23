Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA8BF3227
	for <patches@lists.linux.dev>; Sat, 23 Apr 2022 21:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0808AC385A0;
	Sat, 23 Apr 2022 21:27:22 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="RCS7oLuO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1650749242;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8nT6xUwGH+T9qZmnLqAVhROTu7pimSJ2l5EYZO/D9qA=;
	b=RCS7oLuOMUgiOHQCqCAP3VfK9UALDHqdovcO7S+nBzOgCFsJfOaeV8NGN1+aRTJRlkaIK7
	s1LYteaAioVy5Ur3QZNGsLY6ce4s+PKiQRplSjG1XRW+2F+eykeOrl5ckifOZBgq+dr+vt
	wASYqtJcR7D552C52EUpGFxgkLADrP8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 85d5eeac (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sat, 23 Apr 2022 21:27:22 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH v6 07/17] m68k: use fallback for random_get_entropy() instead of zero
Date: Sat, 23 Apr 2022 23:26:13 +0200
Message-Id: <20220423212623.1957011-8-Jason@zx2c4.com>
In-Reply-To: <20220423212623.1957011-1-Jason@zx2c4.com>
References: <20220423212623.1957011-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling random_get_entropy_fallback() would be
preferable, because that always needs to return _something_, even
falling back to jiffies eventually. It's not as though
random_get_entropy_fallback() is super high precision or guaranteed to
be entropic, but basically anything that's not zero all the time is
better than returning zero all the time.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/m68k/include/asm/timex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/m68k/include/asm/timex.h b/arch/m68k/include/asm/timex.h
index 6a21d9358280..f4a7a340f4ca 100644
--- a/arch/m68k/include/asm/timex.h
+++ b/arch/m68k/include/asm/timex.h
@@ -35,7 +35,7 @@ static inline unsigned long random_get_entropy(void)
 {
 	if (mach_random_get_entropy)
 		return mach_random_get_entropy();
-	return 0;
+	return random_get_entropy_fallback();
 }
 #define random_get_entropy	random_get_entropy
 
-- 
2.35.1

