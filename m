Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7486B48987C;
	Mon, 31 Aug 2026 14:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185052; cv=none; b=rb6cz06LymZOFGAens8ar+9dBMX+369pB9MZZIdhqqi422YvNRrP1OuFemYKTHwpbDS1LvD7+pgi9jJDd33IhyjjM6Bo2LleHm4dOyOWFR4scKnphpQLCuSdaXhKKgaucLyrcm/xkokYraWWG7RmxMaM80MFZauSYbFnDFBwj1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185052; c=relaxed/simple;
	bh=COII7TgoEgR2kJhNJetVK/wXXblb9czVeTpEUMBI6TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2c/OCKE+nidlFScZyf4saROgWCQv5JNb57yiD0Vrw18yXQGdXcyHbS6eKL2oben4ztx1KXH2k2CKskWYaghMpVBOTdwkF67Qh2qA5Yy8bPq2aDoqCWfpNZMdI0MpMATL/DljHe4FIfjcgbIllgrrCPuWhE40DPHpH656nQw4ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vY7aFjxC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vY7aFjxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC871F000E9;
	Mon, 31 Aug 2026 14:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185050;
	bh=tAu8H5BXO3M5tOhWx3hsRa21b2V4jjpAA5Ic4Ghw2Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vY7aFjxCIZ3zmE9RBdxrFhTq2eJjc2Qjy9wQq+Apibt7cv0KIu3/iksoXYwfQKUhC
	 lsLZ1Ary1sZrkJVjN3vvDQ54LEY4vn2yxvHFuNqKsAHiaHrQo8v1tztpO9yD5a//ZV
	 VkKTpLeoEwkL0YvK+jmWnzMmeKcf7fJyfLFdYs14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 37/69] HID: ft260: wake up device from power saving mode
Date: Mon, 31 Aug 2026 15:35:10 +0200
Message-ID: <20260831133400.367295659@linuxfoundation.org>
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

[ Upstream commit 4b3da6853a619a952e8caf2e8393264dd42ffa27 ]

The FT260 can enter a power saving mode after being idle for longer
than 5 seconds.

When being woken up from power saving mode by an I2C write request,
a possible NACK is not correctly reported by the controller. As a
workaround, the driver will issue an I2C status report two times in
ft260_xfer_status() after the chip has been idle for more than 5s.

Co-developed-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Signed-off-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -31,6 +31,8 @@ MODULE_PARM_DESC(debug, "Toggle FT260 de
 #define FT260_REPORT_MAX_LENGTH (64)
 #define FT260_I2C_DATA_REPORT_ID(len) (FT260_I2C_REPORT_MIN + (len - 1) / 4)
 
+#define FT260_WAKEUP_NEEDED_AFTER_MS (4800) /* 5s minus 200ms margin */
+
 /*
  * The ft260 input report format defines 62 bytes for the data payload, but
  * when requested 62 bytes, the controller returns 60 and 2 in separate input
@@ -237,6 +239,7 @@ struct ft260_device {
 	struct completion wait;
 	struct mutex lock;
 	u8 write_buf[FT260_REPORT_MAX_LENGTH];
+	unsigned long need_wakeup_at;
 	u8 *read_buf;
 	u16 read_idx;
 	u16 read_len;
@@ -306,6 +309,20 @@ static int ft260_xfer_status(struct ft26
 	struct ft260_get_i2c_status_report report;
 	int ret;
 
+	if (time_is_before_jiffies(dev->need_wakeup_at)) {
+		ret = ft260_hid_feature_report_get(hdev, FT260_I2C_STATUS,
+						(u8 *)&report, sizeof(report));
+		if (unlikely(ret < 0)) {
+			hid_err(hdev, "failed to retrieve status: %d, no wakeup\n",
+				ret);
+		} else {
+			dev->need_wakeup_at = jiffies +
+				msecs_to_jiffies(FT260_WAKEUP_NEEDED_AFTER_MS);
+			ft260_dbg("bus_status %#02x, wakeup\n",
+				  report.bus_status);
+		}
+	}
+
 	ret = ft260_hid_feature_report_get(hdev, FT260_I2C_STATUS,
 					   (u8 *)&report, sizeof(report));
 	if (unlikely(ret < 0)) {


