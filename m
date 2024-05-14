Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDCA4E1C9;
	Tue, 14 May 2024 11:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686576; cv=none; b=igFh0FKEfOWZL85J6nsoNLswCBtcpFVzE+1PYiVt8zCP9PaFiPmqcoboIGUQYVsE6WocAamvyOpMTVzP7s7Ha7jmEqrYIJ3bViSsEVPms30D9QLj62T7vYEhAtMPd7hn5I/XQS7dM4brsSDNWc8NDEYxQlQ6AP4DGF23CMcmXms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686576; c=relaxed/simple;
	bh=TO/JOY8vMVSip6msMzutHXkXIYWtMdZ2BcVa4WFpFpk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i/nxsvC1J3oHjFyBPQ+fMfGvy0Qy0d/FbbcHLbkr2OUkdJgtzzO9BNt4Bn+d0wVqGU3s75BKqL40YWw+1HpvZmCKZsARAMxAheprj5/0b14+za6wnKT63ud58onAq93ESzEOGeIX0IEAU3w7YGldCYQ/D9HdlJzliFxZJ9yIako=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G3W2I4rs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G3W2I4rs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768ECC2BD10;
	Tue, 14 May 2024 11:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686575;
	bh=TO/JOY8vMVSip6msMzutHXkXIYWtMdZ2BcVa4WFpFpk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G3W2I4rs4rt2m+3pDJpj30Thjpy1sjtDnMwHqrrTXejJspU6cLos5+bAF4McbBOQr
	 EcMu4HzbnhDKQnlHOorhezrf9RVV00zjauZF7mz+5Gpwt/5wDvJvhfUvXtH6ylMPKW
	 KYIP2aN2jL10jW62ADW44F5z4KCtI9K6LGkUDIec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksa Savic <savicaleksa83@gmail.com>,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/236] hwmon: (corsair-cpro) Use a separate buffer for sending commands
Date: Tue, 14 May 2024 12:18:36 +0200
Message-ID: <20240514101026.211653001@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aleksa Savic <savicaleksa83@gmail.com>

[ Upstream commit e0cd85dc666cb08e1bd313d560cb4eff4d04219e ]

Introduce cmd_buffer, a separate buffer for storing only
the command that is sent to the device. Before this separation,
the existing buffer was shared for both the command and the
report received in ccp_raw_event(), which was copied into it.

However, because of hidraw, the raw event parsing may be triggered
in the middle of sending a command, resulting in outputting gibberish
to the device. Using a separate buffer resolves this.

Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Aleksa Savic <savicaleksa83@gmail.com>
Acked-by: Marius Zachmann <mail@mariuszachmann.de>
Link: https://lore.kernel.org/r/20240504092504.24158-2-savicaleksa83@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index fa6aa4fc8b521..0a9cbb556188f 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -79,6 +79,7 @@ struct ccp_device {
 	struct device *hwmon_dev;
 	struct completion wait_input_report;
 	struct mutex mutex; /* whenever buffer is used, lock before send_usb_cmd */
+	u8 *cmd_buffer;
 	u8 *buffer;
 	int target[6];
 	DECLARE_BITMAP(temp_cnct, NUM_TEMP_SENSORS);
@@ -111,15 +112,15 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 	unsigned long t;
 	int ret;
 
-	memset(ccp->buffer, 0x00, OUT_BUFFER_SIZE);
-	ccp->buffer[0] = command;
-	ccp->buffer[1] = byte1;
-	ccp->buffer[2] = byte2;
-	ccp->buffer[3] = byte3;
+	memset(ccp->cmd_buffer, 0x00, OUT_BUFFER_SIZE);
+	ccp->cmd_buffer[0] = command;
+	ccp->cmd_buffer[1] = byte1;
+	ccp->cmd_buffer[2] = byte2;
+	ccp->cmd_buffer[3] = byte3;
 
 	reinit_completion(&ccp->wait_input_report);
 
-	ret = hid_hw_output_report(ccp->hdev, ccp->buffer, OUT_BUFFER_SIZE);
+	ret = hid_hw_output_report(ccp->hdev, ccp->cmd_buffer, OUT_BUFFER_SIZE);
 	if (ret < 0)
 		return ret;
 
@@ -492,7 +493,11 @@ static int ccp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (!ccp)
 		return -ENOMEM;
 
-	ccp->buffer = devm_kmalloc(&hdev->dev, OUT_BUFFER_SIZE, GFP_KERNEL);
+	ccp->cmd_buffer = devm_kmalloc(&hdev->dev, OUT_BUFFER_SIZE, GFP_KERNEL);
+	if (!ccp->cmd_buffer)
+		return -ENOMEM;
+
+	ccp->buffer = devm_kmalloc(&hdev->dev, IN_BUFFER_SIZE, GFP_KERNEL);
 	if (!ccp->buffer)
 		return -ENOMEM;
 
-- 
2.43.0



