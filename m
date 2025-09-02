Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA5B2DD5EB;
	Tue,  2 Sep 2025 13:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820608; cv=none; b=aY6UUc3Abi/aBrcuIJLSzHS5M1g19QM9Iw9YJBakJqh+3dFk6D7LYlcnDjWeGkuuvx2aONgn98djmZsYa3j/W1Xa/6/GUvxH29wiQzovm9VolVv4UjeFYldmFFxvEs/b+xfVhOnUUBgSZkLHt+8FNXYOT3rdBMfRyytZ4o8nnTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820608; c=relaxed/simple;
	bh=DtI0seSSVWC/tatFjVhot+OoS/aq6C4AvuKdTT76s34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDiTpQhMGer5bPlFcS6b/8uo3HmBJ6kBBgYgzEnwhNerAPlxavQSkY43fKeC1D3gSO3IOmzVXJQBTK+jRG2TcRJ46PoOU9+3zY+4k8o3PJmNKWGOBPxLC03dF1JDmMgOzAt5F+ZicWVWOO+lnlL8mGM0d9VCrF1oGpUOqYI21Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Erty/T0w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Erty/T0w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6C6C4CEED;
	Tue,  2 Sep 2025 13:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820608;
	bh=DtI0seSSVWC/tatFjVhot+OoS/aq6C4AvuKdTT76s34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Erty/T0wtZMafrKHR/EydvoH4R4Zhy9ESrjeGPiSK8Lu6hLOsjMBCdw5oExDU6KaY
	 X0N2Nh7wuu06rQq6oS2samb/3dmDHHi5/E1O14nW+Rw9x05szP8ALYFLbMY3iSCW30
	 dQpoFbXMlT8P77v3xXyAPDzHrokoGTZILFixbnBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamish Martin <hamish.martin@alliedtelesis.co.nz>,
	Jiri Kosina <jkosina@suse.cz>,
	Romain Sioen <romain.sioen@microchip.com>
Subject: [PATCH 5.15 31/33] HID: mcp2221: Handle reads greater than 60 bytes
Date: Tue,  2 Sep 2025 15:21:49 +0200
Message-ID: <20250902131928.284765782@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
References: <20250902131927.045875971@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


