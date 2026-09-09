Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DCF656B853;
	Wed,  9 Sep 2026 14:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964724; cv=none; b=u97wC7JEHKNgwBD3oCB0qiuQHIO/RCrZb4urN4HQCPN0+O7q/0WJVBzo+0DqdARHeKgmYrx+ZtizCyFzGhNvEOPa+XWVHsUvRQxu1hZhDDxBxGuGwBxkabqJDrHmz80YHMNIqNktDwGtIo2+Ne/PxJqAt7fwyHKDWZzMCkC+OsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964724; c=relaxed/simple;
	bh=YDlBocotIJCjoknB4Rdz2/Q7ic2ISVGz4VKfloYBvuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PUtUFPD7jsqlo3NLLuVWs7HvTOd2moI8zcZmcxSKdRkkzSTi9hfsro2GcrhUvzC2ODLPdZ6m8Z5/7KpBTGKJsEfrzLLj7Unxtq5JmOhoJ5viz3+gEADEQyqXCNawIyVd39jKYn30xt7/acWDlmL0XwDJUAmr7mESQ2+Sxm68qHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLuKNdaS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLuKNdaS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0EC1F00A3A;
	Wed,  9 Sep 2026 14:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964722;
	bh=lnJW/YyJmh962pE0aS4kntBOb9kGpajDqHdlIN08PDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLuKNdaSMS3++rP6wq9RDSOMyRKpZZnSCBdjzWusQwsTAo/LHs2Tt7Sgx7x13oVrC
	 ZynChYb2+j+5bD71oYeYqjZHfgEE6NI53MTMFZJU8A/0LOZoaPh+jCbaYMsJ6mjXgh
	 B8U4mfOVEph6YOvSnMX3GYGxmyhsOqwNsZZFZfQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Florian Pradines <florian.pradines@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 473/583] HID: mcp2221: fix OOB write in mcp2221_raw_event()
Date: Wed,  9 Sep 2026 15:42:38 +0200
Message-ID: <20260909134254.252733075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Pradines <florian.pradines@gmail.com>

[ Upstream commit f097d246677b03db814c5862f368cea341b76a00 ]

mcp2221_raw_event() copies device-supplied data into mcp->rxbuf at
offset rxbuf_idx without checking that the copy fits within the
destination buffer. A device responding with up to 60 bytes to a
small I2C/SMBus read can overflow the buffer.

Add a rxbuf_size field to struct mcp2221, set it alongside rxbuf in
mcp_i2c_smbus_read(), and check rxbuf_idx + data[3] <= rxbuf_size
before the memcpy.

Reported-by: Benoît Sevens <bsevens@google.com>
Signed-off-by: Florian Pradines <florian.pradines@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Stable-dep-of: db2333f88729 ("HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -121,6 +121,7 @@ struct mcp2221 {
 	u8 *rxbuf;
 	u8 txbuf[64];
 	int rxbuf_idx;
+	int rxbuf_size;
 	int status;
 	u8 cur_i2c_clk_div;
 	struct gpio_chip *gc;
@@ -323,12 +324,14 @@ static int mcp_i2c_smbus_read(struct mcp
 		mcp->txbuf[3] = (u8)(msg->addr << 1);
 		total_len = msg->len;
 		mcp->rxbuf = msg->buf;
+		mcp->rxbuf_size = msg->len;
 	} else {
 		mcp->txbuf[1] = smbus_len;
 		mcp->txbuf[2] = 0;
 		mcp->txbuf[3] = (u8)(smbus_addr << 1);
 		total_len = smbus_len;
 		mcp->rxbuf = smbus_buf;
+		mcp->rxbuf_size = smbus_len;
 	}
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
@@ -915,6 +918,10 @@ static int mcp2221_raw_event(struct hid_
 					mcp->status = -EINVAL;
 					break;
 				}
+				if (mcp->rxbuf_idx + data[3] > mcp->rxbuf_size) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				if (4 + data[3] > size) {
 					mcp->status = -EINVAL;
 					break;


