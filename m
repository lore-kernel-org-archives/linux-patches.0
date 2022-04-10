Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D52139A
	for <patches@lists.linux.dev>; Sun, 10 Apr 2022 21:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4752FC385A4;
	Sun, 10 Apr 2022 21:50:38 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="EoEiRPi7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649627437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sejvMdltPCXTzEKFmNj/gkozCnvR+ZhNjcilYgDYs/4=;
	b=EoEiRPi7bM3YMtpflGeHRv7J7AFQ0XVuLlQurjsdYVJcVAxP5wqdVA0wUOlrZ4G2fY4uTU
	/x0DKnZUf5qImTM6Dm9c1oqi9HGF9/ZbLtd7Tnmf6WKT9TjzeLvt1qNqXN9PoULJRa5XOv
	CMo7MBwGXlZwAxg2G2ZghuGe8iN2KtQ=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 440d167a (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sun, 10 Apr 2022 21:50:37 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Dominik Brodowski <linux@dominikbrodowski.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	"David S . Miller" <davem@davemloft.net>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	John Stultz <john.stultz@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Dinh Nguyen <dinguyen@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org,
	linux-xtensa@linux-xtensa.org
Subject: [PATCH v2 05/11] mips: use ktime_read_raw_clock() for random_get_entropy() instead of zero
Date: Sun, 10 Apr 2022 23:49:45 +0200
Message-Id: <20220410214951.55294-6-Jason@zx2c4.com>
In-Reply-To: <20220410214951.55294-1-Jason@zx2c4.com>
References: <20220410214951.55294-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling ktime_read_raw_clock() would be preferable,
because that always needs to return _something_, even falling back to
jiffies eventually. It's not as though ktime_read_raw_clock() is super
high precision or guaranteed to be entropic, but basically anything
that's not zero all the time is better than returning zero all the time.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/mips/include/asm/timex.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/timex.h b/arch/mips/include/asm/timex.h
index b05bb70a2e46..fa6a5ca20b46 100644
--- a/arch/mips/include/asm/timex.h
+++ b/arch/mips/include/asm/timex.h
@@ -94,7 +94,7 @@ static inline unsigned long random_get_entropy(void)
 	else if (likely(imp != PRID_IMP_R6000 && imp != PRID_IMP_R6000A))
 		return read_c0_random();
 	else
-		return 0;	/* no usable register */
+		return ktime_read_raw_clock();	/* no usable register */
 }
 #define random_get_entropy random_get_entropy
 
-- 
2.35.1

