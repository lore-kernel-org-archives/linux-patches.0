Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D769C26B08E;
	Tue,  8 Apr 2025 12:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116736; cv=none; b=mdFNLfwK4E/dzb3+UMD2DJBRJDnsbEo6Ev1cBZRx6pymZilCIZwA01q1CXjIffRdeMm8455MIesKyqX3PREluTS87lMMFb260nnyAHTN5QRaHXvmiFKqnBrXqt6g9uLmuEpoYQO8HPK0BnAgqZ2hjU2FGZUvFLYnX3DbHkOPC4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116736; c=relaxed/simple;
	bh=A3dcYTDtbG1CdR8kRRaw4LB/Al1u0r7wGHqnxUA/F8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vzla3LFI3/LWddtqklqhzmL/vWvq8yQkyM8iZAyJlf7CyyPqtegu49mmzfh5rMLC7LRZsVXa1LjYMUj/g9RK7AWrkWbeSvE2jaoK7npglGW37fP/oANlY/lw1YSciYCAnmxYn2or0nYAuf89btCbxQEKUASYaN3turXVG+XsK08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHz2DJia; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHz2DJia"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67076C4CEE5;
	Tue,  8 Apr 2025 12:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116736;
	bh=A3dcYTDtbG1CdR8kRRaw4LB/Al1u0r7wGHqnxUA/F8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHz2DJiabyEol0HUYYSL9dfUfyuSrkwhgU1o7QKZYdaBYF/1JMfhL+2QVOb0xDRt+
	 90S50q3eBoIeA++6h4DnNXShDYcOHmx+Kd3MjKHI/oMtQPtIIKGkH0pg+h/5YMYpr4
	 ZnhpQj6E74UBev7uyeg/3VbFJo6bPPgvOQk31anA=
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
Subject: [PATCH 6.12 249/423] context_tracking: Always inline ct_{nmi,irq}_{enter,exit}()
Date: Tue,  8 Apr 2025 12:49:35 +0200
Message-ID: <20250408104851.534421460@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



