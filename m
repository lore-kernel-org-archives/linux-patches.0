Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553CA47F775;
	Mon, 31 Aug 2026 14:00:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184833; cv=none; b=Ogb3XfM7pNDWfdV8geHgCd/KKqiMssQOjdIgZDRSJ1iSDirpcPFbfWaVbHri4CgqLF8zKjsjkhk4MdmDoNqoqL5JzQ8xbkucpqok4cBQqsKXSbURRXo8r1CgQLYqyu6nFDLQ2DWa9yuqLVpBY+PZrMVqkHAN5y1vg0TDTLhHhG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184833; c=relaxed/simple;
	bh=uBnMc5emYpGshb6oe45F4iHffwJ3mmQCYfUwAw29Hwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oAwF0lcuu37IRH8c+etMznKomIX/zptWt49npJPirSF5YMNCa3oEUba/7TQ+Je+fsSneU2VV8ncfjxdwEeXY44FNC83dy2xWRu4whUijGQ3geRoh1QFkHmkNecpkSv7noqd+WBiXO30Fyy93bwyfxZ4Jg0JgmK7ddc9gXt6JvNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vT0vuGve; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vT0vuGve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A79A1F000E9;
	Mon, 31 Aug 2026 14:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184832;
	bh=G7jB/dae6C9hoKkVpAutWKrZkZ65JKx2Nw+Kbz6fjRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vT0vuGveRm1wSRsTz5HNCSQBcgK7kE3Vt2bvqkNnxEI39NDqavVy6aXBApiM+mEFI
	 S+6/dsVLo1c38LzvbwQyrDxE5Ps0d0EhrDM5tE7KBrzGG2clW6Xa+Nqzt8Gq5fWp+/
	 KmE51WX2zhdSVYRpVtUGOwIPB3LpmoRvDWjdLJ00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Germain Hebert <germain.hebert@ca.abb.com>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 52/92] HID: ft260: missed NACK from busy device
Date: Mon, 31 Aug 2026 15:34:50 +0200
Message-ID: <20260831133402.427633631@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
 drivers/hid/hid-ft260.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

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
@@ -487,6 +500,7 @@ static int ft260_i2c_read(struct ft260_d
 {
 	struct ft260_i2c_read_request_report rep;
 	struct hid_device *hdev = dev->hdev;
+	u8 bus_busy = 0;
 	int timeout;
 	int ret = 0;
 
@@ -525,7 +539,10 @@ static int ft260_i2c_read(struct ft260_d
 
 	dev->read_buf = NULL;
 
-	ret = ft260_xfer_status(dev);
+	if (flag & FT260_FLAG_STOP)
+		bus_busy = FT260_I2C_STATUS_BUS_BUSY;
+
+	ret = ft260_xfer_status(dev, bus_busy);
 	if (ret < 0) {
 		ret = -EIO;
 		ft260_i2c_reset(hdev);
@@ -1004,7 +1021,7 @@ static int ft260_probe(struct hid_device
 	mutex_init(&dev->lock);
 	init_completion(&dev->wait);
 
-	ret = ft260_xfer_status(dev);
+	ret = ft260_xfer_status(dev, FT260_I2C_STATUS_BUS_BUSY);
 	if (ret)
 		ft260_i2c_reset(hdev);
 


