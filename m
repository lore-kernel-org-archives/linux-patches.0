Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836FE285061;
	Wed, 20 May 2026 16:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295551; cv=none; b=HFQklKOGq60k1BYpPScQ2C5eF6qbO1bCmy4+N136PYiLa/YJ7PrFkXowFH/MNwB5vJGQtMOluCML/NB8T9gIYjZM++4uuugXJsUyQ2icP+gbrAyMhF0eWAO1I6XfvrhzVs+1TrBcVuxQ/apYzGb7YhpcZj8UHbsOUt+FilJmbM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295551; c=relaxed/simple;
	bh=y3b2iVbDttGZ8kNW+IbHPGASZf3lYArUBOQu2lBgfqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpLypKiZAXhdb4hct34p99mFgDPwlbN5xcdcRLNL7SqI/W0fFcI4CN+k2Iz2nKqmFMy7Dndn5ocp2cETwvWtFVVjV93rOFU1RglE7v/K7/7c9v8DSeMLapROO8CGphRYOOJN+HoA1T+Xjy6fY8445HPY0dKANWoQKMXWXaDxka4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mlMPgErl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mlMPgErl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B201F000E9;
	Wed, 20 May 2026 16:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295550;
	bh=BAz2siFvpJoLq9LwMLXKmbVBydjIP4f9FtrrxR+U/GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mlMPgErlGus2w93ba/U7Z6seYwqC76qk/XHpU7JntRecUYg9wS8f3hZFR0P8mzvM7
	 FKzAS/pq8pKR0Ra5FnoNvYLG7Iei+xTlObAobN881VWdxgkPPtwmVPHbOdO3h5KAz1
	 xtNSzDT6DO5A26TBF2h5q8NapMUKYUcl7UoDZbuk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0461/1146] vfio: unhide vdev->debug_root
Date: Wed, 20 May 2026 18:11:51 +0200
Message-ID: <20260520162158.630603524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index e90859956514a..ef02a4996d451 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -72,13 +72,11 @@ struct vfio_device {
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



