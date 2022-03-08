Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038972F33
	for <patches@lists.linux.dev>; Tue,  8 Mar 2022 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=M8LQmozKlMAmwF5ONXTxr0GrFDyz/bb34QoDIznuFrY=; b=mHKKjGaH+5+tBy0yeR0XX1fqT4
	1k5Ej3Zxpm4lGSdY5JsgxYfQY1Tp9xDGkq9uZQW7Mjx0iPu+2Kcu6UmBdmd4uZRfyLvUzH/F5iCGF
	yQw1SfG1I+wmL1VNWerUZ4sypofb0kHsou3Ntr3boSPpG0T+0gKBspE6gISqSm8siVqZZQhOjff5H
	eYdOVzbnN0vt0xAk8chLfdECRQi1RAYR6P7vYwfOqNVAkizMawEEkC18xCITAJbjyH1vB35c2FuFL
	10teRvYsjMIrkhGS5ja7PZ1r7DeLJgCucV0o/+7BxkEWZbsapd41rkrglNO7zVNv4lZlab5ENhnaW
	Yv5x0e4w==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nRPnx-002Tq3-5N; Tue, 08 Mar 2022 02:42:29 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Jingoo Han <jg1.han@samsung.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jirislaby@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Julian Wiedmann <jwi@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH] tty: hvc: fix return value of __setup handler
Date: Mon,  7 Mar 2022 18:42:28 -0800
Message-Id: <20220308024228.20477-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__setup() handlers should return 1 to indicate that the boot option
has been handled or 0 to indicate that it was not handled.
Add a pr_warn() message if the option value is invalid and then
always return 1.

Fixes: 86b40567b917 ("tty: replace strict_strtoul() with kstrtoul()")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Julian Wiedmann <jwi@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
---
 drivers/tty/hvc/hvc_iucv.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-next-20220307.orig/drivers/tty/hvc/hvc_iucv.c
+++ linux-next-20220307/drivers/tty/hvc/hvc_iucv.c
@@ -1417,7 +1417,9 @@ out_error:
  */
 static	int __init hvc_iucv_config(char *val)
 {
-	 return kstrtoul(val, 10, &hvc_iucv_devices);
+	if (kstrtoul(val, 10, &hvc_iucv_devices))
+		pr_warn("hvc_iucv= invalid parameter value '%s'\n", val);
+	return 1;
 }
 
 
