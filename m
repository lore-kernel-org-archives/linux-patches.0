Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DABA3BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:54:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DLhwtoUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD363C433C9;
	Wed, 15 Nov 2023 19:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078097;
	bh=Gbj0sIa13sAJcySTYcPIKVpQz2eyUQEEv05shIUoM3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DLhwtoUW539pWFc+3uPCvDk98ou+GyBf6sRzGF0wbib9iRgMz7QamZuYT0jnMCTv9
	 3vyePE4WrMCB5bbk4u6frOLv71oj8O/5NNmRSuMXOGm/dlpqWD5cXh8/9k9+A+GzOS
	 c5/f4XWvT1JO0PfxfKBwlnGviHTgNbgBniR663Ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/379] platform/x86: wmi: Fix opening of char device
Date: Wed, 15 Nov 2023 14:23:02 -0500
Message-ID: <20231115192651.458460589@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit eba9ac7abab91c8f6d351460239108bef5e7a0b6 ]

Since commit fa1f68db6ca7 ("drivers: misc: pass miscdevice pointer via
file private data"), the miscdevice stores a pointer to itself inside
filp->private_data, which means that private_data will not be NULL when
wmi_char_open() is called. This might cause memory corruption should
wmi_char_open() be unable to find its driver, something which can
happen when the associated WMI device is deleted in wmi_free_devices().

Fix the problem by using the miscdevice pointer to retrieve the WMI
device data associated with a char device using container_of(). This
also avoids wmi_char_open() picking a wrong WMI device bound to a
driver with the same name as the original driver.

Fixes: 44b6b7661132 ("platform/x86: wmi: create userspace interface for drivers")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20231020211005.38216-5-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 0fcfdc574191b..2b79377cc21e2 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -849,21 +849,13 @@ static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 }
 static int wmi_char_open(struct inode *inode, struct file *filp)
 {
-	const char *driver_name = filp->f_path.dentry->d_iname;
-	struct wmi_block *wblock;
-	struct wmi_block *next;
-
-	list_for_each_entry_safe(wblock, next, &wmi_block_list, list) {
-		if (!wblock->dev.dev.driver)
-			continue;
-		if (strcmp(driver_name, wblock->dev.dev.driver->name) == 0) {
-			filp->private_data = wblock;
-			break;
-		}
-	}
+	/*
+	 * The miscdevice already stores a pointer to itself
+	 * inside filp->private_data
+	 */
+	struct wmi_block *wblock = container_of(filp->private_data, struct wmi_block, char_dev);
 
-	if (!filp->private_data)
-		return -ENODEV;
+	filp->private_data = wblock;
 
 	return nonseekable_open(inode, filp);
 }
-- 
2.42.0



