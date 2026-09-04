Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D023BD1B;
	Fri,  4 Sep 2026 05:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498980; cv=none; b=bX9WQVw55s8It8fXB76caE7vqm86vz5BqyD3l2VdGBdkVdoDKstNYTZC9YICGRngoA9VtHZ/yB5zuja+4lXaXbQuN5Q5bQM4IqUMT59jZvnN87ByMMzTLEsuh8QlKDSCZdpWt/5Kat7d/cWPmpnvGWc02AauejvwtniTobLNjJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498980; c=relaxed/simple;
	bh=badNxRxNIOq7JzYnqD6WQjDvSvghcGOqfBhA/S/T3CY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLBpU3oREcOFEMGnk32Y/vtz64RwB1R0e8P4iuIkgURn56QncRZOqmSG7EJ6qB0NSi6xusGm9pvebH46EKBG3umDv4DWIZsLzxkxBi4aYxskl+CBSaIT8AnNRbSxS5VMIrW4mgzB8KUlPM4CHXoJVlVWvOCJ60PXLWLWrCsgl84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BR5V0kde; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BR5V0kde"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FBA31F00A3D;
	Fri,  4 Sep 2026 05:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498979;
	bh=dEiGkVM0pkWyJdQaeVzTPiBPe3Tgg6a1u8W+BaLIwDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BR5V0kdeUg4MY1aXyHxtl4XwmX1+Pw/1CW+NQku4inY+McrxpxQkfB6DCtaT3BJWt
	 2Brgx3V1kwlzpilitfkRP/VEM+d5RzLPcg5J8p/osehR4nS9ZQfCMjNivNnUTPLXkA
	 rZc9gm7lXIo3XqZB6Zf8ATveU6U67GJVW0fpdyKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 7.2 254/713] HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes
Date: Fri,  4 Sep 2026 06:53:42 +0200
Message-ID: <20260904045809.533589461@linuxfoundation.org>
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

commit db2333f88729c8aae062cb171ed058725ff5c901 upstream.

mcp_i2c_smbus_read() stores the caller-supplied buffer pointer in
mcp->rxbuf for the duration of a transfer but never clears it when the
transfer finishes or times out. Once the caller frees or reuses the
buffer, mcp->rxbuf becomes a dangling pointer. A delayed or spurious
MCP2221_I2C_GET_DATA report can then drive mcp2221_raw_event() to
memcpy device data into the freed memory, causing a write
use-after-free.

Route all return paths through a single exit point that clears
mcp->rxbuf and mcp->rxbuf_size, so that the existing !mcp->rxbuf guard
in the raw_event handler can reject any report arriving after the
transfer has ended.

Fixes: 67a95c21463d ("HID: mcp2221: add usb to i2c-smbus host bridge")
Cc: stable@vger.kernel.org
Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -343,7 +343,7 @@ static int mcp_i2c_smbus_read(struct mcp
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
 	if (ret)
-		return ret;
+		goto out;
 
 	mcp->rxbuf_idx = 0;
 
@@ -365,7 +365,7 @@ static int mcp_i2c_smbus_read(struct mcp
 			} else {
 				usleep_range(980, 1000);
 				mcp_cancel_last_cmd(mcp);
-				return ret;
+				goto out;
 			}
 		} else {
 			retries = 0;
@@ -375,6 +375,10 @@ static int mcp_i2c_smbus_read(struct mcp
 	usleep_range(980, 1000);
 	ret = mcp_chk_last_cmd_status_free_bus(mcp);
 
+out:
+	mcp->rxbuf = NULL;
+	mcp->rxbuf_size = 0;
+
 	return ret;
 }
 


