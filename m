Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF232FB97F;
	Tue,  2 Sep 2025 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820706; cv=none; b=DM+IcQHdQ1sDrI0sBj6yutRPuQkM1Xh5yHPRZcIchqVf4HOsnYzNoTTWfSZSF3kQQ4TQPxhlnpZXyRAJ6zDDiU7qfXP7INFxVe/+aAtFLDvWVYhI4upzo1uRIbKvuKXjHsh81DCV+1e1ed/W9txfCP2cn0ZcMjIOO90RVVMIW3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820706; c=relaxed/simple;
	bh=nUl8N/7ScnQShUdJP/l7LSXBuVauwv+bm6gv6FjdCWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Puv7IM8kSMrgdCYGYndg69DfifPTdJYB5Kwffl/BjmU3fuZnWsPXG6nd2Brav5BitzQuDxhsBwmS7ujGcdRISHdOVQ80JtP0C/bFZMAUF3sFKTwLT8dB6ad8elXEohl+qLLxleaVGJPgR4NuZjbN/n/nxvpLH9AobejOW72XRuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lSHYQNw/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lSHYQNw/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD680C4CEF4;
	Tue,  2 Sep 2025 13:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820706;
	bh=nUl8N/7ScnQShUdJP/l7LSXBuVauwv+bm6gv6FjdCWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSHYQNw/W3hp5mccsVm6ktvrpMoWxeUk4z3fiDeWCv73ptKTOosW1rNgj+ZCmRVcx
	 KDE0qTn+HZApeNAgFxf06p1saWvxlCGmfwN7zaqSpF0juWlEUWjwrztS0trDMnEmBM
	 CqM6BZT8uKW8i2xRBoMN7FTrfchGR3F4OfHtmyZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 5.10 28/34] HID: mcp2221: Handle reads greater than 60 bytes
Date: Tue,  2 Sep 2025 15:21:54 +0200
Message-ID: <20250902131927.734305122@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131926.607219059@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hamish Martin <hamish.martin@alliedtelesis.co.nz>

commit 2682468671aa0b4d52ae09779b48212a80d71b91 upstream.

When a user requests more than 60 bytes of data the MCP2221 must chunk
the data in chunks up to 60 bytes long (see command/response code 0x40
in the datasheet).
In order to signal that the device has more data the (undocumented) byte
at byte index 2 of the Get I2C Data response uses the value 0x54. This
contrasts with the case for the final data chunk where the value
returned is 0x55 (MCP2221_I2C_READ_COMPL). The fact that 0x55 was not
returned in the response was interpreted by the driver as a failure
meaning that all reads of more than 60 bytes would fail.

Add support for reads that are split over multiple chunks by looking for
the response code indicating that more data is expected and continuing
the read as the code intended. Some timing delays are required to ensure
the chip has time to refill its FIFO as data is read in from the I2C
bus. This timing has been tested in my system when configured for bus
speeds of 50KHz, 100KHz, and 400KHz and operates well.

Signed-off-by: Hamish Martin <hamish.martin@alliedtelesis.co.nz>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Fixes: 67a95c21463d0 ("HID: mcp2221: add usb to i2c-smbus host bridge")
[romain.sioen@microchip.com: backport to stable, up to 6.8. Add "Fixes" tag]
Signed-off-by: Romain Sioen <romain.sioen@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |   32 +++++++++++++++++++++++---------
 1 file changed, 23 insertions(+), 9 deletions(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -44,6 +44,7 @@ enum {
 	MCP2221_I2C_MASK_ADDR_NACK = 0x40,
 	MCP2221_I2C_WRADDRL_SEND = 0x21,
 	MCP2221_I2C_ADDR_NACK = 0x25,
+	MCP2221_I2C_READ_PARTIAL = 0x54,
 	MCP2221_I2C_READ_COMPL = 0x55,
 	MCP2221_ALT_F_NOT_GPIOV = 0xEE,
 	MCP2221_ALT_F_NOT_GPIOD = 0xEF,
@@ -279,6 +280,7 @@ static int mcp_i2c_smbus_read(struct mcp
 {
 	int ret;
 	u16 total_len;
+	int retries = 0;
 
 	mcp->txbuf[0] = type;
 	if (msg) {
@@ -302,20 +304,31 @@ static int mcp_i2c_smbus_read(struct mcp
 	mcp->rxbuf_idx = 0;
 
 	do {
+		/* Wait for the data to be read by the device */
+		usleep_range(980, 1000);
+
 		memset(mcp->txbuf, 0, 4);
 		mcp->txbuf[0] = MCP2221_I2C_GET_DATA;
 
 		ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
-		if (ret)
-			return ret;
-
-		ret = mcp_chk_last_cmd_status_free_bus(mcp);
-		if (ret)
-			return ret;
-
-		usleep_range(980, 1000);
+		if (ret) {
+			if (retries < 5) {
+				/* The data wasn't ready to read.
+				 * Wait a bit longer and try again.
+				 */
+				usleep_range(90, 100);
+				retries++;
+			} else {
+				return ret;
+			}
+		} else {
+			retries = 0;
+		}
 	} while (mcp->rxbuf_idx < total_len);
 
+	usleep_range(980, 1000);
+	ret = mcp_chk_last_cmd_status_free_bus(mcp);
+
 	return ret;
 }
 
@@ -776,7 +789,8 @@ static int mcp2221_raw_event(struct hid_
 				mcp->status = -EIO;
 				break;
 			}
-			if (data[2] == MCP2221_I2C_READ_COMPL) {
+			if (data[2] == MCP2221_I2C_READ_COMPL ||
+			    data[2] == MCP2221_I2C_READ_PARTIAL) {
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];


