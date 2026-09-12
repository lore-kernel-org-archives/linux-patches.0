Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75832DE702;
	Sat, 12 Sep 2026 10:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207572; cv=none; b=uJgh91ctHOCihcjKwiB7s1tcEjzQjq+2xeRDCGg/ZNqwNWTYV5UVp9LuJeZWTA7/uKAuDVliSy5ZQ71QLMpXTFOt8prloVFMTr1A3zTG7aC2j74gzu3dRaoj5AOd9nKxkVkzR9QEFlUjtlfMRd/wRKtdODomfJNfc6/EyO/Wtuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207572; c=relaxed/simple;
	bh=92sufL4QrmWtMqoPUA7wJ35nTAz2Ohga/j0tZpc5vGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjpQ/Ij/+RXzbMyVkFLrnvE8SYBlQ5rsVLtjQl9f7tyZvTtl5Sj7cJO5f4twSjZXatNjXZlj50vypotjz8XywPpy4gobPneeUSDjgtNpY0a4Q8sr2DG2tyXNAfRV4Cp3QcRefabLyuarIU1T9ZYvQk+czWJOZ2LrnssKmx7mcMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q28022T2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q28022T2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E131F000FF;
	Sat, 12 Sep 2026 10:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207570;
	bh=K7EheG2zKY7iKeZLOxBkUaQsQSuL67KXLhoB1G5kzNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q28022T2/KEwZ4QzZnjTg/2lW4nBUhH0k7lssKcFwJ58JZ/lfoePisOeAVIkYi6XI
	 db1FTPqPTNPFn9RVH4ezyhWJmyYLNkCB/y7BwXNae/kpcCl8iYjFAmJC7/ugkzR9ck
	 9vz5vjJW3EfL2rsBDyGMTwpQ+VG/Y5OPc6zZfdSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0439/1518] tty: hvc: restrict HVC_DCC to ARMv6+ and ARM64
Date: Sat, 12 Sep 2026 08:43:28 +0200
Message-ID: <20260912065633.381330465@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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



