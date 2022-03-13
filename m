Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9C7816
	for <patches@lists.linux.dev>; Sun, 13 Mar 2022 06:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TXfzceAStKfRWW5SY5h7OZXN9kLSLV3yQCvecqnCkVU=; b=h40sZ+KjtiZzznLAHbOtKlkAHk
	nwANXLoMXHLKo7CrAjQA+tW+7zZN1g/vk8w3nWRWdeUYYM+mzINUSuGfqmupwvv12QjoAYdtfw7P0
	Z537z04yLlppkailK+ydEjM/v5vFJ+y/Ml3j4GJVaoxtPPjp47n1SdzedUvB95ulu7B7I67BAzLcF
	kEOkQSAmFVVpdAd7s0RGEYPIdUSjHRSHK2FW0U6O+D6XTi7TNBzv82nqzYPS1oUO+3bTPBjIxcF6A
	WBzw/OREDWO+/yYXuc5j0yynI2uePRBNSnhlPqu7W9mDVvvDSrgI4zlMExfHGIo9wIaSHY13JhfvQ
	dZBTy49Q==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nTICW-002Hbv-UH; Sun, 13 Mar 2022 06:59:37 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linuxppc-dev@lists.ozlabs.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Paul Mackerras <paulus@samba.org>
Subject: [PATCH] powerpc/xive: fix return value of __setup handler
Date: Sat, 12 Mar 2022 22:59:36 -0800
Message-Id: <20220313065936.4363-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from xive_off() and xive_store_eoi_cmdline().

Fixes: 243e25112d06 ("powerpc/xive: Native exploitation of the XIVE interrupt controller")
Fixes: c21ee04f11ae ("powerpc/xive: Add a kernel parameter for StoreEOI")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
From: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Cédric Le Goater <clg@kaod.org>
Cc: Paul Mackerras <paulus@samba.org>
---
 arch/powerpc/sysdev/xive/common.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20220310.orig/arch/powerpc/sysdev/xive/common.c
+++ linux-next-20220310/arch/powerpc/sysdev/xive/common.c
@@ -1708,20 +1708,20 @@ __be32 *xive_queue_page_alloc(unsigned i
 static int __init xive_off(char *arg)
 {
 	xive_cmdline_disabled = true;
-	return 0;
+	return 1;
 }
 __setup("xive=off", xive_off);
 
 static int __init xive_store_eoi_cmdline(char *arg)
 {
 	if (!arg)
-		return -EINVAL;
+		return 1;
 
 	if (strncmp(arg, "off", 3) == 0) {
 		pr_info("StoreEOI disabled on kernel command line\n");
 		xive_store_eoi = false;
 	}
-	return 0;
+	return 1;
 }
 __setup("xive.store-eoi=", xive_store_eoi_cmdline);
 
