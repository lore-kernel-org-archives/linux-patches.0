Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C80E7E
	for <patches@lists.linux.dev>; Fri,  4 Mar 2022 01:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=YP/xPHEToJlBuN8DCPqXaoW92yPiieu61YrqcXy3zcY=; b=G8Nwr9R47ujV1G8aAl6Pv5g91x
	SibuUE/P+DNqz6CqPwJWnXtwUQBBdPP1Hj+NCZAjVy8Gv5Jm8Ee0Kec83IdY+lTiSvWVbM5RdjF6G
	JG6tpMekhLPjFctVHoNl4h42K/tZtaGvkbiQbdVs3PSfrqmBZh5d5gSg+5vpIhognJejdExqWOXV/
	X92kUfOnrQF9WibzNGdfv9952u002NOn9e3TmpDR1pCpg7/sbnh3xv5p0qYnJ4/zj4m8rm+WTBjQV
	zhWsnmZP60mEWKpZ5wn5E6tpytH0Rf3kT5729EYmD3WEVcH+cxFZfsQ30IKxUQZbvKRBdyBY3RTRB
	nO6fOvTg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nPwVd-008Dgj-P7; Fri, 04 Mar 2022 01:13:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	kernel test robot <lkp@intel.com>,
	Paul Burton <paulburton@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	linux-mips@vger.kernel.org
Subject: [PATCH] mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
Date: Thu,  3 Mar 2022 17:13:28 -0800
Message-Id: <20220304011328.27459-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Include the DECstation interrupt handler in opting out of
FPU support.

Fixes a linker error:

mips-linux-ld: arch/mips/dec/int-handler.o: in function `fpu':
(.text+0x148): undefined reference to `handle_fpe_int'

Fixes: 183b40f992c8 ("MIPS: Allow FP support to be disabled")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: "Maciej W. Rozycki" <macro@orcam.me.uk>
Cc: linux-mips@vger.kernel.org
---
This builds OK. Is it enough for runtime interrupt handling?

 arch/mips/dec/int-handler.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- mmotm-2022-0302-1653.orig/arch/mips/dec/int-handler.S
+++ mmotm-2022-0302-1653/arch/mips/dec/int-handler.S
@@ -139,7 +139,7 @@
 
 		beqz	t0,spurious
 
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
 		 and	t2,t0
 		bnez	t2,fpu			# handle FPU immediately
 #endif
@@ -280,7 +280,7 @@ handle_it:
 		j	dec_irq_dispatch
 		 nop
 
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
 fpu:
 		lw	t0,fpu_kstat_irq
 		nop
