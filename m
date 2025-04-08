Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F19315B554;
	Tue,  8 Apr 2025 12:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116418; cv=none; b=tPyzvozXmYPTrBkrBaRAIaS0ovmWrqzL37H49H/GJ45xfLG87FqvqZakt4IB2Qr3zulKciwpNWGhaAofyjmPZnv31nY/Itd6yb9y6zHITNE2UIcwgquC5DU5Zg5lhxleX7zUBCPfffhWK+zXwWjmXBpJxKWBxDULaYxjZ0TdMQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116418; c=relaxed/simple;
	bh=HkfHrKbvGhwUaSTzk4saCTfrXDBLNKAlnD/FPCh0xeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zjl0MsTVgdN+Dj56NUiQcN2K5qb2yXa1J2QJy453SgQexzpIbeJAtmZmWppGkSmhQSE6VbGo2Bu0RgGzZQr3pvy9SghLW5uGJqUzE+75sDxGgp1ezhfRsKFj1FuTDapvQP4Ynrbxars+sKAVF6qg+31olp9X4sG9/hQmfZLUslo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQ//eDxL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQ//eDxL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F042C4CEE5;
	Tue,  8 Apr 2025 12:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116418;
	bh=HkfHrKbvGhwUaSTzk4saCTfrXDBLNKAlnD/FPCh0xeg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQ//eDxLx0Be5I47DQ9zQleB05IVpAlU9Is++/zqCRHmL2eoEjroV6GKuvLm2q5Qt
	 0wnfxjomwGU0rKmFdjz4k7Dv+jwPmr1oVJBoVRCzY24nUNQXsfK05EjUgdCWFN6Rhi
	 VwLUt5WNcg6Z3wf0xPVNkCp/H6JX8SBSblQkQrJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/423] dummycon: fix default rows/cols
Date: Tue,  8 Apr 2025 12:47:00 +0200
Message-ID: <20250408104847.929920557@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit beefaba1978c04ea2950d34236f58fe6cf6a7f58 ]

dummycon fails to build on ARM/footbridge when the VGA console is
disabled, since I got the dependencies slightly wrong in a previous
patch:

drivers/video/console/dummycon.c: In function 'dummycon_init':
drivers/video/console/dummycon.c:27:25: error: 'CONFIG_DUMMY_CONSOLE_COLUMNS' undeclared (first use in this function); did you mean 'CONFIG_DUMMY_CONSOLE'?
   27 | #define DUMMY_COLUMNS   CONFIG_DUMMY_CONSOLE_COLUMNS
drivers/video/console/dummycon.c:28:25: error: 'CONFIG_DUMMY_CONSOLE_ROWS' undeclared (first use in this function); did you mean 'CONFIG_DUMMY_CONSOLE'?
   28 | #define DUMMY_ROWS      CONFIG_DUMMY_CONSOLE_ROWS

This only showed up after many thousand randconfig builds on Arm, and
doesn't matter in practice, but should still be fixed. Address it by
using the default row/columns on footbridge after all in that corner
case.

Fixes: 4293b0925149 ("dummycon: limit Arm console size hack to footbridge")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409151512.LML1slol-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/console/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
index bc31db6ef7d26..c4a8f74df2493 100644
--- a/drivers/video/console/Kconfig
+++ b/drivers/video/console/Kconfig
@@ -52,7 +52,7 @@ config DUMMY_CONSOLE
 
 config DUMMY_CONSOLE_COLUMNS
 	int "Initial number of console screen columns"
-	depends on DUMMY_CONSOLE && !ARCH_FOOTBRIDGE
+	depends on DUMMY_CONSOLE && !(ARCH_FOOTBRIDGE && VGA_CONSOLE)
 	default 160 if PARISC
 	default 80
 	help
@@ -62,7 +62,7 @@ config DUMMY_CONSOLE_COLUMNS
 
 config DUMMY_CONSOLE_ROWS
 	int "Initial number of console screen rows"
-	depends on DUMMY_CONSOLE && !ARCH_FOOTBRIDGE
+	depends on DUMMY_CONSOLE && !(ARCH_FOOTBRIDGE && VGA_CONSOLE)
 	default 64 if PARISC
 	default 30 if ARM
 	default 25
-- 
2.39.5



