Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201532FA3C;
	Mon, 29 Dec 2025 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025794; cv=none; b=utM7PMGsrdtU9Q1ww0CC6kvCyeFejOK9k2h4x4WsUZUO/AjWoP072lfNIUZRbh6FQ64xHMv95o33JbC2XDUjy+1B7oPyXpe8QwNJLudztBGdYDXs6XoSyQ+ZgMSYVOPqcP7VOLiKv0Bj2dAVUQBBWVhfQGQoGS9u2RglRDVaeRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025794; c=relaxed/simple;
	bh=Fu8IKOABUCqDVc8VWaX53X+P63mVamhusaGj8aVg+oU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f9FndL3zEaZtaCqXHhw9P0YYTsRVEXvUArCrCUSOFs50eLqPPV9/qY5AUHXbeCQ3APxONWrB9uVAkEWa/7oIybiq5E+/M831MgYmsfGDFQ01u3Vb+71EtsNMkzmhqVvfQVPdRR6oHpDYF2eMUf5GkXAjcvbz32/zWqyv926vKDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2mi+Z+fq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2mi+Z+fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2F8C4CEF7;
	Mon, 29 Dec 2025 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025794;
	bh=Fu8IKOABUCqDVc8VWaX53X+P63mVamhusaGj8aVg+oU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2mi+Z+fq+WQWBlKwXaujNO1vLP/jjpS+iXdSlG4oW4nFqp8C5ZsufwkvFmHQRl13n
	 XNCWu+YxeTbfMfCM6KXAKijtjHwIPBMJvrP5OvVsVldwoGRel+XyGrNzAdAw6QJ7X9
	 5WDYDBfyNdh0xDoZkKX/TXXvVfwbEJrBVkWqT6ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cedar Maxwell <cedarmaxwell@mac.com>,
	Stan Johnson <userm57@yahoo.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Finn Thain <fthain@linux-m68k.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 338/430] powerpc: Add reloc_offset() to font bitmap pointer used for bootx_printf()
Date: Mon, 29 Dec 2025 17:12:20 +0100
Message-ID: <20251229160736.765335900@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Finn Thain <fthain@linux-m68k.org>

commit b94b73567561642323617155bf4ee24ef0d258fe upstream.

Since Linux v6.7, booting using BootX on an Old World PowerMac produces
an early crash. Stan Johnson writes, "the symptoms are that the screen
goes blank and the backlight stays on, and the system freezes (Linux
doesn't boot)."

Further testing revealed that the failure can be avoided by disabling
CONFIG_BOOTX_TEXT. Bisection revealed that the regression was caused by
a change to the font bitmap pointer that's used when btext_init() begins
painting characters on the display, early in the boot process.

Christophe Leroy explains, "before kernel text is relocated to its final
location ... data is addressed with an offset which is added to the
Global Offset Table (GOT) entries at the start of bootx_init()
by function reloc_got2(). But the pointers that are located inside a
structure are not referenced in the GOT and are therefore not updated by
reloc_got2(). It is therefore needed to apply the offset manually by using
PTRRELOC() macro."

Cc: stable@vger.kernel.org
Link: https://lists.debian.org/debian-powerpc/2025/10/msg00111.html
Link: https://lore.kernel.org/linuxppc-dev/d81ddca8-c5ee-d583-d579-02b19ed95301@yahoo.com/
Reported-by: Cedar Maxwell <cedarmaxwell@mac.com>
Closes: https://lists.debian.org/debian-powerpc/2025/09/msg00031.html
Bisected-by: Stan Johnson <userm57@yahoo.com>
Tested-by: Stan Johnson <userm57@yahoo.com>
Fixes: 0ebc7feae79a ("powerpc: Use shared font data")
Suggested-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Finn Thain <fthain@linux-m68k.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/22b3b247425a052b079ab84da926706b3702c2c7.1762731022.git.fthain@linux-m68k.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/btext.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/powerpc/kernel/btext.c
+++ b/arch/powerpc/kernel/btext.c
@@ -20,6 +20,7 @@
 #include <asm/io.h>
 #include <asm/processor.h>
 #include <asm/udbg.h>
+#include <asm/setup.h>
 
 #define NO_SCROLL
 
@@ -463,7 +464,7 @@ static noinline void draw_byte(unsigned
 {
 	unsigned char *base	= calc_base(locX << 3, locY << 4);
 	unsigned int font_index = c * 16;
-	const unsigned char *font	= font_sun_8x16.data + font_index;
+	const unsigned char *font = PTRRELOC(font_sun_8x16.data) + font_index;
 	int rb			= dispDeviceRowBytes;
 
 	rmci_maybe_on();


