Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AD72DEA68;
	Tue, 22 Jul 2025 13:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192571; cv=none; b=dHXS5RHxQxFI0+pqQYx5wntqOCtjvPHxWGDt4NPb0I24i8V97Cameby9bvj5A/epXs3Iaf66T0xaMxL/tIb3vieHveKNc83X3Uj4oZqxjVXKN+MH2cNW3SGWne5vawDRClrwChKkcwmYYK5mbTxrKMsWmC9ZbBOfaHXtKJ4k7Ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192571; c=relaxed/simple;
	bh=doB/rxLx0rn6bDKw4NwcS+dl2eIwrwLd3n21GSEiMtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EScktM5f6FANgxnijLNWrGykB5LYiwfpHxMXSKG/4nqRcRAzJK7Ac5BWCTnqvbn8mFFby6kpp0xueEFX/ltHLSUAXSV4FJAkvxQo321zXzQhzRFBSzXq5FzQnytgAcHUJatgBJPd/PzyTp9lTqoFryD5F4d1eTcv5iR2/Oz4QbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwDTNrHX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwDTNrHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AE0C4CEEB;
	Tue, 22 Jul 2025 13:56:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192571;
	bh=doB/rxLx0rn6bDKw4NwcS+dl2eIwrwLd3n21GSEiMtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EwDTNrHXZZCFqbmDjXhRZcvdcnHePzlZawqvXZ5tutjTTM5OWQafqP7BO76TwXWtg
	 zRZsgJUBKYf1VZraA8VwYihFPWhbzNSODCSo1AedsV1UE35BLjCSUtzmpt/+91uKPj
	 468911mwrxCeGPPdC6btoNZoW+6jC/fRcjXGHxtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bbbade4e1a7ab45ca3b@syzkaller.appspotmail.com,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/111] hwmon: (corsair-cpro) Validate the size of the received input buffer
Date: Tue, 22 Jul 2025 15:44:48 +0200
Message-ID: <20250722134336.106906554@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Marius Zachmann <mail@mariuszachmann.de>

[ Upstream commit 495a4f0dce9c8c4478c242209748f1ee9e4d5820 ]

Add buffer_recv_size to store the size of the received bytes.
Validate buffer_recv_size in send_usb_cmd().

Reported-by: syzbot+3bbbade4e1a7ab45ca3b@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-hwmon/61233ba1-e5ad-4d7a-ba31-3b5d0adcffcc@roeck-us.net
Fixes: 40c3a4454225 ("hwmon: add Corsair Commander Pro driver")
Signed-off-by: Marius Zachmann <mail@mariuszachmann.de>
Link: https://lore.kernel.org/r/20250619132817.39764-5-mail@mariuszachmann.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-cpro.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/hwmon/corsair-cpro.c b/drivers/hwmon/corsair-cpro.c
index 280b90646a873..b37f36f55f88a 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -84,6 +84,7 @@ struct ccp_device {
 	struct mutex mutex; /* whenever buffer is used, lock before send_usb_cmd */
 	u8 *cmd_buffer;
 	u8 *buffer;
+	int buffer_recv_size; /* number of received bytes in buffer */
 	int target[6];
 	DECLARE_BITMAP(temp_cnct, NUM_TEMP_SENSORS);
 	DECLARE_BITMAP(fan_cnct, NUM_FANS);
@@ -139,6 +140,9 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 	if (!t)
 		return -ETIMEDOUT;
 
+	if (ccp->buffer_recv_size != IN_BUFFER_SIZE)
+		return -EPROTO;
+
 	return ccp_get_errno(ccp);
 }
 
@@ -150,6 +154,7 @@ static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	spin_lock(&ccp->wait_input_report_lock);
 	if (!completion_done(&ccp->wait_input_report)) {
 		memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
+		ccp->buffer_recv_size = size;
 		complete_all(&ccp->wait_input_report);
 	}
 	spin_unlock(&ccp->wait_input_report_lock);
-- 
2.39.5



