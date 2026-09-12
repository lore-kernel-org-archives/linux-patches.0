Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE8E1FBEA6;
	Sat, 12 Sep 2026 16:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230655; cv=none; b=ZsDcnk1c32mlzImLnUNBL/0QvpuLOZbknbxgdiCI2cUeJjV3/qwjf/hVoZbznwL6hKjQUjWwdV5e+7xGIvXAFoPwYxdwZwnYATCbmFbIvyRzlo1hnH6m6nEC0Vcvxw96zhG6narTHBamno8sL46khDp0Xuymx4W6lYGK21mFLGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230655; c=relaxed/simple;
	bh=t0hWNU0iS6KGyISvNBNT18SvCG8b8P59hbcI0W0Bvzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOCXLZLpzWG7ALcyH49BKlDGm9VApWK+tmfFLmmex71C+ba33+NDG3L6WDGjP1PICy4gAg4CJZ5VhjVcfOhjIZG9f6zYYfyn8fM4ZFf+MzkRA45ch6JWga7kp366VTbJ1hnkhyt5J5X3EKGhSX5EdHicf5IoXpee0XP92+WCu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5Gqwfc1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5Gqwfc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1551B1F000FF;
	Sat, 12 Sep 2026 16:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230653;
	bh=5SXk9uee9/+q3sQrP+emnWIPmHO0SBekexMwK+B0b+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5Gqwfc1D3qtd91Uo9I6EvWoz7Qz5kiPgmV1N+s8rF4sRqhK201NXebTynlAL7Ccb
	 Lua6yt8coF3tewa1LuN66RYC6U4uFYGX4fibtokabW1c4a2ZwjkWrzOXpe3AHd9vYv
	 M+UZsDn5QpAZNQ9ngXVq7OrCFdeDLrUgHbHqbh5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0839/1191] HID: i2c-hid: Fold i2c_hid_execute_reset() into i2c_hid_hwreset()
Date: Sat, 12 Sep 2026 08:59:27 +0200
Message-ID: <20260912065607.102802693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit f023605d1de6f150d9266747a2630f029956041f ]

i2c_hid_hwreset() is the only caller of i2c_hid_execute_reset(),
fold the latter into the former.

This is a preparation patch for removing the need for
I2C_HID_QUIRK_NO_IRQ_AFTER_RESET by making i2c-hid behave
more like Windows.

No functional changes intended.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: 8da0f0951dee ("HID: i2c-hid: Fix "(null)" output when reading report descriptor fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 73 ++++++++++++------------------
 1 file changed, 30 insertions(+), 43 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 624d542df3a7d..4d59ddf2c1b04 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -424,12 +424,23 @@ static int i2c_hid_set_power(struct i2c_hid *ihid, int power_state)
 	return ret;
 }
 
-static int i2c_hid_execute_reset(struct i2c_hid *ihid)
+static int i2c_hid_hwreset(struct i2c_hid *ihid)
 {
 	size_t length = 0;
 	int ret;
 
-	i2c_hid_dbg(ihid, "resetting...\n");
+	i2c_hid_dbg(ihid, "%s\n", __func__);
+
+	/*
+	 * This prevents sending feature reports while the device is
+	 * being reset. Otherwise we may lose the reset complete
+	 * interrupt.
+	 */
+	mutex_lock(&ihid->reset_lock);
+
+	ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
+	if (ret)
+		goto err_unlock;
 
 	/* Prepare reset command. Command register goes first. */
 	*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
@@ -442,59 +453,35 @@ static int i2c_hid_execute_reset(struct i2c_hid *ihid)
 
 	ret = i2c_hid_xfer(ihid, ihid->cmdbuf, length, NULL, 0);
 	if (ret) {
-		dev_err(&ihid->client->dev, "failed to reset device.\n");
-		goto out;
+		dev_err(&ihid->client->dev,
+			"failed to reset device: %d\n", ret);
+		goto err_clear_reset;
 	}
 
+	i2c_hid_dbg(ihid, "%s: waiting...\n", __func__);
+
 	if (ihid->quirks & I2C_HID_QUIRK_NO_IRQ_AFTER_RESET) {
 		msleep(100);
-		goto out;
-	}
-
-	i2c_hid_dbg(ihid, "%s: waiting...\n", __func__);
-	if (!wait_event_timeout(ihid->wait,
-				!test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
-				msecs_to_jiffies(5000))) {
+		clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
+	} else if (!wait_event_timeout(ihid->wait,
+				       !test_bit(I2C_HID_RESET_PENDING, &ihid->flags),
+				       msecs_to_jiffies(5000))) {
 		ret = -ENODATA;
-		goto out;
+		goto err_clear_reset;
 	}
 	i2c_hid_dbg(ihid, "%s: finished.\n", __func__);
 
-out:
-	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
-	return ret;
-}
-
-static int i2c_hid_hwreset(struct i2c_hid *ihid)
-{
-	int ret;
-
-	i2c_hid_dbg(ihid, "%s\n", __func__);
-
-	/*
-	 * This prevents sending feature reports while the device is
-	 * being reset. Otherwise we may lose the reset complete
-	 * interrupt.
-	 */
-	mutex_lock(&ihid->reset_lock);
-
-	ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
-	if (ret)
-		goto out_unlock;
-
-	ret = i2c_hid_execute_reset(ihid);
-	if (ret) {
-		dev_err(&ihid->client->dev,
-			"failed to reset device: %d\n", ret);
-		i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
-		goto out_unlock;
-	}
-
 	/* At least some SIS devices need this after reset */
 	if (!(ihid->quirks & I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET))
 		ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
 
-out_unlock:
+	mutex_unlock(&ihid->reset_lock);
+	return ret;
+
+err_clear_reset:
+	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
+	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
+err_unlock:
 	mutex_unlock(&ihid->reset_lock);
 	return ret;
 }
-- 
2.53.0



