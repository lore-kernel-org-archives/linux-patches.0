Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E7A1428E4;
	Wed,  3 Jul 2024 10:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004203; cv=none; b=JwJaRD22L3W6VZT21DObPW6T8uuy9llGl6ERkuyBLfyVQHQg39R23Nb4i10+E0OuueSsSlvAgaKLXANBjl6vMui1syB2QyqluwdeJbaFi1+EpuISDq1Qsxf4iP20iRg8x7/Jlwz3lIPaDDxAJV/AOYMut36trl67RDEjNgiPWZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004203; c=relaxed/simple;
	bh=yuKXtjYbrI5x9YhJ7AyI7pzC40EGnbkF/ooYq1Sx44s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wma1kiEcheHJ456hzZBxoYSrJyX0fdhNzVHCes0OoGvBHqIsLnCCTUIZVRxFFpbbRADGcDznvetOqsJB6ly7vETiSkG/EtElpB/Bt//wG4r5SnhetNza/gfLXF1iTCMBEvYTJro7SoYuHsdTWQEsmTaEZVtYnAvM0UoEaqZTX4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yg6xyurE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yg6xyurE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B14BC2BD10;
	Wed,  3 Jul 2024 10:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004202;
	bh=yuKXtjYbrI5x9YhJ7AyI7pzC40EGnbkF/ooYq1Sx44s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yg6xyurERw5oFXm8Qgb5nhzKOhc7SiuYM9RysIhS/6XFOsOukgBG1Af0+ftcW9l0V
	 NC4CWS3+JT4JMOqRrRPIdfdhPF3bSofAyGFKcXjg818gR3JHCE9Iq0fUY6+mZoVHge
	 XQGTfGlqVg4aDFtWSBRWaJNWLcthU3rKxCD3D7ZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/189] soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message
Date: Wed,  3 Jul 2024 12:40:14 +0200
Message-ID: <20240703102847.246164000@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index ef3f95fefab58..6634709e646c4 100644
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



