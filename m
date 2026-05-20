Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04FA436DA03;
	Wed, 20 May 2026 16:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294425; cv=none; b=dupHfQTcVZVJORWMWqCHwm+JUs1KirjDKLIrpVMUzizB0EYO/ocxzUOHHUF7FqfBRacjAxyQS0MwmDAt25eR49QrVu5DlHu0+fIIjjIn6eMuqDah6bTiZwG7BtYb+a299FWVgH912EF0G02tg8Waaw+3ZnjJTDMmqKEefEWarYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294425; c=relaxed/simple;
	bh=c/SAr9x/kmgHY//MzoEgUboyNeOZ5DfJ4tBG1cSH2G0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MdcyvO5IJuzWCqjir0caqb9Ko55Tl2GPT+x9wG48mqIXGwupfFTkQoJHAmfBYFYauqLEzf9jR25YU19xolKg5FFOm+yAJMOqLsM89xiRHcGFlu23aphrJpsOoMjaVv5tRraX9TRAxGv93QipPg/FMZ8eav1UYBiG3kFfnsJFwwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coIE4xhO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coIE4xhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7991F00894;
	Wed, 20 May 2026 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294423;
	bh=6M27JhB+sdFzlv86XenIrYaStKrMa9ynuhP0vO0uePc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=coIE4xhO9RhJlnr2y+PvPT85Tbz9YKmOjO7BJMzeTELYnmHjoVEFL7TcGvsdRTWZz
	 jGaTkfv3nJ77DyRYyEW4INkNCRwksya8mbVw08ZdKHvrQCXy8VyOAWdJIo/WMrBAsd
	 IXvsJpBm5nFJZlOi7Hsq0GF2jTgiXHE7jpdy58fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0033/1146] soundwire: debugfs: initialize firmware_file to empty string
Date: Wed, 20 May 2026 18:04:43 +0200
Message-ID: <20260520162149.132499308@linuxfoundation.org>
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

From: Gui-Dong Han <hanguidong02@gmail.com>

[ Upstream commit 7215e4552f31e53595eae56a834f7e286beecccc ]

Passing NULL to debugfs_create_str() causes a NULL pointer dereference,
and creating debugfs nodes with NULL string pointers is no longer
permitted.

Additionally, firmware_file is a global pointer. Previously, adding every
new slave blindly overwrote it with NULL.

Fix these issues by initializing firmware_file to an allocated empty
string once in the subsystem init path (sdw_debugfs_init), and freeing
it in the exit path. Existing driver code handles empty strings
correctly.

Fixes: fe46d2a4301d ("soundwire: debugfs: add interface to read/write commands")
Reported-by: yangshiguang <yangshiguang@xiaomi.com>
Closes: https://lore.kernel.org/lkml/17647e4c.d461.19b46144a4e.Coremail.yangshiguang1011@163.com/
Signed-off-by: Gui-Dong Han <hanguidong02@gmail.com>
Link: https://patch.msgid.link/20260323085930.88894-4-hanguidong02@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/debugfs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/soundwire/debugfs.c b/drivers/soundwire/debugfs.c
index ccc9670ef77ce..2905ec19b8384 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -358,8 +358,8 @@ void sdw_slave_debugfs_init(struct sdw_slave *slave)
 	debugfs_create_file("go", 0200, d, slave, &cmd_go_fops);
 
 	debugfs_create_file("read_buffer", 0400, d, slave, &read_buffer_fops);
-	firmware_file = NULL;
-	debugfs_create_str("firmware_file", 0200, d, &firmware_file);
+	if (firmware_file)
+		debugfs_create_str("firmware_file", 0200, d, &firmware_file);
 
 	slave->debugfs = d;
 }
@@ -371,10 +371,15 @@ void sdw_slave_debugfs_exit(struct sdw_slave *slave)
 
 void sdw_debugfs_init(void)
 {
+	if (!firmware_file)
+		firmware_file = kstrdup("", GFP_KERNEL);
+
 	sdw_debugfs_root = debugfs_create_dir("soundwire", NULL);
 }
 
 void sdw_debugfs_exit(void)
 {
 	debugfs_remove_recursive(sdw_debugfs_root);
+	kfree(firmware_file);
+	firmware_file = NULL;
 }
-- 
2.53.0



