Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E2F26D4F9;
	Mon, 23 Mar 2026 14:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277663; cv=none; b=IvL8hr+iY6fIVCfN/ggjmel+5FkOsLw9dsry7PwMvjfG1BJ+qXOHfnMsB4OY+fQyerQwfxQy0X81mn26n46KjqE2xZi03kovOEIi3Qe16V5qYlULKWHx6hdL/aAzpMrahewuZyyzumXwb5b0aDNwR79u3Bz9mm8lYJBjLeSqWPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277663; c=relaxed/simple;
	bh=C3VPQrEU5dVE/qmbd5fTGZUJd3UTO8Os76yH1Lkdsb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fofjDfx7axb/LuSkiY0FLKtfsGXDUQpfw10RR/daUvUEiPBV47f4qmnb3EOgBOITAZhWH05KX2yTpAnpRv0Qr6J6vcZUIAdos3nMiQqdRQXUdG5hCQyCtMRQghR0BYaXtLAjJj2seagXyYoguL0ZTb5xteWPVWqN56KeimlkSeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=USf0xWkL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="USf0xWkL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FAAC4CEF7;
	Mon, 23 Mar 2026 14:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277662;
	bh=C3VPQrEU5dVE/qmbd5fTGZUJd3UTO8Os76yH1Lkdsb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=USf0xWkL1fxrCw7VcGGsv3ubvdA1Hrnh/wTvv1Cml7VVH2+56dL2K2iDUl9f3l5Sy
	 0IvG2MBnCSYT8P6yseVVtflfY9ZYK04WKn0tZbt65lgj7U/YJbjg0CQJSB3XpDbpey
	 qSrIiIkAHep7Rp3OIL0leZQba0/dW0CtmyIpw0Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/567] mailbox: Use guard/scoped_guard for con_mutex
Date: Mon, 23 Mar 2026 14:39:44 +0100
Message-ID: <20260323134535.408193080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit 16da9a653c5bf5d97fb296420899fe9735aa9c3c ]

Use guard and scoped_guard for con_mutex to simplify code.

Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Stable-dep-of: fcd7f96c7836 ("mailbox: Prevent out-of-bounds access in fw_mbox_index_xlate()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c | 61 +++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 4c27de9514e55..7dcbca48d1a0f 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -6,6 +6,7 @@
  * Author: Jassi Brar <jassisinghbrar@gmail.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -370,13 +371,9 @@ static int __mbox_bind_client(struct mbox_chan *chan, struct mbox_client *cl)
  */
 int mbox_bind_client(struct mbox_chan *chan, struct mbox_client *cl)
 {
-	int ret;
-
-	mutex_lock(&con_mutex);
-	ret = __mbox_bind_client(chan, cl);
-	mutex_unlock(&con_mutex);
+	guard(mutex)(&con_mutex);
 
-	return ret;
+	return __mbox_bind_client(chan, cl);
 }
 EXPORT_SYMBOL_GPL(mbox_bind_client);
 
@@ -417,28 +414,25 @@ struct mbox_chan *mbox_request_channel(struct mbox_client *cl, int index)
 		return ERR_PTR(ret);
 	}
 
-	mutex_lock(&con_mutex);
+	scoped_guard(mutex, &con_mutex) {
+		chan = ERR_PTR(-EPROBE_DEFER);
+		list_for_each_entry(mbox, &mbox_cons, node)
+			if (mbox->dev->of_node == spec.np) {
+				chan = mbox->of_xlate(mbox, &spec);
+				if (!IS_ERR(chan))
+					break;
+			}
 
-	chan = ERR_PTR(-EPROBE_DEFER);
-	list_for_each_entry(mbox, &mbox_cons, node)
-		if (mbox->dev->of_node == spec.np) {
-			chan = mbox->of_xlate(mbox, &spec);
-			if (!IS_ERR(chan))
-				break;
-		}
+		of_node_put(spec.np);
 
-	of_node_put(spec.np);
+		if (IS_ERR(chan))
+			return chan;
 
-	if (IS_ERR(chan)) {
-		mutex_unlock(&con_mutex);
-		return chan;
+		ret = __mbox_bind_client(chan, cl);
+		if (ret)
+			chan = ERR_PTR(ret);
 	}
 
-	ret = __mbox_bind_client(chan, cl);
-	if (ret)
-		chan = ERR_PTR(ret);
-
-	mutex_unlock(&con_mutex);
 	return chan;
 }
 EXPORT_SYMBOL_GPL(mbox_request_channel);
@@ -549,9 +543,8 @@ int mbox_controller_register(struct mbox_controller *mbox)
 	if (!mbox->of_xlate)
 		mbox->of_xlate = of_mbox_index_xlate;
 
-	mutex_lock(&con_mutex);
-	list_add_tail(&mbox->node, &mbox_cons);
-	mutex_unlock(&con_mutex);
+	scoped_guard(mutex, &con_mutex)
+		list_add_tail(&mbox->node, &mbox_cons);
 
 	return 0;
 }
@@ -568,17 +561,15 @@ void mbox_controller_unregister(struct mbox_controller *mbox)
 	if (!mbox)
 		return;
 
-	mutex_lock(&con_mutex);
-
-	list_del(&mbox->node);
+	scoped_guard(mutex, &con_mutex) {
+		list_del(&mbox->node);
 
-	for (i = 0; i < mbox->num_chans; i++)
-		mbox_free_channel(&mbox->chans[i]);
+		for (i = 0; i < mbox->num_chans; i++)
+			mbox_free_channel(&mbox->chans[i]);
 
-	if (mbox->txdone_poll)
-		hrtimer_cancel(&mbox->poll_hrt);
-
-	mutex_unlock(&con_mutex);
+		if (mbox->txdone_poll)
+			hrtimer_cancel(&mbox->poll_hrt);
+	}
 }
 EXPORT_SYMBOL_GPL(mbox_controller_unregister);
 
-- 
2.51.0



