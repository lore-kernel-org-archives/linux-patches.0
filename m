Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E48AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B170C433D2;
	Wed,  4 Jan 2023 16:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849180;
	bh=RgYOqSb9VEXTOoprQI6xWOMh/t5UklMHpPQKAMrXJKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=owF27ZZetYCKG04HaSkMsYlCV6ga2UOoamNCyodLelYsoy8X/8p4JredM24m99dCW
	 /Z9IVhyXV80kulUgBA9tri/e9O7Sbx2mApC5dpP6Gz2mmsYdp1FrOLvv/y8lDgYxAk
	 moCxz9/4iYi/2BFLrUC/Ro+tunqO6sHb3jWp0Tmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 147/207] parisc: Drop locking in pdc console code
Date: Wed,  4 Jan 2023 17:06:45 +0100
Message-Id: <20230104160516.567851199@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Helge Deller <deller@gmx.de>

commit 7dc4dbfe750e1f18c511e73c8ed114da8de9ff85 upstream.

No need to have specific locking for console I/O since
the PDC functions provide an own locking.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/pdc_cons.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 7d0989f523d0..cf3bf8232374 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -12,37 +12,27 @@
 #include <asm/page.h>		/* for PAGE0 */
 #include <asm/pdc.h>		/* for iodc_call() proto and friends */
 
-static DEFINE_SPINLOCK(pdc_console_lock);
-
 static void pdc_console_write(struct console *co, const char *s, unsigned count)
 {
 	int i = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pdc_console_lock, flags);
 	do {
 		i += pdc_iodc_print(s + i, count - i);
 	} while (i < count);
-	spin_unlock_irqrestore(&pdc_console_lock, flags);
 }
 
 #ifdef CONFIG_KGDB
 static int kgdb_pdc_read_char(void)
 {
-	int c;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pdc_console_lock, flags);
-	c = pdc_iodc_getc();
-	spin_unlock_irqrestore(&pdc_console_lock, flags);
+	int c = pdc_iodc_getc();
 
 	return (c <= 0) ? NO_POLL_CHAR : c;
 }
 
 static void kgdb_pdc_write_char(u8 chr)
 {
-	if (PAGE0->mem_cons.cl_class != CL_DUPLEX)
-		pdc_console_write(NULL, &chr, 1);
+	/* no need to print char as it's shown on standard console */
+	/* pdc_iodc_print(&chr, 1); */
 }
 
 static struct kgdb_io kgdb_pdc_io_ops = {
-- 
2.39.0



