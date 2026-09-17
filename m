Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7200F3B27DF;
	Thu, 17 Sep 2026 17:52:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667551; cv=none; b=r1Ovm+NLnCWCg/rZFBzuccgkH1Wp6v1YYrJuGRBGtpWrHGrvSxZzHUW1Ur/W9rYnfTmFZIo0en0qiBv8plUqKkdzSe5rYOU3I57Jj9ILqoPL6ODIrPiqsleFR0Ax9UTBBdQ6bmh+cgyOFLLLUPHiJnD6VsZP9SW1zXbjg0SEDxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667551; c=relaxed/simple;
	bh=xJj0zriFmn3xgVsBUQQInSIoq9jyQOwchsCWmEoLV7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7beMpk3o1AEmdezBwFSslj34BzcUhtcw5DhMqI7SAd8FnwsELe+c4qIMO2nvgbMl1ZRiD6T9I7wix+Jy+nrSG9kl68niPtw352h2kVNGkZg1htD9/d4C6P+npUc1HENVgRIjcuYVyuJmqfw1G/tsvqhNu5hyw1Gko8Is2tk01A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sxmkTtZH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sxmkTtZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8D981F000FF;
	Thu, 17 Sep 2026 17:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667550;
	bh=yco8CLSJsrgMeeBhEToJHm2qcBhNMjTzUeczkgvwyfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sxmkTtZHm/AZ5qjaSREZUJmTpfAr5Ymkoauh89vPGzASaFLtEjrwxppzsGcGl5G1/
	 P2F5otfg6LXDVP2t0WbP9WkX8F7Bjluv45mkt7T4DTzAXTAv1sEKsk/KQIbqaqQLc9
	 I6nbOyDDL+R7d64MT6rjM3TXqxYl/T+KTM3u5CIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joonwon Kang <joonwonkang@google.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0092/1102] mailbox: Make mbox_send_message() return error code when tx fails
Date: Thu, 17 Sep 2026 16:00:35 +0100
Message-ID: <20260917151541.798983518@linuxfoundation.org>
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
index d1db150e7e546..afc48a957162d 100644
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
index 1689031c58c9a..4b6211696126c 100644
--- a/include/linux/mailbox_controller.h
+++ b/include/linux/mailbox_controller.h
@@ -114,6 +114,7 @@ struct mbox_controller {
  * @txdone_method:	Way to detect TXDone chosen by the API
  * @cl:			Pointer to the current owner of this channel
  * @tx_complete:	Transmission completion
+ * @tx_status:		Transmission status
  * @active_req:		Currently active request hook
  * @msg_count:		No. of mssg currently queued
  * @msg_free:		Index of next available mssg slot
@@ -126,6 +127,7 @@ struct mbox_chan {
 	unsigned txdone_method;
 	struct mbox_client *cl;
 	struct completion tx_complete;
+	int tx_status;
 	void *active_req;
 	unsigned msg_count, msg_free;
 	void *msg_data[MBOX_TX_QUEUE_LEN];
-- 
2.53.0



