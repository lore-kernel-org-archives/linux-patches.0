Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F1E41A575;
	Tue, 21 Jul 2026 19:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663026; cv=none; b=dfFvaLXkLwLI9kYoUQxeQ6GOZ81rxh+3L5o4i35amIsy3KIXHHOK99Buw3PMvZIVM7z33oPVGmLiSjCG7jGbApc44HPxR6vpXCKFhyo9PLJRWY72CT6IIf61Uuw1Tg5mc9JPWSs65lcLfidJKbTbOG3DENHIdUdwu6uOCjNxB8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663026; c=relaxed/simple;
	bh=4fdJWMVelVM3ybMWP73Js1cuJsUD3TiLRco1zhIUsXo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PhjPdyxeOJES0opEXvIfHOUXi95KclGUwz1cC9qQGRhKTyrTYCCCC2/ogFJcc7xfsXUwarUMMu35V8p3Em5iI1bfTETvanDHWz8NvgBjMdmGXQCu78XNAjmGQOm1sOH0uQohQPuEJKLo7y+WaDEb19MVEHe23ts4ruZZqFBrJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ga6PB7q/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ga6PB7q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996411F000E9;
	Tue, 21 Jul 2026 19:43:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663025;
	bh=+OL1punbAOqLCwi5YwFMrkXKXbaGgj6K95RQ0IXPLCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ga6PB7q/hEQGcOl9bBBBwqS7+ReL7qha+e2zvfelRbyXa9E/uE6w6/vCordLsyTIk
	 EO1Tk3tbo/MD48hELDCEEKcp3Uv4DZgcXlrIQMbNsHkGFKCc3F8o1oartpVJGoXIQ5
	 GRpkZelGFvasC3aISY7Qb8w/z4tTNXaEVTVmnWBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0667/1276] thermal: testing: zone: Flush work items during cleanup
Date: Tue, 21 Jul 2026 17:18:30 +0200
Message-ID: <20260721152501.032435296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit fb1a5dfe86d3af1e1c3ce168cf0d8d43897e0f77 ]

To prevent freed module code from being executed during the thermal
testing module unload, make it add a dedicated workqueue for thermal
testing work items and flush it in thermal_testing_exit().

Fixes: f6a034f2df42 ("thermal: Introduce a debugfs-based testing facility")
Link: https://sashiko.dev/#/patchset/20260605185212.2491144-1-sam.moelius%40trailofbits.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/1959388.tdWV9SEqCh@rafael.j.wysocki
[ rjw: Make variable d_command static ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/testing/command.c         | 36 ++++++++++++++++++++---
 drivers/thermal/testing/thermal_testing.h |  8 +++++
 drivers/thermal/testing/zone.c            |  7 ++---
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/drivers/thermal/testing/command.c b/drivers/thermal/testing/command.c
index 3c99a771aa6d7e..a0eb43e8fdce77 100644
--- a/drivers/thermal/testing/command.c
+++ b/drivers/thermal/testing/command.c
@@ -86,7 +86,10 @@
 
 #include "thermal_testing.h"
 
-struct dentry *d_testing;
+struct workqueue_struct *tt_wq __ro_after_init;
+
+struct dentry *d_testing __ro_after_init;
+static struct dentry *d_command __ro_after_init;
 
 #define TT_COMMAND_SIZE		16
 
@@ -213,17 +216,42 @@ static const struct file_operations tt_command_fops = {
 
 static int __init thermal_testing_init(void)
 {
+	int error;
+
+	tt_wq = alloc_workqueue("thermal_testing", WQ_UNBOUND, 0);
+	if (!tt_wq)
+		return -ENOMEM;
+
 	d_testing = debugfs_create_dir("thermal-testing", NULL);
-	if (!IS_ERR(d_testing))
-		debugfs_create_file("command", 0200, d_testing, NULL,
-				    &tt_command_fops);
+	if (IS_ERR(d_testing)) {
+		error = PTR_ERR(d_testing);
+		goto destroy_wq;
+	}
+
+	d_command = debugfs_create_file("command", 0200, d_testing, NULL, &tt_command_fops);
+	if (IS_ERR(d_command)) {
+		error = PTR_ERR(d_command);
+		goto remove_d_testing;
+	}
 
 	return 0;
+
+remove_d_testing:
+	debugfs_remove(d_testing);
+destroy_wq:
+	destroy_workqueue(tt_wq);
+	return error;
 }
 module_init(thermal_testing_init);
 
 static void __exit thermal_testing_exit(void)
 {
+	/* First, prevent new commands from being entered. */
+	debugfs_remove(d_command);
+	/* Flush commands in progress (if any). */
+	flush_workqueue(tt_wq);
+	destroy_workqueue(tt_wq);
+	/* Remove the directory structure and clean up. */
 	debugfs_remove(d_testing);
 	tt_zone_cleanup();
 }
diff --git a/drivers/thermal/testing/thermal_testing.h b/drivers/thermal/testing/thermal_testing.h
index c790a32aae4ed7..5880c9a63dba99 100644
--- a/drivers/thermal/testing/thermal_testing.h
+++ b/drivers/thermal/testing/thermal_testing.h
@@ -1,4 +1,12 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/workqueue.h>
+
+extern struct workqueue_struct *tt_wq;
+
+static inline void tt_queue_work(struct work_struct *work)
+{
+	queue_work(tt_wq, work);
+}
 
 extern struct dentry *d_testing;
 
diff --git a/drivers/thermal/testing/zone.c b/drivers/thermal/testing/zone.c
index 1f01f495270313..3d5c6804106a8a 100644
--- a/drivers/thermal/testing/zone.c
+++ b/drivers/thermal/testing/zone.c
@@ -13,7 +13,6 @@
 #include <linux/idr.h>
 #include <linux/list.h>
 #include <linux/thermal.h>
-#include <linux/workqueue.h>
 
 #include "thermal_testing.h"
 
@@ -209,7 +208,7 @@ int tt_add_tz(void)
 
 	INIT_WORK(&tt_work->work, tt_add_tz_work_fn);
 	tt_work->tt_zone = no_free_ptr(tt_zone);
-	schedule_work(&(no_free_ptr(tt_work)->work));
+	tt_queue_work(&(no_free_ptr(tt_work)->work));
 
 	return 0;
 }
@@ -272,7 +271,7 @@ int tt_del_tz(const char *arg)
 
 	INIT_WORK(&tt_work->work, tt_del_tz_work_fn);
 	tt_work->tt_zone = tt_zone;
-	schedule_work(&(no_free_ptr(tt_work)->work));
+	tt_queue_work(&(no_free_ptr(tt_work)->work));
 
 	return 0;
 }
@@ -369,7 +368,7 @@ int tt_zone_add_trip(const char *arg)
 	INIT_WORK(&tt_work->work, tt_zone_add_trip_work_fn);
 	tt_work->tt_zone = no_free_ptr(tt_zone);
 	tt_work->tt_trip = no_free_ptr(tt_trip);
-	schedule_work(&(no_free_ptr(tt_work)->work));
+	tt_queue_work(&(no_free_ptr(tt_work)->work));
 
 	return 0;
 }
-- 
2.53.0



