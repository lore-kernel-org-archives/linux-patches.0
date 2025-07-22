Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3F621917E3;
	Tue, 22 Jul 2025 14:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193061; cv=none; b=oJwO3cs6muGyOqcf7G+tm1p5VweE/RHVPt9bVM7kBolex2PC6OwXSLGyqsf7APb9ZcTJexPJDSe866pBi5FdL5S6IlRzCFu9RIYT3gjUGvPJd+eAl/aXnu+gR/1e7mIf1h/jd/CJtJ3SxfNGQRyDeo3ZAWHEA6a8aE1M3QibUw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193061; c=relaxed/simple;
	bh=fHZhFWd4avnJM0DHGG3jyoUMuPAmm34l6RP8snHww98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnzHs6rFnGeT0x4ysHhMoYZu4jJVFVLa1oQRfdwEpYQef4eCYaCtsGR9/st65j9fGn8KYEo92lzLptV3PEkdZaMSv6KecY07H2uu+JGzn4UFad1pRHwuuGCP9hIl+Z12tIIDbyYcL4rgg4Gds2jRrPUk8daEb4iGMyW98JTTs0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vr+2pjiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vr+2pjiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34284C4CEEB;
	Tue, 22 Jul 2025 14:04:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193061;
	bh=fHZhFWd4avnJM0DHGG3jyoUMuPAmm34l6RP8snHww98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vr+2pjiDaMyywaeB4d/y8T7nMpogy8l4xhDNI+EbM4im46pZ7z5PVoZSfCmYg1BA4
	 T1eT94Yb+k7AI5cHGg7yBGHyB2bXBsDuYCHcJMt2bMuk5rc4zVG5ZTknoEVKyzFE9r
	 zqDNNwpcavOJZCIQLtBxxyJhK4bDyp9zQW8Rlorw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3bbbade4e1a7ab45ca3b@syzkaller.appspotmail.com,
	Marius Zachmann <mail@mariuszachmann.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/158] hwmon: (corsair-cpro) Validate the size of the received input buffer
Date: Tue, 22 Jul 2025 15:44:50 +0200
Message-ID: <20250722134344.696383320@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e1a7f7aa7f804..b7b911f8359c7 100644
--- a/drivers/hwmon/corsair-cpro.c
+++ b/drivers/hwmon/corsair-cpro.c
@@ -89,6 +89,7 @@ struct ccp_device {
 	struct mutex mutex; /* whenever buffer is used, lock before send_usb_cmd */
 	u8 *cmd_buffer;
 	u8 *buffer;
+	int buffer_recv_size; /* number of received bytes in buffer */
 	int target[6];
 	DECLARE_BITMAP(temp_cnct, NUM_TEMP_SENSORS);
 	DECLARE_BITMAP(fan_cnct, NUM_FANS);
@@ -146,6 +147,9 @@ static int send_usb_cmd(struct ccp_device *ccp, u8 command, u8 byte1, u8 byte2,
 	if (!t)
 		return -ETIMEDOUT;
 
+	if (ccp->buffer_recv_size != IN_BUFFER_SIZE)
+		return -EPROTO;
+
 	return ccp_get_errno(ccp);
 }
 
@@ -157,6 +161,7 @@ static int ccp_raw_event(struct hid_device *hdev, struct hid_report *report, u8
 	spin_lock(&ccp->wait_input_report_lock);
 	if (!completion_done(&ccp->wait_input_report)) {
 		memcpy(ccp->buffer, data, min(IN_BUFFER_SIZE, size));
+		ccp->buffer_recv_size = size;
 		complete_all(&ccp->wait_input_report);
 	}
 	spin_unlock(&ccp->wait_input_report_lock);
-- 
2.39.5



