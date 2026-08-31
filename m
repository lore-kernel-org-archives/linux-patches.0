Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 943064B53E0;
	Mon, 31 Aug 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184830; cv=none; b=G6cWBKPC0QRM39cnj/4BYBCAfoCC2kQxNME/ZCApNMKmoADcNZu3wG2sCXit+OYLgCkan+P61GYj3Riwj7w0qS5vKaSNgsuCYgw9FRujyhpeC8gYDLkvZaYXfgKmpOpCfOtlAYrslx9SZZrEOKri9u8FPiC9u4ESRhY/Xn9x5j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184830; c=relaxed/simple;
	bh=hUEO8sD2y/JP+jrrcq4DSIsePyaPeC+fr47xDLSkvvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkeZerdUFmBQegY+Hv5pWpEaSPCnrSjRewxiQsPR6FT1XEZl+8GoSRf1n1DR2547mwWLCUzMvT4dRuqh2RAAKUgEGaW91ijBV9HljRNlYnqpeU88n3gBG1kOmPQEtcB1MVaM9ag6Pbt47TJiL34kBiXkKxMK1BF5hSjIjfge7ZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYgW9snR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYgW9snR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F58B1F000E9;
	Mon, 31 Aug 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184829;
	bh=mNvGtDiGEk7QMQ2jl/ULkToZX+9S5rY3jGGvgOScBvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nYgW9snRTmgBOe2ichjoCAnr5VaunOMKvOUsClVBUAU0iazfN/m7/XCWc+7QeMGUm
	 Nms9qATvzJGrrNzAzW9YA7lVapbW9Fi9YDAiWAIxGIQcyBl+SAvy9V9IE8qyG/qqFF
	 T6rS86VeKK18L7lJf3blXjRiMKanw/0OfS2AHgfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 51/92] HID: ft260: wake up device from power saving mode
Date: Mon, 31 Aug 2026 15:34:49 +0200
Message-ID: <20260831133402.381173322@linuxfoundation.org>
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


