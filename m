Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72673B7752;
	Thu, 17 Sep 2026 19:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671690; cv=none; b=O3dafCn+ECPE5Lu3AU6ycsxFEliBCMiPB8LKTnkFkRfIbWAiGIYrvPdpx9WdUutACwXk3NUQcfP36WF5ZpOSL490Nbv8ucIZRLb7FjkrNz3Pck13NTkb3KXMeR8mgikeRNqR1AbRhwptDGaO/BCQYnM3Ui7iwulOjD83roFsQ2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671690; c=relaxed/simple;
	bh=uihquVLZ93GmJ+//Y9IhIb27pya5howLxliTbakjTDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M96htBofC8g8jT0I9G87dZDlbJ3JYWTEL/+kcqNTMhNMf9f/byKjoFOwHwsrzegPSNEY/coFoPlW+ePhx8Rwg4qzOr+P/kf7puHZAPvy0jDna7lS0yQ28dRIUuAjgyQtmtNq1BeDOwiZUoNc3BP9aB1CPVBJFrIKJS8ba0diGqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dbm4E8t+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dbm4E8t+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490C71F00893;
	Thu, 17 Sep 2026 19:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671686;
	bh=4l97jw7bpExDNLZJF95bd9Kh4QWkoQ6YWqcyKhQ/cvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dbm4E8t+5JPmrSXLzYlwsEEX5E7qI5aocfx6ndGtmuXfyudv6trnynRxIpgWCMWbm
	 erpSu03pA1ly27QD+IYRJW/y4ApEPcEa4i759jv3Lwha9zW4+EeVHx/T0IZROmtGs/
	 cReDRcxIXlswyUM2jGJIDpOs4XD7JhDWhE7j2n/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiangshan Yi <yijiangshan@kylinos.cn>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1058/1102] HID: mcp2221: clear rxbuf after I2C/SMBus transfer completes
Date: Thu, 17 Sep 2026 16:16:41 +0100
Message-ID: <20260917151607.373279105@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -320,7 +320,7 @@ static int mcp_i2c_smbus_read(struct mcp
 
 	ret = mcp_send_data_req_status(mcp, mcp->txbuf, 4);
 	if (ret)
-		return ret;
+		goto out;
 
 	mcp->rxbuf_idx = 0;
 
@@ -342,7 +342,7 @@ static int mcp_i2c_smbus_read(struct mcp
 			} else {
 				usleep_range(980, 1000);
 				mcp_cancel_last_cmd(mcp);
-				return ret;
+				goto out;
 			}
 		} else {
 			retries = 0;
@@ -352,6 +352,10 @@ static int mcp_i2c_smbus_read(struct mcp
 	usleep_range(980, 1000);
 	ret = mcp_chk_last_cmd_status_free_bus(mcp);
 
+out:
+	mcp->rxbuf = NULL;
+	mcp->rxbuf_size = 0;
+
 	return ret;
 }
 


