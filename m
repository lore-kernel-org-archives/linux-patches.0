Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418071F7065;
	Tue,  3 Dec 2024 15:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238172; cv=none; b=UT2JiIx4bKapFBFZbyY0lkeJMBL4qhMjDBJDbju8UwsSHoFhPQfbdMdEMuwpQwhmhtkXYXeQSxpyfzXwBqePwcuFaKHzestlBP4Z1hOx7XFj+0Lc4gihEDK/rxfp2Mx4WfBLa6TteWI4iE2aTB2T6On5UPOrB+1Qz+zGt0Ynv1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238172; c=relaxed/simple;
	bh=Z7EN+wLUSjuTe7Dxo7IEfEkT+/tq78SU2lrBlJ5H5iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PBf8CvIjRrWxFibQmHIek2shEdTACF3VgVhi8XwjkJouPnxCIK3muE1mmGgH6aKjhybcMP+BH+yJax5YqmEaqGZIi9vWXxWGTCNI9xxFjn2fba6hbm4/3VZ8Bx1Ig631jD8UJuSBR8WyDeIDf2NJrW/a0SYUnT9bP0+Cd7pi1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcZ2Uy9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcZ2Uy9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCCB1C4CECF;
	Tue,  3 Dec 2024 15:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238172;
	bh=Z7EN+wLUSjuTe7Dxo7IEfEkT+/tq78SU2lrBlJ5H5iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcZ2Uy9DzhT3uoRnby+H9uCnGWE+IxxU2+KzEdrj0eNr8BWNmT/CoW9NSecgXakKS
	 SwiLZrdT8k5E6moebG1hK5b2uX3MYJqwRXdXqw00FAboubUh7nMJV1aUThiQ4BWVzc
	 4AYdTwTDViROSF5b2o/2t1ih5b6NHBSu3JE7xlGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 187/817] watchdog: Add HAS_IOPORT dependency for SBC8360 and SBC7240
Date: Tue,  3 Dec 2024 15:35:59 +0100
Message-ID: <20241203144003.030612953@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Schnelle <schnelle@linux.ibm.com>

[ Upstream commit d4d3125a3452a54acca69050be67b87ee2900e77 ]

Both drivers use I/O port accesses without declaring a dependency on
CONFIG_HAS_IOPORT. For sbc8360_wdt this causes a compile error on UML
once inb()/outb() helpers become conditional.

For sbc7240_wdt this causes no such errors with UML because this driver
depends on both x86_32 and !UML. Nevertheless add HAS_IOPORT as
a dependency for both drivers to be explicit and drop the !UML
dependency for sbc7240_wdt as it is now redundant since UML implies no
HAS_IOPORT.

Fixes: 52df67b6b313 ("watchdog: add HAS_IOPORT dependencies")
Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
index bae1d97cce89b..8a48113ec2ace 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1500,7 +1500,7 @@ config 60XX_WDT
 
 config SBC8360_WDT
 	tristate "SBC8360 Watchdog Timer"
-	depends on X86_32
+	depends on X86_32 && HAS_IOPORT
 	help
 
 	  This is the driver for the hardware watchdog on the SBC8360 Single
@@ -1513,7 +1513,7 @@ config SBC8360_WDT
 
 config SBC7240_WDT
 	tristate "SBC Nano 7240 Watchdog Timer"
-	depends on X86_32 && !UML
+	depends on X86_32 && HAS_IOPORT
 	help
 	  This is the driver for the hardware watchdog found on the IEI
 	  single board computers EPIC Nano 7240 (and likely others). This
-- 
2.43.0



