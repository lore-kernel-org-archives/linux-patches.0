Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CEEB481B8;
	Mon,  1 Apr 2024 17:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991403; cv=none; b=JsbDphgHl+KvtHzEXdX4A4qxnGfyj70pZoT53jEduZ5A9jT2CiPmEjWdeRCm+SOLMTEbnGDKj0ETkxET5jvdbsmMQZZ+o3B1jLvgOlp/U5shwByvyJehVgaZCEZCq6RxABR41Qveu97rrvRtyZk2Yb0zYtd4Sa9l1uLYyYy4AZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991403; c=relaxed/simple;
	bh=yMy6LHa2JNfPh5OFlqaPTl25fwXzD2dBWshuZKWJuus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkVe2jssBcA15v3HmEb89dYLFpYXrBUWstzFi6Hm0tN3OpCWxEiZNHWaIcHP4fiqMpl9OLUFi+tDx/F7jYBIw8oXqVZtyQyaiB2019AgVRvXarEUE/nwtIV2FYEyf5NoBRRTbv+sgk5HxFmjGAuy41weL2dQqJ0DCKvMAhlEQio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=enRVVqwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enRVVqwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBFAC433F1;
	Mon,  1 Apr 2024 17:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991403;
	bh=yMy6LHa2JNfPh5OFlqaPTl25fwXzD2dBWshuZKWJuus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enRVVqwFoHb+KeuIjm4Ck/65brQSnfSJV5q+9u3Lnpyw70gjeXF0hdbrt4plzM4A1
	 DxaI1UpXYSyhrB8Cc6flxb2s3ae/9y2dGr1KKRzJt4RUQMbuqpQfD5vJMs6Sujd1h2
	 2qyFsEUkJRDW7seuA1xq+NXqY31oV7UBxM63v1lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian A. Ehrhardt" <lk@c--e.de>,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 254/272] usb: typec: ucsi: Clear UCSI_CCI_RESET_COMPLETE before reset
Date: Mon,  1 Apr 2024 17:47:24 +0200
Message-ID: <20240401152538.962795707@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
@@ -878,13 +878,47 @@ static int ucsi_reset_connector(struct u
 
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


