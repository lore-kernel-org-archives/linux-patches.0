Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600571FBC82;
	Tue,  3 Dec 2024 15:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240488; cv=none; b=uUJTzixFi2F0LNUGxBTn7qw/AXxLg6PC/zSb3zHJAQnz6I5WVFKBBPGf4CLXROgHFSge+FBNc28T5BpXBGxsw0Zn0uKyMnNOB8NbHX+gvHUuLHXFsUhC73j+DvrDgpJniEvyQloQebOfSjI7yo5+y6VdjRT5z7brtwd0VNgv12k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240488; c=relaxed/simple;
	bh=LgvL5VTWmfSODKVp1ZEXAStYOGM3n0LVBLbVIXB8W/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACRpW/mRCFMpql39dRp8Q+rXj6JIq/XfkZXolrV9hanExU6PBoPLRcPU7CgcmR9h/yjxGazo14qtVXBOp9Az6Azom2FBtZBTXhxuaIl5TOwwD7natuG9WY0N5jWbdV+x/HNIgxoSk+E45wWnBc6YW7Z0TltJThFxn4z6346kedY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jtucOF6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jtucOF6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B20C4CED6;
	Tue,  3 Dec 2024 15:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240488;
	bh=LgvL5VTWmfSODKVp1ZEXAStYOGM3n0LVBLbVIXB8W/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jtucOF6rFNeYmE9mVUYRuhWmfYT3QmFpBOjHHMlUGyTDfZyFCUf8GaJqIq1PEd+M1
	 wt2lvjKpgkQEhO0WRVube8WzYGJoy43EkpKHvRt1BhO7THSVg2wJrgw7thR0gYZNnR
	 oXcL7jlnMEabYJOsjwHKwjMqSmrQ2SHQ/1+WdOsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Niklas Schnelle <schnelle@linux.ibm.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 151/826] watchdog: Add HAS_IOPORT dependency for SBC8360 and SBC7240
Date: Tue,  3 Dec 2024 15:37:58 +0100
Message-ID: <20241203144749.634698904@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 684b9fe84fff5..94c96bcfefe34 100644
--- a/drivers/watchdog/Kconfig
+++ b/drivers/watchdog/Kconfig
@@ -1509,7 +1509,7 @@ config 60XX_WDT
 
 config SBC8360_WDT
 	tristate "SBC8360 Watchdog Timer"
-	depends on X86_32
+	depends on X86_32 && HAS_IOPORT
 	help
 
 	  This is the driver for the hardware watchdog on the SBC8360 Single
@@ -1522,7 +1522,7 @@ config SBC8360_WDT
 
 config SBC7240_WDT
 	tristate "SBC Nano 7240 Watchdog Timer"
-	depends on X86_32 && !UML
+	depends on X86_32 && HAS_IOPORT
 	help
 	  This is the driver for the hardware watchdog found on the IEI
 	  single board computers EPIC Nano 7240 (and likely others). This
-- 
2.43.0



