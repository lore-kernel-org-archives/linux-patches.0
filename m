Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BA8347B437;
	Sat, 12 Sep 2026 12:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215652; cv=none; b=goIjSXdQN21EZCNDI0oBloxSWLKaFbwQUenAjBEhNMPU469mv9d7s6zanqk70ih72vzWUybliPp4poCU/BrUdhwxeVF8XUgntijUq2Q4eTAkuJAamr055sVhSQ5eLWen1hFvLLwHAmbj0Mypd45BV0N32Rgu8z1nNoVFmrzxyas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215652; c=relaxed/simple;
	bh=Ab2t4j01oDBkMTzWwTjW+L3vsAW9+NmW0gjFDCh3kJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TqVO3tiG9d9i+jz/NwoVkTn9sjcxtIK4ewFarK/ay/H3VQq/4BysCZnKKCmbysYX9j6aXHDCzTefnuU/aINwed4b16kpsFrAsng0AGP1N6+SEyNNmFl7GELQuV21zWRriytkyUy4MjYVnQTuFii6H/ggOP2gKsaSpk2ZnG11Wag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oPKHOXv2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oPKHOXv2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45631F000FF;
	Sat, 12 Sep 2026 12:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215649;
	bh=X1WAkt6r0E3dHH+sY3L0bAjHhLvE2yUnqlQQtmHZENM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oPKHOXv2weCDdODgGDMAZ1W3673n1oLIa6qGYbOks5UalSH7jEqba/G4OVf9KY9VO
	 UuRV7dqeRJtjrS66rk3kqNq0AfgsOqzmowAZViC6FtwPNwECCz3jh4sKIlJ6mgtuVV
	 pwlJQeh8QIY8ao1ag82mZNVMYvWfb0IJ6QWwoxY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0576/1376] tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64
Date: Sat, 12 Sep 2026 08:50:02 +0200
Message-ID: <20260912065620.368291134@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c2a4e88b328f3..5866195de26a6 100644
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



