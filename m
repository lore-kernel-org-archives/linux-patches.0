Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77DC278161;
	Sat, 12 Sep 2026 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226906; cv=none; b=LkMxc1VmmRC0ynqidLPY+31kk2KdbtfMUhtWkow0rJvyK2g9Uez4bE+xqqbe+BQpzAynUYa7VN1+uWeH7lH2EbgSXABdxVLL8rnrFYQUZzNAhToWwDhiCNFD7bg+qDdiZs4Lv+sXviFebjaI6b+TmdCMMte9ts0fL/TxXUtY6tM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226906; c=relaxed/simple;
	bh=lB/cWPaM5ZcPegr9g20uLDYzpTmzO2GmqLcARA7o8+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYPbYkYUda8/lB2krTfu8v7svR05v48foJVw12JepDcODEurG5WsBOh3mPddF70NdGBy8g8pee072lfLMWDAFkzbxWef46tHGpXCL1zOC1T32YwiAfwMvJc930NUn2sRYlCSfWdRLdw7oU1HoyeqkT+F45lR2D0TW5xUNzG3uXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vElW5yXC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vElW5yXC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A253E1F000FF;
	Sat, 12 Sep 2026 15:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226903;
	bh=o8vv34rgPq/WaoqdB1X3sd3FWdcYrq2CYG3/gx8DpuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vElW5yXCG/LBAVNRoToW/fWWBYf9ggJ2nY+k6vB66nJsvhsm43qJ7TOggfO1zzJZu
	 6iKnezsu0XC8Lr/L2lEMxXteid80Ijdu/nsl5hsl/lDrm6hOCPk9S1OIdTR+t0HZUt
	 7D7QNGyBTnWnDxykBzqQ751uRqgvQYdRPpL+gDn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.1 0073/1191] HID: mcp2221: validate report size in mcp2221_raw_event()
Date: Sat, 12 Sep 2026 08:46:41 +0200
Message-ID: <20260912065549.801177706@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

From: Jiangshan Yi <yijiangshan@kylinos.cn>

commit 2c9a6998c19503626c57a2267bf279e204113079 upstream.

mcp2221_raw_event() never validates the size of incoming HID reports.
In the MCP2221_I2C_GET_DATA path it trusts the device-supplied data[3]
as the copy length without checking that 4 + data[3] bytes actually
exist in the received report. A malicious or misbehaving USB device can
send a short report with a large data[3], causing the memcpy to read
past the valid report data in the HID transfer buffer and leak
uninitialized kernel memory back to userspace through the I2C/SMBus
read path.

Add a minimum size check at entry and validate that the source range
fits within the received report before the copy.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -739,6 +739,9 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
+	if (size < 4)
+		return 0;
+
 	switch (data[0]) {
 
 	case MCP2221_I2C_WR_DATA:
@@ -797,6 +800,10 @@ static int mcp2221_raw_event(struct hid_
 					mcp->status = -EINVAL;
 					break;
 				}
+				if (4 + data[3] > size) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];


