Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9457C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:29:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBB65C433D2;
	Mon, 24 Apr 2023 13:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682342972;
	bh=XceAHinoPLvIfUIBuPBswUzyA8nZBrYRZs6HlidQhSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGHYxijAgue2htwz1z8YvvH+ZF5VHXF0slGTZcs+CRAy++Vn5rFmftM8cpv6tqt64
	 69ACNpwbi9phIqeDJB6tt9/GGl1CKPgaA7UPVkvzRFl4EZ3bP57qXBzkTsQFkI+wW7
	 gFXv4DeXOAQB6rOAx4C502dzJ/cG23DvhTdhd+ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WANG Xuerui <git@xen0n.name>,
	Randy Dunlap <rdunlap@infradead.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 028/110] LoongArch: Fix build error if CONFIG_SUSPEND is not set
Date: Mon, 24 Apr 2023 15:16:50 +0200
Message-Id: <20230424131137.183655156@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 1cf62488f5e465b1cd814d19be238a4b7ad5be38 ]

We can see the following build error on LoongArch if CONFIG_SUSPEND is
not set:

  ld: drivers/acpi/sleep.o: in function 'acpi_pm_prepare':
  sleep.c:(.text+0x2b8): undefined reference to 'loongarch_wakeup_start'

Here is the call trace:

  acpi_pm_prepare()
    __acpi_pm_prepare()
      acpi_sleep_prepare()
        acpi_get_wakeup_address()
          loongarch_wakeup_start()

Root cause: loongarch_wakeup_start() is defined in arch/loongarch/power/
suspend_asm.S which is only built under CONFIG_SUSPEND. In order to fix
the build error, just let acpi_get_wakeup_address() return 0 if CONFIG_
SUSPEND is not set.

Fixes: 366bb35a8e48 ("LoongArch: Add suspend (ACPI S3) support")
Reviewed-by: WANG Xuerui <git@xen0n.name>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/all/11215033-fa3c-ecb1-2fc0-e9aeba47be9b@infradead.org/
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/acpi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/loongarch/include/asm/acpi.h b/arch/loongarch/include/asm/acpi.h
index 4198753aa1d0f..976a810352c60 100644
--- a/arch/loongarch/include/asm/acpi.h
+++ b/arch/loongarch/include/asm/acpi.h
@@ -41,8 +41,11 @@ extern void loongarch_suspend_enter(void);
 
 static inline unsigned long acpi_get_wakeup_address(void)
 {
+#ifdef CONFIG_SUSPEND
 	extern void loongarch_wakeup_start(void);
 	return (unsigned long)loongarch_wakeup_start;
+#endif
+	return 0UL;
 }
 
 #endif /* _ASM_LOONGARCH_ACPI_H */
-- 
2.39.2



