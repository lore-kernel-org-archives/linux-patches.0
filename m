Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6694317E4
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 04:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SNG8dsJKnqg4yoB1IAs+5+zuDlU3R1ic4tYvheuBHLI=; b=BIJf36tfAUXQXZqcOnbeAxttFX
	jFYQv0XXdHsIqDASqvzeCHFWihKYilk3cBB7YnenzeaqjtnWquPL2Fw2mclByXwyKXocnLBPj/MCX
	RaBePffOxZitWR550+mebrZDyIePhbYVH0r8PHLVLJcQx24hXPGUVuFzs6eBqsxmapMTWV5dPeUOv
	eNLkIn+YKoTteSp0QOkIc8uZW4AlOG4kySu/x+4CVBm28T0TzNfjGU8zpoKzPkyZzXMzw/b14XGcK
	mTSNmUW4cjUWIdFr5LGTpKGAdsPHshNUie5Tz1iOkAOHpuzMM5XNAoc7gkQiVOqLXFUI9cQd1xprT
	kRtI7Whg==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOtyQ-00Er1X-42; Tue, 01 Mar 2022 04:18:54 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Ard Biesheuvel <ardb@kernel.org>,
	linux-efi@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	Octavian Purdila <octavian.purdila@intel.com>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Matt Fleming <matt@codeblueprint.co.uk>
Subject: [PATCH] efi: fix return value of __setup handlers
Date: Mon, 28 Feb 2022 20:18:51 -0800
Message-Id: <20220301041851.12459-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When "dump_apple_properties" is used on the kernel boot command line,
it causes an Unknown parameter message and the string is added to init's
argument strings:

  Unknown kernel command line parameters "dump_apple_properties
    BOOT_IMAGE=/boot/bzImage-517rc6 efivar_ssdt=newcpu_ssdt", will be
    passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
     dump_apple_properties
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     efivar_ssdt=newcpu_ssdt

Similarly when "efivar_ssdt=somestring" is used, it is added to the
Unknown parameter message and to init's environment strings, polluting
them (see examples above).

Change the return value of the __setup functions to 1 to indicate
that the __setup options have been handled.

Fixes: 58c5475aba67 ("x86/efi: Retrieve and assign Apple device properties")
Fixes: 475fb4e8b2f4 ("efi / ACPI: load SSTDs from EFI variables")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>
Cc: Octavian Purdila <octavian.purdila@intel.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
---
 drivers/firmware/efi/apple-properties.c |    2 +-
 drivers/firmware/efi/efi.c              |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- linux-next-20220228.orig/drivers/firmware/efi/apple-properties.c
+++ linux-next-20220228/drivers/firmware/efi/apple-properties.c
@@ -24,7 +24,7 @@ static bool dump_properties __initdata;
 static int __init dump_properties_enable(char *arg)
 {
 	dump_properties = true;
-	return 0;
+	return 1;
 }
 
 __setup("dump_apple_properties", dump_properties_enable);
--- linux-next-20220228.orig/drivers/firmware/efi/efi.c
+++ linux-next-20220228/drivers/firmware/efi/efi.c
@@ -212,7 +212,7 @@ static int __init efivar_ssdt_setup(char
 		memcpy(efivar_ssdt, str, strlen(str));
 	else
 		pr_warn("efivar_ssdt: name too long: %s\n", str);
-	return 0;
+	return 1;
 }
 __setup("efivar_ssdt=", efivar_ssdt_setup);
 
