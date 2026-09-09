Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E22753FD37;
	Wed,  9 Sep 2026 14:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964607; cv=none; b=Co0ThunNyP8gg4qxXupTB5jys1Tv6AR5ZH/qKQ4UDcE+ztrYipRjJyj06oFaFNJarrp5vO5qnQdfzf/5Q2o/xcQBSCMrxj8z79q9cUeAGtNfIAKjm8c8ZfxED7sTUCBrz0vzQWTQnFJseojiflbAc6OIglE2HRnjomekt2NwF+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964607; c=relaxed/simple;
	bh=8hndO4oHZdg1cLhQQ0Psvg1Kx08ALDOuuxP3oaD/7jE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBbWeJrKAEcHhiGENBLWm9Jeks70NlrrTBGE19SNJA1aJiwkRdAYvxafgPdOL49ywXT09CKoa3+XKCUpES4IP8dvF1lo0b/MgVf5wAnDHZ4pVL1daxEyXfROjQJpGRjz6W9ysOddxkRAIeK/6/GkQvY0KmDV+5HgctmdTp/x/3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bUvFurmE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bUvFurmE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A1D1F00A3A;
	Wed,  9 Sep 2026 14:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964606;
	bh=vLY8iozEPt/u+Qm4bef3U7oNMYvlSN5fFWE1qGpJUSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUvFurmEWniyUPC1k3VREATLxiYdTj9MMWh4FdOkjh8ripeEJ+iOFMrKHyvLLphCC
	 LMzaGMZs/tHXQcd6qKjmIrBtOOJuBf+j24tgCKFrtKh67TyTngC4dr9N/Zcyaffv9K
	 V8bkQL0hOe4hWdspq16onRWo12mRZ6m55nXbvMtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 474/583] HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes
Date: Wed,  9 Sep 2026 15:42:39 +0200
Message-ID: <20260909134254.286035704@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiangshan Yi <yijiangshan@kylinos.cn>

[ Upstream commit db2333f88729c8aae062cb171ed058725ff5c901 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-mcp2221.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -336,7 +336,7 @@ static int mcp_i2c_smbus_read(struct mcp
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
 	if (ret)
-		return ret;
+		goto out;
 
 	mcp->rxbuf_idx = 0;
 
@@ -358,7 +358,7 @@ static int mcp_i2c_smbus_read(struct mcp
 			} else {
 				usleep_range(980, 1000);
 				mcp_cancel_last_cmd(mcp);
-				return ret;
+				goto out;
 			}
 		} else {
 			retries = 0;
@@ -368,6 +368,10 @@ static int mcp_i2c_smbus_read(struct mcp
 	usleep_range(980, 1000);
 	ret = mcp_chk_last_cmd_status_free_bus(mcp);
 
+out:
+	mcp->rxbuf = NULL;
+	mcp->rxbuf_size = 0;
+
 	return ret;
 }
 


