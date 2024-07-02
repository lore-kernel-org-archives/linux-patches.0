Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D3014293;
	Tue,  2 Jul 2024 17:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940896; cv=none; b=RkFYqTXgYRWFfEzXh6l7IO71LxdNRWknwM9U2FtSM4SiVMyz3MFaYgrDWtfIsfl0dPCsF8/ZRlqFklmDP8l/DIC8yn7sZHy1Exgjeg/lS4yijJC/b5mdW2FtvYLvEJgTjyZdwrH2oqfakg7NwJx6uX2tKSLic7FkHT+oWfmfzaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940896; c=relaxed/simple;
	bh=QObmch+mpMpEo9cmUkBjM1HkVuTuGlv4g/l6gWjKL0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yvs0iq+Nx07whcyzaaepuRoooN1OguCfkrKVw4N6jtMHNicUiSkAJkZk2VgTBeAL9hJy+Blb1jq9dw3crwQY3Sn2ioUjqhRjx0JJehsP9I5rnAqOeC434vHanqUesSSt9V041NfPA/FFcYT/dFIVDCzvKzQjQN7rc2c4cv/VG0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b1i4gWuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b1i4gWuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF3BC116B1;
	Tue,  2 Jul 2024 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940896;
	bh=QObmch+mpMpEo9cmUkBjM1HkVuTuGlv4g/l6gWjKL0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1i4gWuJWJiF3fiNvVR1ygSLdn0FQq7rJhJM/qHAbRmL45vKaD9sZWD/rMv/NxiaD
	 kgl9pC4C1ZbS7V5rhTqXSvcjHq0quQdVpLSJXezrKGjYsVtZQHONTMsGMdcfJuSacl
	 OeMA3YBmP10dT8tRoIB6lm5l1LWm8bFk6EpPXKNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/163] soc: ti: wkup_m3_ipc: Send NULL dummy message instead of pointer message
Date: Tue,  2 Jul 2024 19:03:01 +0200
Message-ID: <20240702170235.601894084@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3aff106fc11a0..9a22932984232 100644
--- a/drivers/soc/ti/wkup_m3_ipc.c
+++ b/drivers/soc/ti/wkup_m3_ipc.c
@@ -16,7 +16,6 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include <linux/of.h>
-#include <linux/omap-mailbox.h>
 #include <linux/platform_device.h>
 #include <linux/remoteproc.h>
 #include <linux/suspend.h>
@@ -314,7 +313,6 @@ static irqreturn_t wkup_m3_txev_handler(int irq, void *ipc_data)
 static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 {
 	struct device *dev = m3_ipc->dev;
-	mbox_msg_t dummy_msg = 0;
 	int ret;
 
 	if (!m3_ipc->mbox) {
@@ -330,7 +328,7 @@ static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 	 * the RX callback to avoid multiple interrupts being received
 	 * by the CM3.
 	 */
-	ret = mbox_send_message(m3_ipc->mbox, &dummy_msg);
+	ret = mbox_send_message(m3_ipc->mbox, NULL);
 	if (ret < 0) {
 		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
 			__func__, ret);
@@ -352,7 +350,6 @@ static int wkup_m3_ping(struct wkup_m3_ipc *m3_ipc)
 static int wkup_m3_ping_noirq(struct wkup_m3_ipc *m3_ipc)
 {
 	struct device *dev = m3_ipc->dev;
-	mbox_msg_t dummy_msg = 0;
 	int ret;
 
 	if (!m3_ipc->mbox) {
@@ -361,7 +358,7 @@ static int wkup_m3_ping_noirq(struct wkup_m3_ipc *m3_ipc)
 		return -EIO;
 	}
 
-	ret = mbox_send_message(m3_ipc->mbox, &dummy_msg);
+	ret = mbox_send_message(m3_ipc->mbox, NULL);
 	if (ret < 0) {
 		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
 			__func__, ret);
-- 
2.43.0



