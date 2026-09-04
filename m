Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D2D23BD1B;
	Fri,  4 Sep 2026 05:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498983; cv=none; b=NAILYOcDaJ/xrLfSnAx4iJkBoTBPId4FCReklMxDML0MfWtAtHljlvHfu8Aiwz6e1lC4BX2Y1v664ICYRdyv4gAM5cHFT3eH64omhx60i6FrHplRIhH9mriPz/TvUxR5yVlmUdq0fxWtwQnuSEfVCzEnbJplUHfqi/tjPz1eBmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498983; c=relaxed/simple;
	bh=zN5moGioIGPMJB2ijvykHpjwjjyRz/UzOB2yEhirtF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dB/+3M6O2bHiA9QTeol/6+AlEZICMrHP/ZsMIZAJ8LYxOSa+tGmoV5Dr5YG19KaWM39Gp0RxIdW484J/VAiVfBlixOEDlqZQKLxeUrtF6gDgyKitgN5eaYTlLB278OxnpUUI18N4w8CiL7VzmS8BpUHy6rG8AGDoVjhxsBjgdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0i7OpAA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0i7OpAA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B39C1F00A3D;
	Fri,  4 Sep 2026 05:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498981;
	bh=TM925i4CbNOH2axonbjAIsf6G8DBeD4I6KQXtffO78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O0i7OpAAoQLn1OflTqw9WmByjyUxsnbokEZs50vPboY8UUu69Nfq0DwZO+GpBHX3E
	 M0aKAmznnyhJaorpCIC8XZ4PaA5VoWW1C4FvcUS1k2q71WbPErxEIZyQz4CrNw0A+Z
	 LlntPD2vZ7TdzioP7JRCJj1H5+GTQ62G31gkavdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 255/713] HID: mcp2221: validate report size in mcp2221_raw_event()
Date: Fri,  4 Sep 2026 06:53:43 +0200
Message-ID: <20260904045809.555808602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -865,6 +865,9 @@ static int mcp2221_raw_event(struct hid_
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
+	if (size < 4)
+		return 0;
+
 	switch (data[0]) {
 
 	case MCP2221_I2C_WR_DATA:
@@ -930,6 +933,10 @@ static int mcp2221_raw_event(struct hid_
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


