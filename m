Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6828F24418E;
	Tue, 20 May 2025 13:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749263; cv=none; b=SIDClJfTSaQlKNay3pu3i6t00QntdTQJHRcrhxIjb4Vr0Jc6Ef1r3SDlm6SxEn3zBQaRSVDI7ReNYVjAoCJBqSrKzlItPcvevqdnLDHSRiXK0iPToPkLJdb1nBDPTsIV9AboNXoOup/DwaG7r0qp5eclr/mAnB3WSs+HGPCAvsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749263; c=relaxed/simple;
	bh=ogD7nPfkd/ifYeHAs7BFDAO14+y9s8fNjRKFxlfk00c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pyVnZ5UTp2EZ6+m5bLQ9AXtKjUKDsB8BEmZh1I/ysw0OfLPU0XIq+QIJgf7cVEm2HPiueuESJV4nQG1BSgR7WKYjpAyS8ZvGuhKFA85sLBfV0jBU0DZwuxXKUW9E9UKGgkY8whqWqCFhpWRbWDVVOXviZE7DF0jVSt8ykm/VMBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jM6hEy0M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jM6hEy0M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBAE8C4CEE9;
	Tue, 20 May 2025 13:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749263;
	bh=ogD7nPfkd/ifYeHAs7BFDAO14+y9s8fNjRKFxlfk00c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jM6hEy0Mvznp0vOaaHj9QMStYi7pgmXE016R7Coj6Gspyuy4xmz1cbX6kCW418Oeb
	 yEIdTd7OaZSGLe9Fz8xBXLFD4y30r7MJtl/hj/o1+HnwjrfdmoRNjpwV8nLOJtYpp6
	 tIOhMeWaJQ3E5j4NOelkEQCl/E2mF1+qUlfOa1u8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 48/59] usb: typec: ucsi: displayport: Fix deadlock
Date: Tue, 20 May 2025 15:50:39 +0200
Message-ID: <20250520125755.751330699@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
References: <20250520125753.836407405@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Kuchynski <akuchynski@chromium.org>

commit 364618c89d4c57c85e5fc51a2446cd939bf57802 upstream.

This patch introduces the ucsi_con_mutex_lock / ucsi_con_mutex_unlock
functions to the UCSI driver. ucsi_con_mutex_lock ensures the connector
mutex is only locked if a connection is established and the partner pointer
is valid. This resolves a deadlock scenario where
ucsi_displayport_remove_partner holds con->mutex waiting for
dp_altmode_work to complete while dp_altmode_work attempts to acquire it.

Cc: stable <stable@kernel.org>
Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Signed-off-by: Andrei Kuchynski <akuchynski@chromium.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250424084429.3220757-2-akuchynski@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/displayport.c |   19 +++++++++++--------
 drivers/usb/typec/ucsi/ucsi.c        |   34 ++++++++++++++++++++++++++++++++++
 drivers/usb/typec/ucsi/ucsi.h        |    3 +++
 3 files changed, 48 insertions(+), 8 deletions(-)

--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -54,7 +54,8 @@ static int ucsi_displayport_enter(struct
 	u8 cur = 0;
 	int ret;
 
-	mutex_lock(&dp->con->lock);
+	if (!ucsi_con_mutex_lock(dp->con))
+		return -ENOTCONN;
 
 	if (!dp->override && dp->initialized) {
 		const struct typec_altmode *p = typec_altmode_get_partner(alt);
@@ -100,7 +101,7 @@ static int ucsi_displayport_enter(struct
 	schedule_work(&dp->work);
 	ret = 0;
 err_unlock:
-	mutex_unlock(&dp->con->lock);
+	ucsi_con_mutex_unlock(dp->con);
 
 	return ret;
 }
@@ -112,7 +113,8 @@ static int ucsi_displayport_exit(struct
 	u64 command;
 	int ret = 0;
 
-	mutex_lock(&dp->con->lock);
+	if (!ucsi_con_mutex_lock(dp->con))
+		return -ENOTCONN;
 
 	if (!dp->override) {
 		const struct typec_altmode *p = typec_altmode_get_partner(alt);
@@ -144,7 +146,7 @@ static int ucsi_displayport_exit(struct
 	schedule_work(&dp->work);
 
 out_unlock:
-	mutex_unlock(&dp->con->lock);
+	ucsi_con_mutex_unlock(dp->con);
 
 	return ret;
 }
@@ -202,20 +204,21 @@ static int ucsi_displayport_vdm(struct t
 	int cmd = PD_VDO_CMD(header);
 	int svdm_version;
 
-	mutex_lock(&dp->con->lock);
+	if (!ucsi_con_mutex_lock(dp->con))
+		return -ENOTCONN;
 
 	if (!dp->override && dp->initialized) {
 		const struct typec_altmode *p = typec_altmode_get_partner(alt);
 
 		dev_warn(&p->dev,
 			 "firmware doesn't support alternate mode overriding\n");
-		mutex_unlock(&dp->con->lock);
+		ucsi_con_mutex_unlock(dp->con);
 		return -EOPNOTSUPP;
 	}
 
 	svdm_version = typec_altmode_get_svdm_version(alt);
 	if (svdm_version < 0) {
-		mutex_unlock(&dp->con->lock);
+		ucsi_con_mutex_unlock(dp->con);
 		return svdm_version;
 	}
 
@@ -259,7 +262,7 @@ static int ucsi_displayport_vdm(struct t
 		break;
 	}
 
-	mutex_unlock(&dp->con->lock);
+	ucsi_con_mutex_unlock(dp->con);
 
 	return 0;
 }
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1352,6 +1352,40 @@ void ucsi_set_drvdata(struct ucsi *ucsi,
 EXPORT_SYMBOL_GPL(ucsi_set_drvdata);
 
 /**
+ * ucsi_con_mutex_lock - Acquire the connector mutex
+ * @con: The connector interface to lock
+ *
+ * Returns true on success, false if the connector is disconnected
+ */
+bool ucsi_con_mutex_lock(struct ucsi_connector *con)
+{
+	bool mutex_locked = false;
+	bool connected = true;
+
+	while (connected && !mutex_locked) {
+		mutex_locked = mutex_trylock(&con->lock) != 0;
+		connected = con->status.flags & UCSI_CONSTAT_CONNECTED;
+		if (connected && !mutex_locked)
+			msleep(20);
+	}
+
+	connected = connected && con->partner;
+	if (!connected && mutex_locked)
+		mutex_unlock(&con->lock);
+
+	return connected;
+}
+
+/**
+ * ucsi_con_mutex_unlock - Release the connector mutex
+ * @con: The connector interface to unlock
+ */
+void ucsi_con_mutex_unlock(struct ucsi_connector *con)
+{
+	mutex_unlock(&con->lock);
+}
+
+/**
  * ucsi_create - Allocate UCSI instance
  * @dev: Device interface to the PPM (Platform Policy Manager)
  * @ops: I/O routines
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -15,6 +15,7 @@
 
 struct ucsi;
 struct ucsi_altmode;
+struct ucsi_connector;
 
 /* UCSI offsets (Bytes) */
 #define UCSI_VERSION			0
@@ -62,6 +63,8 @@ int ucsi_register(struct ucsi *ucsi);
 void ucsi_unregister(struct ucsi *ucsi);
 void *ucsi_get_drvdata(struct ucsi *ucsi);
 void ucsi_set_drvdata(struct ucsi *ucsi, void *data);
+bool ucsi_con_mutex_lock(struct ucsi_connector *con);
+void ucsi_con_mutex_unlock(struct ucsi_connector *con);
 
 void ucsi_connector_change(struct ucsi *ucsi, u8 num);
 


