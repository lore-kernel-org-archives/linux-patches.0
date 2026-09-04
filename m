Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C85358378;
	Fri,  4 Sep 2026 06:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502221; cv=none; b=K1rVI1cTw+U8W4MG1X7PrN7zlxl7BouhiK9xbhLyrZpxPTSjzkoKkC47WOk7deaJFNAucs4MzKxGkXk70cXepelJTn+3/UqL2SZbbP41oZJ5HJF0idgX4+sXY5psedWTmis8n/m7+5pw3gGiM5Y0L0ltJY11ytFHCSEbAHHH/LQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502221; c=relaxed/simple;
	bh=a4AKjsWjy9E2Y7KhxJw/xzU6gCddnJ+3FZq+foyfNWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uqW0OLTJyQW8vJfimQtDmNvol13OCIAySg2mhgNglNXFGZFQOsoH8CElEWB4YQidaP5Ax4F4VUuFn0tx4OUO5v/I7cP+ryYyQyfY5WKSt2+SzWxktKyq0zB+CzGh9omnpFb8MxoDnxNoORGcsWLCV4DopTZM0/kOMbGZ1hr2W9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzAwSoEt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzAwSoEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1DF1F00A3D;
	Fri,  4 Sep 2026 06:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502219;
	bh=rYYdafv5/7oVhPcWCmm0gIZH99EOiQ4BhwSbESoynFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzAwSoEtvS/lCh+wLcH8A6H28WuRP5NccTnZdrOD96kn/7JfC24eeqX2U/eWcKK96
	 TuD1Ek5quMPzXz/vmYj8nX7/QSum92L/1i8AKNOoh8o6mNc6KetZ1DaDYbDiLpz6eL
	 VvoKKYf1rcjGrrjWcHctJ95xEfi5c2NGWmWcJGGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 129/403] HID: mcp2221: validate report size in mcp2221_raw_event()
Date: Fri,  4 Sep 2026 06:58:52 +0200
Message-ID: <20260904045737.771444725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -759,6 +759,9 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
+	if (size < 4)
+		return 0;
+
 	switch (data[0]) {
 
 	case MCP2221_I2C_WR_DATA:
@@ -820,6 +823,10 @@ static int mcp2221_raw_event(struct hid_
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


