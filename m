Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC6E26D4E2;
	Tue,  2 Sep 2025 13:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820359; cv=none; b=nWoXLtAoah3P3eHWs2aOuM4PSQ64Qav+R3ND8vDTJvUWjV/Ps74BNn8OoA04EtaIQX5FL+V7ZjrzgvaYPQUYpukVjMRRUbjLYmHKEK75LXivFuk7yg8aFD+3qTWZP54BYPeRZ47+Ez9N0psFEYeZC7MXZDjsPFvDjsKUdVuzssM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820359; c=relaxed/simple;
	bh=Z0hBmWzUs08J7nuwtmeOq66ViYzHV3rKI5uXc5aQmSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eDk6mToZQZMVqcStzysH+lNuRe3Bnc+hq6N9qKkug/4TZzfgb3QZ4d4C2e14PVaijGZwxxo4y35S7/72wUxvOtrHXSLuPEJy7PyS7bXljRdJHL5jTF9Os2EKrhzx7Njj7Yenai2/7AtlGm8KaQg/mM4olnS04guRLhFHc70t7gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oOzijb6r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oOzijb6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B29EC4CEF4;
	Tue,  2 Sep 2025 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820359;
	bh=Z0hBmWzUs08J7nuwtmeOq66ViYzHV3rKI5uXc5aQmSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oOzijb6rCUMfwq87fVn3iV3zO8wcmdHl747X/GiiZgdgNbpzOM9CrfWCJfvr7dMoJ
	 jjPBb68XGt9Qvn5m+QSM86u5d0vPRHaVhusr3vusXJSUkkbyxmbtjTW0LchYzEwQie
	 y7NpNGGF7J71K6P7OjEKLi1kjvxQ7CwSmRTI6AOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.6 72/75] HID: mcp2221: Dont set bus speed on every transfer
Date: Tue,  2 Sep 2025 15:21:24 +0200
Message-ID: <20250902131937.934010545@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

commit 02a46753601a24e1673d9c28173121055e8e6cc9 upstream.

Since the initial commit of this driver the I2C bus speed has been
reconfigured for every single transfer. This is despite the fact that we
never change the speed and it is never "lost" by the chip.
Upon investigation we find that what was really happening was that the
setting of the bus speed had the side effect of cancelling a previous
failed command if there was one, thereby freeing the bus. This is the
part that was actually required to keep the bus operational in the face
of failed commands.

Instead of always setting the speed, we now correctly cancel any failed
commands as they are detected. This means we can just set the bus speed
at probe time and remove the previous speed sets on each transfer.
This has the effect of improving performance and reducing the number of
commands required to complete transfers.

Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
[romain.sioen@microchip.com: backport to stable, up to 6.8. Add "Fixes" tag]
Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -187,6 +187,25 @@ static int mcp_cancel_last_cmd(struct mc
 	return mcp_send_data_req_status(mcp, mcp->txbuf, 8);
 }
 
+/* Check if the last command succeeded or failed and return the result.
+ * If the command did fail, cancel that command which will free the i2c bus.
+ */
+static int mcp_chk_last_cmd_status_free_bus(struct mcp2221 *mcp)
+{
+	int ret;
+
+	ret = mcp_chk_last_cmd_status(mcp);
+	if (ret) {
+		/* The last command was a failure.
+		 * Send a cancel which will also free the bus.
+		 */
+		usleep_range(980, 1000);
+		mcp_cancel_last_cmd(mcp);
+	}
+
+	return ret;
+}
+
 static int mcp_set_i2c_speed(struct mcp2221 *mcp)
 {
 	int ret;
@@ -241,7 +260,7 @@ static int mcp_i2c_write(struct mcp2221
 		usleep_range(980, 1000);
 
 		if (last_status) {
-			ret = mcp_chk_last_cmd_status(mcp);
+			ret = mcp_chk_last_cmd_status_free_bus(mcp);
 			if (ret)
 				return ret;
 		}
@@ -308,7 +327,7 @@ static int mcp_i2c_smbus_read(struct mcp
 		if (ret)
 			return ret;
 
-		ret = mcp_chk_last_cmd_status(mcp);
+		ret = mcp_chk_last_cmd_status_free_bus(mcp);
 		if (ret)
 			return ret;
 
@@ -328,11 +347,6 @@ static int mcp_i2c_xfer(struct i2c_adapt
 
 	mutex_lock(&mcp->lock);
 
-	/* Setting speed before every transaction is required for mcp2221 */
-	ret = mcp_set_i2c_speed(mcp);
-	if (ret)
-		goto exit;
-
 	if (num == 1) {
 		if (msgs->flags & I2C_M_RD) {
 			ret = mcp_i2c_smbus_read(mcp, msgs, MCP2221_I2C_RD_DATA,
@@ -417,9 +431,7 @@ static int mcp_smbus_write(struct mcp222
 	if (last_status) {
 		usleep_range(980, 1000);
 
-		ret = mcp_chk_last_cmd_status(mcp);
-		if (ret)
-			return ret;
+		ret = mcp_chk_last_cmd_status_free_bus(mcp);
 	}
 
 	return ret;
@@ -437,10 +449,6 @@ static int mcp_smbus_xfer(struct i2c_ada
 
 	mutex_lock(&mcp->lock);
 
-	ret = mcp_set_i2c_speed(mcp);
-	if (ret)
-		goto exit;
-
 	switch (size) {
 
 	case I2C_SMBUS_QUICK:
@@ -1152,6 +1160,11 @@ static int mcp2221_probe(struct hid_devi
 	if (i2c_clk_freq < 50)
 		i2c_clk_freq = 50;
 	mcp->cur_i2c_clk_div = (12000000 / (i2c_clk_freq * 1000)) - 3;
+	ret = mcp_set_i2c_speed(mcp);
+	if (ret) {
+		hid_err(hdev, "can't set i2c speed: %d\n", ret);
+		return ret;
+	}
 
 	mcp->adapter.owner = THIS_MODULE;
 	mcp->adapter.class = I2C_CLASS_HWMON;


