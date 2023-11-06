Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85BA20316
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssTjU9/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E766C433C7;
	Mon,  6 Nov 2023 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276423;
	bh=LPZZqRZF0/yD7MuCoD8LvnkvtsR9Iv2woK0outVAaIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ssTjU9/v8Pl/eTJsV5RQOi1cyH0P1KBa3rfPjMl8W8O3UGTsi7WfqR7spbc5Jsbi4
	 R4dUTCO54wo/9T/Jl188Mql2GOPM0cd6xFGQtISjC+/7nAhGi1C6aGjv8gSjdIvZt1
	 U6CuKEk/IMDJg/EGqFsqiJi7/5GjhwBuertXWLnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeffery Miller <jefferymiller@google.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 09/62] Input: synaptics-rmi4 - handle reset delay when using SMBus trsnsport
Date: Mon,  6 Nov 2023 14:03:15 +0100
Message-ID: <20231106130302.152305016@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
References: <20231106130301.807965064@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 5030b2fe6aab37fe42d14f31842ea38be7c55c57 ]

Touch controllers need some time after receiving reset command for the
firmware to finish re-initializing and be ready to respond to commands
from the host. The driver already had handling for the post-reset delay
for I2C and SPI transports, this change adds the handling to
SMBus-connected devices.

SMBus devices are peculiar because they implement legacy PS/2
compatibility mode, so reset is actually issued by psmouse driver on the
associated serio port, after which the control is passed to the RMI4
driver with SMBus companion device.

Note that originally the delay was added to psmouse driver in
92e24e0e57f7 ("Input: psmouse - add delay when deactivating for SMBus
mode"), but that resulted in an unwanted delay in "fast" reconnect
handler for the serio port, so it was decided to revert the patch and
have the delay being handled in the RMI4 driver, similar to the other
transports.

Tested-by: Jeffery Miller <jefferymiller@google.com>
Link: https://lore.kernel.org/r/ZR1yUFJ8a9Zt606N@penguin
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics.c |  1 +
 drivers/input/rmi4/rmi_smbus.c  | 50 ++++++++++++++++++---------------
 2 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index d2c9f4cbd00c6..e43e93ac2798a 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -1753,6 +1753,7 @@ static int synaptics_create_intertouch(struct psmouse *psmouse,
 		psmouse_matches_pnp_id(psmouse, topbuttonpad_pnp_ids) &&
 		!SYN_CAP_EXT_BUTTONS_STICK(info->ext_cap_10);
 	const struct rmi_device_platform_data pdata = {
+		.reset_delay_ms = 30,
 		.sensor_pdata = {
 			.sensor_type = rmi_sensor_touchpad,
 			.axis_align.flip_y = true,
diff --git a/drivers/input/rmi4/rmi_smbus.c b/drivers/input/rmi4/rmi_smbus.c
index c130468541b7d..7080c2ddbaf2b 100644
--- a/drivers/input/rmi4/rmi_smbus.c
+++ b/drivers/input/rmi4/rmi_smbus.c
@@ -235,12 +235,29 @@ static void rmi_smb_clear_state(struct rmi_smb_xport *rmi_smb)
 
 static int rmi_smb_enable_smbus_mode(struct rmi_smb_xport *rmi_smb)
 {
-	int retval;
+	struct i2c_client *client = rmi_smb->client;
+	int smbus_version;
+
+	/*
+	 * psmouse driver resets the controller, we only need to wait
+	 * to give the firmware chance to fully reinitialize.
+	 */
+	if (rmi_smb->xport.pdata.reset_delay_ms)
+		msleep(rmi_smb->xport.pdata.reset_delay_ms);
 
 	/* we need to get the smbus version to activate the touchpad */
-	retval = rmi_smb_get_version(rmi_smb);
-	if (retval < 0)
-		return retval;
+	smbus_version = rmi_smb_get_version(rmi_smb);
+	if (smbus_version < 0)
+		return smbus_version;
+
+	rmi_dbg(RMI_DEBUG_XPORT, &client->dev, "Smbus version is %d",
+		smbus_version);
+
+	if (smbus_version != 2 && smbus_version != 3) {
+		dev_err(&client->dev, "Unrecognized SMB version %d\n",
+				smbus_version);
+		return -ENODEV;
+	}
 
 	return 0;
 }
@@ -253,11 +270,10 @@ static int rmi_smb_reset(struct rmi_transport_dev *xport, u16 reset_addr)
 	rmi_smb_clear_state(rmi_smb);
 
 	/*
-	 * we do not call the actual reset command, it has to be handled in
-	 * PS/2 or there will be races between PS/2 and SMBus.
-	 * PS/2 should ensure that a psmouse_reset is called before
-	 * intializing the device and after it has been removed to be in a known
-	 * state.
+	 * We do not call the actual reset command, it has to be handled in
+	 * PS/2 or there will be races between PS/2 and SMBus. PS/2 should
+	 * ensure that a psmouse_reset is called before initializing the
+	 * device and after it has been removed to be in a known state.
 	 */
 	return rmi_smb_enable_smbus_mode(rmi_smb);
 }
@@ -273,7 +289,6 @@ static int rmi_smb_probe(struct i2c_client *client,
 {
 	struct rmi_device_platform_data *pdata = dev_get_platdata(&client->dev);
 	struct rmi_smb_xport *rmi_smb;
-	int smbus_version;
 	int error;
 
 	if (!pdata) {
@@ -312,18 +327,9 @@ static int rmi_smb_probe(struct i2c_client *client,
 	rmi_smb->xport.proto_name = "smb";
 	rmi_smb->xport.ops = &rmi_smb_ops;
 
-	smbus_version = rmi_smb_get_version(rmi_smb);
-	if (smbus_version < 0)
-		return smbus_version;
-
-	rmi_dbg(RMI_DEBUG_XPORT, &client->dev, "Smbus version is %d",
-		smbus_version);
-
-	if (smbus_version != 2 && smbus_version != 3) {
-		dev_err(&client->dev, "Unrecognized SMB version %d\n",
-				smbus_version);
-		return -ENODEV;
-	}
+	error = rmi_smb_enable_smbus_mode(rmi_smb);
+	if (error)
+		return error;
 
 	i2c_set_clientdata(client, rmi_smb);
 
-- 
2.42.0



