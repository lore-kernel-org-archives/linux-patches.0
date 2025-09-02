Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B4324B2D;
	Tue,  2 Sep 2025 13:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820491; cv=none; b=a+iwCU6IavAqd6piJ+gW5m59pBk1i2p8wL6QpB3XVkaPzVjSkCNuFwIkFDnCf1WkE0hRlzNfN2YWWF7aP98/CcQdgT+x7ML80u6bU+f2v8XAqTvMXIFIpQA1A9Pn6KHleTi1HWVX8vABx8KXFc69hjaXPpiCV19ySgz+fDU/Yzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820491; c=relaxed/simple;
	bh=8iVbkRikCkBI8URpIt0hubUQf/Cu/DEpy/2z2B2ftdU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qt6atxsAPJmDvOjgT1D6tmbXLR0skfb1Q0Uv1VpgJDWoV5e2b0z/p8cHdUGrY9J1lOQ0EyGqon4ncFhjq0lWqH3v15TmJ2cTm2SEElzt5aPfzlbF6GuRULEljBDuYGUvqtsX62STATozqTHnbadnVy/ZJieJQ0idjqXfQMTetug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs96chSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs96chSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA4CC4CEED;
	Tue,  2 Sep 2025 13:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820491;
	bh=8iVbkRikCkBI8URpIt0hubUQf/Cu/DEpy/2z2B2ftdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs96chSnKHN72y7IAGdfK8PYKY9/pDYrvMt4Q+/LFafGdKHthE+iEfv0uXdFDJRAg
	 V44XT7CiM/tLnJtRKcVNAKhQxNOogTlD3O5URX1mJwoaDgPuu3fx1Dd0mfnWnIytq8
	 ggWlaStkoM5IQ3e78yxB079zNIoezd0d81IM2+78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.1 47/50] HID: mcp2221: Dont set bus speed on every transfer
Date: Tue,  2 Sep 2025 15:21:38 +0200
Message-ID: <20250902131932.381198014@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131930.509077918@linuxfoundation.org>
References: <20250902131930.509077918@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -169,6 +169,25 @@ static int mcp_cancel_last_cmd(struct mc
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
@@ -223,7 +242,7 @@ static int mcp_i2c_write(struct mcp2221
 		usleep_range(980, 1000);
 
 		if (last_status) {
-			ret = mcp_chk_last_cmd_status(mcp);
+			ret = mcp_chk_last_cmd_status_free_bus(mcp);
 			if (ret)
 				return ret;
 		}
@@ -290,7 +309,7 @@ static int mcp_i2c_smbus_read(struct mcp
 		if (ret)
 			return ret;
 
-		ret = mcp_chk_last_cmd_status(mcp);
+		ret = mcp_chk_last_cmd_status_free_bus(mcp);
 		if (ret)
 			return ret;
 
@@ -310,11 +329,6 @@ static int mcp_i2c_xfer(struct i2c_adapt
 
 	mutex_lock(&mcp->lock);
 
-	/* Setting speed before every transaction is required for mcp2221 */
-	ret = mcp_set_i2c_speed(mcp);
-	if (ret)
-		goto exit;
-
 	if (num == 1) {
 		if (msgs->flags & I2C_M_RD) {
 			ret = mcp_i2c_smbus_read(mcp, msgs, MCP2221_I2C_RD_DATA,
@@ -399,9 +413,7 @@ static int mcp_smbus_write(struct mcp222
 	if (last_status) {
 		usleep_range(980, 1000);
 
-		ret = mcp_chk_last_cmd_status(mcp);
-		if (ret)
-			return ret;
+		ret = mcp_chk_last_cmd_status_free_bus(mcp);
 	}
 
 	return ret;
@@ -419,10 +431,6 @@ static int mcp_smbus_xfer(struct i2c_ada
 
 	mutex_lock(&mcp->lock);
 
-	ret = mcp_set_i2c_speed(mcp);
-	if (ret)
-		goto exit;
-
 	switch (size) {
 
 	case I2C_SMBUS_QUICK:
@@ -870,6 +878,11 @@ static int mcp2221_probe(struct hid_devi
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


