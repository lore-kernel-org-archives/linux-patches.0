Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D86071514DC;
	Tue,  2 Jul 2024 17:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941248; cv=none; b=CxNDbvggur/ZxXK+SkYXgoEcy8lP3u1xFYf3HpDAVdKOP9diFYGO8WOyyfSdX+ilARQeEEThNgoJfZ5vmO++zETxqHGgFo+ZHD+qdTjbp9aLllrC7DP57zrja0Oai+Z+JNSyMK2+9uXOO0I2ZptDvYq88swBShHBmv9Q2ceE+B4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941248; c=relaxed/simple;
	bh=J6KN1FZdNtRaRSApPyTaHk0YxMvKzAaslr4lXvCPKDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jpbkg/2/vO0Y1SiWmiaLRO8wUdTejlpBped6ZySvoYQh1qH59zCIeHx/ZKr9g4agEnpiNPxQ8AsHLIoX48D4mFDspFkns5vMulChcHrHalJ5vO7ld+DX61TdZ8CE3YQ0exaoxBlUcOQRE4gFVhNXz8WJeVF9pSxcIwXWGgtl8yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wv5iyhEV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wv5iyhEV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B13CC116B1;
	Tue,  2 Jul 2024 17:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941248;
	bh=J6KN1FZdNtRaRSApPyTaHk0YxMvKzAaslr4lXvCPKDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wv5iyhEVtQkOwiI6jDg0JDHGqltWoi0zE/PpkTmiahOV+sm5nVuN4SQnFF23AVHjn
	 4a35bV1BzR9oMtVsefBoPTci2vY99Fj8ATzULdrV3bDhH/UYsiDyGvH9xdVbmDpxg7
	 pysjTrRKr6MNtDrwfbBOI5IdKoKLpEQWhIwjhaog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/128] usb: typec: ucsi: Never send a lone connector change ack
Date: Tue,  2 Jul 2024 19:03:22 +0200
Message-ID: <20240702170226.290822179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

[ Upstream commit de52aca4d9d56c3b2f00b638d457075914b1a227 ]

Some PPM implementation do not like UCSI_ACK_CONNECTOR_CHANGE
without UCSI_ACK_COMMAND_COMPLETE. Moreover, doing this is racy
as it requires sending two UCSI_ACK_CC_CI commands in a row and
the second one will be started with UCSI_CCI_ACK_COMPLETE already
set in CCI.

Bundle the UCSI_ACK_CONNECTOR_CHANGE with the UCSI_ACK_COMMAND_COMPLETE
for the UCSI_GET_CONNECTOR_STATUS command that is sent while
handling a connector change event.

Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240327224554.1772525-3-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8bdf8a42bca4 ("usb: typec: ucsi: Ack also failed Get Error commands")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   48 ++++++++++++++++++------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -36,22 +36,16 @@
  */
 #define UCSI_SWAP_TIMEOUT_MS	5000
 
-static int ucsi_acknowledge_command(struct ucsi *ucsi)
+static int ucsi_acknowledge(struct ucsi *ucsi, bool conn_ack)
 {
 	u64 ctrl;
 
 	ctrl = UCSI_ACK_CC_CI;
 	ctrl |= UCSI_ACK_COMMAND_COMPLETE;
-
-	return ucsi->ops->sync_write(ucsi, UCSI_CONTROL, &ctrl, sizeof(ctrl));
-}
-
-static int ucsi_acknowledge_connector_change(struct ucsi *ucsi)
-{
-	u64 ctrl;
-
-	ctrl = UCSI_ACK_CC_CI;
-	ctrl |= UCSI_ACK_CONNECTOR_CHANGE;
+	if (conn_ack) {
+		clear_bit(EVENT_PENDING, &ucsi->flags);
+		ctrl |= UCSI_ACK_CONNECTOR_CHANGE;
+	}
 
 	return ucsi->ops->sync_write(ucsi, UCSI_CONTROL, &ctrl, sizeof(ctrl));
 }
@@ -64,7 +58,7 @@ static int ucsi_read_error(struct ucsi *
 	int ret;
 
 	/* Acknowledge the command that failed */
-	ret = ucsi_acknowledge_command(ucsi);
+	ret = ucsi_acknowledge(ucsi, false);
 	if (ret)
 		return ret;
 
@@ -76,7 +70,7 @@ static int ucsi_read_error(struct ucsi *
 	if (ret)
 		return ret;
 
-	ret = ucsi_acknowledge_command(ucsi);
+	ret = ucsi_acknowledge(ucsi, false);
 	if (ret)
 		return ret;
 
@@ -139,7 +133,7 @@ static int ucsi_exec_command(struct ucsi
 		return -EIO;
 
 	if (cci & UCSI_CCI_NOT_SUPPORTED) {
-		if (ucsi_acknowledge_command(ucsi) < 0)
+		if (ucsi_acknowledge(ucsi, false) < 0)
 			dev_err(ucsi->dev,
 				"ACK of unsupported command failed\n");
 		return -EOPNOTSUPP;
@@ -152,15 +146,15 @@ static int ucsi_exec_command(struct ucsi
 	}
 
 	if (cmd == UCSI_CANCEL && cci & UCSI_CCI_CANCEL_COMPLETE) {
-		ret = ucsi_acknowledge_command(ucsi);
+		ret = ucsi_acknowledge(ucsi, false);
 		return ret ? ret : -EBUSY;
 	}
 
 	return UCSI_CCI_LENGTH(cci);
 }
 
-int ucsi_send_command(struct ucsi *ucsi, u64 command,
-		      void *data, size_t size)
+static int ucsi_send_command_common(struct ucsi *ucsi, u64 command,
+				    void *data, size_t size, bool conn_ack)
 {
 	u8 length;
 	int ret;
@@ -179,7 +173,7 @@ int ucsi_send_command(struct ucsi *ucsi,
 			goto out;
 	}
 
-	ret = ucsi_acknowledge_command(ucsi);
+	ret = ucsi_acknowledge(ucsi, conn_ack);
 	if (ret)
 		goto out;
 
@@ -188,6 +182,12 @@ out:
 	mutex_unlock(&ucsi->ppm_lock);
 	return ret;
 }
+
+int ucsi_send_command(struct ucsi *ucsi, u64 command,
+		      void *data, size_t size)
+{
+	return ucsi_send_command_common(ucsi, command, data, size, false);
+}
 EXPORT_SYMBOL_GPL(ucsi_send_command);
 
 /* -------------------------------------------------------------------------- */
@@ -785,7 +785,9 @@ static void ucsi_handle_connector_change
 	mutex_lock(&con->lock);
 
 	command = UCSI_GET_CONNECTOR_STATUS | UCSI_CONNECTOR_NUMBER(con->num);
-	ret = ucsi_send_command(ucsi, command, &con->status, sizeof(con->status));
+
+	ret = ucsi_send_command_common(ucsi, command, &con->status,
+				       sizeof(con->status), true);
 	if (ret < 0) {
 		dev_err(ucsi->dev, "%s: GET_CONNECTOR_STATUS failed (%d)\n",
 			__func__, ret);
@@ -833,14 +835,6 @@ static void ucsi_handle_connector_change
 	if (con->status.change & UCSI_CONSTAT_CAM_CHANGE)
 		ucsi_partner_task(con, ucsi_check_altmodes, 1, 0);
 
-	mutex_lock(&ucsi->ppm_lock);
-	clear_bit(EVENT_PENDING, &con->ucsi->flags);
-	ret = ucsi_acknowledge_connector_change(ucsi);
-	mutex_unlock(&ucsi->ppm_lock);
-
-	if (ret)
-		dev_err(ucsi->dev, "%s: ACK failed (%d)", __func__, ret);
-
 out_unlock:
 	mutex_unlock(&con->lock);
 }


