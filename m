Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CA046C4B5;
	Tue, 21 Jul 2026 16:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649621; cv=none; b=RwWhtIc4zia08rmUXDYyMmVGsmYRvevflMosHotgsoYk0RpSzofHwyHzQ4nzDqAZ/WdBsSWVLOpZ5bAq5ZhMUPUalhRuzHC5BfLsZeGyYXaKEZm4sxZR4kpmF0/i5ZSzEK7KkBKSqEKMTxyevsuWxLS7Cp5So0nLSkTLCoUljwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649621; c=relaxed/simple;
	bh=sJskEiMJF38jhBqUiBAQNKbUdM4AZ44/E1miyplM3Xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJGYmd/0+Qa/p9lorQCB4gbwuWhxCX3yooAJArcYbGreVNndXSc52TAvIT+cqmfiTjmfApKpXArdxYw7pKBl0/PwVRYJ/GUp9apKzwgBs4w4oYh/z+77PQ9kEl2qowtjiBZy84AgHaAyPqsFg8UJfzIc2y/FQTsiJ65VnrLb6e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtPKAngl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtPKAngl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DA31F000E9;
	Tue, 21 Jul 2026 16:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649620;
	bh=+GikJuas7LhU6ZR5iCGwdBTKzeW7DKTxvDWyoD0o/2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FtPKAnglfcK3J3DBYpKaDXso4V4P4ep1E3YN2TYQmOk1oKmq3p8WdXarFgQlPa5Wm
	 5fN/x58nM2GfPK/f456yOsePpKCYQGKHbmN8kP/VAxkx3DfTnF1xRYBFPbwOfXOtIe
	 M58G4WGR+lWjZMeJs0xjeFgOSiHPPSNy/TyNGuJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Nelson-Moore <enelsonmoore@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	linux-arm-kernel@lists.infradead.org,
	Russell King <linux@armlinux.org.uk>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0602/2077] fbdev/arm: Export acorndata_8x8 font symbol for bootloader
Date: Tue, 21 Jul 2026 17:04:35 +0200
Message-ID: <20260721152607.005716965@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

[ Upstream commit 470ea955a18c76eeb10ca11ffcb2fe923bfc5515 ]

The text display code used in the Risc PC kernel image decompression
code uses arch/arm/boot/compressed/font.c, which includes
lib/fonts/font_acorn_8x8.c, which further includes <linux/font.h>.

Since commit 97df8960240a ("lib/fonts: Provide helpers for calculating
glyph pitch and size") <linux/font.h> contains inline functions that
require __do_div64, which is not linked into the ARM kernel
decompressor. This makes Risc PC zImages fail to build.

Resolve this issue by defining the BOOTLOADER symbol and use it to avoid
a static declaration of the acorndata_8x8 symbol. That way it can be
referenced by the arm bootloader, and other static math functions and
symbols (like __do_div64) stay static and don't get unneccesary included
in the ARM kernel bootloader decompressor object file.

Fixes: 97df8960240a ("lib/fonts: Provide helpers for calculating glyph pitch and size")
Reported-by: Ethan Nelson-Moore <enelsonmoore@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@armlinux.org.uk>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/compressed/Makefile | 2 +-
 lib/fonts/font_acorn_8x8.c        | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index a159120d1e42e2..e3f550d6285786 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -157,4 +157,4 @@ $(obj)/piggy_data: $(obj)/../Image FORCE
 
 $(obj)/piggy.o: $(obj)/piggy_data
 
-CFLAGS_font.o := -Dstatic=
+CFLAGS_font.o := -DBOOTLOADER
diff --git a/lib/fonts/font_acorn_8x8.c b/lib/fonts/font_acorn_8x8.c
index 36c51016769d41..4ff52c79f8c4d6 100644
--- a/lib/fonts/font_acorn_8x8.c
+++ b/lib/fonts/font_acorn_8x8.c
@@ -5,7 +5,12 @@
 
 #define FONTDATAMAX 2048
 
+#ifdef BOOTLOADER
+/* The acorndata_8x8 symbol is needed by the ARM bootloader too. */
+const struct font_data acorndata_8x8 = {
+#else
 static const struct font_data acorndata_8x8 = {
+#endif
 { 0, 0, FONTDATAMAX, 0 }, {
 /* 00 */  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* ^@ */
 /* 01 */  0x7e, 0x81, 0xa5, 0x81, 0xbd, 0x99, 0x81, 0x7e, /* ^A */
-- 
2.53.0



