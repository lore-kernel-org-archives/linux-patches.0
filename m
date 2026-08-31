Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9550E48C8D9;
	Mon, 31 Aug 2026 14:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185048; cv=none; b=fIKtk7QbBgTw/roqL+YNW8/UiclymE5oa0Uv81c/q8TpygvnVtYv7KaiG6EbrkRum8ab2sWAEY5Xgd3XQFHCzTzZ3WUJZP6tFlhZANN2YRG+Iat60kWOSQT2DCBxymWRRxLMjvBLgRmap1TD1g5fz0AqCDG+r3bFAyfAv0XYsuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185048; c=relaxed/simple;
	bh=GOZBkXDR0ybTyScLQxC9WzYDe4HVNA7R7+Y1VgnVAq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A4SpzHW9TIOVT4r1L+dlA/waW0VX1LmxqwPq3R0N5YG9NnzTwhEBZZMZidjewH0MaqIoMP0qe4tnmT8o6BzwyNQcwuSw2p4+2nZI7BWPIlh1USgQfmwmDv1M6b2BSiUi+Zk0X8kjDKXJWFOPubNq6SjGUB6r9l4CbenT21gC3Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L216Rx+T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L216Rx+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFE51F000E9;
	Mon, 31 Aug 2026 14:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185047;
	bh=UH5yp9noDmXo+KKs4BTQ06URw6rd6IRbV/N/e5ufLx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L216Rx+TK6jMW+n36NTmes8FQ3teK8FqQcDJ2EomOCu2bKmVo7CNTq/C8h9PqyS9r
	 zwbYULkByL7HMU8qb3RTm8g7g+5mlQHCPTbpSEXlOOSnBacybQ/PkUQm00BTXCXSys
	 zns1Fq2Zz/II7CKcVEp0qBjU7DY03rTp59VS8hTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/69] HID: ft260: skip unexpected HID input reports
Date: Mon, 31 Aug 2026 15:35:09 +0200
Message-ID: <20260831133400.312139551@linuxfoundation.org>
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

[ Upstream commit b7121e3c04440cc2af9cabbabb24efd23741294a ]

The FT260 is not supposed to generate unexpected HID reports. However,
in theory, the unsolicited HID Input reports can be issued by a specially
crafted malicious USB device masquerading as FT260 when the attacker has
physical access to the USB port. In this case, the read_buf pointer points
to the final data portion of the previous I2C Read transfer, and the memcpy
invoked in the ft260_raw_event() will try copying the content of the
unexpected report into the wrong location.

This commit sets the Read buffer pointer to NULL on the I2C Read
transaction completion and checks it in the ft260_raw_event() to detect
and skip the unsolicited Input report.

Reported-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   36 +++++++++++++++++++++++++-----------
 1 file changed, 25 insertions(+), 11 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -471,17 +471,13 @@ static int ft260_i2c_read(struct ft260_d
 	struct ft260_i2c_read_request_report rep;
 	struct hid_device *hdev = dev->hdev;
 	int timeout;
-	int ret;
+	int ret = 0;
 
 	if (len > FT260_RD_DATA_MAX) {
 		hid_err(hdev, "%s: unsupported rd len: %d\n", __func__, len);
 		return -EINVAL;
 	}
 
-	dev->read_idx = 0;
-	dev->read_buf = data;
-	dev->read_len = len;
-
 	rep.report = FT260_I2C_READ_REQ;
 	rep.length = cpu_to_le16(len);
 	rep.address = addr;
@@ -492,25 +488,36 @@ static int ft260_i2c_read(struct ft260_d
 
 	reinit_completion(&dev->wait);
 
+	dev->read_idx = 0;
+	dev->read_buf = data;
+	dev->read_len = len;
+
 	ret = ft260_hid_output_report(hdev, (u8 *)&rep, sizeof(rep));
 	if (ret < 0) {
 		hid_err(hdev, "%s: failed to start transaction, ret %d\n",
 			__func__, ret);
-		return ret;
+		goto ft260_i2c_read_exit;
 	}
 
 	timeout = msecs_to_jiffies(5000);
 	if (!wait_for_completion_timeout(&dev->wait, timeout)) {
+		ret = -ETIMEDOUT;
 		ft260_i2c_reset(hdev);
-		return -ETIMEDOUT;
+		goto ft260_i2c_read_exit;
 	}
 
+	dev->read_buf = NULL;
+
 	ret = ft260_xfer_status(dev);
-	if (ret == 0)
-		return 0;
+	if (ret < 0) {
+		ret = -EIO;
+		ft260_i2c_reset(hdev);
+		goto ft260_i2c_read_exit;
+	}
 
-	ft260_i2c_reset(hdev);
-	return -EIO;
+ft260_i2c_read_exit:
+	dev->read_buf = NULL;
+	return ret;
 }
 
 /*
@@ -1033,6 +1040,13 @@ static int ft260_raw_event(struct hid_de
 		ft260_dbg("i2c resp: rep %#02x len %d\n", xfer->report,
 			  xfer->length);
 
+		if ((dev->read_buf == NULL) ||
+		    (xfer->length > dev->read_len - dev->read_idx)) {
+			hid_err(hdev, "unexpected report %#02x, length %d\n",
+				xfer->report, xfer->length);
+			return -1;
+		}
+
 		memcpy(&dev->read_buf[dev->read_idx], &xfer->data,
 		       xfer->length);
 		dev->read_idx += xfer->length;


