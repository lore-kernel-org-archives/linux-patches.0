Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E7717C
	for <patches@lists.linux.dev>; Sat, 23 Apr 2022 21:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08187C385A0;
	Sat, 23 Apr 2022 21:27:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="MSYQwMzg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1650749253;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YrlrsyxX3sZtzfHNKb7mYg+twm6XjlLCpZCvOEwIgSU=;
	b=MSYQwMzgIpC6YbxDKPWXfTD4jWLjHswJbBAN+ATkmr1lT1ocWvery8XGXzhBpoyw1qCYD3
	Eg3XvfWI5qXOEjI4gnSgqfSAhcHyykC7szHgryMCTX1vHcE+FfC8cmWQ2pkeLKTX6mQlDE
	9FAfLbA4u3ZheDVeQ+XZGEKfP3VhOz8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id d31ac3b4 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sat, 23 Apr 2022 21:27:33 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jonas Bonn <jonas@southpole.se>,
	Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
	Stafford Horne <shorne@gmail.com>
Subject: [PATCH v6 11/17] openrisc: use fallback for random_get_entropy() instead of zero
Date: Sat, 23 Apr 2022 23:26:17 +0200
Message-Id: <20220423212623.1957011-12-Jason@zx2c4.com>
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
Cc: Jonas Bonn <jonas@southpole.se>
Cc: Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>
Cc: Stafford Horne <shorne@gmail.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/openrisc/include/asm/timex.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/openrisc/include/asm/timex.h b/arch/openrisc/include/asm/timex.h
index d52b4e536e3f..115e89b336cd 100644
--- a/arch/openrisc/include/asm/timex.h
+++ b/arch/openrisc/include/asm/timex.h
@@ -23,6 +23,9 @@ static inline cycles_t get_cycles(void)
 {
 	return mfspr(SPR_TTCR);
 }
+#define get_cycles get_cycles
+
+#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
 
 /* This isn't really used any more */
 #define CLOCK_TICK_RATE 1000
-- 
2.35.1

