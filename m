Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230EC36F421;
	Wed, 20 May 2026 17:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298406; cv=none; b=FXYAy4TJmrdch82EyDsBAeAMbqQt5miN4H4rfgSUvuNMEEjYgRDyS2riQjfmtP5Aqi3bB3sLlrOjvlOcbldqYmiGNFMwAU4UKD5ndh9hgjaQthyl0JyAGurq92JVm8L2VTYj77IwQOZ/3VOJ5JbpYXX2G7FYT0BCZFAs+kbad10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298406; c=relaxed/simple;
	bh=cmhqbPYA/ttnF1fcmyshEn7DB9OaRlldczPXkJvnWjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFO/rFltshYM5PtvO97OXXCk4gtTQ1OU18m2D+OiiQtoerLQ+9S5dFa35/be7OokpbYRBW/NirKbEvxTxJL9tS4r0SkRaFKjT/zjpVVJM7MHEK18MAHJL0D+4u8dDW45ewEySf1sZAFLeut5MZdlraGMsKx4kbMOdAGsJsIb/4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIQHiCj4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIQHiCj4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DDE1F000E9;
	Wed, 20 May 2026 17:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298405;
	bh=UkIkVJFU7pXy3x3Z1Dp0aj8LBIXWAn9PuuRi88lLRAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eIQHiCj4WL+bG0M4LdDqqyw9HlxHMFyU+GmLlA1NsRz14Oydn/tbPlnkGz728Abir
	 KLylhd7peA4cBUSgqychJklthPoD2VKbYaDWPZJFv7EU5MrNiyoF4ZROAB2HLgGSZt
	 fRPQgjWk93BdjrAaQAd+UETQpUqDSs6h/c9U8UtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 356/957] vfio: unhide vdev->debug_root
Date: Wed, 20 May 2026 18:13:59 +0200
Message-ID: <20260520162142.250692606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 555aa178f8d22261d71da74df6267e6e6e97f95a ]

When debugfs is disabled, the hisilicon driver now fails to build:

drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c: In function 'hisi_acc_vfio_debug_init':
drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c:1671:62: error: 'struct vfio_device' has no member named 'debug_root'
 1671 |         vfio_dev_migration = debugfs_lookup("migration", vdev->debug_root);
      |                                                              ^~

The driver otherwise relies on dead-code elimination, but this reference
fails. The single struct member is not going to make much of a difference
for memory consumption, so just keep this visible unconditionally.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: b398f91779b8 ("hisi_acc_vfio_pci: register debugfs for hisilicon migration driver")
Link: https://lore.kernel.org/r/20260327165521.3779707-1-arnd@kernel.org
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/vfio.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee5..18fc36aadc326 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -71,13 +71,11 @@ struct vfio_device {
 	u8 iommufd_attached:1;
 #endif
 	u8 cdev_opened:1;
-#ifdef CONFIG_DEBUG_FS
 	/*
 	 * debug_root is a static property of the vfio_device
 	 * which must be set prior to registering the vfio_device.
 	 */
 	struct dentry *debug_root;
-#endif
 };
 
 /**
-- 
2.53.0



