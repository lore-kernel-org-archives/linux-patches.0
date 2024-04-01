Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989C71CA8F;
	Mon,  1 Apr 2024 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987736; cv=none; b=rpnnxce1lH0ndWLgQpvB+Lom7yhKKL0zyVUWYuVVuAvFqY8XHAqmW/31ejX/n++TPnfdJYwdP/Oq/rzsxGOF+zRXjcqZdu08s2brguPZaTAUPY9AMHfAqD6WWNV8Sx13rcqSZkmTc8wX82RKUAAP5q8cSgZ2ZEBRzESbWaKQV+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987736; c=relaxed/simple;
	bh=nPL9yUUNlEESLxAwaliLg/1+i/rc+SP85+e18WH+4AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FeOMH8aOiJl9+GBJD1yQhlvdmu+EX+wQCh0e1QVfXukOjPdZ7C8PJ5HW+HavSfX3BScXpM08OD/eE97TMh2ejljUY3XmN7nwKEbujHntrEHA0SaRQpy57VpC3HqO79lqoJ5PLkvJagnXaC7l5+LRPjMv/5tmwLT4gPKSR5sYLsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH+vDhA2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH+vDhA2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B6DC433C7;
	Mon,  1 Apr 2024 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987736;
	bh=nPL9yUUNlEESLxAwaliLg/1+i/rc+SP85+e18WH+4AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wH+vDhA2f3KbqjUJXcUdmHlUwGku9nDMzlOe1OVjFvtYZ/Npk3IbAUimkKeQOoCG6
	 vMHL7rrtSjPB03IW6loZA6DOdeT9nD3dFukM7DSqJE0O2fkK5q48RGTHJgjjG03XSc
	 AB2yZqVxQ1JmZC4Ss2j6HpEW3Ti1wOA4Ao8ArHvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.8 376/399] usb: typec: ucsi: Clear UCSI_CCI_RESET_COMPLETE before reset
Date: Mon,  1 Apr 2024 17:45:42 +0200
Message-ID: <20240401152600.403407717@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian A. Ehrhardt <lk@c--e.de>

commit 3de4f996a0b5412aa451729008130a488f71563e upstream.

Check the UCSI_CCI_RESET_COMPLETE complete flag before starting
another reset. Use a UCSI_SET_NOTIFICATION_ENABLE command to clear
the flag if it is set.

Signed-off-by: Christian A. Ehrhardt <lk@c--e.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Neil Armstrong <neil.armstrong@linaro.org> # on SM8550-QRD
Link: https://lore.kernel.org/r/20240320073927.1641788-6-lk@c--e.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   36 +++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -985,13 +985,47 @@ static int ucsi_reset_connector(struct u
 
 static int ucsi_reset_ppm(struct ucsi *ucsi)
 {
-	u64 command = UCSI_PPM_RESET;
+	u64 command;
 	unsigned long tmo;
 	u32 cci;
 	int ret;
 
 	mutex_lock(&ucsi->ppm_lock);
 
+	ret = ucsi->ops->read(ucsi, UCSI_CCI, &cci, sizeof(cci));
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * If UCSI_CCI_RESET_COMPLETE is already set we must clear
+	 * the flag before we start another reset. Send a
+	 * UCSI_SET_NOTIFICATION_ENABLE command to achieve this.
+	 * Ignore a timeout and try the reset anyway if this fails.
+	 */
+	if (cci & UCSI_CCI_RESET_COMPLETE) {
+		command = UCSI_SET_NOTIFICATION_ENABLE;
+		ret = ucsi->ops->async_write(ucsi, UCSI_CONTROL, &command,
+					     sizeof(command));
+		if (ret < 0)
+			goto out;
+
+		tmo = jiffies + msecs_to_jiffies(UCSI_TIMEOUT_MS);
+		do {
+			ret = ucsi->ops->read(ucsi, UCSI_CCI,
+					      &cci, sizeof(cci));
+			if (ret < 0)
+				goto out;
+			if (cci & UCSI_CCI_COMMAND_COMPLETE)
+				break;
+			if (time_is_before_jiffies(tmo))
+				break;
+			msleep(20);
+		} while (1);
+
+		WARN_ON(cci & UCSI_CCI_RESET_COMPLETE);
+	}
+
+	command = UCSI_PPM_RESET;
 	ret = ucsi->ops->async_write(ucsi, UCSI_CONTROL, &command,
 				     sizeof(command));
 	if (ret < 0)


