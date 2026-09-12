Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80A537C916;
	Sat, 12 Sep 2026 16:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229670; cv=none; b=HyEOAlhqek+m/P2pep42uhHpg4SzHOKpQC6EwI5nYHOo7kKPbC7+WTJMKaIL9cdO5N2wRoQ7Tau2dHN3m8BY2WNuwgJe3yEVjoYH4849ub4Qlaa2jyJl4nlrAfrKLmqCvlmAKXCaedSGpiKTIn0LLtehhFQeU7BEQCmB8+f1uYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229670; c=relaxed/simple;
	bh=gZ4Vv5G3kakI1B8T/jxp6GxzZD4P5F5UpuWdv0nVDC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXI0W7+yXqvNod1tnibTeLKyMnT6PllXDlkX0ub2aXNaGj1uuekKpSybCWeRLGg+tZ1Pzhd0LSKoiheSzATCwTnrTWtinaX+llaHjy7ZQOqB02hfisoLDqmaKSd7rY8wAyNlUoR4tcU1u9yjaeOKxeg+hMOz1wOblkGc2vXdwDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AJ2uXTN/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AJ2uXTN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BFD81F000FF;
	Sat, 12 Sep 2026 16:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229669;
	bh=YZncDKrVILnqza02goCHLVmdMROYVNNCOU25lKwjfgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AJ2uXTN/XAyB+yppot0yXR9w0Id3m2ZHoGIt345l/VwpYwguw34XRJALBb3yQAObG
	 Sp1gfieizGc6QiWFMolr2bardxvEVlPhz+gilNQXYWwHia8xbbbYFE7yy4HUfDdzTW
	 kHiUl1Z8tNZlQqIOafMPA/PiDkDdM6NTpNbnoaTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0636/1191] tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64
Date: Sat, 12 Sep 2026 08:56:04 +0200
Message-ID: <20260912065602.540047133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 782f4dbd1794b4f30dc116a7ca42c5962c409be8 ]

hvc_dcc drives the JTAG DCC via the ARMv6/v7 CP14 debug registers
(mrc/mcr p14, 0, rX, c0, c1/c5, 0 in asm/dcc.h). That encoding is
undefined on older ARM cores, and also on ARMv7-M, but HVC_DCC only
depends on ARM, so it can be enabled on e.g. ARM926 (ARCH_MULTI_V5),
where hvc_dcc_console_init() runs __dcc_putchar() at boot and takes an
undefined-instruction trap before the console is up:

  Internal error: Oops - undefined instruction: 0 [#1] ARM
  PC is at hvc_dcc_check+0x50/0x8c
   hvc_dcc_check from hvc_dcc_console_init+0x18/0x48
   hvc_dcc_console_init from console_init+0x58/0x170
  Kernel panic - not syncing: Fatal exception

Restrict HVC_DCC to the CPUs where that encoding is valid: the
CPU_V6 || CPU_V6K || CPU_V7 set that arch/arm/include/debug/icedcc.S
guards it with, plus ARM64.

Fixes: 16c63f8ea49c ("drivers: char: hvc: add arm JTAG DCC console support")
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260717071616.91423-1-kmehltretter@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/hvc/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/hvc/Kconfig b/drivers/tty/hvc/Kconfig
index 4f9264d005c06..8bcc632ed4089 100644
--- a/drivers/tty/hvc/Kconfig
+++ b/drivers/tty/hvc/Kconfig
@@ -79,7 +79,7 @@ config HVC_UDBG
 
 config HVC_DCC
 	bool "ARM JTAG DCC console"
-	depends on ARM || ARM64
+	depends on (ARM && (CPU_V6 || CPU_V6K || CPU_V7)) || ARM64
 	select HVC_DRIVER
 	select SERIAL_CORE_CONSOLE
 	help
-- 
2.53.0



