Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1F139A
	for <patches@lists.linux.dev>; Sun, 10 Apr 2022 21:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA62C385A5;
	Sun, 10 Apr 2022 21:50:49 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="eYFoGmmo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1649627448;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XGGw/2OLV9XBv7hCdHmioHEJlceq6MZoyaNom0couuU=;
	b=eYFoGmmo8Dt/9ijlnNQRwao6VRVAUmVZ8OjQCi65Uj2pkdtlxXF4NqJPRINb2QSw1Es4LG
	exj/uAqtkrm562joHuvbgsNSoj++sHxYW8y36ud/bfe1FofaUFalJPd7C8U1Gkx0LzomSD
	VKsm/ImybmHqWCeMOLGftiBgl+U7nsk=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 074745f1 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sun, 10 Apr 2022 21:50:48 +0000 (UTC)
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
Subject: [PATCH v2 07/11] nios2: use ktime_read_raw_clock() for random_get_entropy() instead of zero
Date: Sun, 10 Apr 2022 23:49:47 +0200
Message-Id: <20220410214951.55294-8-Jason@zx2c4.com>
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
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/nios2/include/asm/timex.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/nios2/include/asm/timex.h b/arch/nios2/include/asm/timex.h
index a769f871b28d..3c74d3e337a0 100644
--- a/arch/nios2/include/asm/timex.h
+++ b/arch/nios2/include/asm/timex.h
@@ -9,4 +9,6 @@ typedef unsigned long cycles_t;
 
 extern cycles_t get_cycles(void);
 
+#define random_get_entropy() ((unsigned long)(get_cycles() ?: ktime_read_raw_clock()))
+
 #endif
-- 
2.35.1

