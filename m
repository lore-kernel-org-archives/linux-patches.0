Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A5B1F8934;
	Tue,  3 Dec 2024 16:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242021; cv=none; b=YjTsn5zWxCH8WNqcMwfWYqHE/DsGWK2AgiB+1tzYHqGT5RRhew715lMlseqg+oM/U/caNMhF7SXTFRPAwhQ60KHZ6fEgI1bOpkLpb492r18f7YBBZi+w1TovGdm5pSjzmF4w9GZJViqKSrt+XmXt08KMAAGtbUAPLfUHU90LxDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242021; c=relaxed/simple;
	bh=cfpgBeBWDVnt3UgyG386MX0x+1uUYHeAmO2wXqgHvFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szjQS+SM5J6x8B2n02pWPmlHIeGC7VncKUeli3lYR5z65c7la4GzglxzVSu+qnLcib+tihqsyT9t1c6Cri6c70fL/Bi754rHuh6lMDTKPwc4kAO8Yp3B4WsddE7xAMnmMwDEzHA6nbm/OL+pk1pDddNPwaEUnluCCqTAYFUo+L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5tMRI8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5tMRI8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26810C4CED6;
	Tue,  3 Dec 2024 16:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242021;
	bh=cfpgBeBWDVnt3UgyG386MX0x+1uUYHeAmO2wXqgHvFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5tMRI8y4JuJnNdjMt5hw0FMc4gp6MCKuaXtnVu+rN7mgdhJddYoVCssrtszfcP6+
	 kIWcGT+xOZZL+PftNJEi2lNQeI42FmuUpOFMvxMRk6FKt/kq8dxshEbtcc5xSeW7Eu
	 JZYhdTK9UANCz11VMKQKgY0ajEFF7KeOZYCjrG3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 553/826] power: reset: ep93xx: add AUXILIARY_BUS dependency
Date: Tue,  3 Dec 2024 15:44:40 +0100
Message-ID: <20241203144805.320718764@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit b6d445f6724deda3fd87fa33358009d947a64c5d ]

This fails to link when compile-testing and the auxiliary bus is not built-in:

x86_64-linux-ld: drivers/power/reset/ep93xx-restart.o: in function `ep93xx_reboot_driver_init':
ep93xx-restart.c:(.init.text+0x11): undefined reference to `__auxiliary_driver_register'
x86_64-linux-ld: drivers/power/reset/ep93xx-restart.o: in function `ep93xx_reboot_driver_exit':
ep93xx-restart.c:(.exit.text+0x8): undefined reference to `auxiliary_driver_unregister'

Add the appropriate dependency.

Fixes: 9fa7cdb4368f ("power: reset: Add a driver for the ep93xx reset")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20241111104418.3891756-1-arnd@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
index 389d5a193e5dc..f5fc33a8bf443 100644
--- a/drivers/power/reset/Kconfig
+++ b/drivers/power/reset/Kconfig
@@ -79,6 +79,7 @@ config POWER_RESET_EP93XX
 	bool "Cirrus EP93XX reset driver" if COMPILE_TEST
 	depends on MFD_SYSCON
 	default ARCH_EP93XX
+	select AUXILIARY_BUS
 	help
 	  This driver provides restart support for Cirrus EP93XX SoC.
 
-- 
2.43.0



