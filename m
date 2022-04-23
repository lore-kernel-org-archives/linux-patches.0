Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38847C
	for <patches@lists.linux.dev>; Sat, 23 Apr 2022 21:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284B4C385B5;
	Sat, 23 Apr 2022 21:27:37 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kyMVhG7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
	t=1650749255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3TMVtFwVx79Bv/zYq/NVuw6TqFO4X5ToQdno7UhEYGQ=;
	b=kyMVhG7yvaKiRRcIQCVKw5SS/W9uDC1RlWnCqtjZ03EbW0hvM0idc6w7sk99AJgaCn1V75
	lGOjnU4zoOJyYQ0Hp+VXNuxxtlspxxdQYY7ywIXDVXOzj+4l+ZVCluARQJ9D/eKNm4UF4F
	HLoSZNcyXy78PPpIdM3yyXeCUE1kAC8=
Received: 
	by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 5fd212c0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
	Sat, 23 Apr 2022 21:27:35 +0000 (UTC)
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	tglx@linutronix.de,
	arnd@arndb.de
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
	Dinh Nguyen <dinguyen@kernel.org>
Subject: [PATCH v6 12/17] nios2: use fallback for random_get_entropy() instead of zero
Date: Sat, 23 Apr 2022 23:26:18 +0200
Message-Id: <20220423212623.1957011-13-Jason@zx2c4.com>
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
Cc: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 arch/nios2/include/asm/timex.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/nios2/include/asm/timex.h b/arch/nios2/include/asm/timex.h
index a769f871b28d..40a1adc9bd03 100644
--- a/arch/nios2/include/asm/timex.h
+++ b/arch/nios2/include/asm/timex.h
@@ -8,5 +8,8 @@
 typedef unsigned long cycles_t;
 
 extern cycles_t get_cycles(void);
+#define get_cycles get_cycles
+
+#define random_get_entropy() (((unsigned long)get_cycles()) ?: random_get_entropy_fallback())
 
 #endif
-- 
2.35.1

