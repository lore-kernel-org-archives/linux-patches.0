Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34D43263F4D;
	Tue,  8 Apr 2025 12:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115030; cv=none; b=FxCI4tsfeqnmpPsrcS1Mp+fxOcwwjjWb1Zmzg++wZeXhFcmxOHUJHnqo1qzkA5h8hEVOhFsWZ9JiHLPZSqv2m58DTm51U9Es1v5kfRFhu2kI2V/i7uAoWvAKyGdeq60UgtrWDehXx5z+WhI0m0svJajXWFd2IC4eouqeXUU/2y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115030; c=relaxed/simple;
	bh=PckkhWHm62BoE/wYz+M4gVQFSWSY2swgUmpiiddeWAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKN4La2D2V6hmFU4H99r/anHzK+8t0HLjv57Ou5iCY1CiM3Y22KvMKPAQGBUxvU0K5wRUlJ9tKaXaxXkLmRrMBl7ZjjS4rgx7cHZWdjFrVZZmI/J7Hy8kmd7bG4xSVarZbRkCPdAiywgmZd8gjjA0/gkAchMbdYjfEmW1z0CYOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scZoGCCV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scZoGCCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD6BC4CEE5;
	Tue,  8 Apr 2025 12:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115030;
	bh=PckkhWHm62BoE/wYz+M4gVQFSWSY2swgUmpiiddeWAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scZoGCCV3UDFIwKDmczcQqnATD+9xG4J0EOdswgsDcJZpiublkGGA7tLnXZhg1+o3
	 piA9+VSmMoqReuzWP8X2Dhk6qdYOnydablxKcqI2+/Sbu+HNT6O7Ca7QeQT9NBFtCA
	 u0Cw3FixXpKm4cChSLhEAavuTI8mgnUe3cppNXDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 296/499] context_tracking: Always inline ct_{nmi,irq}_{enter,exit}()
Date: Tue,  8 Apr 2025 12:48:28 +0200
Message-ID: <20250408104858.596915532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 9ac50f7311dc8b39e355582f14c1e82da47a8196 ]

Thanks to CONFIG_DEBUG_SECTION_MISMATCH, empty functions can be
generated out of line.  These can be called from noinstr code, so make
sure they're always inlined.

Fixes the following warnings:

  vmlinux.o: warning: objtool: irqentry_nmi_enter+0xa2: call to ct_nmi_enter() leaves .noinstr.text section
  vmlinux.o: warning: objtool: irqentry_nmi_exit+0x16: call to ct_nmi_exit() leaves .noinstr.text section
  vmlinux.o: warning: objtool: irqentry_exit+0x78: call to ct_irq_exit() leaves .noinstr.text section

Fixes: 6f0e6c1598b1 ("context_tracking: Take IRQ eqs entrypoints over RCU")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Paul E. McKenney <paulmck@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: https://lore.kernel.org/r/8509bce3f536bcd4ae7af3a2cf6930d48c5e631a.1743481539.git.jpoimboe@kernel.org
Closes: https://lore.kernel.org/d1eca076-fdde-484a-b33e-70e0d167c36d@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/context_tracking_irq.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/context_tracking_irq.h b/include/linux/context_tracking_irq.h
index c50b5670c4a52..197916ee91a4b 100644
--- a/include/linux/context_tracking_irq.h
+++ b/include/linux/context_tracking_irq.h
@@ -10,12 +10,12 @@ void ct_irq_exit_irqson(void);
 void ct_nmi_enter(void);
 void ct_nmi_exit(void);
 #else
-static inline void ct_irq_enter(void) { }
-static inline void ct_irq_exit(void) { }
+static __always_inline void ct_irq_enter(void) { }
+static __always_inline void ct_irq_exit(void) { }
 static inline void ct_irq_enter_irqson(void) { }
 static inline void ct_irq_exit_irqson(void) { }
-static inline void ct_nmi_enter(void) { }
-static inline void ct_nmi_exit(void) { }
+static __always_inline void ct_nmi_enter(void) { }
+static __always_inline void ct_nmi_exit(void) { }
 #endif
 
 #endif
-- 
2.39.5



