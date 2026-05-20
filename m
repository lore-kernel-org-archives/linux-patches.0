Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FD7356748;
	Wed, 20 May 2026 17:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297424; cv=none; b=UAMgyrBYJ2MjNlD/sCOElNj54+sTFSOPVSMHQVDEwP3/7BJU/a8beYdRx5GuwzRPXiIxo2FEjll6FlujDfhHKkZzlKp5siZwSvAlFeFbptO62qP/PUNfeJ2GVV8qKmgj2Z5JmadSyaHV7PNNx5rBzY/I8PUu6V8WrIOaiyqJ20A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297424; c=relaxed/simple;
	bh=LvNqNG5DEekom5ctOw/N9J0GjfdSK0JtDUrHEOgBWY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUQVdmyhSn8lT/u+kz8tf4Y0dQugyP6ukjzpN9MGsqLwER0Y/b+hhkQRDrQXiuLdlvC9fZL3eYuHXvr0gq/hRPegNQxODi9s7ylGe63daSPYqlVLIbLOTVlZtp8MqbnbaK9UJU4xevlOdcyVK7keI20k6LK5nhWphQIcdAzFmxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wkq9VJE6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wkq9VJE6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985241F000E9;
	Wed, 20 May 2026 17:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297423;
	bh=Pz0WrD4+YSTjPdhJepXVCJaRG7vh+XEGXPYFuJpt5DU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wkq9VJE6C3AvsBsE0MroERXK5IEqLCz8+6c019zt1t26SpBjejkMaYPM37HYQNCHj
	 NaO6e9jlREH8+QwH7AqGAlht4pOX2McrRSfLxxueQq0JasrHtGcC5Wdm7Z4lY7Vylj
	 1RLnVrqAaiuYYEZwlDMheM0SZRymKCRzugJfmgj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	yangshiguang <yangshiguang@xiaomi.com>,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 026/957] soundwire: debugfs: initialize firmware_file to empty string
Date: Wed, 20 May 2026 18:08:29 +0200
Message-ID: <20260520162135.126691242@linuxfoundation.org>
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
index 1e0f9318b6165..feb4d15102753 100644
--- a/drivers/soundwire/debugfs.c
+++ b/drivers/soundwire/debugfs.c
@@ -350,8 +350,8 @@ void sdw_slave_debugfs_init(struct sdw_slave *slave)
 	debugfs_create_file("go", 0200, d, slave, &cmd_go_fops);
 
 	debugfs_create_file("read_buffer", 0400, d, slave, &read_buffer_fops);
-	firmware_file = NULL;
-	debugfs_create_str("firmware_file", 0200, d, &firmware_file);
+	if (firmware_file)
+		debugfs_create_str("firmware_file", 0200, d, &firmware_file);
 
 	slave->debugfs = d;
 }
@@ -363,10 +363,15 @@ void sdw_slave_debugfs_exit(struct sdw_slave *slave)
 
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



