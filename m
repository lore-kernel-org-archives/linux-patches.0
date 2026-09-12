Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071982D739C;
	Sat, 12 Sep 2026 14:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224562; cv=none; b=RqzcsRXlCJf1Ad1uxYS95VWtmA/BJB91bRhS1OQ2I1wvpYgvS/evS0X5YfH6vLr1wXyGnlKmvuQ082hE/dRhFMhjyBxzabZLx+Fvv9oPViJvxt8xnXw2wveRnsB855GvLR4LU0k5ZE+OCGMEY3UnWqYSpn1tRGpVaamD2uSvD0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224562; c=relaxed/simple;
	bh=OaOqCIovdxWKCwwt3Tp0pkdFyBuW91MHrcPqG1xCVsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJzOutvHe0T/bugwt6Lk+Y4RWAUyDjhoCixGecc3zOz52JZRaoqw/+mWr8gRZDxNTcT9eRTzDGd2giUu3WHC4kkl2EXVd63cqev5ljIZIAbwomLZjN2GLPwgo2fLZPhKs1j0dVdoojx3m3w/qrWgt8mbgqTFDK+CTNr661sBg2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lryqa+U3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lryqa+U3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564A91F000FF;
	Sat, 12 Sep 2026 14:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224560;
	bh=KhPYIPAPVb3R03k4oNqoJJ9ejbEFGZcCLoIo/ASVGH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lryqa+U348/jX8/3jB5scTAXbYMuUK5sNfRZsJ6ymscsWKFFHECc9PzbRU6F8iQBx
	 zsWLWdG1eNq/EgOrgxKtA+qR0soIgS7S6M44HFK61uQRivZRKjNVIgHoBu12QMCz8e
	 ZWgFnaDVUf9of/U+0dzpOAP/3hnpDVRVg5ZTDzOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1018/1424] HID: i2c-hid: Split i2c_hid_hwreset() in start() and finish() functions
Date: Sat, 12 Sep 2026 08:57:30 +0200
Message-ID: <20260912065630.109154748@linuxfoundation.org>
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

[ Upstream commit 96d3098db835d58649b73a5788898bd7672a319b ]

Split i2c_hid_hwreset() into:

i2c_hid_start_hwreset() which sends the PWR_ON and reset commands; and
i2c_hid_finish_hwreset() which actually waits for the reset to complete.

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
 drivers/hid/i2c-hid/i2c-hid-core.c | 38 ++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index c87d3a825dc08..4ef7d20484ded 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -420,7 +420,7 @@ static int i2c_hid_set_power(struct i2c_hid *ihid, int power_state)
 	return ret;
 }
 
-static int i2c_hid_hwreset(struct i2c_hid *ihid)
+static int i2c_hid_start_hwreset(struct i2c_hid *ihid)
 {
 	size_t length = 0;
 	int ret;
@@ -432,11 +432,11 @@ static int i2c_hid_hwreset(struct i2c_hid *ihid)
 	 * being reset. Otherwise we may lose the reset complete
 	 * interrupt.
 	 */
-	mutex_lock(&ihid->reset_lock);
+	lockdep_assert_held(&ihid->reset_lock);
 
 	ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
 	if (ret)
-		goto err_unlock;
+		return ret;
 
 	/* Prepare reset command. Command register goes first. */
 	*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
@@ -454,6 +454,18 @@ static int i2c_hid_hwreset(struct i2c_hid *ihid)
 		goto err_clear_reset;
 	}
 
+	return 0;
+
+err_clear_reset:
+	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
+	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
+	return ret;
+}
+
+static int i2c_hid_finish_hwreset(struct i2c_hid *ihid)
+{
+	int ret = 0;
+
 	i2c_hid_dbg(ihid, "%s: waiting...\n", __func__);
 
 	if (ihid->quirks & I2C_HID_QUIRK_NO_IRQ_AFTER_RESET) {
@@ -471,14 +483,11 @@ static int i2c_hid_hwreset(struct i2c_hid *ihid)
 	if (!(ihid->quirks & I2C_HID_QUIRK_NO_WAKEUP_AFTER_RESET))
 		ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
 
-	mutex_unlock(&ihid->reset_lock);
 	return ret;
 
 err_clear_reset:
 	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
 	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
-err_unlock:
-	mutex_unlock(&ihid->reset_lock);
 	return ret;
 }
 
@@ -722,7 +731,11 @@ static int i2c_hid_parse(struct hid_device *hid)
 	}
 
 	do {
-		ret = i2c_hid_hwreset(ihid);
+		mutex_lock(&ihid->reset_lock);
+		ret = i2c_hid_start_hwreset(ihid);
+		if (ret == 0)
+			ret = i2c_hid_finish_hwreset(ihid);
+		mutex_unlock(&ihid->reset_lock);
 		if (ret)
 			msleep(1000);
 	} while (tries-- > 0 && ret);
@@ -974,10 +987,15 @@ static int i2c_hid_core_resume(struct i2c_hid *ihid)
 	 * However some ALPS touchpads generate IRQ storm without reset, so
 	 * let's still reset them here.
 	 */
-	if (ihid->quirks & I2C_HID_QUIRK_RESET_ON_RESUME)
-		ret = i2c_hid_hwreset(ihid);
-	else
+	if (ihid->quirks & I2C_HID_QUIRK_RESET_ON_RESUME) {
+		mutex_lock(&ihid->reset_lock);
+		ret = i2c_hid_start_hwreset(ihid);
+		if (ret == 0)
+			ret = i2c_hid_finish_hwreset(ihid);
+		mutex_unlock(&ihid->reset_lock);
+	} else {
 		ret = i2c_hid_set_power(ihid, I2C_HID_PWR_ON);
+	}
 
 	if (ret)
 		return ret;
-- 
2.53.0



