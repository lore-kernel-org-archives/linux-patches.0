Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CB147F79F;
	Mon, 31 Aug 2026 14:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184839; cv=none; b=EjNOMTdNxN5z4xLHdWz3cAep3LIIz2n3HQBSCEAQReVQMWjvz1WR+TeF6GgxezCV+F+xWXgR6IjAmLuAM6CgZrP/D0VwnjZtnIazGXaV7HO1iKJ9oObQmD2fBX8V7sNNpZZgAy+aT2B5ieWrnKWbhXsCRgKDh6CQH91yJgpx180=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184839; c=relaxed/simple;
	bh=h2YrJdb8PfmzmpmG7OgRmWxhex+f5wbOCqAy7X+4fiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtdhVKNhxrw8huLANNZnLPaHVIIOJLA0yjs1XWpWzWA0Kw1qcAXovNAZ7S4kvMUYQtzmtlGzxfHjP86+5H5OvLk4O+uXfyxd6P3z5QsxThCX0lKRGvyVS55sLR0opOElcB6gIt7A9p321kNA2ARBEu/6PYs3R0OWPNJ2EKhX8x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kMNC4JqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kMNC4JqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339881F000E9;
	Mon, 31 Aug 2026 14:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184837;
	bh=0+FDiJEV6Lfoq/hZHYgx3/YHDg+5EuXR36IckprbJmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kMNC4JqCuCyWdw7r0ZH6KGdR5vM26VDLmghLLhulVerB3rYtqoeftrkuNO6VBm+OT
	 Is5IoTJ7/hOMKcDRSglYfSEEzgc7cBeZbVAFYqF9EOgiO9fASQy6i8QJqQwkufYdIp
	 wPug+4wUExKGIuIsBW46eivqmgwsimHCUkROdMQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 54/92] HID: ft260: fix stack-use-after-return write in I2C read race
Date: Mon, 31 Aug 2026 15:34:52 +0200
Message-ID: <20260831133402.528608905@linuxfoundation.org>
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

From: Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>

[ Upstream commit bf3e39df3a397fd82967a31d17c4e02c7feab221 ]

ft260_i2c_read() points dev->read_buf at a caller-supplied buffer
(often an on-stack variable), arms a completion and waits up to five
seconds for the device to return the data. The HID input callback
ft260_raw_event() runs in the input/IRQ path, independent of the
dev->lock mutex held by the read path, and copies the device-supplied
payload into dev->read_buf after a plain NULL check.

These two paths share read_buf, read_idx and read_len with no
serialization. If the device delays its response until the read
times out, ft260_i2c_read() resets the controller, clears read_buf
and returns, unwinding the stack frame the buffer lived in. A
response that arrives at that moment lets ft260_raw_event() pass the
NULL check and then memcpy() the device-controlled payload into the
now-freed stack location, a bounded but attacker-influenced
stack-use-after-return write triggerable by malicious or
malfunctioning hardware.

Add a dedicated spinlock that serializes every access to read_buf,
read_idx and read_len. ft260_raw_event() now holds it across the
NULL check, the memcpy and the index update, while the read path
takes it when arming and when clearing the buffer, so the teardown
can no longer slip between the check and the copy.

Fixes: 6a82582d9fa4 ("HID: ft260: add usb hid to i2c host bridge driver")
Cc: stable@vger.kernel.org
Signed-off-by: Raman Varabets <kernel-linux-20260610-80b7ab08@raman.v1.sg>
Reviewed-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[ adapted per-iteration locking to the flat single-shot `ft260_i2c_read()` body (no chunking loop), dropping one indentation level. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -240,6 +240,8 @@ struct ft260_device {
 	struct mutex lock;
 	u8 write_buf[FT260_REPORT_MAX_LENGTH];
 	unsigned long need_wakeup_at;
+	/* Protects read_buf, read_idx and read_len against ft260_raw_event() */
+	spinlock_t read_lock;
 	u8 *read_buf;
 	u16 read_idx;
 	u16 read_len;
@@ -500,6 +502,7 @@ static int ft260_i2c_read(struct ft260_d
 {
 	struct ft260_i2c_read_request_report rep;
 	struct hid_device *hdev = dev->hdev;
+	unsigned long irqflags;
 	u8 bus_busy = 0;
 	int timeout;
 	int ret = 0;
@@ -519,9 +522,11 @@ static int ft260_i2c_read(struct ft260_d
 
 	reinit_completion(&dev->wait);
 
+	spin_lock_irqsave(&dev->read_lock, irqflags);
 	dev->read_idx = 0;
 	dev->read_buf = data;
 	dev->read_len = len;
+	spin_unlock_irqrestore(&dev->read_lock, irqflags);
 
 	ret = ft260_hid_output_report(hdev, (u8 *)&rep, sizeof(rep));
 	if (ret < 0) {
@@ -537,7 +542,9 @@ static int ft260_i2c_read(struct ft260_d
 		goto ft260_i2c_read_exit;
 	}
 
+	spin_lock_irqsave(&dev->read_lock, irqflags);
 	dev->read_buf = NULL;
+	spin_unlock_irqrestore(&dev->read_lock, irqflags);
 
 	if (flag & FT260_FLAG_STOP)
 		bus_busy = FT260_I2C_STATUS_BUS_BUSY;
@@ -550,7 +557,9 @@ static int ft260_i2c_read(struct ft260_d
 	}
 
 ft260_i2c_read_exit:
+	spin_lock_irqsave(&dev->read_lock, irqflags);
 	dev->read_buf = NULL;
+	spin_unlock_irqrestore(&dev->read_lock, irqflags);
 	return ret;
 }
 
@@ -1019,6 +1028,7 @@ static int ft260_probe(struct hid_device
 		 ((struct hidraw *)hdev->hidraw)->minor);
 
 	mutex_init(&dev->lock);
+	spin_lock_init(&dev->read_lock);
 	init_completion(&dev->wait);
 
 	ret = ft260_xfer_status(dev, FT260_I2C_STATUS_BUS_BUSY);
@@ -1068,6 +1078,7 @@ static int ft260_raw_event(struct hid_de
 {
 	struct ft260_device *dev = hid_get_drvdata(hdev);
 	struct ft260_i2c_input_report *xfer = (void *)data;
+	unsigned long irqflags;
 
 	if (size < offsetof(struct ft260_i2c_input_report, data)) {
 		hid_err(hdev, "short report %d\n", size);
@@ -1076,6 +1087,8 @@ static int ft260_raw_event(struct hid_de
 
 	if (xfer->report >= FT260_I2C_REPORT_MIN &&
 	    xfer->report <= FT260_I2C_REPORT_MAX) {
+		bool complete_read;
+
 		ft260_dbg("i2c resp: rep %#02x len %d size %d\n",
 			  xfer->report, xfer->length, size);
 
@@ -1086,8 +1099,15 @@ static int ft260_raw_event(struct hid_de
 			return -1;
 		}
 
+		/*
+		 * Hold read_lock so a timed-out ft260_i2c_read() cannot
+		 * clear read_buf between the NULL check and the memcpy.
+		 */
+		spin_lock_irqsave(&dev->read_lock, irqflags);
+
 		if ((dev->read_buf == NULL) ||
 		    (xfer->length > dev->read_len - dev->read_idx)) {
+			spin_unlock_irqrestore(&dev->read_lock, irqflags);
 			hid_err(hdev, "unexpected report %#02x, length %d\n",
 				xfer->report, xfer->length);
 			return -1;
@@ -1096,8 +1116,11 @@ static int ft260_raw_event(struct hid_de
 		memcpy(&dev->read_buf[dev->read_idx], &xfer->data,
 		       xfer->length);
 		dev->read_idx += xfer->length;
+		complete_read = dev->read_idx == dev->read_len;
+
+		spin_unlock_irqrestore(&dev->read_lock, irqflags);
 
-		if (dev->read_idx == dev->read_len)
+		if (complete_read)
 			complete(&dev->wait);
 
 	} else {


