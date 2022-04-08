Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D9029A8
	for <patches@lists.linux.dev>; Fri,  8 Apr 2022 18:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8946FC385A5;
	Fri,  8 Apr 2022 18:23:32 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="X5Gkobvj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649442212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X+SOXCxlTVp5T6r4OXCDhv2RSY3Z97e2yzOuZYoobyg=;
	b=X5Gkobvj4quH9iXj/OmVaky1rOe+XlIiOQkQwsW/YXlqbHU2kvCpAxr3F4BlAiUBJjacz4
	4hLrdMULeI/cM/0ZYjOyJ5ULjjQszeCJT4hYpzk92ZapKgN5ISsrXbdV5iB2kpZxcK0qe6
	yMVMQkcZxubXBYCwgD1TiGQ4JjUNu+I=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a12bc66c (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Fri, 8 Apr 2022 18:23:31 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
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
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	John Stultz <john.stultz@linaro.org>,
	Stephen Boyd <sboyd@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-m68k@lists.linux-m68k.org,
	linux-mips@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	sparclinux@vger.kernel.org,
	linux-um@lists.infradead.org,
	x86@kernel.org,
	linux-xtensa@linux-xtensa.org
Subject: [PATCH RFC v1 10/10] xtensa: use sched_clock() for random_get_entropy() instead of zero
Date: Fri,  8 Apr 2022 20:21:45 +0200
Message-Id: <20220408182145.142506-11-Jason@zx2c4.com>
In-Reply-To: <20220408182145.142506-1-Jason@zx2c4.com>
References: <20220408182145.142506-1-Jason@zx2c4.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the event that random_get_entropy() can't access a cycle counter or
similar, falling back to returning 0 is really not the best we can do.
Instead, at least calling sched_clock() would be preferable, because
that always needs to return _something_, even falling back to jiffies
eventually. It's not as though sched_clock() is super high precision or
guaranteed to be entropic, but basically anything that's not zero all
the time is better than returning zero all the time.

This is accomplished by just including the asm-generic code like on
other architectures, which means we can get rid of the empty stub
function here.

Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/xtensa/include/asm/timex.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/include/asm/timex.h b/arch/xtensa/include/asm/timex.h
index 233ec75e60c6..3f2462f2d027 100644
--- a/arch/xtensa/include/asm/timex.h
+++ b/arch/xtensa/include/asm/timex.h
@@ -29,10 +29,6 @@
 
 extern unsigned long ccount_freq;
 
-typedef unsigned long long cycles_t;
-
-#define get_cycles()	(0)
-
 void local_timer_setup(unsigned cpu);
 
 /*
@@ -59,4 +55,6 @@ static inline void set_linux_timer (unsigned long ccompare)
 	xtensa_set_sr(ccompare, SREG_CCOMPARE + LINUX_TIMER);
 }
 
+#include <asm-generic/timex.h>
+
 #endif	/* _XTENSA_TIMEX_H */
-- 
2.35.1

