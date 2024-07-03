Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52BC16E5ED;
	Wed,  3 Jul 2024 11:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006085; cv=none; b=kvgbosm1K3cVL9L1bWw1Mf3QtGyyJYalh1cVCcmk3L5ZCTncn/YaiaRhPKgOB8rPh+XafF0r34FCymqBzQ79IMNr6lsFtmhQgGncRYSqMubhyko2VwQS2q9NoMW9i9ktg5suEu4vK30efcprKTQ/yVovmdcv52RF7Q4bYGMNBfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006085; c=relaxed/simple;
	bh=WqnA6W80ySVu5UtQqCMf6Pkez5HLF1nxbyLcbOnZq8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1W5Sisasf474qqb0Xh2aQszp3HgzaHBGlcvi5CDoERWS+cIbU6xX/4wuzTwkCBkMwSmfv/EyRM8IGk0o3j3qmkjjcR7mdFAeYzvsS19VzkA2NG0qCuYdSx2zlShkbvbvAGmZ0TF07i1+/Ma1Rj4pt7mHeXUvEIs/H/3pJe6FKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OiMNtB6T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OiMNtB6T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953DDC2BD10;
	Wed,  3 Jul 2024 11:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006085;
	bh=WqnA6W80ySVu5UtQqCMf6Pkez5HLF1nxbyLcbOnZq8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OiMNtB6TiPOpjVErOKVIs8+iJyUN6Z+b29tmlTKv0ehfczRHt3kI2XlDAZQdUAeDi
	 dbhXOLRhr4Fr5kXxjqN5PeqJyCVFykETKfz35+wXHCmEGOW1aMz2a335vv0grFsScq
	 F/k8L4K37W3gQ3ZCk6A4Piv64GLXeZskBhoJkgEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 296/356] soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message
Date: Wed,  3 Jul 2024 12:40:32 +0200
Message-ID: <20240703102924.313835654@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit ddbf3204f600a4d1f153498f618369fca352ae00 ]

mbox_send_message() sends a u32 bit message, not a pointer to a message.
We only convert to a pointer type as a generic type. If we want to send
a dummy message of 0, then simply send 0 (NULL).

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240325165507.30323-1-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/wkup_m3_ipc.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
index 8b3ff44fd9010..967c40059a431 100644
--- a/drivers/soc/ti/wkup_m3_ipc.c
+++ b/drivers/soc/ti/wkup_m3_ipc.c
@@ -14,7 +14,6 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/omap-mailbox.h>
 #include <linux/platform_device.h>
 #include <linux/remoteproc.h>
 #include <linux/suspend.h>
@@ -151,7 +150,6 @@ static irqreturn_t wkup_m3_txev_handler(int irq, void *ipc_data)
 static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 {
 	struct device *dev = m3_ipc->dev;
-	mbox_msg_t dummy_msg = 0;
 	int ret;
 
 	if (!m3_ipc->mbox) {
@@ -167,7 +165,7 @@ static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 	 * the RX callback to avoid multiple interrupts being received
 	 * by the CM3.
 	 */
-	ret = mbox_send_message(m3_ipc->mbox, &dummy_msg);
+	ret = mbox_send_message(m3_ipc->mbox, NULL);
 	if (ret < 0) {
 		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
 			__func__, ret);
@@ -189,7 +187,6 @@ static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 static int wkup_m3_ping_noirq(struct wkup_m3_ipc *m3_ipc)
 {
 	struct device *dev = m3_ipc->dev;
-	mbox_msg_t dummy_msg = 0;
 	int ret;
 
 	if (!m3_ipc->mbox) {
@@ -198,7 +195,7 @@ static int wkup_m3_ping_noirq(struct wkup_m3_ipc *m3_ipc)
 		return -EIO;
 	}
 
-	ret = mbox_send_message(m3_ipc->mbox, &dummy_msg);
+	ret = mbox_send_message(m3_ipc->mbox, NULL);
 	if (ret < 0) {
 		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
 			__func__, ret);
-- 
2.43.0



