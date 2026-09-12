Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D312F6931;
	Sat, 12 Sep 2026 17:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232699; cv=none; b=Uu5OqqUAUawkaNoBc32CpMLajU5QorVA0OvDdhwczax9PMskOl3+yDC3VHYPKZAdQUC8U9Ywx/pV/rX8pzeFzzjxBI+RpTFTy6pStBq3pbMomF0A/zIAClQLbSBRVHT0yCy/QSv3MlnlzqECHWf9nGZJ8hnvwwXYThMMewhmrGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232699; c=relaxed/simple;
	bh=7MkhR+tBfWnMro5q4gKP2xU95Y6Ovyj0JxbUrhV1feQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EszJ3FMXB1elYVMGtTo6pVYf89pObXyhskpTg+/aifPB05Iej3Bshp/RqTbVBwszGlzS0X5dVomLC4tWSIkVtsSEdGi8K/v3UHtF7OE5gBbEi2NJrP7abvhTIHXPEU8Jvk8E/BlK+Sp+Sqq68T3hGPAMe0BXxxbIbXugwEj3uKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWgDDHMo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWgDDHMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9AA1F000FF;
	Sat, 12 Sep 2026 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232698;
	bh=5uY9MBkGHIt6GSFtQZLJeoxAn607XWNgSLNwbfHJApw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hWgDDHMoxGa5NzP8sRC24wkUqR1hwKQzxaMd/l2d6V5xqW9JBhpSwXslD4PaPkSKI
	 Em4zMLsdjrE+xYogynUKCz2Biq0LLrGSNoE6/b8Uet5k8cLXE/b9JX53WzfvO9Z2VC
	 nsSjcr7qqIsWbgbohtTWVU5YQT753KvW1yeYbGNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 5.15 062/935] HID: mcp2221: validate report size in mcp2221_raw_event()
Date: Sat, 12 Sep 2026 08:51:32 +0200
Message-ID: <20260912065528.262231339@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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


