Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D1B43F4BF;
	Mon, 31 Aug 2026 14:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185054; cv=none; b=cagXY5OsudhvlzKAzNeAetO+jaE2kUZZOzR30dZQ5jSnfKtUMOZ+J83tIeuf7vWKb48frfOVAPitCme4/XLhcHchBUnenejx+rJrPfFIHY4dnT5xMxf9jt6hl5LJhjUelf5mreyGGAtplyvkjuHzQNOc361fhA5ae4z9OnAqg5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185054; c=relaxed/simple;
	bh=9EBTK/9NZbXDMaMMPyto5VrTxXVL07w4uV+yKbshSHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu988qlpAkQ4wozXfsB8asUy7JvJmunm9bXJdfZnL2ZYLfePs/gkbvKSnMrQBvNKhSs3iqTnSEwC7xOp1e4hT3Tqp+r2+MmjeUvUBAdc1SA0H7zqaL2y9VJfRYQKa/F1AO9xWMvnzvUYFB5FJq1OE/bL25ewm2DdazCJog3zTvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgsDq3fg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgsDq3fg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F071F000E9;
	Mon, 31 Aug 2026 14:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185053;
	bh=zslmJWe2Em4ZcZ1mIVJmsVq4Gtwb4l1mmtsHPzuABkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wgsDq3fgZ2t5uXNYPW/tOKRKSqREyUXyPKMAt1A8+261EWKPoJUAa8JVhTcpBx6/m
	 jdj4NDWQ36T+H27Mto0jMLS7P79CRoCtm17dhRyT1PvF6k8DWRNx4xChNsLFD/NPZv
	 7L5cY9iVpBCmHqo9SrMLXp+krxlojTDMm3aUEpnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Germain Hebert <germain.hebert@ca.abb.com>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 38/69] HID: ft260: missed NACK from busy device
Date: Mon, 31 Aug 2026 15:35:11 +0200
Message-ID: <20260831133400.438223885@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Zaidman <michael.zaidman@gmail.com>

[ Upstream commit 5afac727defa0b2a3dffb2abd5fb5f594b98d217 ]

When writing into a slow device like an EEPROM chip, the
controller may exit the busy state before the device releases
the bus. In this case, the ft260_xfer_status returns success
before the data transfer completion.

The patch fixes it by returning from the ft260_xfer_status()
with the "-EAGAIN" on both controller and bus busy status when
appropriate.

It does not apply to the i2c combined transactions when after
the write IO, the controller keeps the bus busy until the read
IO and then between reading IOs to ensure an atomic operation.

Co-developed-by: Germain Hebert <germain.hebert@ca.abb.com>
Signed-off-by: Germain Hebert <germain.hebert@ca.abb.com>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -303,7 +303,7 @@ static int ft260_i2c_reset(struct hid_de
 	return ret;
 }
 
-static int ft260_xfer_status(struct ft260_device *dev)
+static int ft260_xfer_status(struct ft260_device *dev, u8 bus_busy)
 {
 	struct hid_device *hdev = dev->hdev;
 	struct ft260_get_i2c_status_report report;
@@ -334,7 +334,7 @@ static int ft260_xfer_status(struct ft26
 	ft260_dbg("bus_status %#02x, clock %u\n", report.bus_status,
 		  dev->clock);
 
-	if (report.bus_status & FT260_I2C_STATUS_CTRL_BUSY)
+	if (report.bus_status & (FT260_I2C_STATUS_CTRL_BUSY | bus_busy))
 		return -EAGAIN;
 
 	if (report.bus_status & FT260_I2C_STATUS_BUS_BUSY)
@@ -379,8 +379,11 @@ static int ft260_hid_output_report(struc
 static int ft260_hid_output_report_check_status(struct ft260_device *dev,
 						u8 *data, int len)
 {
+	u8 bus_busy;
 	int ret, usec, try = 100;
 	struct hid_device *hdev = dev->hdev;
+	struct ft260_i2c_write_request_report *rep =
+		(struct ft260_i2c_write_request_report *)data;
 
 	ret = ft260_hid_output_report(hdev, data, len);
 	if (ret < 0) {
@@ -398,8 +401,18 @@ static int ft260_hid_output_report_check
 		ft260_dbg("wait %d usec, len %d\n", usec, len);
 	}
 
+	/*
+	 * Do not check the busy bit for combined transactions
+	 * since the controller keeps the bus busy between writing
+	 * and reading IOs to ensure an atomic operation.
+	 */
+	if (rep->flag == FT260_FLAG_START)
+		bus_busy = 0;
+	else
+		bus_busy = FT260_I2C_STATUS_BUS_BUSY;
+
 	do {
-		ret = ft260_xfer_status(dev);
+		ret = ft260_xfer_status(dev, bus_busy);
 		if (ret != -EAGAIN)
 			break;
 	} while (--try);
@@ -485,10 +498,10 @@ static int ft260_smbus_write(struct ft26
 static int ft260_i2c_read(struct ft260_device *dev, u8 addr, u8 *data,
 			  u16 len, u8 flag)
 {
+	int timeout, ret = 0;
 	struct ft260_i2c_read_request_report rep;
 	struct hid_device *hdev = dev->hdev;
-	int timeout;
-	int ret = 0;
+	u8 bus_busy = 0;
 
 	if (len > FT260_RD_DATA_MAX) {
 		hid_err(hdev, "%s: unsupported rd len: %d\n", __func__, len);
@@ -525,7 +538,10 @@ static int ft260_i2c_read(struct ft260_d
 
 	dev->read_buf = NULL;
 
-	ret = ft260_xfer_status(dev);
+	if (flag & FT260_FLAG_STOP)
+		bus_busy = FT260_I2C_STATUS_BUS_BUSY;
+
+	ret = ft260_xfer_status(dev, bus_busy);
 	if (ret < 0) {
 		ret = -EIO;
 		ft260_i2c_reset(hdev);
@@ -1004,7 +1020,7 @@ static int ft260_probe(struct hid_device
 	mutex_init(&dev->lock);
 	init_completion(&dev->wait);
 
-	ret = ft260_xfer_status(dev);
+	ret = ft260_xfer_status(dev, FT260_I2C_STATUS_BUS_BUSY);
 	if (ret)
 		ft260_i2c_reset(hdev);
 


