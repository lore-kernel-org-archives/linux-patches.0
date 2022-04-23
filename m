Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F67C
	for <patches@lists.linux.dev>; Sat, 23 Apr 2022 21:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CB5BC385A5;
	Sat, 23 Apr 2022 21:27:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="BEZkpuLY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1650749261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LtsT1bg8rxvUBlF/kXwH98fwCiYSInDOUaZObg+GDzI=;
	b=BEZkpuLYc+kRzZgF0QhMewuWGSQIScrjfxolT94RPSCCw6AoQSDUHd29gRXQh5NxXn2tlu
	SA+kCYIyrCzHOguzPz/xF8xLO1nTG4i9m3kNrQvHoOjWXAgeJmoSqMD53vtaBmHU6x9kC8
	io3ZvlAr+RgKr0GvRkJNhAQ4joo/ChU=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ba2011b9 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sat, 23 Apr 2022 21:27:40 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v6 14/17] um: use fallback for random_get_entropy() instead of zero
Date: Sat, 23 Apr 2022 23:26:20 +0200
Message-Id: <20220423212623.1957011-15-Jason@zx2c4.com>
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

This is accomplished by just including the asm-generic code like on
other architectures, which means we can get rid of the empty stub
function here.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/um/include/asm/timex.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/um/include/asm/timex.h b/arch/um/include/asm/timex.h
index e392a9a5bc9b..9f27176adb26 100644
--- a/arch/um/include/asm/timex.h
+++ b/arch/um/include/asm/timex.h
@@ -2,13 +2,8 @@
 #ifndef __UM_TIMEX_H
 #define __UM_TIMEX_H
 
-typedef unsigned long cycles_t;
-
-static inline cycles_t get_cycles (void)
-{
-	return 0;
-}
-
 #define CLOCK_TICK_RATE (HZ)
 
+#include <asm-generic/timex.h>
+
 #endif
-- 
2.35.1

