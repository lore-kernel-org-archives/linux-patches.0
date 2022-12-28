Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4011863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:48:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BEAC433D2;
	Wed, 28 Dec 2022 14:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672238916;
	bh=Zj9v1liHklHYKjP0Yes7cbUTORLjQ//yW9lHFa/qzgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ZAftvPLdS4nGyZ4zaeiT2FnYvUMboHA0BldnxF7J9yy1wKHYYJuFuGOgf8Mre2Fn
	 1f0Itj78u4OyifDFWcJT69kh/1hB5baEDHwwYJib5INmNuL1GwWllLPhMUSMOuMspy
	 3omxnuu1f0o6Y/rG5VElczqNPwtVgRkZuoKOB2IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Brown <doug@schmorgal.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/731] ARM: mmp: fix timer_read delay
Date: Wed, 28 Dec 2022 15:32:46 +0100
Message-Id: <20221228144258.265194810@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Doug Brown <doug@schmorgal.com>

[ Upstream commit e348b4014c31041e13ff370669ba3348c4d385e3 ]

timer_read() was using an empty 100-iteration loop to wait for the
TMR_CVWR register to capture the latest timer counter value. The delay
wasn't long enough. This resulted in CPU idle time being extremely
underreported on PXA168 with CONFIG_NO_HZ_IDLE=y.

Switch to the approach used in the vendor kernel, which implements the
capture delay by reading TMR_CVWR a few times instead.

Fixes: 49cbe78637eb ("[ARM] pxa: add base support for Marvell's PXA168 processor line")
Signed-off-by: Doug Brown <doug@schmorgal.com>
Link: https://lore.kernel.org/r/20221204005117.53452-3-doug@schmorgal.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-mmp/time.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-mmp/time.c b/arch/arm/mach-mmp/time.c
index 41b2e8abc9e6..708816caf859 100644
--- a/arch/arm/mach-mmp/time.c
+++ b/arch/arm/mach-mmp/time.c
@@ -43,18 +43,21 @@
 static void __iomem *mmp_timer_base = TIMERS_VIRT_BASE;
 
 /*
- * FIXME: the timer needs some delay to stablize the counter capture
+ * Read the timer through the CVWR register. Delay is required after requesting
+ * a read. The CR register cannot be directly read due to metastability issues
+ * documented in the PXA168 software manual.
  */
 static inline uint32_t timer_read(void)
 {
-	int delay = 100;
+	uint32_t val;
+	int delay = 3;
 
 	__raw_writel(1, mmp_timer_base + TMR_CVWR(1));
 
 	while (delay--)
-		cpu_relax();
+		val = __raw_readl(mmp_timer_base + TMR_CVWR(1));
 
-	return __raw_readl(mmp_timer_base + TMR_CVWR(1));
+	return val;
 }
 
 static u64 notrace mmp_read_sched_clock(void)
-- 
2.35.1



