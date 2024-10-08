Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CD251DE8B1;
	Tue,  8 Oct 2024 12:54:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392047; cv=none; b=ZCBoZJVjyliljF+vfrOkWKfvYR8VyEwovHpvIAQfMX4As9uwsvjPqJOXr/UvR5UZI1Szp+48xSEyq4MNjFS1bmOoRQi+U813F6L+/nGPUhetGkzBIWYs+ikCD4wy9YzHOrL8fevTyHswiEeU+YejbuZgCPcOrSBF93gjRxxk2k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392047; c=relaxed/simple;
	bh=KqZqLlsU2pBPlfbcA8/5KLOmHzRT1TjeDNJCMDmSBQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTD7PCJWmhJsfYbkYo/+IyJKUJxbU8Febi2q3CT8v3HsoBkqbTnGdbR4NqzjC/HKs9SfTjVx1UhMPCsf+vWu+NnZ0wjORqA1uM7e/KsTO92fcbD3YrvcuWnl2wT3qyEEr+CV8XMS+pl73C1foXuZgn9RcLup7D0VaTO/xNX5pc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZNWr7w4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZNWr7w4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E7DC4CEC7;
	Tue,  8 Oct 2024 12:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392047;
	bh=KqZqLlsU2pBPlfbcA8/5KLOmHzRT1TjeDNJCMDmSBQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZNWr7w4GaIq5DMn29RzufeYjuVHic3AtdafzicqcCmFAjhMuckD/91JGmWiBYPFj
	 cKkNM3M+SGAUMwrSOittQ6fv0nxqBb4zJouv0tV9i6lJe5ZfFL7eUhmpVeiZzrCtor
	 IWHdFVgOIjQIKi+ZJZoW28E9BmJgCLev0VYfSdzU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 300/558] HID: i2c-hid: ensure various commands do not interfere with each other
Date: Tue,  8 Oct 2024 14:05:30 +0200
Message-ID: <20241008115714.125130933@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit b4ed18a3d56eabd18cfd9841ff05111e3cfbe8f9 ]

i2c-hid uses 2 shared buffers: command and "raw" input buffer for
sending requests to peripherals and read data from peripherals when
executing variety of commands. Such commands include reading of HID
registers, requesting particular power mode, getting and setting
reports and so on. Because all such requests use the same 2 buffers
they should not execute simultaneously.

Fix this by introducing "cmd_lock" mutex and acquire it whenever
we needs to access ihid->cmdbuf or idid->rawbuf.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 42 +++++++++++++++++++-----------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 632eaf9e11a6b..2f8a9d3f1e861 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -105,6 +105,7 @@ struct i2c_hid {
 
 	wait_queue_head_t	wait;		/* For waiting the interrupt */
 
+	struct mutex		cmd_lock;	/* protects cmdbuf and rawbuf */
 	struct mutex		reset_lock;
 
 	struct i2chid_ops	*ops;
@@ -220,6 +221,8 @@ static int i2c_hid_xfer(struct i2c_hid *ihid,
 static int i2c_hid_read_register(struct i2c_hid *ihid, __le16 reg,
 				 void *buf, size_t len)
 {
+	guard(mutex)(&ihid->cmd_lock);
+
 	*(__le16 *)ihid->cmdbuf = reg;
 
 	return i2c_hid_xfer(ihid, ihid->cmdbuf, sizeof(__le16), buf, len);
@@ -252,6 +255,8 @@ static int i2c_hid_get_report(struct i2c_hid *ihid,
 
 	i2c_hid_dbg(ihid, "%s\n", __func__);
 
+	guard(mutex)(&ihid->cmd_lock);
+
 	/* Command register goes first */
 	*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
 	length += sizeof(__le16);
@@ -342,6 +347,8 @@ static int i2c_hid_set_or_send_report(struct i2c_hid *ihid,
 	if (!do_set && le16_to_cpu(ihid->hdesc.wMaxOutputLength) == 0)
 		return -ENOSYS;
 
+	guard(mutex)(&ihid->cmd_lock);
+
 	if (do_set) {
 		/* Command register goes first */
 		*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
@@ -384,6 +391,8 @@ static int i2c_hid_set_power_command(struct i2c_hid *ihid, int power_state)
 {
 	size_t length;
 
+	guard(mutex)(&ihid->cmd_lock);
+
 	/* SET_POWER uses command register */
 	*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
 	length = sizeof(__le16);
@@ -440,25 +449,27 @@ static int i2c_hid_start_hwreset(struct i2c_hid *ihid)
 	if (ret)
 		return ret;
 
-	/* Prepare reset command. Command register goes first. */
-	*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
-	length += sizeof(__le16);
-	/* Next is RESET command itself */
-	length += i2c_hid_encode_command(ihid->cmdbuf + length,
-					 I2C_HID_OPCODE_RESET, 0, 0);
+	scoped_guard(mutex, &ihid->cmd_lock) {
+		/* Prepare reset command. Command register goes first. */
+		*(__le16 *)ihid->cmdbuf = ihid->hdesc.wCommandRegister;
+		length += sizeof(__le16);
+		/* Next is RESET command itself */
+		length += i2c_hid_encode_command(ihid->cmdbuf + length,
+						 I2C_HID_OPCODE_RESET, 0, 0);
 
-	set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
+		set_bit(I2C_HID_RESET_PENDING, &ihid->flags);
 
-	ret = i2c_hid_xfer(ihid, ihid->cmdbuf, length, NULL, 0);
-	if (ret) {
-		dev_err(&ihid->client->dev,
-			"failed to reset device: %d\n", ret);
-		goto err_clear_reset;
-	}
+		ret = i2c_hid_xfer(ihid, ihid->cmdbuf, length, NULL, 0);
+		if (ret) {
+			dev_err(&ihid->client->dev,
+				"failed to reset device: %d\n", ret);
+			break;
+		}
 
-	return 0;
+		return 0;
+	}
 
-err_clear_reset:
+	/* Clean up if sending reset command failed */
 	clear_bit(I2C_HID_RESET_PENDING, &ihid->flags);
 	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
 	return ret;
@@ -1200,6 +1211,7 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 	ihid->is_panel_follower = drm_is_panel_follower(&client->dev);
 
 	init_waitqueue_head(&ihid->wait);
+	mutex_init(&ihid->cmd_lock);
 	mutex_init(&ihid->reset_lock);
 	INIT_WORK(&ihid->panel_follower_prepare_work, ihid_core_panel_prepare_work);
 
-- 
2.43.0



