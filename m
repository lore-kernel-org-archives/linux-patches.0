Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DF0753D0D5;
	Thu, 17 Sep 2026 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659883; cv=none; b=MM5vnx1RB7iWq0tfLi1F3pkuM+kHWiiTOCVWdxlbaYW0u4WOPmDb/xVzcbWm/kWcRQkPNBqF09jgbVN8W0XoG33NIH3pTzcnWsw5jb3SwsbTsbFxx3dazlMixeOs15HBOIqHafRsRo0JQu6RJQ9gGC8RKkZbrkVcwyuYBPbBh3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659883; c=relaxed/simple;
	bh=5jVhXuVbvQXj7/0nXxN9wj7T93PgE51qlsdujWyhb08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rjq8tNdpU51x2IbcIFjtCXJjBaVdNkbJde9KyEve1Ua9tg5ZSX5hfKvMXG39NxTMbZsrHLgY6uZKb8gIMjqQgwv99jx/Qqet6V/1IMJmSuTzQ2V0N7UTqOBmnWDbQ2IEZZzqFOMTw2FZnQxtpgg70Edhkqy1lAhpiIZgB+TM5bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bWU0O++Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bWU0O++Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512BF1F000FF;
	Thu, 17 Sep 2026 15:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659875;
	bh=ZC0uMMpdgSr+Ln8pxgiQQ9oqDju0WLSskjjsOx/cnO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bWU0O++YWuTZ35EVNsRLtSJb747OzYbZ+W44zGT57heSgOmV+eayNKdanz6n5DSSh
	 3JF0NhtG8nBOwXCSIhy0ui2NyL6I9IrwHGgrIoY2Xk5lErZPk7D7fw2CKlZo6HBbyd
	 b9hlnx20TuWE2II9cgD0OFQ+toGyvuM88Fn05un4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Linmao Li <lilinmao@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 402/733] hwmon: (corsair-cpro) Remove debugfs entries when probe fails
Date: Thu, 17 Sep 2026 16:11:50 +0100
Message-ID: <20260917151401.758366898@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4ee875c423c66c45d7ef7bbff403cd0e3971e0a2 ]

ccp_debugfs_init() registers debugfs files whose private data is the devm
allocated ccp.  If hwmon_device_register_with_info() fails right after it,
ccp_probe() returns without removing them: the HID core then frees ccp,
and ccp_remove() is not called for a failed probe, so the files stay
behind.  Reading one of them dereferences the freed pointer.

Remove the debugfs entries on that error path.  debugfs_remove_recursive()
waits for readers already inside the show callbacks, so ccp is no longer
reachable through debugfs by the time probe returns.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-hwmon/20260708031612.BD7E61F000E9@smtp.kernel.org/
Fixes: 5997eb60f896 ("hwmon: (corsair-cpro) Add firmware and bootloader information")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Link: https://patch.msgid.link/20260828061949.3151191-1-lilinmao@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 56de0fe0f544c..c096451526132 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -642,13 +642,15 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 							 ccp, &ccp_chip_info, NULL);
 	if (IS_ERR(ccp->hwmon_dev)) {
 		ret = PTR_ERR(ccp->hwmon_dev);
-		goto out_hw_close;
+		goto out_debugfs_remove;
 	}
 
 	ccp_debugfs_init(ccp, fw_valid, bl_valid);
 
 	return 0;
 
+out_debugfs_remove:
+	debugfs_remove_recursive(ccp->debugfs);
 out_hw_close:
 	hid_hw_close(hdev);
 	hid_device_io_stop(hdev);
-- 
2.53.0



