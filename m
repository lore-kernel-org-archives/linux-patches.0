Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DCF3DBD48;
	Wed, 30 Sep 2026 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794135; cv=none; b=C/PnR6U5igUPTMqj0utwWVh2eLTQA1v+JYF/++RR+K0EQYFWu6JBk+mCz22GqcLYXvBfhvTGI+JJwesxRTpwim/DP0OFV0Tr47dkuqz7dMB8G95jJkdAAwzjiDp5+YqY8Lz1VHvMG6gTp9KmiP1G7dUjCcVJcZUVr4/6RdLYtd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794135; c=relaxed/simple;
	bh=uslc0CyShOwb1/2WWRMcdZ88qMjf5qfhyrz5ZxyCv+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/rDWMmi/KfKHbrY0+L3EhYZnU28WEQZnY79KdJONNs319AFi71jI9qIocOJhcuSneSvXZiYIrS5LSiR020NdAssPlTucWaP3z15Syv93eziS35M/PfY8S0Y8e4uW/ylxonT/7eOqeYUihEf67MVcEhNdYtjTRxz8RoCId3+Zb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=un204JVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="un204JVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1259E1F000FF;
	Wed, 30 Sep 2026 18:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794134;
	bh=r+7eqX9RCfTSRlX3gKhqF+2N70BDWp4E7R9CT5C3CDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=un204JVcIjzywQ8wwICg7m1BUnDfC0hpb9K9dxI9XMddhrcv64RNQGMqTqTFe9Zta
	 mZICU/yEnmShV2VTokpjYO2C+tIuWPKhZva/ghYJnlaGrkQ3tvbyI+ppZXfGbx3jpQ
	 ZZ6KqcAhjJj1p4Q8Kj1a0wX7nBCPP1EJ9g+zIMHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonwon Kang <joonwonkang@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0059/1193] mailbox: Make mbox_send_message() return error code when tx fails
Date: Wed, 30 Sep 2026 17:12:23 +0200
Message-ID: <20260930152435.589914988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Joonwon Kang <joonwonkang@google.com>

[ Upstream commit 96a3d2f3167f5644b30e60171898e67123c3c2c6 ]

When the mailbox controller failed transmitting message, the error code
was only passed to the client's tx done handler and not to
mbox_send_message() in blocking mode. For this reason, the function could
return a false success. This commit resolves the issue by introducing the
tx status and checking it before mbox_send_message() returns.

This commit works with the premise that the multi-threads' access to a
channel in blocking mode is serialized by clients, not by the mailbox
APIs, since the current mbox_send_message() in blocking mode does not
support multi-threads.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/mailbox.c          | 6 +++++-
 include/linux/mailbox_controller.h | 2 ++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 39269359e3a64..b68c5f681ed1c 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -110,8 +110,10 @@ static void tx_tick(struct mbox_chan *chan, int r)
 	if (chan->cl->tx_done)
 		chan->cl->tx_done(chan->cl, mssg, r);
 
-	if (r != -ETIME && chan->cl->tx_block)
+	if (r != -ETIME && chan->cl->tx_block) {
+		chan->tx_status = r;
 		complete(&chan->tx_complete);
+	}
 }
 
 static enum hrtimer_restart txdone_hrtimer(struct hrtimer *hrtimer)
@@ -281,6 +283,8 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 		if (ret == 0) {
 			t = -ETIME;
 			tx_tick(chan, t);
+		} else if (chan->tx_status < 0) {
+			t = chan->tx_status;
 		}
 	}
 
diff --git a/include/linux/mailbox_controller.h b/include/linux/mailbox_controller.h
index b91379922cb33..2acd8524754c3 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -111,6 +111,7 @@ struct mbox_controller {
  * @txdone_method:	Way to detect TXDone chosen by the API
  * @cl:			Pointer to the current owner of this channel
  * @tx_complete:	Transmission completion
+ * @tx_status:		Transmission status
  * @active_req:		Currently active request hook
  * @msg_count:		No. of mssg currently queued
  * @msg_free:		Index of next available mssg slot
@@ -123,6 +124,7 @@ struct mbox_chan {
 	unsigned txdone_method;
 	struct mbox_client *cl;
 	struct completion tx_complete;
+	int tx_status;
 	void *active_req;
 	unsigned msg_count, msg_free;
 	void *msg_data[MBOX_TX_QUEUE_LEN];
-- 
2.53.0



