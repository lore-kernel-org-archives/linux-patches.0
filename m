Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CE8AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25448C433D2;
	Wed,  4 Jan 2023 16:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849186;
	bh=MYO0wgBWbAV5yh3M0dPp84M6RWXDjl3eWW7uR7rcwN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPPZBFq/pFyukm/wzBeBQP6twvxUkmoiq8kFDFu7fnq++Ab8faw2LPDuWRwsLBVWT
	 CEoychLc8aA9ey0LK/DuMWFTD5uwBxxBmbiIbty90NqAA8RnoHNK5/qQCf5SGMb8SW
	 1yCmPq30a/pTo2WbMTL3gcv5SJzgtyAxykq1buhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.1 148/207] parisc: Fix locking in pdc_iodc_print() firmware call
Date: Wed,  4 Jan 2023 17:06:46 +0100
Message-Id: <20230104160516.597569546@linuxfoundation.org>
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

commit 7236aae5f81f3efbd93d0601e74fc05994bc2580 upstream.

Utilize pdc_lock spinlock to protect parallel modifications of the
iodc_dbuf[] buffer, check length to prevent buffer overflow of
iodc_dbuf[], drop the iodc_retbuf[] buffer and fix some wrong
indentings.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c |   24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1288,9 +1288,8 @@ void pdc_io_reset_devices(void)
 
 #endif /* defined(BOOTLOADER) */
 
-/* locked by pdc_console_lock */
-static int __attribute__((aligned(8)))   iodc_retbuf[32];
-static char __attribute__((aligned(64))) iodc_dbuf[4096];
+/* locked by pdc_lock */
+static char iodc_dbuf[4096] __page_aligned_bss;
 
 /**
  * pdc_iodc_print - Console print using IODC.
@@ -1307,6 +1306,9 @@ int pdc_iodc_print(const unsigned char *
 	unsigned int i;
 	unsigned long flags;
 
+	count = min_t(unsigned int, count, sizeof(iodc_dbuf));
+
+	spin_lock_irqsave(&pdc_lock, flags);
 	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
@@ -1322,12 +1324,11 @@ int pdc_iodc_print(const unsigned char *
 	}
 
 print:
-        spin_lock_irqsave(&pdc_lock, flags);
-        real32_call(PAGE0->mem_cons.iodc_io,
-                    (unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
-                    PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
-                    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
-        spin_unlock_irqrestore(&pdc_lock, flags);
+	real32_call(PAGE0->mem_cons.iodc_io,
+		(unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
+		PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
+		__pa(pdc_result), 0, __pa(iodc_dbuf), i, 0);
+	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	return i;
 }
@@ -1354,10 +1355,11 @@ int pdc_iodc_getc(void)
 	real32_call(PAGE0->mem_kbd.iodc_io,
 		    (unsigned long)PAGE0->mem_kbd.hpa, ENTRY_IO_CIN,
 		    PAGE0->mem_kbd.spa, __pa(PAGE0->mem_kbd.dp.layers), 
-		    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), 1, 0);
+		    __pa(pdc_result), 0, __pa(iodc_dbuf), 1, 0);
 
 	ch = *iodc_dbuf;
-	status = *iodc_retbuf;
+	/* like convert_to_wide() but for first return value only: */
+	status = *(int *)&pdc_result;
 	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	if (status == 0)


