Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E0037701A;
	Sat, 17 Oct 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259710; cv=none; b=Ejy4KxQ6/4r44oJ3yBJP97ITtOPK2vYzsTy1f+EzivbXj0eTUmWFHm2tqo9pDE1VN0+jGqmsgpoA8hfv1hy7Bvw1Dg9YlV+WtkLFbTO9nl6bJsjzXdO3SP/ZC4P0KQp8L8UZRWIj3pREJWUgigf0bqIABAtyiZCb8stARSTjwSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259710; c=relaxed/simple;
	bh=KaXNY1XFia6ny1xjLcQRx6NnvVNNUjZ9bi2yOwOM9Bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GeHoKT7Cgd1I4s3M5pnIDFWGbNsEYrHKb3KLlSErbryrjyZTeMfNHDES14fs0/MEnGkph25D7nImEU2LOXKBHsXpSZ+oijWK5AGRw2jhwOWpZbFXSyVcIH5AyFrpo0L6UMPXQSiMkwDZKtnb2KtTlyweyxNMf0OEbyML6d75dqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HlgKH7EB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HlgKH7EB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC371F000C4;
	Sat, 17 Oct 2026 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259709;
	bh=vNukxmMHOVC8dctA09cIEo7BaIfXDAM5C79pAbrjAic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HlgKH7EBR4KxdHdWrd4x3vhPCyd4BJ4rqG7VFBQle2hGEvApN6kXMUJat2DJU4M3u
	 zvkI5MpK07WWh6kgYsQLsNTSzA5g5sGNv3cUS8aKtOUxoZN190C1KUCdCNDAVvvH4O
	 mDwfanJU0S0WdSJLfvKxJVaQqbSlH5sFVg+NzJ+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Beno=C3=AEt=20Sevens?= <bsevens@google.com>,
	Florian Pradines <florian.pradines@gmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Sonnet 5.5" <noreply@anthropic.com>
Subject: [PATCH 6.6 1304/1674] HID: mcp2221: fix OOB write in mcp2221_raw_event()
Date: Sat, 17 Oct 2026 17:59:36 +0200
Message-ID: <20261017160504.618462338@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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

[ Keep the existing size check and also set rxbuf_size for the SMBus
  block read paths so they are not rejected by the new check. ]
Co-Authored-By: Claude Sonnet 5.5 <noreply@anthropic.com>

Stable-dep-of: db2333f88729 ("HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-mcp2221.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index 6678b14e9855a..075ad0beae6a3 100644
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
@@ -307,12 +308,14 @@ static int mcp_i2c_smbus_read(struct mcp2221 *mcp,
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
@@ -522,6 +525,7 @@ static int mcp_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 
 			mcp->rxbuf_idx = 0;
 			mcp->rxbuf = data->block;
+			mcp->rxbuf_size = sizeof(data->block);
 			mcp->txbuf[0] = MCP2221_I2C_GET_DATA;
 			ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
 			if (ret)
@@ -545,6 +549,7 @@ static int mcp_smbus_xfer(struct i2c_adapter *adapter, u16 addr,
 
 			mcp->rxbuf_idx = 0;
 			mcp->rxbuf = data->block;
+			mcp->rxbuf_size = sizeof(data->block);
 			mcp->txbuf[0] = MCP2221_I2C_GET_DATA;
 			ret = mcp_send_data_req_status(mcp, mcp->txbuf, 1);
 			if (ret)
@@ -827,6 +832,10 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 					mcp->status = -EINVAL;
 					break;
 				}
+				if (mcp->rxbuf_idx + data[3] > mcp->rxbuf_size) {
+					mcp->status = -EINVAL;
+					break;
+				}
 				buf = mcp->rxbuf;
 				memcpy(&buf[mcp->rxbuf_idx], &data[4], data[3]);
 				mcp->rxbuf_idx = mcp->rxbuf_idx + data[3];
-- 
2.53.0



