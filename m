Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298C124C067;
	Tue, 29 Apr 2025 17:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946237; cv=none; b=d4nYOEYilk+QaVPSDn+dYQHSMXkp644k/dRlFXMYgNVKuXaTIyI4ZQhPaqMNFeAyknior7eBrD/y5o9q8LPZD0vLMzosTppf3+8cCJJOjjhLTlxAo/tiFOBRy1CtK23IZoH52jTIK68/0VLR2gZHg4B2UORsFIn655prqstkj0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946237; c=relaxed/simple;
	bh=b1YeA0Pz5xmjWXs/2/DBEN1nzPPltWUS2WWL6GBP4IA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKpCmEh2/RrfgjcAgGdrNJV3Kty0zVx+GseUg1aXBRjCYnQ0bkRQ1S/rl+s5dINucdChH2me0GRHbUvGvRNJKJHqGsmQou8lLaLemXysmbgf5wUO2aQm/yhX4HWy3xc3Hs289D2rEw7sEiToDFtRQbHFyalylBRomny6BXVV0ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiRgLpo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiRgLpo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC80C4CEEE;
	Tue, 29 Apr 2025 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946237;
	bh=b1YeA0Pz5xmjWXs/2/DBEN1nzPPltWUS2WWL6GBP4IA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiRgLpo1BydWH+8m4IPeXOwGOXn7vmzK8qwuepphFPe4y36xQAJyDmYvwDegm/nYx
	 lo3kETMfEX0h64nrBD+pTw2BtEXzYzRWnli3i20JUVyUqOHtnuMnUYpquJwUZSyHYu
	 42kLFNKU/jjHksxjEWK70sS3gLlCnLFnZnal7UtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	=?UTF-8?q?=C5=81ukasz=20Bartosik?= <ukaszb@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 200/311] usb: typec: ucsi: return CCI and message from sync_control callback
Date: Tue, 29 Apr 2025 18:40:37 +0200
Message-ID: <20250429161129.206687451@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 667ecac55861281c1f5e107c8550ae893b3984f6 ]

Some of the drivers emulate or handle some of the commands in the
platform-specific way. The code ends up being split between several
callbacks, which complicates emulation.

In preparation to reworking such drivers, move read_cci() and
read_message_in() calls into ucsi_sync_control_common().

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Łukasz Bartosik <ukaszb@chromium.org>
Link: https://lore.kernel.org/r/20250120-ucsi-merge-commands-v2-1-462a1ec22ecc@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/cros_ec_ucsi.c |  5 +++--
 drivers/usb/typec/ucsi/ucsi.c         | 19 +++++++++++--------
 drivers/usb/typec/ucsi/ucsi.h         |  6 ++++--
 drivers/usb/typec/ucsi/ucsi_acpi.c    |  5 +++--
 drivers/usb/typec/ucsi/ucsi_ccg.c     |  5 +++--
 5 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/typec/ucsi/cros_ec_ucsi.c b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
index c605c86167268..744f0709a40ed 100644
--- a/drivers/usb/typec/ucsi/cros_ec_ucsi.c
+++ b/drivers/usb/typec/ucsi/cros_ec_ucsi.c
@@ -105,12 +105,13 @@ static int cros_ucsi_async_control(struct ucsi *ucsi, u64 cmd)
 	return 0;
 }
 
-static int cros_ucsi_sync_control(struct ucsi *ucsi, u64 cmd)
+static int cros_ucsi_sync_control(struct ucsi *ucsi, u64 cmd, u32 *cci,
+				  void *data, size_t size)
 {
 	struct cros_ucsi_data *udata = ucsi_get_drvdata(ucsi);
 	int ret;
 
-	ret = ucsi_sync_control_common(ucsi, cmd);
+	ret = ucsi_sync_control_common(ucsi, cmd, cci, data, size);
 	switch (ret) {
 	case -EBUSY:
 		/* EC may return -EBUSY if CCI.busy is set.
diff --git a/drivers/usb/typec/ucsi/ucsi.c b/drivers/usb/typec/ucsi/ucsi.c
index 2a2915b0a645f..e8c7e9dc49309 100644
--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -55,7 +55,8 @@ void ucsi_notify_common(struct ucsi *ucsi, u32 cci)
 }
 EXPORT_SYMBOL_GPL(ucsi_notify_common);
 
-int ucsi_sync_control_common(struct ucsi *ucsi, u64 command)
+int ucsi_sync_control_common(struct ucsi *ucsi, u64 command, u32 *cci,
+			     void *data, size_t size)
 {
 	bool ack = UCSI_COMMAND(command) == UCSI_ACK_CC_CI;
 	int ret;
@@ -80,6 +81,13 @@ int ucsi_sync_control_common(struct ucsi *ucsi, u64 command)
 	else
 		clear_bit(COMMAND_PENDING, &ucsi->flags);
 
+	if (!ret && cci)
+		ret = ucsi->ops->read_cci(ucsi, cci);
+
+	if (!ret && data &&
+	    (*cci & UCSI_CCI_COMMAND_COMPLETE))
+		ret = ucsi->ops->read_message_in(ucsi, data, size);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(ucsi_sync_control_common);
@@ -95,7 +103,7 @@ static int ucsi_acknowledge(struct ucsi *ucsi, bool conn_ack)
 		ctrl |= UCSI_ACK_CONNECTOR_CHANGE;
 	}
 
-	return ucsi->ops->sync_control(ucsi, ctrl);
+	return ucsi->ops->sync_control(ucsi, ctrl, NULL, NULL, 0);
 }
 
 static int ucsi_run_command(struct ucsi *ucsi, u64 command, u32 *cci,
@@ -108,9 +116,7 @@ static int ucsi_run_command(struct ucsi *ucsi, u64 command, u32 *cci,
 	if (size > UCSI_MAX_DATA_LENGTH(ucsi))
 		return -EINVAL;
 
-	ret = ucsi->ops->sync_control(ucsi, command);
-	if (ucsi->ops->read_cci(ucsi, cci))
-		return -EIO;
+	ret = ucsi->ops->sync_control(ucsi, command, cci, data, size);
 
 	if (*cci & UCSI_CCI_BUSY)
 		return ucsi_run_command(ucsi, UCSI_CANCEL, cci, NULL, 0, false) ?: -EBUSY;
@@ -127,9 +133,6 @@ static int ucsi_run_command(struct ucsi *ucsi, u64 command, u32 *cci,
 	else
 		err = 0;
 
-	if (!err && data && UCSI_CCI_LENGTH(*cci))
-		err = ucsi->ops->read_message_in(ucsi, data, size);
-
 	/*
 	 * Don't ACK connection change if there was an error.
 	 */
diff --git a/drivers/usb/typec/ucsi/ucsi.h b/drivers/usb/typec/ucsi/ucsi.h
index 28780acc4af2e..892bcf8dbcd50 100644
--- a/drivers/usb/typec/ucsi/ucsi.h
+++ b/drivers/usb/typec/ucsi/ucsi.h
@@ -79,7 +79,8 @@ struct ucsi_operations {
 	int (*read_cci)(struct ucsi *ucsi, u32 *cci);
 	int (*poll_cci)(struct ucsi *ucsi, u32 *cci);
 	int (*read_message_in)(struct ucsi *ucsi, void *val, size_t val_len);
-	int (*sync_control)(struct ucsi *ucsi, u64 command);
+	int (*sync_control)(struct ucsi *ucsi, u64 command, u32 *cci,
+			    void *data, size_t size);
 	int (*async_control)(struct ucsi *ucsi, u64 command);
 	bool (*update_altmodes)(struct ucsi *ucsi, struct ucsi_altmode *orig,
 				struct ucsi_altmode *updated);
@@ -531,7 +532,8 @@ void ucsi_altmode_update_active(struct ucsi_connector *con);
 int ucsi_resume(struct ucsi *ucsi);
 
 void ucsi_notify_common(struct ucsi *ucsi, u32 cci);
-int ucsi_sync_control_common(struct ucsi *ucsi, u64 command);
+int ucsi_sync_control_common(struct ucsi *ucsi, u64 command, u32 *cci,
+			     void *data, size_t size);
 
 #if IS_ENABLED(CONFIG_POWER_SUPPLY)
 int ucsi_register_port_psy(struct ucsi_connector *con);
diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index ac1ebb5d95272..0ac6e5ce4a288 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -128,12 +128,13 @@ static int ucsi_gram_read_message_in(struct ucsi *ucsi, void *val, size_t val_le
 	return ret;
 }
 
-static int ucsi_gram_sync_control(struct ucsi *ucsi, u64 command)
+static int ucsi_gram_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
+				  void *data, size_t size)
 {
 	struct ucsi_acpi *ua = ucsi_get_drvdata(ucsi);
 	int ret;
 
-	ret = ucsi_sync_control_common(ucsi, command);
+	ret = ucsi_sync_control_common(ucsi, command, cci, data, size);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index 511dd1b224ae5..43a8a67159d84 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -628,7 +628,8 @@ static int ucsi_ccg_async_control(struct ucsi *ucsi, u64 command)
 	return ccg_write(uc, reg, (u8 *)&command, sizeof(command));
 }
 
-static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command)
+static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command, u32 *cci,
+				 void *data, size_t size)
 {
 	struct ucsi_ccg *uc = ucsi_get_drvdata(ucsi);
 	struct ucsi_connector *con;
@@ -652,7 +653,7 @@ static int ucsi_ccg_sync_control(struct ucsi *ucsi, u64 command)
 		ucsi_ccg_update_set_new_cam_cmd(uc, con, &command);
 	}
 
-	ret = ucsi_sync_control_common(ucsi, command);
+	ret = ucsi_sync_control_common(ucsi, command, cci, data, size);
 
 err_put:
 	pm_runtime_put_sync(uc->dev);
-- 
2.39.5



