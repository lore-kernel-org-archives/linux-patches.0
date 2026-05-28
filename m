Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2AF52F260C;
	Thu, 28 May 2026 20:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998619; cv=none; b=govxzvdqdkGqlsnGxzohPX3P6tiwj9txhodJs+BjHwTk7YQIc1vJU/bcChPYDnHzCcQXBr5qlN2uWTs9wHYCSFCC2Gq/pE1joVgfueY6NDafPmi8i586pnfwhZr2skA2fRVI3wXdwtdPznieepyxUznS0ZEJ6vmElU5kHCTantk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998619; c=relaxed/simple;
	bh=y+cc/Iwkc0cqY2HQh+dw2l0mzpEZVjsPlS56ln5fgOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSfpdCHyb6waVvss7sSsnHPBRbPmZF6XTgu1N1W4yiAe0l4vndgiLjH3DgpQltoJr1gSvvLM71Kp7EUqdZYAmxcXMQy1cWDQY7rzCyYh0BiXIYm47U9sGZPJmO+QL9Sa+u4wUTuT9z0xPM4dIeDpVKJHpd2SM+zrJDhCiyXgr+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZcldiUo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZcldiUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE971F000E9;
	Thu, 28 May 2026 20:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998617;
	bh=PaBjsc7gHdENxeR68XjOxPOBqIELnKtO+a5v6WJ4dFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vZcldiUoRh1a/lcL4mYo4Y/gEUHYTDrur9oTL00C3EuzaxZSJ9NmcQB2u57wC6GvF
	 P/mMDfVEOYJf7LFas3YNyHpLb6bjojUVzoj95klRVwPHjNSC+PbelgSS+3rEc7Es7g
	 C8vpJhd6ZiwEg3O61pjbHDGJ7FpU+Ou1fdHGkAwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 201/461] firmware: arm_ffa: Snapshot notifier callbacks under lock
Date: Thu, 28 May 2026 21:45:30 +0200
Message-ID: <20260528194652.907498247@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit 38290b180a4d5746baed796d49f88d56d2f336cd ]

Both notification handlers currently look up a notifier callback under
notify_lock, drop the lock, and then dereference the returned
notifier entry. A concurrent unregister can delete and free that
entry in the gap, leaving the handler to dereference stale memory.

Copy the callback pointer and callback data while notify_lock is
still held and invoke the callback only after the lock is dropped.
This keeps the existing callback execution model while removing the
use-after-free window in both the framework and non-framework
notification paths.

Fixes: 285a5ea0f542 ("firmware: arm_ffa: Add support for handling framework notifications")
Link: https://patch.msgid.link/20260428-ffa_fixes-v2-10-8595ae450034@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 35 ++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 001e6f40881df..aa6b9d52a673f 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -1463,20 +1463,25 @@ static int ffa_notify_send(struct ffa_device *dev, int notify_id,
 
 static void handle_notif_callbacks(u64 bitmap, enum notify_type type)
 {
+	ffa_notifier_cb cb;
+	void *cb_data;
 	int notify_id;
-	struct notifier_cb_info *cb_info = NULL;
 
 	for (notify_id = 0; notify_id <= FFA_MAX_NOTIFICATIONS && bitmap;
 	     notify_id++, bitmap >>= 1) {
 		if (!(bitmap & 1))
 			continue;
 
-		read_lock(&drv_info->notify_lock);
-		cb_info = notifier_hnode_get_by_type(notify_id, type);
-		read_unlock(&drv_info->notify_lock);
+		scoped_guard(read_lock, &drv_info->notify_lock) {
+			struct notifier_cb_info *cb_info;
+
+			cb_info = notifier_hnode_get_by_type(notify_id, type);
+			cb = cb_info ? cb_info->cb : NULL;
+			cb_data = cb_info ? cb_info->cb_data : NULL;
+		}
 
-		if (cb_info && cb_info->cb)
-			cb_info->cb(notify_id, cb_info->cb_data);
+		if (cb)
+			cb(notify_id, cb_data);
 	}
 }
 
@@ -1484,9 +1489,10 @@ static void handle_fwk_notif_callbacks(u32 bitmap)
 {
 	void *buf;
 	uuid_t uuid;
+	void *fwk_cb_data;
 	int notify_id = 0, target;
+	ffa_fwk_notifier_cb fwk_cb;
 	struct ffa_indirect_msg_hdr *msg;
-	struct notifier_cb_info *cb_info = NULL;
 	size_t min_offset = offsetof(struct ffa_indirect_msg_hdr, uuid);
 
 	/* Only one framework notification defined and supported for now */
@@ -1522,12 +1528,17 @@ static void handle_fwk_notif_callbacks(u32 bitmap)
 		ffa_rx_release();
 	}
 
-	read_lock(&drv_info->notify_lock);
-	cb_info = notifier_hnode_get_by_vmid_uuid(notify_id, target, &uuid);
-	read_unlock(&drv_info->notify_lock);
+	scoped_guard(read_lock, &drv_info->notify_lock) {
+		struct notifier_cb_info *cb_info;
+
+		cb_info = notifier_hnode_get_by_vmid_uuid(notify_id, target,
+							  &uuid);
+		fwk_cb = cb_info ? cb_info->fwk_cb : NULL;
+		fwk_cb_data = cb_info ? cb_info->cb_data : NULL;
+	}
 
-	if (cb_info && cb_info->fwk_cb)
-		cb_info->fwk_cb(notify_id, cb_info->cb_data, buf);
+	if (fwk_cb)
+		fwk_cb(notify_id, fwk_cb_data, buf);
 	kfree(buf);
 }
 
-- 
2.53.0



