Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88FB437467;
	Thu, 17 Sep 2026 19:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671688; cv=none; b=m70qoJD6Us3LMhmFQlc6CcwwfXQaGkFtz2I19J2PUIUA+oCycSzNplx1akDPBwJvAty/ZoLG180OV0hM7V+UupT9fcbB41BivcXDmEmAuv+ZPFEpD0L5m5dMEnsOyMw3HkeRQdkVy31BO0YWsv9Ei08qkt++UiR5JXJNlCJ/xY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671688; c=relaxed/simple;
	bh=12mXA/evNCSGN+Fn3Gc5lZgEqQOLA7IXehiuIlHsTPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SmnNXcBVOnuQid8MUb9SLdhTgyCsWcvzvWWs6FnLP2uAze1wfQkMIlpUqxCCM6RJNyU+ZPLE5BvoSNVl71toHld2UN1yGNJ9IV6iLqZ00U3cTgP8hSW/PUIq2G0KLsRdy8DYVu3C3c2rhZ0PxNoonxwE9YU81OiBMmIaV82wohc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WP9QNXfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WP9QNXfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 663A91F00899;
	Thu, 17 Sep 2026 19:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671682;
	bh=QB4izwhgNf75Nn29sFFlH2oyJOeJ+guVPQ2wskWHmGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WP9QNXfL8NOvxN5mz81rPSFDxPXKiB1UeUfbvg0vugBhxZhvvwpBUZLjZQkeOtbBj
	 mfWJfYe3v2uqS8PnRRFfmb2waKge7LdBCzUZTeglfL6WL3pFFuLj3aqb8UlXkOAloR
	 7Oa99Kde58rl0eBRZF8xLwPX+vR5xr0gqtfMdlXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Florian Pradines <florian.pradines@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1057/1102] HID: mcp2221: fix OOB write in mcp2221_raw_event()
Date: Thu, 17 Sep 2026 16:16:40 +0100
Message-ID: <20260917151607.347481410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -99,6 +99,7 @@ struct mcp2221 {
 	u8 *rxbuf;
 	u8 txbuf[64];
 	int rxbuf_idx;
+	int rxbuf_size;
 	int status;
 	u8 cur_i2c_clk_div;
 	struct gpio_chip *gc;
@@ -307,12 +308,14 @@ static int mcp_i2c_smbus_read(struct mcp
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
@@ -823,6 +826,10 @@ static int mcp2221_raw_event(struct hid_
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


