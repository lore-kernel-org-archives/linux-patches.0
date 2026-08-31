Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF56A480DF5;
	Mon, 31 Aug 2026 14:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184820; cv=none; b=mAXlC0kAyR7BFKynYAjRywf1S6bBOGUvMDzzF4RPYRhg6i2uhSZVT45sNhiQeOHgx/zXGjt0/elYKV7BViXulL5wmXu2lFeg4kQ3AqbyuLjkq9Y6WTEZKmgLH0EqvFBQbEg/48oAg22RKCyBbtJHX9yZOwNIfpPcXmem5AvD/Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184820; c=relaxed/simple;
	bh=B5bte070//TaxRPJAo1LZhwOT6/0nMh9SzQBXxosQC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=byzdBDk7ogQKB+F5cYOLjWxNuORfnEh6Uwmxy+1kLfBfAcLmWJNt2TFQt1Rp30X86UZP2klcFKc5HK8/F7+oHLM1Egj4ZjhU2mIUGC14Vvu1Oz3CSpNzc/Zeamrhef6+aU9UWMfSv2MRcSs1T+JCYzx5IDqtwekMIfj8bXEk4bY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0IoTU0gr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0IoTU0gr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D981F000E9;
	Mon, 31 Aug 2026 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184817;
	bh=hBP+BN/nMCHazavJTLYnP4fVHpYgw2s2dLPguvS53pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0IoTU0grjYsuaWsDy80cZAQLPH/EjAI7pR+JH9gbIK+Oh711T67BKRjP1VHDfkpka
	 WzovgDWJSSAJKjcmsPgTuRhJbjvsJ2Pl/e+DBw0wqS23qTClycL7Fn4S5yYKeM5mx8
	 wgSqaHS9biNUfDdm3bafo76eEMfZgCHYrTS4YRwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Zaidman <michael.zaidman@gmail.com>,
	Guillaume Champagne <champagne.guillaume.c@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/92] HID: ft260: improve i2c write performance
Date: Mon, 31 Aug 2026 15:34:46 +0200
Message-ID: <20260831133402.208968248@linuxfoundation.org>
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

[ Upstream commit 6fca5e3f5574ca1bd5bade5737848c816f924c6a ]

The patch improves the I2C write performance by 20 - 30 percent by
revising the sleep time in the ft260_hid_output_report_check_status()
in the following ways:

1. Reduce the wait time and start to poll earlier.

Sending a large amount of data at a low I2C clock rate saturates the
internal FT260 buffer and causes hiccups in status readiness, as shown
below in the log fragment. Aligning the status check wait time to the
worst case significantly reduces the write performance.

[Oct22 10:28] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.005296] ft260_xfer_status: bus_status 0x20, clock 100
[  +0.013460] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.003244] ft260_hid_output_report_check_status: wait 1920 usec, len 38
[  +0.000190] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.015324] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.003491] ft260_hid_output_report_check_status: wait 1920 usec, len 38
[  +0.000202] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.016047] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.002768] ft260_hid_output_report_check_status: wait 1920 usec, len 38
[  +0.000150] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.011389] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.003467] ft260_hid_output_report_check_status: wait 1920 usec, len 38
[  +0.000191] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000172] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000131] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000241] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000233] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000190] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000196] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.011314] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0
[  +0.003334] ft260_hid_output_report_check_status: wait 1920 usec, len 38
[  +0.000227] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000204] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000198] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000147] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.011060] ft260_i2c_write: rep 0xd8 addr 0x51 off 0 len 34 d[0] 0x0

  Before:
    $ sudo ./i2cperf -f 2 -o 2 -s 32 -r 0-0xff 13 0x51 -S

      Fill block with increment via i2ctransfer by chunks
      -------------------------------------------------------------------
      data rate(bps)  efficiency(%)  data size(B)  total IOs   IO size(B)
      -------------------------------------------------------------------
      40510           80             256           8           32

  After:
    $ sudo ./i2cperf -f 2 -o 2 -s 32 -r 0-0xff 13 0x51 -S

      Fill block with increment via i2ctransfer by chunks
      -------------------------------------------------------------------
      data rate(bps)  efficiency(%)  data size(B)  total IOs   IO size(B)
      -------------------------------------------------------------------
      52584           80             256           8           32

2. Do not sleep if the estimated I2C transfer time is below 2 ms since
   the first xfer status query frequently takes around 1.5 ms, and the
   following status queries take about 200us on average. So we usually
   return from the routine after the first 1 - 3 status checks.

[Oct22 11:14] ft260_i2c_write: rep 0xd4 addr 0x51 off 0 len 18 d[0] 0x0
[  +0.004270] ft260_xfer_status: bus_status 0x20, clock 100
[  +0.013889] ft260_i2c_write: rep 0xd4 addr 0x51 off 0 len 18 d[0] 0x0
[  +0.000856] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000138] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.013352] ft260_i2c_write: rep 0xd4 addr 0x51 off 0 len 18 d[0] 0x0
[  +0.001501] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000177] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.014477] ft260_i2c_write: rep 0xd4 addr 0x51 off 0 len 18 d[0] 0x0
[  +0.001377] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000233] ft260_xfer_status: bus_status 0x41, clock 100
[  +0.000191] ft260_xfer_status: bus_status 0x40, clock 100
[  +0.013197] ft260_i2c_write: rep 0xd4 addr 0x51 off 0 len 18 d[0] 0x0

  Before:
    $ sudo ./i2cperf -f 2 -o 2 -s 16 -r 0-0xff 13 0x51 -S

      Fill block with increment via i2ctransfer by chunks
      -------------------------------------------------------------------
      data rate(bps)  efficiency(%)  data size(B)  total IOs   IO size(B)
      -------------------------------------------------------------------
      28826           73             256           16          16

  After:
    $ sudo ./i2cperf -f 2 -o 2 -s 16 -r 0-0xff 13 0x51 -S

      Fill block with increment via i2ctransfer by chunks
      -------------------------------------------------------------------
      data rate(bps)  efficiency(%)  data size(B)  total IOs   IO size(B)
      -------------------------------------------------------------------
      45138           73             256           16          16

Signed-off-by: Michael Zaidman <michael.zaidman@gmail.com>
Tested-by: Guillaume Champagne <champagne.guillaume.c@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Stable-dep-of: bf3e39df3a39 ("HID: ft260: fix stack-use-after-return write in I2C read race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-ft260.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/hid/hid-ft260.c
+++ b/drivers/hid/hid-ft260.c
@@ -355,7 +355,7 @@ static int ft260_hid_output_report(struc
 static int ft260_hid_output_report_check_status(struct ft260_device *dev,
 						u8 *data, int len)
 {
-	int ret, usec, try = 3;
+	int ret, usec, try = 100;
 	struct hid_device *hdev = dev->hdev;
 
 	ret = ft260_hid_output_report(hdev, data, len);
@@ -366,10 +366,14 @@ static int ft260_hid_output_report_check
 		return ret;
 	}
 
-	/* transfer time = 1 / clock(KHz) * 10 bits * bytes */
-	usec = 10000 / dev->clock * len;
-	usleep_range(usec, usec + 100);
-	ft260_dbg("wait %d usec, len %d\n", usec, len);
+	/* transfer time = 1 / clock(KHz) * 9 bits * bytes */
+	usec = len * 9000 / dev->clock;
+	if (usec > 2000) {
+		usec -= 1500;
+		usleep_range(usec, usec + 100);
+		ft260_dbg("wait %d usec, len %d\n", usec, len);
+	}
+
 	do {
 		ret = ft260_xfer_status(dev);
 		if (ret != -EAGAIN)


