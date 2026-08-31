Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE60E43F4C5;
	Mon, 31 Aug 2026 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185046; cv=none; b=oUXQQgZiQJHd0jOAtviIXbiKtBt0XF6kH0MDyBXt3j/NarqD4AZ+AVZmv9yYG+D8VnWg/7/vCzvwQN24azHaielOZlIucx8MXcjfy/X5XUFjwa6Te+PBSZK3fgRT0pYonFV7xFBJYOpFbtSNy2FSdQrFflZDsZwiw6i5Nju1bL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185046; c=relaxed/simple;
	bh=8zXpWTAXN1p/UtXli9KSTFt8BLV1HziS82isxPMKefE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qPNf3qoBvA6R6hgSoVzdUGXCOgkLaiCe5o5ybDU7DpmO9hfUcmYMSGM1Q/sOSTSLmwCM2gRHINE21mwiehglRCKkJf8tc6Ah7d0oYhRsabWrQ/daqx/uQRGmUTa1MXHlTUN9RBjJt6UQAe8yYTNcld0Gl7+P6LlakW5UUs5v7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kce6Uxqw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kce6Uxqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12CE91F000E9;
	Mon, 31 Aug 2026 14:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185044;
	bh=JASqQ2lxa3kq0KUpgbSqrZdh+oafStpTZqAhkqE03aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kce6UxqwzUE5tEOXzU3tMLJhimje4PiPJlXB6NShAwZxBpP8hSdw8IWbzK9WCrHmj
	 tyTznDnuY7t6CgUSP9onNmCluPG77bE1r03i2KrjqXpoJBOcNiPPhpdLtyE69K1mlD
	 2B4/NbCWavE9stQFUoGOlkXl+eTEZr6u9A7Er3fU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrik Berkhan <Enrik.Berkhan@inka.de>,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 35/69] HID: ft260: improve i2c large reads performance
Date: Mon, 31 Aug 2026 15:35:08 +0200
Message-ID: <20260831133400.267835382@linuxfoundation.org>
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

[ Upstream commit 54410c14800ad652c77e5c6fc5c17baad6e42cb6 ]

The patch increases the read buffer size to 180 bytes. It reduces
the number of ft260_i2c_read() calls by three, improving the big
reads performance.

$ sudo i2ctransfer -y -f 13 w2@0x51 0x0 0x0 r180

Before:

[  +4.071878] ft260_i2c_write_read: off 0x0 rlen 180 wlen 2
[  +0.000005] ft260_i2c_write: rep 0xd0 addr 0x51 off 0 len 2 wlen 2 flag 0x2 d[0] 0x0
[  +0.001097] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000175] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.000004] ft260_i2c_read: rep 0xc2 addr 0x51 len 180 rlen 60 flag 0x3
[  +0.008579] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.000208] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.000001] ft260_i2c_read: rep 0xc2 addr 0x51 len 120 rlen 60 flag 0x0
[  +0.008794] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.000181] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.000002] ft260_i2c_read: rep 0xc2 addr 0x51 len 60 rlen 60 flag 0x4
[  +0.008817] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.000223] ft260_xfer_status: bus_status 0x20, clock 100

After:

[ +11.611642] ft260_i2c_write_read: off 0x0 rlen 180 wlen 2
[  +0.000005] ft260_i2c_write: rep 0xd0 addr 0x51 off 0 len 2 wlen 2 flag 0x2 d[0] 0x0
[  +0.008001] ft260_xfer_status: bus_status 0x20, clock 100
[  +0.000001] ft260_i2c_read: rep 0xc2 addr 0x51 len 180 rlen 180 flag 0x7
[  +0.008994] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.007987] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.007992] ft260_raw_event: i2c resp: rep 0xde len 60
[  +0.000206] ft260_xfer_status: bus_status 0x20, clock 100

Suggested-by: Enrik Berkhan <Enrik.Berkhan@inka.de>
Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -30,12 +30,19 @@ MODULE_PARM_DESC(debug, "Toggle FT260 de
 
 #define FT260_REPORT_MAX_LENGTH (64)
 #define FT260_I2C_DATA_REPORT_ID(len) (FT260_I2C_REPORT_MIN + (len - 1) / 4)
+
 /*
- * The input report format assigns 62 bytes for the data payload, but ft260
- * returns 60 and 2 in two separate transactions. To minimize transfer time
- * in reading chunks mode, set the maximum read payload length to 60 bytes.
- */
-#define FT260_RD_DATA_MAX (60)
+ * The ft260 input report format defines 62 bytes for the data payload, but
+ * when requested 62 bytes, the controller returns 60 and 2 in separate input
+ * reports. To achieve better performance with the multi-report read data
+ * transfers, we set the maximum read payload length to a multiple of 60.
+ * With a 100 kHz I2C clock, one 240 bytes read takes about 1/27 second,
+ * which is excessive; On the other hand, some higher layer drivers like at24
+ * or optoe limit the i2c reads to 128 bytes. To not block other drivers out
+ * of I2C for potentially troublesome amounts of time, we select the maximum
+ * read payload length to be 180 bytes.
+*/
+#define FT260_RD_DATA_MAX (180)
 #define FT260_WR_DATA_MAX (60)
 
 /*


