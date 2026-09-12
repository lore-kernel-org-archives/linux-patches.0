Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CA2242D65;
	Sat, 12 Sep 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224558; cv=none; b=CgYUBBMUTL4epVERU5pQVnl8WeB31S2Kytob3ecOsbgrMxamlchsXVRc3RkhQiQ+MYOJab6K411azXGytqYhhykRLPGrEProqiharALC0LMtm14j29a2WgPcfSJySqVGcURMa/xLfWvwigwGsosh7AbgCcggFnuNhWAx53uLV8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224558; c=relaxed/simple;
	bh=476lKe52gxqoAjP/2+K2rmfLSTp2u9aPjVYpdqpduHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7LDFCnVwbTubKOn9M4rtqjy3YyopEwbp4TsFeRqvbbCGk2xnIsFIGDa1HOq96+pHNNQK/p2bTF6gfCkT/CMeP374TUSHodZJhhexvNpaEmGZtzVcUYJonNdkYkBSPyz+ZDNDG8c4GiR+X88eglwlYelhgkc9JHT/M39EscVxUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=so3YcSzS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="so3YcSzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4CA1F000FF;
	Sat, 12 Sep 2026 14:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224556;
	bh=ldEL92GgVv7xmfSiAvsz1E42I2zteEY7djMQK8V1uuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=so3YcSzSwlSheEBldBEHksHEDuZPbYYNHTFbUCf6JmrwATw3umSy3I4GwYzvxq5/D
	 t2G1N0lXCkDgJkmcOZjbSBYkDloC8u7mL8ls/nWBspNVxtSKziWDQkbHClrEim+riN
	 sNj5ud9u8/DzN0C/hhCKbRbWABtaa4dgqGox6cV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1017/1424] HID: i2c-hid: Fold i2c_hid_execute_reset() into i2c_hid_hwreset()
Date: Sat, 12 Sep 2026 08:57:29 +0200
Message-ID: <20260912065630.087534787@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0a350780407ec..c87d3a825dc08 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -420,12 +420,23 @@ static int i2c_hid_set_power(struct i2c_hid *ihid, int power_state)
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
@@ -438,59 +449,35 @@ static int i2c_hid_execute_reset(struct i2c_hid *ihid)
 
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



