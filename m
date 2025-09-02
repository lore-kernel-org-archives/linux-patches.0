Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D11CF261593;
	Tue,  2 Sep 2025 13:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820364; cv=none; b=CihGwMNmnmWsGtRk7Otffj9vGyWcFx1ALaBkIp2A8V9t49l74L5rpOQ2qYV2T74NJA2dMuimhNcLtrP3z3QxgCZetKrA7D4IGni2ZQsc32e6kRfCE01Tviq2mf2bqybRYFyjH9NE29xO4IVN6l72Co8LQuJc2wE9lywazF3LfJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820364; c=relaxed/simple;
	bh=v2kmXIe/DmC/OZuOdFMOSAQMj5faWjR8YwfKkJUBy8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+c2sFX903gSXtYR2Vpual1eVPcJJffdF7zPQ220aRSHaG2Ua7HNWnZWmoZs4X4G9S7EemYubz0k/E5IN411P8f6kOxIzBzNZ+tB6wp+QNFCSmByxMcXxUv/KI+J9DN/X4CESma5c/BcKlNUHBeldyTqCXTkZCrKS8ivC0tin5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P0A6eXcO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P0A6eXcO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF8EC4CEED;
	Tue,  2 Sep 2025 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820362;
	bh=v2kmXIe/DmC/OZuOdFMOSAQMj5faWjR8YwfKkJUBy8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P0A6eXcOEpAOb9QSToFH4xXnNvHNLrtCob+DhczuXKQEj95OBS8tiySKCqZJF/3wP
	 dQFKw+kCbW3quxAcMhGu787+PsIBaSvfDj8Z86iSqYDLzhoX6MANbmWKUChTCeB0fb
	 l3rXK80QX4AnuDdePVGDISdyqfR8lazDTo0rsuHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 6.6 73/75] HID: mcp2221: Handle reads greater than 60 bytes
Date: Tue,  2 Sep 2025 15:21:25 +0200
Message-ID: <20250902131937.971637145@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -49,6 +49,7 @@ enum {
 	MCP2221_I2C_MASK_ADDR_NACK = 0x40,
 	MCP2221_I2C_WRADDRL_SEND = 0x21,
 	MCP2221_I2C_ADDR_NACK = 0x25,
+	MCP2221_I2C_READ_PARTIAL = 0x54,
 	MCP2221_I2C_READ_COMPL = 0x55,
 	MCP2221_ALT_F_NOT_GPIOV = 0xEE,
 	MCP2221_ALT_F_NOT_GPIOD = 0xEF,
@@ -297,6 +298,7 @@ static int mcp_i2c_smbus_read(struct mcp
 {
 	int ret;
 	u16 total_len;
+	int retries = 0;
 
 	mcp->txbuf[0] = type;
 	if (msg) {
@@ -320,20 +322,31 @@ static int mcp_i2c_smbus_read(struct mcp
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
 
@@ -799,7 +812,8 @@ static int mcp2221_raw_event(struct hid_
 				mcp->status = -EIO;
 				break;
 			}
-			if (data[2] == MCP2221_I2C_READ_COMPL) {
+			if (data[2] == MCP2221_I2C_READ_COMPL ||
+			    data[2] == MCP2221_I2C_READ_PARTIAL) {
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];


