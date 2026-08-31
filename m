Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65E9A43E07C;
	Mon, 31 Aug 2026 14:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184827; cv=none; b=scxcvc2Eko8zopeCVYHdjjjjSFhGqL4Bsh6LKxDa/rG4GUWjbUNEMhJakkEbSVqNvZsz9STMpMPcsKy+etvjpnQkypAh70l05EuRKezWoSF19UGCvjCepPHIUp+GD5t1R5W+LbshgYWlqnUcpP48I6cOPGjDQVmn1bBcpajd0vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184827; c=relaxed/simple;
	bh=9omnvKIx8AsrnYrDZLGH8NmRrj5rl81dqSUVjNoBMdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gt9eKefFyPCUAUl066dxGlcAAbyC0WLlHwovkbH0W/xuP0ZSms7Wn47PX5fObccdRwqKK/q8PAzJ/fehVdydiyrYUcOXB9a0sWVdLevYuwNJbQUzs+t+MvQDM3cqDXFzFH4wCKRAb/YT574Gea6i2HO2ajlIW2M/aLS3tcDWNDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EoapA+pD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EoapA+pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6471F00A3D;
	Mon, 31 Aug 2026 14:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184826;
	bh=FKXpSvuj5Gbj2VAgxR20W+Bah4XN6jUg2W6y2EDQRDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EoapA+pDLtrwhGUFRVzy7DlZdOVKFWR+sR2n4q8BWNKt2BGG9MkiPIrh5cmuPL+XH
	 39sQg0uIIslCP6NmLG/LxdGFPtAGPl49u1eBxHIgOSXeNJLXRVS1NSb73+T0p2Rc1r
	 pHr+5wIqP3zwQmSW6BSTLLcuZzudPPq/NE9woxeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 50/92] HID: ft260: skip unexpected HID input reports
Date: Mon, 31 Aug 2026 15:34:48 +0200
Message-ID: <20260831133402.307270905@linuxfoundation.org>
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
 drivers/hid/hid-ft260.c |   41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

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
@@ -1041,10 +1055,9 @@ static int ft260_raw_event(struct hid_de
 			complete(&dev->wait);
 
 	} else {
-		hid_err(hdev, "unknown report: %#02x\n", xfer->report);
-		return 0;
+		hid_err(hdev, "unhandled report %#02x\n", xfer->report);
 	}
-	return 1;
+	return 0;
 }
 
 static struct hid_driver ft260_driver = {


