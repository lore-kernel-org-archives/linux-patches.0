Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90F047A0B0;
	Tue, 16 Jun 2026 16:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628752; cv=none; b=qFgRs6gTy28CApnE2asNw8auwCc6mRwPkDRgdIHlt0lkl0vWIu1r/CZj10IFH5aCwdpl/YdUAfC35w+NutCXClNd+Hgcy+tRkvqkqvIB80Ke/7iy64zcG+OW0bsM9IjMW2bk+QR/JlQb/YbPvBqD50dcotOpe7HFFoV13U9go84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628752; c=relaxed/simple;
	bh=ON2Lr0rrUC2y5IxuxSdluG5iJ8hAYNBfcs9UH0sZmBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8QvPSuDWCVHvOeYpTiULpH0b9XQ6eJhwc5b6QN45uECHCvED0CuuhCbiprc+m6H2cEzuT5Ocrq6mUuXlsv9LDCqUOm6L9pNd2j7OUanW3oo1FFFO+SOdsJe1xrwsdCL+L9HFGhPGGk5IhxTwmB4+c5iYuTGvDTqJufNf1FRx4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OXt6Ul1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OXt6Ul1A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6930E1F000E9;
	Tue, 16 Jun 2026 16:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628751;
	bh=bOXhqvgddTyRZQ2ITbLhJm8CP2bIt7Gc7OvTJbIvbrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OXt6Ul1Aqe+hrAHhsONK8AQn9FzGmXmNvq2BqvsjAb4rtOtU3OpK3Agc1c3+k4C47
	 8QRzcYgdON+/vv4H+0esOt1yE2tKCtuYQjqPaQa+YNz83YQ5gZjT7UlvtPyq6wAj6u
	 xzZbgP6xCEQ6ZQLDEW5aEr04kLEBEprEzKtTamYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abbfd103085885cf16a2@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Michal Pecio <michal.pecio@gmail.com>,
	Heitor Alves de Siqueira <halves@igalia.com>
Subject: [PATCH 6.6 156/452] usb: usbtmc: check URB actual_length for interrupt-IN notifications
Date: Tue, 16 Jun 2026 20:26:23 +0530
Message-ID: <20260616145125.913082722@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heitor Alves de Siqueira <halves@igalia.com>

commit 52f2ad3f7e5eb3b5908e1d685d4342519dc9cfcd upstream.

USBTMC devices can use an optional interrupt endpoint for notification
messages. These typically contain two-byte headers indicating the
payload format, but the driver does not check if these headers are
present before accessing the data buffers. In cases where the URB
actual_length is not enough to fit these headers, the driver will either
cause an out-of-bounds read, or consume stale leftover data from a
previous notification.

Fix by checking if actual_data contains enough bytes for the headers,
otherwise resubmit URB to the interrupt endpoint.

Fixes: dbf3e7f654c0 ("Implement an ioctl to support the USMTMC-USB488 READ_STATUS_BYTE operation.")
Reported-by: syzbot+abbfd103085885cf16a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abbfd103085885cf16a2
Cc: stable <stable@kernel.org>
Suggested-by: Michal Pecio <michal.pecio@gmail.com>
Signed-off-by: Heitor Alves de Siqueira <halves@igalia.com>
Link: https://patch.msgid.link/20260505-usbtmc-iin-size-v3-1-a36113f62db7@igalia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usbtmc.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/usb/class/usbtmc.c
+++ b/drivers/usb/class/usbtmc.c
@@ -2310,6 +2310,14 @@ static void usbtmc_interrupt(struct urb
 
 	switch (status) {
 	case 0: /* SUCCESS */
+		/* ensure at least two bytes of headers were transferred */
+		if (urb->actual_length < 2) {
+			dev_warn(dev,
+				"actual length %d not sufficient for interrupt headers\n",
+				urb->actual_length);
+			goto exit;
+		}
+
 		/* check for valid STB notification */
 		if (data->iin_buffer[0] > 0x81) {
 			data->bNotify1 = data->iin_buffer[0];


