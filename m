Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35C44EEDE;
	Tue, 20 May 2025 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747749934; cv=none; b=U2jkw7GJMs9k4izaPPuOJzmC4WgVwGax0wQu23/F+UfoC9gT6s/2pE+WEi2nVrX/gVlVaVyBfp0if1XfOwybTBJ+/3tUR04lwl38xwihYHIvC59VZ6OQsWR0V9wUf63VuxrqSK/JyCi/lWmVGJpBVN/7oXz8GcSuOu4a0OdOvIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747749934; c=relaxed/simple;
	bh=3IQ0MggXLNNMNTk1AsJW0ehdEjUAJHt/5vWPEGA45cY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kIvQin9VhNvvqWZXqkm2e9UpvKRJjbvnwTWkoa9auu4HtqtyJveXDIeE12aEo6SK5RdKBxFXdC6oaRGGAdHC62WlrJH8ncKBpjhG2WGvb9/a30FlgB12EHD1f6kYNYtdj0DYCnd2SRSII8QsZgEuyvz3KzzVslFQos5gyCeryqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKblye0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKblye0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF1EC4CEE9;
	Tue, 20 May 2025 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747749934;
	bh=3IQ0MggXLNNMNTk1AsJW0ehdEjUAJHt/5vWPEGA45cY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKblye0KW6ZYeoT3GcCE09w3d2xtknyDAQ2vxw7/BnVQVS73wfKbqwnAW/n3/9Fdj
	 MtyIhWp8ovQBRXXLEzLaz2VXWFkBzt7TyciWlfchCXjcXvvNfyUyLW9PhdT5MCVfNE
	 7YdbiO5y+O4SoXyJ+vc3U9PeYBYCrP95fdp+5Mso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 106/117] usb: typec: ucsi: displayport: Fix deadlock
Date: Tue, 20 May 2025 15:51:11 +0200
Message-ID: <20250520125808.211166529@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
References: <20250520125803.981048184@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/usb/typec/ucsi/ucsi.h        |    2 ++
 3 files changed, 47 insertions(+), 8 deletions(-)

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
@@ -1560,6 +1560,40 @@ void ucsi_set_drvdata(struct ucsi *ucsi,
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
@@ -79,6 +79,8 @@ int ucsi_register(struct ucsi *ucsi);
 void ucsi_unregister(struct ucsi *ucsi);
 void *ucsi_get_drvdata(struct ucsi *ucsi);
 void ucsi_set_drvdata(struct ucsi *ucsi, void *data);
+bool ucsi_con_mutex_lock(struct ucsi_connector *con);
+void ucsi_con_mutex_unlock(struct ucsi_connector *con);
 
 void ucsi_connector_change(struct ucsi *ucsi, u8 num);
 


